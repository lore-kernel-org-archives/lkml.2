Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1HZS0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:26:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42219 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752096Ab1HZS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:26:44 -0400
Date: Fri, 26 Aug 2011 14:26:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 1/4] usb: Provide usb_speed_string() function
In-Reply-To: <20110826180734.GA24226@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1108261422460.2275-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Greg KH wrote:

> > --- a/drivers/usb/Makefile
> > +++ b/drivers/usb/Makefile
> > @@ -53,3 +53,5 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
> >  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
> >  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
> >  obj-$(CONFIG_USB_GADGET)	+= gadget/
> > +
> > +obj-$(CONFIG_USB_SUPPORT)	+= common.o
> 
> You just built this into the kernel, which while ok for some things,
> might not be what some people want.
> 
> Please make this into a separate module if people are building the usb
> code as modules, usb_common.ko perhaps?

> > +#ifdef __KERNEL__
> > +
> > +/**
> > + * usb_speed_string() - Returns human readable-name of the speed.
> > + * @speed: The speed to return human-readable name for.  If it's not
> > + *   any of the speeds defined in usb_device_speed enum, string for
> > + *   USB_SPEED_UNKNOWN will be returned.
> > + */
> > +extern const char *usb_speed_string(enum usb_device_speed speed);
> > +
> > +#endif
> 
> No, this should be in include/linux/usb.h, not ch9.h.

There's a reason for both of these things.  The usb_speed_string 
routine, like the other stuff in ch9.h, is meant to be used with both 
the host-side and device-side USB stacks.

This makes deciding where to put it kind of difficult.  The two stacks 
are pretty much independent; one might be built into the kernel while 
the other is built as modules.  The easiest solution that will always 
work is to put common.c into the main kernel.

Can you suggest a better solution?

Alan Stern

