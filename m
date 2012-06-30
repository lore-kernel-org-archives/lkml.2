Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2F3TVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:21:55 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:48570 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2F3TVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:21:53 -0400
Message-ID: <1341084110.4862.15.camel@piranha.localdomain>
Subject: Logitech HD Webcam C525 does not work when connected to USB 2 port,
 works on USB 3
From: Frederik Himpe <fhimpe@telenet.be>
To: linux-kernel@vger.kernel.org
Cc: linux-uvc-devel@lists.sourceforge.net, linux-usb@vger.kernel.org
Date: Sat, 30 Jun 2012 21:21:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a Logitech HD Webcam C525 using the uvcvideo module and I use
Linux 3.5 RC4. When this camera is connected to a USB2 port, it does not
work most of the time. However it does work fine when connected to a USB
3 port. In Windows it works on both ports.

To test the webcam, I use this command with mplayer2:
$ mplayer tv:// -tv driver=v4l2:width=1280:height=720:device=/dev/video0

When connected to the USB 3 port, the webcam image is shown correctly,
but on a USB 2 port, this output is shown most of the time:

MPlayer2 UNKNOWN (C) 2000-2012 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing tv://.
Detected file format: TV
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
v4l2: unable to open '/dev/video0': Device or resource busy
v4l2: ioctl set mute failed: Bad file descriptor
v4l2: 0 frames successfully processed, 0 frames dropped.
Opening as detected format "TV" failed.
Failed to recognize file format.


Exiting... (End of file)

When connected to the USB 2 port, lsusb -v only shows this information
about this webcam:

Bus 001 Device 007: ID 046d:0826 Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0826 
  bcdDevice            0.10
  iManufacturer           0 
  iProduct                2 
  iSerial                 1 
  bNumConfigurations      1

Much more info is given by lsusb -v when it's connected to the USB 3
port.

Sometimes mplayer does work when connected to the USB 2 port, but after
a few seconds, the image starts freezing, and these errors are shown on
the console:
v4l2: select timeout

Here is a uvcvideo trace from a failed attempt in opening the webcam
with mplayer2 (is it expected that the USB device appears to disconnect
and connect when starting mplayer? I definitely did not disconnect the
device when this was logged).

