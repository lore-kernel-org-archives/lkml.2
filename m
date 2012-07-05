Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2GEVYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:24:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36270 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751812Ab2GEVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:24:37 -0400
Date: Thu, 5 Jul 2012 17:24:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frederik Himpe <fhimpe@telenet.be>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
In-Reply-To: <1341516932.4164.10.camel@piranha.localdomain>
Message-ID: <Pine.LNX.4.44L0.1207051712170.13212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012, Frederik Himpe wrote:

> OK, new attempt.
> 
> I plug in webcam:
> 
> Jul  5 21:19:02 piranha kernel: [ 9611.555849] usb 1-1.2: new high-speed USB device number 5 using ehci_hcd
> Jul  5 21:19:03 piranha kernel: [ 9611.913815] usb 1-1.2: New USB device found, idVendor=046d, idProduct=0826
> Jul  5 21:19:03 piranha kernel: [ 9611.913827] usb 1-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=1
> Jul  5 21:19:03 piranha kernel: [ 9611.913832] usb 1-1.2: Product: HD Webcam C525
> Jul  5 21:19:03 piranha kernel: [ 9611.913835] usb 1-1.2: SerialNumber: 1E83E9D0
> Jul  5 21:19:03 piranha kernel: [ 9612.180813] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)
> Jul  5 21:19:03 piranha kernel: [ 9612.193342] input: HD Webcam C525 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input27
> 
> I run:
> # cat /sys/bus/usb/devices/1-1.2/power/control
> auto
> # echo on > /sys/bus/usb/devices/1-1.2/power/control
> 
> At this moment, the device disconnects and reconnects, according to the
> logs:
> Jul  5 21:20:40 piranha kernel: [ 9709.169304] usb 1-1.2: USB disconnect, device number 5
> Jul  5 21:20:40 piranha kernel: [ 9709.416109] usb 1-1.2: new high-speed USB device number 6 using ehci_hcd
> Jul  5 21:20:41 piranha kernel: [ 9709.774203] usb 1-1.2: New USB device found, idVendor=046d, idProduct=0826
> Jul  5 21:20:41 piranha kernel: [ 9709.774215] usb 1-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=1
> Jul  5 21:20:41 piranha kernel: [ 9709.774219] usb 1-1.2: Product: HD Webcam C525
> Jul  5 21:20:41 piranha kernel: [ 9709.774222] usb 1-1.2: SerialNumber: 1E83E9D0
> Jul  5 21:20:41 piranha kernel: [ 9710.040969] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)
> Jul  5 21:20:41 piranha kernel: [ 9710.053472] input: HD Webcam C525 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input28
> 
> And it's back to auto:
> # cat /sys/bus/usb/devices/1-1.2/power/control
> auto

:-)  That's pretty funny -- although you may not think so.

> I tried setting to on again, and then this appears in the logs:
> Jul  5 21:21:59 piranha kernel: [ 9788.223118] usb 1-1.2: USB disconnect, device number 6
> Jul  5 21:22:00 piranha kernel: [ 9788.330415] usb 1-1.2: new full-speed USB device number 7 using ehci_hcd
> Jul  5 21:22:00 piranha kernel: [ 9788.402207] usb 1-1.2: device descriptor read/64, error -32
> Jul  5 21:22:00 piranha kernel: [ 9788.577706] usb 1-1.2: device descriptor read/64, error -32
> Jul  5 21:22:00 piranha kernel: [ 9788.753203] usb 1-1.2: new full-speed USB device number 8 using ehci_hcd
> Jul  5 21:22:00 piranha kernel: [ 9788.824996] usb 1-1.2: device descriptor read/64, error -32
> Jul  5 21:22:00 piranha kernel: [ 9789.000493] usb 1-1.2: device descriptor read/64, error -32
> Jul  5 21:22:00 piranha kernel: [ 9789.175991] usb 1-1.2: new full-speed USB device number 9 using ehci_hcd
> Jul  5 21:22:01 piranha kernel: [ 9789.582701] usb 1-1.2: device not accepting address 9, error -32
> Jul  5 21:22:01 piranha kernel: [ 9789.654621] usb 1-1.2: new full-speed USB device number 10 using ehci_hcd
> Jul  5 21:22:01 piranha kernel: [ 9790.061329] usb 1-1.2: device not accepting address 10, error -32
> Jul  5 21:22:01 piranha kernel: [ 9790.061467] hub 1-1:1.0: unable to enumerate USB device on port 2

All right, what you need to do is prevent autosuspend from getting 
enabled in the first place.

For testing purposes, the easiest way to do this is

	echo -1 >/sys/module/usbcore/parameters/autosuspend

before plugging in the webcam.  The -1 will then be used as the default 
autosuspend delay for all new USB devices, and since it is negative, 
autosuspend will be disabled.

In the long run, it may be necessary to add a quirk entry to always
use a reset-resume with this device.  You can find similar entries in 
drivers/usb/core/quirks.c for other Logitech webcams, which makes it 
seem very likely that one is needed for yours.  If you want you 
can try adding the appropriate entry and submit it as a patch.

None of this explains why there isn't any problem when the webcam is 
plugged into a USB-3 port, unfortunately.

Alan Stern

