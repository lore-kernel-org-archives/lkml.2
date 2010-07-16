Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab0GPJLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:11:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51975 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936044Ab0GPJLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qVNDIav7Zs40sxiUJBqimBiKc0CQPc0d4epcGmpAa7bm8J60rXBAGZOY50wg0enhPL
         vncvgcxaa1BL7Z65hPZWpTGbytSLgyo+vr5FD/LsxJbvS41HNdPtY8Bqpm9JQVq2R+Vs
         u78H8TAaG2x4u25M5zNY6c5qqztaN6ARcEp0A=
MIME-Version: 1.0
In-Reply-To: <201007160919.24927.marek.vasut@gmail.com>
References: <4C3FCBFF.50506@gmail.com>
	<201007160709.15385.marek.vasut@gmail.com>
	<AANLkTinEqScq2E0MSRJrUN5fR-1rs8fB9rLgMdhYW9R6@mail.gmail.com>
	<201007160919.24927.marek.vasut@gmail.com>
Date: Fri, 16 Jul 2010 17:11:43 +0800
Message-ID: <AANLkTimi1FQLu5-gY-AV7Ukq9rBc31XrTWz3gLzZGYd1@mail.gmail.com>
Subject: Re: [PATCH] ARM/nuc900: fix nuc900 touchscreen clk definition bug
From: Wan ZongShun <mcuos.com@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/16 Marek Vasut <marek.vasut@gmail.com>:
> Dne Pá 16. července 2010 07:34:21 Wan ZongShun napsal(a):
>> 2010/7/16 Marek Vasut <marek.vasut@gmail.com>:
>> > Dne Pá 16. července 2010 05:03:27 Wan ZongShun napsal(a):
>> >> This patch is to fix nuc900 touchscreen clk definition bug,the .dev_id's
>> >> name should be 'nuc900-ts', it should be the same to pdev.name. or else,
>> >> the touchscreen driver will be not working well due to clock engine
>> >> disabled.
>> >>
>> >> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
>> >> ---
>> >>  arch/arm/mach-w90x900/cpu.c |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
>> >> index 642207e..83c5632 100644
>> >> --- a/arch/arm/mach-w90x900/cpu.c
>> >> +++ b/arch/arm/mach-w90x900/cpu.c
>> >> @@ -93,7 +93,7 @@ static struct clk_lookup nuc900_clkregs[] = {
>> >>       DEF_CLKLOOK(&clk_kpi, "nuc900-kpi", NULL),
>> >>       DEF_CLKLOOK(&clk_wdt, "nuc900-wdt", NULL),
>> >>       DEF_CLKLOOK(&clk_gdma, "nuc900-gdma", NULL),
>> >> -     DEF_CLKLOOK(&clk_adc, "nuc900-adc", NULL),
>> >> +     DEF_CLKLOOK(&clk_adc, "nuc900-ts", NULL),
>> >>       DEF_CLKLOOK(&clk_usi, "nuc900-spi", NULL),
>> >>       DEF_CLKLOOK(&clk_ext, NULL, "ext"),
>> >>       DEF_CLKLOOK(&clk_timer0, NULL, "timer0"),
>> >
>> > Hey,
>> >
>> > Is that thing really touchscreen or general-purpose analog/digital
>> > converter ?
>>
>> Oh, it is general-purpose analog/digital converter controller.
>> I only use it to implemnt my touchscreen function, Also it can be use
>> other function.
>>
>> so, I have to change my touchscreen driver name to nuc900-adc?
>
> No, just change the name of clock in the touchscreen driver. So that the
> touchscreen driver will use nuc900-adc clocksource.


But the clk_get() identifies this clk via looking driver or pdev name.
so I must change my touchscreen driver name, right?
>
> You're welcome. :)
>
>>
>> Thanks for your Reminder, I appreciate it. :)
>>
>> > Cheers
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
