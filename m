Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1HVOvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:51:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42514 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1HVOvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:51:15 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>,
        "Felipe Balbi" <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 4/4] usb: gadget: get rid of
 USB_GADGET_{DUAL,SUPER}SPEED
References: <Pine.LNX.4.44L0.1108200932190.26680-100000@netrider.rowland.org>
Date: Mon, 22 Aug 2011 16:51:11 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0md7lep3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108200932190.26680-100000@netrider.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 20 Aug 2011, Michal Nazarewicz wrote:
>> --- a/drivers/usb/gadget/dummy_hcd.c
>> +++ b/drivers/usb/gadget/dummy_hcd.c
>> @@ -985,7 +985,7 @@ static int dummy_udc_probe (struct platform_device  
>> *pdev)
>>
>>  	dum->gadget.name = gadget_name;
>>  	dum->gadget.ops = &dummy_ops;
>> -	dum->gadget.max_speed = USB_SPEED_SUPER;;
>> +	dum->gadget.max_speed = USB_SPEED_SUPER;

On Sat, 20 Aug 2011 15:41:17 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> You might as well get this right in patch 2/4.  Then this hunk
> wouldn't be needed.

Sorry about that, I've fixuped the wrong commit

>> --- a/drivers/usb/gadget/inode.c
>> +++ b/drivers/usb/gadget/inode.c
> ...
>> @@ -1773,11 +1767,7 @@ gadgetfs_suspend (struct usb_gadget *gadget)
>>  }
>>
>>  static struct usb_gadget_driver gadgetfs_driver = {
>> -#ifdef	CONFIG_USB_GADGET_DUALSPEED
>>  	.max_speed	= USB_SPEED_HIGH,
>> -#else
>> -	.max_speed	= USB_SPEED_FULL,
>> -#endif

> I'm not sure that a static definition is correct here.  The actual
> max_speed depends on what descriptors the userspace program sends.
> Take a look at the ep_config() routine.

Good catch.  I've changed it to:

if (dev->hs_config)
	gadgetfs_driver.max_speed = USB_SPEED_HIGH;
else
	gadgetfs_driver.max_speed = USB_SPEED_FULL;

just before usb_gadget_probe_driver(), which should do the trick.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
