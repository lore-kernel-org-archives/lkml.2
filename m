Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab2GBUMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:12:36 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:51056 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2GBUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:12:35 -0400
Message-ID: <1341259950.4325.11.camel@piranha.localdomain>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
From: Frederik Himpe <fhimpe@telenet.be>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-uvc-devel@lists.sourceforge.net
Date: Mon, 02 Jul 2012 22:12:30 +0200
In-Reply-To: <Pine.LNX.4.44L0.1207011138460.18102-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1207011138460.18102-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-01 at 11:54 -0400, Alan Stern wrote:
> On Sun, 1 Jul 2012, Frederik Himpe wrote:
> 
> > > A usbmon trace would be more helpful.  Or perhaps a pair of traces, one 
> > > for the USB-2 port and one for the USB-3 port.  See the instructions in 
> > > Documentation/usb/usbmon.txt.
> > 
> > OK, I created a usbmon trace both from the USB-2 port as the USB-3 port.
> > During the trace, I connected the USB webcam to the USB port and started
> > mplayer, which failed on USB-2 but worked fine on USB-3.
> > 
> > The two traces can be found here:
> > http://artipc10.vub.ac.be/~frederik/webcam/
> 
> There are two significant differences between the USB-2 and USB-3 
> traces, although I don't know what to make of them.
> 
> Initially it looks like the driver writes a bunch of values to the 
> webcam and asks it to repeat them back.  That's what happens in the 
> USB-3 trace, anyway.  The USB-2 trace shows the values being written, 
> but when asked to repeat them back the webcam sends nothing.
> 
> For example, with USB-3:
> 
> ffff8804085042c0 470397794 S Co:3:003:0 s 22 01 0100 0086 0003 3 = 803e00
> ffff8804085042c0 470399896 C Co:3:003:0 0 3 >
> ffff8804085042c0 470400004 S Ci:3:003:0 s a2 81 0100 0086 0003 3 <
> ffff8804085042c0 470401270 C Ci:3:003:0 0 3 = 803e00
> 
> The 803e00 values get sent and then received.  The analogous part of
> the USB-2 trace shows:
> 
> ffff88040cc1f5c0 208122798 S Co:1:006:0 s 22 01 0100 0086 0003 3 = 803e00
> ffff88040cc1f5c0 208124781 C Co:1:006:0 0 3 >
> ffff88040cc1f5c0 208124818 S Ci:1:006:0 s a2 81 0100 0086 0003 3 <
> ffff88040cc1f5c0 208126156 C Ci:1:006:0 0 0
> 
> Exactly the same values are sent and the request is the same, but no 
> data gets returned.  I have no idea what that means.
> 
> Secondly, both traces show that the webcam stopped being used for a
> short time and was suspended.  A few seconds later, when it was resumed
> again, it worked okay in the USB-3 trace.  But in the USB-2 trace, it
> didn't.  After the resume it failed to reply to the first packet sent
> (a Get-Device-Status request), and thus it had to be re-enumerated.
> 
> Have you tried using the webcam on a different computer?

I just tried it on a different system (Dell Latitude E6400), and it
worked fine on the USB2 ports (kernel version was 3.4.1 on that system,
though). The webcam also works fine on the affected system and USB2
ports in Windows.

-- 
Frederik Himpe <fhimpe@telenet.be>

