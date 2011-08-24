Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1HXCQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:16:13 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39790 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab1HXCQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1108221325290.2192-100000@iolanthe.rowland.org>
References: <929137d06c253bafa2a5559534dd865d4d5a959e.1314028707.git.mina86@mina86.com>
	<Pine.LNX.4.44L0.1108221325290.2192-100000@iolanthe.rowland.org>
Date: Wed, 24 Aug 2011 10:16:04 +0800
Message-ID: <CABqxG0fyNNV39=tnTOVEK+Ko_UxdD0Mc593T7ARFTE47+ab=kQ@mail.gmail.com>
Subject: Re: [PATCHv4 1/4] usb: Provide usb_speed_string() function
From: Dave Young <hidave.darkstar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 1:28 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
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
>> this new function.  This changes a bit the way the
>> speed is printed in few instances at the same time
>> standardising it.
>
>> --- a/drivers/usb/Makefile
>> +++ b/drivers/usb/Makefile
>> @@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC) += musb/
>>  obj-$(CONFIG_USB_RENESAS_USBHS)      += renesas_usbhs/
>>  obj-$(CONFIG_USB_OTG_UTILS)  += otg/
>>  obj-$(CONFIG_USB_GADGET)     += gadget/
>> +
>> +obj-$(CONFIG_USB)            += common.o
>> +obj-$(CONFIG_USB_GADGET)     += common.o
>
> Will this cause problems?  For example, what if CONFIG_USB is Y and
> CONFIG_USB_GADGET is M?
>
> Also, it seems a little silly to have an entire kernel module devoted
> to a single, little function.  This is a symptom of the difficulty of
> sharing code between the host-side and gadget-side USB stacks.
>

How about put the code as inline function in ch9.h?

> Alan Stern
>
>



-- 
Regards
Yang RuiRui
