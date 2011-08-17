Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1HQQZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:25:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58027 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753946Ab1HQQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:25:28 -0400
Date: Wed, 17 Aug 2011 12:25:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <op.v0c5nezf3l0zgt@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108171224380.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011, Michal Nazarewicz wrote:

> >>>> --- a/drivers/usb/gadget/file_storage.c
> >>>> +++ b/drivers/usb/gadget/file_storage.c
> >>>> @@ -3562,11 +3562,7 @@ static void fsg_resume(struct usb_gadget  
> >>>> *gadget)
> >>>>  static struct usb_gadget_driver		fsg_driver = {
> >>>> -#ifdef CONFIG_USB_GADGET_DUALSPEED
> >>>>  	.speed		= USB_SPEED_HIGH,
> >>>> -#else
> >>>> -	.speed		= USB_SPEED_FULL,
> >>>> -#endif
> >>>>  	.function	= (char *) fsg_string_product,
> >>>>  	.unbind		= fsg_unbind,
> >>>>  	.disconnect	= fsg_disconnect,
> 
> >>> You mustn't remove the .speed field entirely.  Set it to  
> >>> USB_SPEED_HIGH.
> 
> >> Please note that the field is not in fact removed.
> 
> > No, but you removed its initializer and as a result, it will be set to
> > 0 whereas it should be set to USB_SPEED_HIGH.
> 
> The initializer is still there. ;)  Only the “#” lines and the initializer
> in the “#else” part are removed.

I must be going selectively blind.  Never mind...

Alan Stern