[ 1878.994588] uvcvideo: uvc_v4l2_open
[ 1879.195761] usb 1-1.2: USB disconnect, device number 15
[ 1879.275132] usb 1-1.2: new full-speed USB device number 16 using
ehci_hcd
[ 1879.346932] usb 1-1.2: device descriptor read/64, error -32
[ 1879.466715] hub 1-1:1.0: unable to enumerate USB device on port 2
[ 1879.666018] usb 1-1.2: new high-speed USB device number 17 using
ehci_hcd
[ 1880.024364] usb 1-1.2: New USB device found, idVendor=046d,
idProduct=0826
[ 1880.024373] usb 1-1.2: New USB device strings: Mfr=0, Product=2,
SerialNumber=1
[ 1880.024377] usb 1-1.2: Product: HD Webcam C525
[ 1880.024380] usb 1-1.2: SerialNumber: 1E83E9D0
[ 1880.291007] uvcvideo: Probing generic UVC device 1.2
[ 1880.291019] uvcvideo: Found format YUV 4:2:2 (YUYV).
[ 1880.291022] uvcvideo: - 640x480 (30.0 fps)
[ 1880.291025] uvcvideo: - 160x120 (30.0 fps)
[ 1880.291027] uvcvideo: - 176x144 (30.0 fps)
[ 1880.291030] uvcvideo: - 320x176 (30.0 fps)
[ 1880.291032] uvcvideo: - 320x240 (30.0 fps)
[ 1880.291034] uvcvideo: - 432x240 (30.0 fps)
[ 1880.291037] uvcvideo: - 352x288 (30.0 fps)
[ 1880.291039] uvcvideo: - 544x288 (30.0 fps)
[ 1880.291042] uvcvideo: - 640x360 (30.0 fps)
[ 1880.291044] uvcvideo: - 752x416 (24.0 fps)
[ 1880.291046] uvcvideo: - 800x448 (24.0 fps)
[ 1880.291048] uvcvideo: - 864x480 (20.0 fps)
[ 1880.291051] uvcvideo: - 960x544 (20.0 fps)
[ 1880.291053] uvcvideo: - 1024x576 (15.0 fps)
[ 1880.291055] uvcvideo: - 800x600 (24.0 fps)
[ 1880.291058] uvcvideo: - 1184x656 (15.0 fps)
[ 1880.291060] uvcvideo: - 960x720 (15.0 fps)
[ 1880.291062] uvcvideo: - 1280x720 (10.0 fps)
[ 1880.291065] uvcvideo: - 1392x768 (10.0 fps)
[ 1880.291067] uvcvideo: - 1504x832 (7.5 fps)
[ 1880.291070] uvcvideo: - 1600x896 (7.5 fps)
[ 1880.291072] uvcvideo: - 1280x960 (7.5 fps)
[ 1880.291074] uvcvideo: - 1712x960 (5.0 fps)
[ 1880.291077] uvcvideo: - 1792x1008 (5.0 fps)
[ 1880.291079] uvcvideo: - 1920x1080 (5.0 fps)
[ 1880.291081] uvcvideo: Found format MJPEG.
[ 1880.291084] uvcvideo: - 640x480 (30.0 fps)
[ 1880.291086] uvcvideo: - 160x120 (30.0 fps)
[ 1880.291088] uvcvideo: - 176x144 (30.0 fps)
[ 1880.291091] uvcvideo: - 320x176 (30.0 fps)
[ 1880.291093] uvcvideo: - 320x240 (30.0 fps)
[ 1880.291096] uvcvideo: - 432x240 (30.0 fps)
[ 1880.291098] uvcvideo: - 352x288 (30.0 fps)
[ 1880.291100] uvcvideo: - 544x288 (30.0 fps)
[ 1880.291103] uvcvideo: - 640x360 (30.0 fps)
[ 1880.291105] uvcvideo: - 752x416 (30.0 fps)
[ 1880.291107] uvcvideo: - 800x448 (30.0 fps)
[ 1880.291110] uvcvideo: - 864x480 (30.0 fps)
[ 1880.291112] uvcvideo: - 960x544 (30.0 fps)
[ 1880.291114] uvcvideo: - 1024x576 (30.0 fps)
[ 1880.291117] uvcvideo: - 800x600 (30.0 fps)
[ 1880.291120] uvcvideo: - 1184x656 (30.0 fps)
[ 1880.291123] uvcvideo: - 960x720 (30.0 fps)
[ 1880.291125] uvcvideo: - 1280x720 (30.0 fps)
[ 1880.291127] uvcvideo: - 1392x768 (30.0 fps)
[ 1880.291130] uvcvideo: - 1504x832 (30.0 fps)
[ 1880.291263] uvcvideo: - 1600x896 (30.0 fps)
[ 1880.291265] uvcvideo: - 1280x960 (30.0 fps)
[ 1880.291267] uvcvideo: - 1712x960 (30.0 fps)
[ 1880.291270] uvcvideo: - 1792x1008 (30.0 fps)
[ 1880.291272] uvcvideo: - 1920x1080 (30.0 fps)
[ 1880.291280] uvcvideo: Found a Status endpoint (addr 87).
[ 1880.291283] uvcvideo: Found UVC 1.00 device HD Webcam C525
(046d:0826)
[ 1880.291399] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/2 to device 1.2 entity 1
[ 1880.291409] uvcvideo: Adding mapping 'Exposure, Auto' to control
00000000-0000-0000-0000-000000000001/2.
[ 1880.291414] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/3 to device 1.2 entity 1
[ 1880.291418] uvcvideo: Adding mapping 'Exposure, Auto Priority' to
control 00000000-0000-0000-0000-000000000001/3.
[ 1880.291422] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/4 to device 1.2 entity 1
[ 1880.291426] uvcvideo: Adding mapping 'Exposure (Absolute)' to control
00000000-0000-0000-0000-000000000001/4.
[ 1880.291430] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/6 to device 1.2 entity 1
[ 1880.291434] uvcvideo: Adding mapping 'Focus (absolute)' to control
00000000-0000-0000-0000-000000000001/6.
[ 1880.291438] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/11 to device 1.2 entity 1
[ 1880.291442] uvcvideo: Adding mapping 'Zoom, Absolute' to control
00000000-0000-0000-0000-000000000001/11.
[ 1880.291447] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/13 to device 1.2 entity 1
[ 1880.291450] uvcvideo: Adding mapping 'Pan (Absolute)' to control
00000000-0000-0000-0000-000000000001/13.
[ 1880.291453] uvcvideo: Adding mapping 'Tilt (Absolute)' to control
00000000-0000-0000-0000-000000000001/13.
[ 1880.291458] uvcvideo: Added control
00000000-0000-0000-0000-000000000001/8 to device 1.2 entity 1
[ 1880.291461] uvcvideo: Adding mapping 'Focus, Auto' to control
00000000-0000-0000-0000-000000000001/8.
[ 1880.291465] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/2 to device 1.2 entity 2
[ 1880.291468] uvcvideo: Adding mapping 'Brightness' to control
00000000-0000-0000-0000-000000000101/2.
[ 1880.291473] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/3 to device 1.2 entity 2
[ 1880.291476] uvcvideo: Adding mapping 'Contrast' to control
00000000-0000-0000-0000-000000000101/3.
[ 1880.291480] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/7 to device 1.2 entity 2
[ 1880.291483] uvcvideo: Adding mapping 'Saturation' to control
00000000-0000-0000-0000-000000000101/7.
[ 1880.291487] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/8 to device 1.2 entity 2
[ 1880.291490] uvcvideo: Adding mapping 'Sharpness' to control
00000000-0000-0000-0000-000000000101/8.
[ 1880.291494] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/10 to device 1.2 entity 2
[ 1880.291497] uvcvideo: Adding mapping 'White Balance Temperature' to
control 00000000-0000-0000-0000-000000000101/10.
[ 1880.291501] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/1 to device 1.2 entity 2
[ 1880.291504] uvcvideo: Adding mapping 'Backlight Compensation' to
control 00000000-0000-0000-0000-000000000101/1.
[ 1880.291508] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/4 to device 1.2 entity 2
[ 1880.291511] uvcvideo: Adding mapping 'Gain' to control
00000000-0000-0000-0000-000000000101/4.
[ 1880.291516] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/5 to device 1.2 entity 2
[ 1880.291519] uvcvideo: Adding mapping 'Power Line Frequency' to
control 00000000-0000-0000-0000-000000000101/5.
[ 1880.291523] uvcvideo: Added control
00000000-0000-0000-0000-000000000101/11 to device 1.2 entity 2
[ 1880.291526] uvcvideo: Adding mapping 'White Balance Temperature,
Auto' to control 00000000-0000-0000-0000-000000000101/11.
[ 1880.291535] uvcvideo: Scanning UVC chain: OT 3 <- XU 5 <- IT 1
[ 1880.291541]  (-> XU 6 XU 7 XU 8)
[ 1880.291541] uvcvideo: Found a valid video chain (1 -> 3).
[ 1880.303768] input: HD Webcam C525
as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input33
[ 1880.303859] uvcvideo: UVC device initialized.
[ 1880.311922] uvcvideo: uvc_v4l2_open
[ 1880.312022] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
[ 1880.312059] uvcvideo: uvc_v4l2_release

Motherboard is an Asrock H77 Pro4/MVP.

Complete dmesg and lsusb -v output about a failed attempt (on USB 2
port) and a succeeded attempt (on USB 3) can be found on
http://artipc10.vub.ac.be/~frederik/webcam/

-- 
Frederik Himpe

