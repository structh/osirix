/*=========================================================================
  Program:   OsiriX

  Copyright (c) OsiriX Team
  All rights reserved.
  Distributed under GNU - LGPL
  
  See http://www.osirix-viewer.com/copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.
=========================================================================*/
#import "ROIVolumeController.h"
#import "ROIVolumeView.h"
#import "Notifications.h"

#import "DCMView.h"

@implementation ROIVolumeController

@synthesize volumeField, seriesName;

- (ViewerController*) viewer
{
	return viewer;
}

- (IBAction) changeParameters:(id) sender
{
	[view setOpacity: [opacity floatValue] showPoints: [showPoints state] showSurface: [showSurfaces state] showWireframe: [showWireframe state] texture: [textured state] useColor: [color state] color: [[colorWell color] colorUsingColorSpaceName: NSCalibratedRGBColorSpace]];
	
}

- (IBAction) reload:(id)sender
{
	[view renderVolume];
	
	[self changeParameters: self];
}

- (void) CloseViewerNotification: (NSNotification*) note
{
	if([note object] == viewer)
	{
		[[self window] close];
	}
}

- (void) setDataString:(NSString*) s volume:(NSString*) v
{
	[volumeField setStringValue: s];
	[seriesName setStringValue: v];
}

-(id) initWithPoints:(NSMutableArray*) pts :(float) volume :(ViewerController*) iviewer roi:(ROI*) iroi
{
    unsigned long   i;
	
	viewer = [iviewer retain];
	roi = [iroi retain];
	
    self = [super initWithWindowNibName:@"ROIVolume"];
    
    [[self window] setDelegate:self];
    
	[view setPixSource:pts];
	
	if( volume < 0.01)
		[volumeField setStringValue: [NSString stringWithFormat:NSLocalizedString(@"Volume : %2.4f mm3.", nil), volume*1000.]];
	else
		[volumeField setStringValue: [NSString stringWithFormat:NSLocalizedString(@"Volume : %2.4f cm3.", nil), volume]];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver: self
		   selector: @selector(CloseViewerNotification:)
			   name: OsirixCloseViewerNotification
			 object: nil];
	
	[self changeParameters: self];
	
    return self;
}

-(void) dealloc
{
    NSLog(@"Dealloc ROIVolumeController");
	
	[viewer release];
	[roi release];
	
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver: self];
	
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[[self window] setAcceptsMouseMovedEvents: NO];
    [[self window] setDelegate:nil];
    
    [self autorelease];
}

- (ROI*) roi
{
	return roi;
}

@end
