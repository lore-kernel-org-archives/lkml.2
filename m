Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1HVVGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:06:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54912 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751992Ab1HVVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:06:45 -0400
Date: Mon, 22 Aug 2011 17:06:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 1/4] usb: Provide usb_speed_string() function
In-Reply-To: <op.v0mro90r3l0zgt@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108221705040.2192-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Michal Nazarewicz wrote:

> >> --- a/drivers/usb/Makefile
> >> +++ b/drivers/usb/Makefile
> >> @@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
> >>  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
> >>  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
> >>  obj-$(CONFIG_USB_GADGET)	+= gadget/
> >> +
> >> +obj-$(CONFIG_USB)		+= common.o
> >> +obj-$(CONFIG_USB_GADGET)	+= common.o
> >
> > Will this cause problems?  For example, what if CONFIG_USB is Y and
> > CONFIG_USB_GADGET is M?
> 
> Hmm, I haven't thought about that.
> 
> > Also, it seems a little silly to have an entire kernel module devoted
> > to a single, little function.
> 
> Agreed.  And again, I haven't thought about compiling as a module which
> would result in a major overkill.
> 
> > This is a symptom of the difficulty of
> > sharing code between the host-side and gadget-side USB stacks.
> 
> Agreed.
> 
> I'm open to any suggestions on how this could be solved.
> 
> Sticking the function to the header file as static inline seems
> like bit... ”bloaty”.
> 
> If this is not easily solvable, I'll probably just drop this patch
> for now.

You could do:

	obj-$(CONFIG_USB_SUPPORT)  += common.o

which would build that subroutine into the main kernel whenever either 
side of the USB stack is enabled.

Alan Stern

