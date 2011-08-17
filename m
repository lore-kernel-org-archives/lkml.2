Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1HQPH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:07:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37710 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1HQPHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:07:55 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108171045200.2100-100000@iolanthe.rowland.org>
Date: Wed, 17 Aug 2011 17:07:52 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0c5nezf3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108171045200.2100-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, 17 Aug 2011, Michal Nazarewicz wrote:
>>>> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct
>>>> usb_composite_driver *driver,
>>>>  		driver->iProduct = driver->name;
>>>>  	composite_driver.function =  (char *) driver->name;
>>>>  	composite_driver.driver.name = driver->name;
>>>> -	composite_driver.speed = min((u8)composite_driver.speed,
>>>> -				     (u8)driver->max_speed);
>>>> +	composite_driver.speed = min(USB_SPEED_SUPER, driver->max_speed);

>> On Wed, 17 Aug 2011 16:20:15 +0200, Alan Stern wrote:
>>> I wonder if the min is needed here at all.  It doesn't seem to be  
>>> doing any good.

> On Wed, 17 Aug 2011, Michal Nazarewicz wrote:
>> Do you mean just doing “composite_driver.speed = driver->max_speed”?

On Wed, 17 Aug 2011 16:47:37 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> Yes.  After all, there aren't any usb_device_speed values larger than
> USB_SPEED_SUPER.

Will fix.

>>>> --- a/drivers/usb/gadget/file_storage.c
>>>> +++ b/drivers/usb/gadget/file_storage.c
>>>> @@ -3562,11 +3562,7 @@ static void fsg_resume(struct usb_gadget  
>>>> *gadget)
>>>>  static struct usb_gadget_driver		fsg_driver = {
>>>> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>>>>  	.speed		= USB_SPEED_HIGH,
>>>> -#else
>>>> -	.speed		= USB_SPEED_FULL,
>>>> -#endif
>>>>  	.function	= (char *) fsg_string_product,
>>>>  	.unbind		= fsg_unbind,
>>>>  	.disconnect	= fsg_disconnect,

>>> You mustn't remove the .speed field entirely.  Set it to  
>>> USB_SPEED_HIGH.

>> Please note that the field is not in fact removed.

> No, but you removed its initializer and as a result, it will be set to
> 0 whereas it should be set to USB_SPEED_HIGH.

The initializer is still there. ;)  Only the “#” lines and the initializer
in the “#else” part are removed.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
