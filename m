Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1HVPDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:03:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46603 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752145Ab1HVPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:03:41 -0400
Date: Mon, 22 Aug 2011 11:03:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/4] usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED
In-Reply-To: <op.v0md7lep3l0zgt@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108221103070.2192-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Michal Nazarewicz wrote:

> >> --- a/drivers/usb/gadget/inode.c
> >> +++ b/drivers/usb/gadget/inode.c
> > ...
> >> @@ -1773,11 +1767,7 @@ gadgetfs_suspend (struct usb_gadget *gadget)
> >>  }
> >>
> >>  static struct usb_gadget_driver gadgetfs_driver = {
> >> -#ifdef	CONFIG_USB_GADGET_DUALSPEED
> >>  	.max_speed	= USB_SPEED_HIGH,
> >> -#else
> >> -	.max_speed	= USB_SPEED_FULL,
> >> -#endif
> 
> > I'm not sure that a static definition is correct here.  The actual
> > max_speed depends on what descriptors the userspace program sends.
> > Take a look at the ep_config() routine.
> 
> Good catch.  I've changed it to:
> 
> if (dev->hs_config)
> 	gadgetfs_driver.max_speed = USB_SPEED_HIGH;
> else
> 	gadgetfs_driver.max_speed = USB_SPEED_FULL;
> 
> just before usb_gadget_probe_driver(), which should do the trick.

Yes, that sounds like the right thing to do.

Alan Stern

