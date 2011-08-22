Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1HVTml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:42:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1HVTmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:42:39 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/4] usb: Provide usb_speed_string() function
References: <Pine.LNX.4.44L0.1108221325290.2192-100000@iolanthe.rowland.org>
Date: Mon, 22 Aug 2011 21:42:35 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0mro90r3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108221325290.2192-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 19:28:46 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:

> On Mon, 22 Aug 2011, Michal Nazarewicz wrote:
>
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> In a few places in the kernel, the code prints
>> a human-readable USB device speed (eg. "high speed").
>> This involves a switch statement sometimes wrapped
>> around in ({ ... }) block leading to code repetition.
>>
>> To mitigate this issue, this commit introduces
>> usb_speed_string() function, which returns
>> a human-readable name of provided speed.
>>
>> It also changes a few places switch was used to use
>> this new function.  This changes a bit the way the
>> speed is printed in few instances at the same time
>> standardising it.
>
>> --- a/drivers/usb/Makefile
>> +++ b/drivers/usb/Makefile
>> @@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
>>  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
>>  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
>>  obj-$(CONFIG_USB_GADGET)	+= gadget/
>> +
>> +obj-$(CONFIG_USB)		+= common.o
>> +obj-$(CONFIG_USB_GADGET)	+= common.o
>
> Will this cause problems?  For example, what if CONFIG_USB is Y and
> CONFIG_USB_GADGET is M?

Hmm, I haven't thought about that.

> Also, it seems a little silly to have an entire kernel module devoted
> to a single, little function.

Agreed.  And again, I haven't thought about compiling as a module which
would result in a major overkill.

> This is a symptom of the difficulty of
> sharing code between the host-side and gadget-side USB stacks.

Agreed.

I'm open to any suggestions on how this could be solved.

Sticking the function to the header file as static inline seems
like bit... ”bloaty”.

If this is not easily solvable, I'll probably just drop this patch
for now.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
