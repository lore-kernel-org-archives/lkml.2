Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab0GEIQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:16:00 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:47897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0GEIP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:15:58 -0400
Subject: Re: macbook webcam no longer works on .35-rc
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <201007050928.46888.laurent.pinchart@ideasonboard.com>
References: <1277932269.11050.1.camel@jlt3.sipsolutions.net>
	 <1278055575.3737.7.camel@jlt3.sipsolutions.net>
	 <201007050928.46888.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 10:15:53 +0200
Message-ID: <1278317753.4993.136.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-05 at 09:28 +0200, Laurent Pinchart wrote:
> Hi Johannes,
> 
> On Friday 02 July 2010 09:26:15 Johannes Berg wrote:
> > On Wed, 2010-06-30 at 23:11 +0200, Johannes Berg wrote:
> > > I'm pretty sure this was a regression in .34, but haven't checked right
> > > now, can bisect when I find time but wanted to inquire first if somebody
> > > had ideas. All I get is:
> > > 
> > > [57372.078968] uvcvideo: Failed to query (130) UVC control 5 (unit 3) :
> > > -32 (exp. 1).
> 
> Does it prevent your camera from working, or does it "just" print annoying 
> messages to the kernel log ?

It prevents it from working, and it's the only error message since the
tool/driver/libv4l/whatever just gives up after getting -EIO.

lsusb -v is:


Bus 001 Device 002: ID 05ac:8507 Apple, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x05ac Apple, Inc.
  idProduct          0x8507 
  bcdDevice            4.18
  iManufacturer           1 Apple Inc.
  iProduct                2 Built-in iSight
  iSerial                 3 8J8B41B6T40U3A00
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          642
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               2 Built-in iSight
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              2 Built-in iSight
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           51
        dwClockFrequency        4.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x0000000a
          Auto-Exposure Mode
          Exposure Time (Absolute)
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               3
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 3
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000157f
          Brightness
          Contrast
          Hue
          Saturation
          Sharpness
          Gamma
          White Balance Temperature
          Backlight Compensation
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0 
        bmVideoStandards     0x 0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               6
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      423
        bEndPointAddress                  130
        bmInfo                              0
        bTerminalLink                       2
        bStillCaptureMethod                 2
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                5
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  5
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            70
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 11
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            363636
        dwFrameInterval( 2)            400000
        dwFrameInterval( 3)            444444
        dwFrameInterval( 4)            500000
        dwFrameInterval( 5)            571428
        dwFrameInterval( 6)            666667
        dwFrameInterval( 7)            800000
        dwFrameInterval( 8)           1000000
        dwFrameInterval( 9)           1333333
        dwFrameInterval(10)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            70
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 11
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            363636
        dwFrameInterval( 2)            400000
        dwFrameInterval( 3)            444444
        dwFrameInterval( 4)            500000
        dwFrameInterval( 5)            571428
        dwFrameInterval( 6)            666667
        dwFrameInterval( 7)            800000
        dwFrameInterval( 8)           1000000
        dwFrameInterval( 9)           1333333
        dwFrameInterval(10)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            70
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 11
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            363636
        dwFrameInterval( 2)            400000
        dwFrameInterval( 3)            444444
        dwFrameInterval( 4)            500000
        dwFrameInterval( 5)            571428
        dwFrameInterval( 6)            666667
        dwFrameInterval( 7)            800000
        dwFrameInterval( 8)           1000000
        dwFrameInterval( 9)           1333333
        dwFrameInterval(10)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            70
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 11
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            363636
        dwFrameInterval( 2)            400000
        dwFrameInterval( 3)            444444
        dwFrameInterval( 4)            500000
        dwFrameInterval( 5)            571428
        dwFrameInterval( 6)            666667
        dwFrameInterval( 7)            800000
        dwFrameInterval( 8)           1000000
        dwFrameInterval( 9)           1333333
        dwFrameInterval(10)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            70
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 11
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            363636
        dwFrameInterval( 2)            400000
        dwFrameInterval( 3)            444444
        dwFrameInterval( 4)            500000
        dwFrameInterval( 5)            571428
        dwFrameInterval( 6)            666667
        dwFrameInterval( 7)            800000
        dwFrameInterval( 8)           1000000
        dwFrameInterval( 9)           1333333
        dwFrameInterval(10)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            26
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               5
        wWidth( 0)                        160
        wHeight( 0)                       120
        wWidth( 1)                        176
        wHeight( 1)                       144
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        640
        wHeight( 4)                       480
        bNumCompressionPatterns             5
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 1 (BT.709)
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0080  1x 128 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b00  2x 768 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       6
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1380  3x 896 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       7
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

johannes

PS: I'll be on vacation until Saturday starting right now.


