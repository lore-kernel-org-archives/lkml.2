Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2GDSm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 14:42:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50254 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755699Ab2GDSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 14:42:28 -0400
Date: Wed, 4 Jul 2012 14:42:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frederik Himpe <fhimpe@telenet.be>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <linux-uvc-devel@lists.sourceforge.net>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
In-Reply-To: <1341426082.4131.8.camel@piranha.localdomain>
Message-ID: <Pine.LNX.4.44L0.1207041425330.15857-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Frederik Himpe wrote:

> > What happens if you disable USB runtime suspend on the affected system?  
> > Windows tends not to use it.
> 
> It appears to make a difference, but it still does not work perfectly.
> 
> I disabled autosuspend like this:
> root@piranha:/sys# for i in $(find -name autosuspend); do echo 0 > $i; done

That doesn't disable autosuspend.  The proper way is:

	echo on >/sys/bus/usb/devices/.../power/control

where you fill in the "..." with the directory name for the webcam.

> Then I started usbmon, connected the camera, and tried different times
> to run mplayer. All failed again:
> http://artipc10.vub.ac.be/~frederik/webcam/usb2-no-autosupend.mon.out

This failed for the same reason as before: The webcam autosuspended.

> I stopped usbmon. I Tried again starting mplayer, and then 1 in 2 cases,
> I got a working image now. However, after a few seconds, the image
> starts to lag, stutter and freeze, just like it cannot keep up with the
> image from the camera.
> 
> I started usbmon again, and made a trace of this image freezing
> happening after a few seconds:
> http://artipc10.vub.ac.be/~frederik/webcam/usb2-no-autosupend.mon.out2

This log also has an autosuspend failure.  In addition, it shows the 
image freezing because of a Set-Interface request that was sent while 
the program was running.  I have no idea why that request was sent.

> I also don't know whether this is related, but when it's connected to
> the usb3 port, the Cheese webcam application tends to freeze when
> starting a recording. kernel logs contain these errors when it's
> connected to USB3:
> [ 1970.959798] usb 3-2: new high-speed USB device number 3 using xhci_hcd
> [ 1971.244188] usb 3-2: New USB device found, idVendor=046d, idProduct=0826
> [ 1971.244198] usb 3-2: New USB device strings: Mfr=0, Product=2, SerialNumber=1
> [ 1971.244202] usb 3-2: Product: HD Webcam C525
> [ 1971.244205] usb 3-2: SerialNumber: 1E83E9D0
> [ 1971.511718] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)
> [ 1971.524373] input: HD Webcam C525 as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.2/input/input68
> [ 1971.524608] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
> [ 1971.524617] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
...

An unrelated problem, I think.

> But at least mplayer works fine when it's connected to USB3.

Alan Stern

