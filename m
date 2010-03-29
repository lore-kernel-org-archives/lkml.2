Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0C2Qi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:38:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:46593 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0C2Qiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:38:54 -0400
Date: Mon, 29 Mar 2010 12:38:53 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003291224170.27175@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003291237480.27175@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003291116240.1680-100000@iolanthe.rowland.org> <alpine.DEB.2.00.1003291224170.27175@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Mar 2010, Justin Piszcz wrote:

>
>
> On Mon, 29 Mar 2010, Alan Stern wrote:

> For your patch, what does this patch against? It does not apply cleanly
> for 2.6.33.
It also fails against 2.6.34-rc2, can you diff -u and show the patch so
I can patch manually or include a patch against 2.6.33 or 2.6.34-rc2? 
Thanks.

>
>> 
>> Alan Stern
>> 
>> 
>> Index: usb-2.6/drivers/usb/host/ohci-hcd.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/usb/host/ohci-hcd.c
>> +++ usb-2.6/drivers/usb/host/ohci-hcd.c
>> @@ -290,6 +290,8 @@ static int ohci_urb_dequeue(struct usb_h
>> 		 */
>> 		urb_priv = urb->hcpriv;
>> 		if (urb_priv) {
>> +			ohci_info(ohci, "start unlink urb %p, ed %p\n",
>> +					urb, urb_priv->ed);
>> 			if (urb_priv->ed->state == ED_OPER)
>> 				start_ed_unlink (ohci, urb_priv->ed);
>> 		}
>> @@ -324,6 +326,9 @@ ohci_endpoint_disable (struct usb_hcd *h
>>
>> 	if (!ed)
>> 		return;
>> +	ohci_info(ohci, "disable ed %p (#%02x) state %d%s\n",
>> +			ed, ep->desc.bEndpointAddress, ed->state,
>> +			list_empty(&ed->td_list) ? "" : " (has tds)");
>> 
>> rescan:
>> 	spin_lock_irqsave (&ohci->lock, flags);
>> @@ -770,6 +775,10 @@ static irqreturn_t ohci_irq (struct usb_
>> 		return IRQ_HANDLED;
>> 	}
>> 
>> +	ohci_info(ohci, "int %x enable %x rm_list %p\n", ints,
>> +			ohci_readl(ohci, &regs->intrenable),
>> +			ohci->ed_rm_list);
>> +
>> 	/* We only care about interrupts that are enabled */
>> 	ints &= ohci_readl(ohci, &regs->intrenable);
>> 
>> 
>
