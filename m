Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1BWP0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:26:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41017 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753375Ab1BWP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:26:21 -0500
Date: Wed, 23 Feb 2011 10:26:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>, Alexander Holler <holler@ahsoftware.de>,
        Michael Jones <michael.jones@matrix-vision.de>
cc: Greg KH <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>, <stable-review@kernel.org>,
        <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
In-Reply-To: <4D64C81B.5060807@ahsoftware.de>
Message-ID: <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Alexander Holler wrote:

> Am 23.02.2011 09:06, schrieb Alexander Holler:
> > Am 16.02.2011 02:44, schrieb Greg KH:
> >> 2.6.32-longterm review patch. If anyone has any objections, please let
> >> us know.
> >
> > This patch killed the MUSB-host-functionality here (on a BeagleBoard).
> 
> Sorry, haven't seen at first, that the question was for 2.6.32. I had to 
> revert this patch for 2.6.37.1. Without the revert I've got endless 
> messages that the "parent hub has no TT".
> 
> I've configured musb in gadget-mode and I'm loading g_zero to use a 
> bt-dongle attached to the OTG-(MUSB-)port.
> 
> > Regards,
> >
> > Alexander

On Wed, 23 Feb 2011, Michael Jones wrote:

> Hi all,
> 
> My OMAP37 board started choking on my USB mouse when I updated from
> 2.6.37 to 2.6.38rc5.  I've tracked it down to commit
> d199c96d41d80a567493e12b8e96ea056a1350c1, "USB: prevent buggy hubs from
> crashing the USB stack."  If I revert this commit, my mouse works again.
> Otherwise, I get the message:
> 
> usb 1-1: new low speed USB device using musb-hdrc and address 33
> usb 1-1: parent hub has no TT
> 
> repeatedly (with 'address' incrementing).
> 
> I'm using the musb-hdrc driver for the OTG USB port in host mode.
> 
> some relevant config:
> CONFIG_USB_EHCI_HCD_OMAP=y
> CONFIG_USB_MUSB_HDRC=y
> CONFIG_USB_MUSB_OMAP2PLUS=y
> CONFIG_USB_MUSB_HOST=y
> CONFIG_USB_MUSB_HDRC_HCD=y
> CONFIG_USB_INVENTRA_DMA=y
> 
> # lsusb
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> Any thoughts on how to get around this besides just reverting the
> commit?  Did anybody already encounter this?
> 
> thanks,
> Michael

In both cases, it appears that the problem is caused by the fact that 
the musb host-controller driver doesn't set the hcd->has_tt flag.

Felipe, you should know where it belongs.  It should be easy enough to 
add.

Alan Stern

