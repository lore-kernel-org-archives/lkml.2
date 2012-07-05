Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2GETfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:35:37 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:56515 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2GETff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:35 -0400
Message-ID: <1341516932.4164.10.camel@piranha.localdomain>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
From: Frederik Himpe <fhimpe@telenet.be>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Date: Thu, 05 Jul 2012 21:35:32 +0200
In-Reply-To: <Pine.LNX.4.44L0.1207041714280.18768-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1207041714280.18768-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 21:20 -0400, Alan Stern wrote:
> On Wed, 4 Jul 2012, Frederik Himpe wrote:
> 
> > > That doesn't disable autosuspend.  The proper way is:
> > > 
> > > 	echo on >/sys/bus/usb/devices/.../power/control
> > > 
> > > where you fill in the "..." with the directory name for the webcam.
> > 
> > usb trace from trying mplayer a few times after disabling autosuspend:
> > 
> > ffff880415761ec0 897158138 S Ii:1:081:7 -115:128 16 <
> > ffff8803c49ec800 897158252 S Co:1:081:0 s 21 01 0100 0003 001a 26 = 01000101 15160500 00000000 00000000 00000000 00000000 0000
> > ffff8803c49ec800 897162252 C Co:1:081:0 -71 0
> 
> This is already too late.  The -71 error code indicates that the webcam 
> has crashed.  We need to see what happens before the crash, in order to 
> determine what causes it.
> 
> Did you use the right path for the webcam device?  According to your
> logs, it should be 1-1.2 -- assuming you plug the webcam into the same
> port as before.

OK, new attempt.

I plug in webcam:

Jul  5 21:19:02 piranha kernel: [ 9611.555849] usb 1-1.2: new high-speed USB device number 5 using ehci_hcd
Jul  5 21:19:03 piranha kernel: [ 9611.913815] usb 1-1.2: New USB device found, idVendor=046d, idProduct=0826
Jul  5 21:19:03 piranha kernel: [ 9611.913827] usb 1-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=1
Jul  5 21:19:03 piranha kernel: [ 9611.913832] usb 1-1.2: Product: HD Webcam C525
Jul  5 21:19:03 piranha kernel: [ 9611.913835] usb 1-1.2: SerialNumber: 1E83E9D0
Jul  5 21:19:03 piranha kernel: [ 9612.180813] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)
Jul  5 21:19:03 piranha kernel: [ 9612.193342] input: HD Webcam C525 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input27

I run:
# cat /sys/bus/usb/devices/1-1.2/power/control
auto
# echo on > /sys/bus/usb/devices/1-1.2/power/control

At this moment, the device disconnects and reconnects, according to the
logs:
Jul  5 21:20:40 piranha kernel: [ 9709.169304] usb 1-1.2: USB disconnect, device number 5
Jul  5 21:20:40 piranha kernel: [ 9709.416109] usb 1-1.2: new high-speed USB device number 6 using ehci_hcd
Jul  5 21:20:41 piranha kernel: [ 9709.774203] usb 1-1.2: New USB device found, idVendor=046d, idProduct=0826
Jul  5 21:20:41 piranha kernel: [ 9709.774215] usb 1-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=1
Jul  5 21:20:41 piranha kernel: [ 9709.774219] usb 1-1.2: Product: HD Webcam C525
Jul  5 21:20:41 piranha kernel: [ 9709.774222] usb 1-1.2: SerialNumber: 1E83E9D0
Jul  5 21:20:41 piranha kernel: [ 9710.040969] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)
Jul  5 21:20:41 piranha kernel: [ 9710.053472] input: HD Webcam C525 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input28

And it's back to auto:
# cat /sys/bus/usb/devices/1-1.2/power/control
auto

I tried setting to on again, and then this appears in the logs:
Jul  5 21:21:59 piranha kernel: [ 9788.223118] usb 1-1.2: USB disconnect, device number 6
Jul  5 21:22:00 piranha kernel: [ 9788.330415] usb 1-1.2: new full-speed USB device number 7 using ehci_hcd
Jul  5 21:22:00 piranha kernel: [ 9788.402207] usb 1-1.2: device descriptor read/64, error -32
Jul  5 21:22:00 piranha kernel: [ 9788.577706] usb 1-1.2: device descriptor read/64, error -32
Jul  5 21:22:00 piranha kernel: [ 9788.753203] usb 1-1.2: new full-speed USB device number 8 using ehci_hcd
Jul  5 21:22:00 piranha kernel: [ 9788.824996] usb 1-1.2: device descriptor read/64, error -32
Jul  5 21:22:00 piranha kernel: [ 9789.000493] usb 1-1.2: device descriptor read/64, error -32
Jul  5 21:22:00 piranha kernel: [ 9789.175991] usb 1-1.2: new full-speed USB device number 9 using ehci_hcd
Jul  5 21:22:01 piranha kernel: [ 9789.582701] usb 1-1.2: device not accepting address 9, error -32
Jul  5 21:22:01 piranha kernel: [ 9789.654621] usb 1-1.2: new full-speed USB device number 10 using ehci_hcd
Jul  5 21:22:01 piranha kernel: [ 9790.061329] usb 1-1.2: device not accepting address 10, error -32
Jul  5 21:22:01 piranha kernel: [ 9790.061467] hub 1-1:1.0: unable to enumerate USB device on port 2

I reproduced this with usbmon running:
http://artipc10.vub.ac.be/~frederik/webcam/usbmon.1u

# cat /sys/kernel/debug/usb/usbmon/1u > /tmp/usbmon.1u
Plug in webcam
# cat /sys/bus/usb/devices/1-1.2/power/control
auto
# echo on > /sys/bus/usb/devices/1-1.2/power/control
[device disconnects and reconnects, according to log]
# echo on > /sys/bus/usb/devices/1-1.2/power/control
[this time the device disconnects and reconnects again]

-- 
Frederik Himpe <fhimpe@telenet.be>

