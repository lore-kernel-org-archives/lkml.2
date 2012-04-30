Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2D3VMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:12:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60487 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756842Ab2D3VMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:12:33 -0400
Date: Mon, 30 Apr 2012 17:12:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Grzegorz Nosek <root@localdomain.pl>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <support@supermicro.com>
Subject: Re: EHCI software retries break Supermicro IPKVM
In-Reply-To: <4F9D4539.9000903@localdomain.pl>
Message-ID: <Pine.LNX.4.44L0.1204301707060.1558-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2012, Grzegorz Nosek wrote:

> W dniu 19.04.2012 19:40, Alan Stern pisze:
> > Do you have any idea what's going wrong?
> 
> Nope. I found this workaround by bisecting.
> 
> > Can you provide complete dmesg logs for kernels both with and without
> > your patch (and with CONFIG_USB_DEBUG enabled)?  Maybe also usbmon
> > traces too.
> 
> Attached. Sorry it took so long, it was rather hard to align time when I 
> can easily reboot this machine with when I actually had the time to do it.
> 
> Note: USB support is compiled in the kernel image, so I couldn't attach 
> usbmon very early. Instead, I captured usbmon traces (and dmesgs since 
> boot) from connecting and disconnecting an ISO image via the KVM's 
> virtual CD drive, which exhibits the same problems (the IPKVM is visible 
> as an USB keyboard, an USB mouse and two USB CD-ROM drives).

That's fine; the logs show pretty clearly what the problem is.

It isn't a software issue.  You've got a hardware problem; either the
IPKVM itself, or the connecting cable, or your computer's EHCI
controller is bad.  The only reason the device worked without the retry
logic is because it failed so completely that the kernel was forced to
run it at full speed (12 Mb/s) instead of high speed (480 Mb/s).  With
the retry logic present, the device was barely workable at high speed
(but it probably didn't work well enough to be very useful).

Have you tried plugging the IPKVM into a different computer to see if 
it behaves any better?

Alan Stern

