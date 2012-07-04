Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2GDSV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 14:21:29 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:56555 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2GDSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 14:21:26 -0400
Message-ID: <1341426082.4131.8.camel@piranha.localdomain>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
From: Frederik Himpe <fhimpe@telenet.be>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-uvc-devel@lists.sourceforge.net
Date: Wed, 04 Jul 2012 20:21:22 +0200
In-Reply-To: <Pine.LNX.4.44L0.1207022039360.27935-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1207022039360.27935-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 20:40 -0400, Alan Stern wrote:
> On Mon, 2 Jul 2012, Frederik Himpe wrote:
> 
> > > Have you tried using the webcam on a different computer?
> > 
> > I just tried it on a different system (Dell Latitude E6400), and it
> > worked fine on the USB2 ports (kernel version was 3.4.1 on that system,
> > though). The webcam also works fine on the affected system and USB2
> > ports in Windows.
> 
> What happens if you disable USB runtime suspend on the affected system?  
> Windows tends not to use it.

It appears to make a difference, but it still does not work perfectly.

I disabled autosuspend like this:
root@piranha:/sys# for i in $(find -name autosuspend); do echo 0 > $i; done

Then I started usbmon, connected the camera, and tried different times
to run mplayer. All failed again:
http://artipc10.vub.ac.be/~frederik/webcam/usb2-no-autosupend.mon.out

I stopped usbmon. I Tried again starting mplayer, and then 1 in 2 cases,
I got a working image now. However, after a few seconds, the image
starts to lag, stutter and freeze, just like it cannot keep up with the
image from the camera.

I started usbmon again, and made a trace of this image freezing
happening after a few seconds:
http://artipc10.vub.ac.be/~frederik/webcam/usb2-no-autosupend.mon.out2

I also don't know whether this is related, but when it's connected to
the usb3 port, the Cheese webcam application tends to freeze when
starting a recording. kernel logs contain these errors when it's
connected to USB3:
[ 1970.959798] usb 3-2: new high-speed USB device number 3 using xhci_hcd
[ 1971.244188] usb 3-2: New USB device found, idVendor=046d, idProduct=0826
[ 1971.244198] usb 3-2: New USB device strings: Mfr=0, Product=2, SerialNumber=1
[ 1971.244202] usb 3-2: Product: HD Webcam C525
[ 1971.244205] usb 3-2: SerialNumber: 1E83E9D0
[ 1971.511718] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)
[ 1971.524373] input: HD Webcam C525 as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.2/input/input68
[ 1971.524608] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1971.524617] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1971.673352] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1971.673364] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1971.805117] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1971.805128] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1971.961869] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1972.096266] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1972.096276] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1972.227921] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1972.227931] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1972.359564] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1972.359574] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1972.491529] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1972.491542] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 1972.631005] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 14 with no TDs queued?
[ 1972.631016] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 2013.465947] xhci_queue_intr_tx: 53 callbacks suppressed
[ 2018.555341] xhci_queue_intr_tx: 34 callbacks suppressed
[ 2023.565002] xhci_queue_intr_tx: 38 callbacks suppressed
[ 2026.437417] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 2051.915715] xhci_queue_intr_tx: 12 callbacks suppressed
[ 2058.361261] xhci_queue_intr_tx: 58 callbacks suppressed
[ 2120.614792] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?
[ 2137.622105] xhci_queue_intr_tx: 29 callbacks suppressed
[ 2142.839167] xhci_queue_intr_tx: 31 callbacks suppressed
[ 2156.751270] xhci_queue_intr_tx: 22 callbacks suppressed
[ 2163.164907] xhci_queue_intr_tx: 33 callbacks suppressed
[ 2165.447345] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 2 ep 0 with no TDs queued?

But at least mplayer works fine when it's connected to USB3.

-- 
Frederik Himpe <fhimpe@telenet.be>

