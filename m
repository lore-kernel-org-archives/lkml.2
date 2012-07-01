Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2GAPyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:54:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37266 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751354Ab2GAPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:54:51 -0400
Date: Sun, 1 Jul 2012 11:54:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frederik Himpe <fhimpe@telenet.be>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
In-Reply-To: <1341146090.4121.3.camel@piranha.localdomain>
Message-ID: <Pine.LNX.4.44L0.1207011138460.18102-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2012, Frederik Himpe wrote:

> > A usbmon trace would be more helpful.  Or perhaps a pair of traces, one 
> > for the USB-2 port and one for the USB-3 port.  See the instructions in 
> > Documentation/usb/usbmon.txt.
> 
> OK, I created a usbmon trace both from the USB-2 port as the USB-3 port.
> During the trace, I connected the USB webcam to the USB port and started
> mplayer, which failed on USB-2 but worked fine on USB-3.
> 
> The two traces can be found here:
> http://artipc10.vub.ac.be/~frederik/webcam/

There are two significant differences between the USB-2 and USB-3 
traces, although I don't know what to make of them.

Initially it looks like the driver writes a bunch of values to the 
webcam and asks it to repeat them back.  That's what happens in the 
USB-3 trace, anyway.  The USB-2 trace shows the values being written, 
but when asked to repeat them back the webcam sends nothing.

For example, with USB-3:

ffff8804085042c0 470397794 S Co:3:003:0 s 22 01 0100 0086 0003 3 = 803e00
ffff8804085042c0 470399896 C Co:3:003:0 0 3 >
ffff8804085042c0 470400004 S Ci:3:003:0 s a2 81 0100 0086 0003 3 <
ffff8804085042c0 470401270 C Ci:3:003:0 0 3 = 803e00

The 803e00 values get sent and then received.  The analogous part of
the USB-2 trace shows:

ffff88040cc1f5c0 208122798 S Co:1:006:0 s 22 01 0100 0086 0003 3 = 803e00
ffff88040cc1f5c0 208124781 C Co:1:006:0 0 3 >
ffff88040cc1f5c0 208124818 S Ci:1:006:0 s a2 81 0100 0086 0003 3 <
ffff88040cc1f5c0 208126156 C Ci:1:006:0 0 0

Exactly the same values are sent and the request is the same, but no 
data gets returned.  I have no idea what that means.

Secondly, both traces show that the webcam stopped being used for a
short time and was suspended.  A few seconds later, when it was resumed
again, it worked okay in the USB-3 trace.  But in the USB-2 trace, it
didn't.  After the resume it failed to reply to the first packet sent
(a Get-Device-Status request), and thus it had to be re-enumerated.

Have you tried using the webcam on a different computer?

Alan Stern

