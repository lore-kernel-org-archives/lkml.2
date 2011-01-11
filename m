Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1AKMQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:16:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60260 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab1AKMQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XJUlADVaa3JPbw/+4lpm5s+XVJdbmzFiyyXmTlzlPnqZQ8LD1pjiZATRUU2uugsP/e
         rBgxrbb9btJ+tD+YfqGGXlaYTuw77e0XMiA5/WrRTG/1gGKrKOj4+R4gm4ZNqCj0MYgc
         R49IFqaqdQdIgqvGa/Z8i1l1sqLyoE5EFQv/M=
MIME-Version: 1.0
In-Reply-To: <20110111112434.GE2385@legolas.emea.dhcp.ti.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com> <20110111112434.GE2385@legolas.emea.dhcp.ti.com>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Tue, 11 Jan 2011 17:46:10 +0530
X-Google-Sender-Auth: VFZaYF9wdLq6mDpCZLg45YS54zI
Message-ID: <AANLkTimbqsDJ1KNSwzJ_RTQ3ON=-XUj0CZpZHAkeH9dP@mail.gmail.com>
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common sources
To: balbi@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

an 11, 2011 at 4:54 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jan 11, 2011 at 06:31:23AM -0500, manjunatha_halli@ti.com wrote:
>> From: Manjunatha Halli <manjunatha_halli@ti.com>
>>
>> These are the sources for the common interfaces required by the
>> FM V4L2 driver for TI WL127x and WL128x chips.
>>
>> These implement the FM channel-8 protocol communication with the
>> chip. This makes use of the Shared Transport as its transport.
>>
>> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> looks like this is implementing a "proprietary" (by that I mean: for
> this driver only) IRQ API. Why aren't you using GENIRQ with threaded
> IRQs support ?
>
> Core IRQ Subsystem would handle a lot of stuff for you.

There is no concept of Interrupts/IRQ as such here, Hence no question of using
GENIRQ.

The FM device WL128x is interfaced via the UART,
(Internally inside the WL128x chip the BT-core on the chip
communicates with FM chip via i2C, and would have dedicated interrupt
lines may be...)

So, Whenever we refer to interrupt or IRQ or handlers in the driver,
It pretty much means a receive callback for the UART frame which
constitutes the FM interrupt event.
i.e FM interrupt would have occurred, If I receive a frame over UART
which starts with 0x08 as 1st byte and has 0xFF as its 3rd byte.

I hope this clarifies the non-usage of GENIRQ with threaded support.

> --
> balbi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
Halli
