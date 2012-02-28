Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2B1FLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:11:49 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40787 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2B1FLs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:11:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tarun.kanti@ti.com designates 10.224.72.138 as permitted sender) smtp.mail=tarun.kanti@ti.com
MIME-Version: 1.0
In-Reply-To: <87linnu8o8.fsf@ti.com>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
	<1329999031-6914-5-git-send-email-tarun.kanti@ti.com>
	<87linnu8o8.fsf@ti.com>
Date: Tue, 28 Feb 2012 10:41:47 +0530
Message-ID: <CAC83Zv+qGD-60=hmd=7rgxqSiw2yHe78C6TyO1pj+qe3UPtcEQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] gpio/omap: get rid of retrigger variable in gpio_irq_handler
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 5:32 AM, Kevin Hilman <khilman@ti.com> wrote:
> Tarun Kanti DebBarma <tarun.kanti@ti.com> writes:
>
>> This local variable is just assigned zero and then OR'ed
>> with isr. It does not appear to serve any purpose and so
>> removing it.
>>
>> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>
> Looks like the use of this was removed when I moved things over to using
> the generic IRQ framework, but I didn't fully clean up.
>
> Can you update the changelog to something along the lines of:
>
> "commit 672e302e3c (ARM: OMAP: use edge/level handlers from generic IRQ
> framework) removed retrigger support in favor of using generic IRQ
> framework.  This patch cleans up some unused remnants of that removal.
Yes, sure.
--
Tarun
>
> Thanks,
>
> Kevin
>
>> ---
>>  drivers/gpio/gpio-omap.c |    3 ---
>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>> index b62e861..3dd4b3a 100644
>> --- a/drivers/gpio/gpio-omap.c
>> +++ b/drivers/gpio/gpio-omap.c
>> @@ -623,7 +623,6 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
>>       u32 isr;
>>       unsigned int gpio_irq, gpio_index;
>>       struct gpio_bank *bank;
>> -     u32 retrigger = 0;
>>       int unmasked = 0;
>>       struct irq_chip *chip = irq_desc_get_chip(desc);
>>
>> @@ -660,8 +659,6 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
>>                       chained_irq_exit(chip, desc);
>>               }
>>
>> -             isr |= retrigger;
>> -             retrigger = 0;
>>               if (!isr)
>>                       break;
