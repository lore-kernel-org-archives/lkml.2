Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1HVR2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 13:28:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38137 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751944Ab1HVR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 13:28:47 -0400
Date: Mon, 22 Aug 2011 13:28:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 1/4] usb: Provide usb_speed_string() function
In-Reply-To: <929137d06c253bafa2a5559534dd865d4d5a959e.1314028707.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1108221325290.2192-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> In a few places in the kernel, the code prints
> a human-readable USB device speed (eg. "high speed").
> This involves a switch statement sometimes wrapped
> around in ({ ... }) block leading to code repetition.
> 
> To mitigate this issue, this commit introduces
> usb_speed_string() function, which returns
> a human-readable name of provided speed.
> 
> It also changes a few places switch was used to use
> this new function.  This changes a bit the way the
> speed is printed in few instances at the same time
> standardising it.

> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
>  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
>  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
>  obj-$(CONFIG_USB_GADGET)	+= gadget/
> +
> +obj-$(CONFIG_USB)		+= common.o
> +obj-$(CONFIG_USB_GADGET)	+= common.o

Will this cause problems?  For example, what if CONFIG_USB is Y and 
CONFIG_USB_GADGET is M?

Also, it seems a little silly to have an entire kernel module devoted 
to a single, little function.  This is a symptom of the difficulty of 
sharing code between the host-side and gadget-side USB stacks.

Alan Stern

