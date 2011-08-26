Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1HZSfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:35:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57918 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab1HZSe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:34:57 -0400
X-Sasl-enc: 7pKwB0de4vsJ2fK9AmRJTZNrDow1PgIJFU6GlgRMtiFQ 1314383696
Date: Fri, 26 Aug 2011 11:34:50 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/4] usb: Provide usb_speed_string() function
Message-ID: <20110826183450.GA32142@kroah.com>
References: <20110826180734.GA24226@kroah.com>
 <Pine.LNX.4.44L0.1108261422460.2275-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108261422460.2275-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 02:26:43PM -0400, Alan Stern wrote:
> On Fri, 26 Aug 2011, Greg KH wrote:
> 
> > > --- a/drivers/usb/Makefile
> > > +++ b/drivers/usb/Makefile
> > > @@ -53,3 +53,5 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
> > >  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
> > >  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
> > >  obj-$(CONFIG_USB_GADGET)	+= gadget/
> > > +
> > > +obj-$(CONFIG_USB_SUPPORT)	+= common.o
> > 
> > You just built this into the kernel, which while ok for some things,
> > might not be what some people want.
> > 
> > Please make this into a separate module if people are building the usb
> > code as modules, usb_common.ko perhaps?
> 
> > > +#ifdef __KERNEL__
> > > +
> > > +/**
> > > + * usb_speed_string() - Returns human readable-name of the speed.
> > > + * @speed: The speed to return human-readable name for.  If it's not
> > > + *   any of the speeds defined in usb_device_speed enum, string for
> > > + *   USB_SPEED_UNKNOWN will be returned.
> > > + */
> > > +extern const char *usb_speed_string(enum usb_device_speed speed);
> > > +
> > > +#endif
> > 
> > No, this should be in include/linux/usb.h, not ch9.h.
> 
> There's a reason for both of these things.  The usb_speed_string 
> routine, like the other stuff in ch9.h, is meant to be used with both 
> the host-side and device-side USB stacks.

Ok, the __KERNEL__ stuff threw me off, those should not be in the patch
as they are not needed, so it's ok to keep it here, sorry.

> This makes deciding where to put it kind of difficult.  The two stacks 
> are pretty much independent; one might be built into the kernel while 
> the other is built as modules.  The easiest solution that will always 
> work is to put common.c into the main kernel.

A module, if the USB Host core is a module, and a module if the USB
gadge core is a module, would be best if at all possible.  I'm a bit
leery of adding stuff to be built into the kernel no matter how the user
decided to configure USB.

Is this possible with the Kbuild system somehow?

thanks,

greg k-h
