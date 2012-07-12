Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab2GLKJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:09:32 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:57486 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933643Ab2GLKJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:29 -0400
To: Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 12 Jul 2012 12:09:24 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Organization: ARM Ltd
In-Reply-To: <CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-34-git-send-email-catalin.marinas@arm.com> <CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com>
Message-ID: <12a7f9b8e6d0b4dc3e3f6fcf91ad2a18@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: linus.ml.walleij@gmail.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, arnd@arndb.de, will.deacon@arm.com, mike.turquette@linaro.org, maz@misterjones.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 02:18:42 +0200, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:

Hi Linus,

> I'm reviewing the only patch I really understand...
> 
> 2012/7/6 Catalin Marinas <catalin.marinas@arm.com>:
> 
>> +/* This isn't really used any more */
>> +#define CLOCK_TICK_RATE 1000
> 
> Is it still necessary to even have it there?

It is used as part of the LATCH/TICK_* computation in
include/linux/jiffies.h. It seems that any value could do, actually, and it
only seem to be used in kernel/time/ntp.c. Any guidance on this much
appreciated.

By the way, there is a very interesting comment about this in
arch/ia64/include/asm/timex.h.

>> +       /* Try to determine the frequency from the device tree or
CNTFRQ
>> */
>> +       if (!of_property_read_u32(np, "clock-frequency", &freq))
>> +               arch_timer_rate = freq;
> 
> Have you documented the bindings for this thing?

It has been documented as part of the architected timer patch that has
been merged for 3.5. See
Documentation/devicetree/bindings/arm/arch_timer.txt.

>> +       arch_timer_calibrate();
> 
> Why is the ability to get this from a clk not contemplated?
> I think this will be common. You could make it optional I think,
> just like in the SMP TWD.

_calibrate() is a misnomer here. It should really be _get_freq(). But your
point still stand, and we could indeed use a clk to obtain the frequency.

It should probably be selected in the following order: clock-frequency
(DT), clk, CNTFRQ.

>> diff --git a/include/clocksource/arm_generic.h
>> b/include/clocksource/arm_generic.h
>> new file mode 100644
>> index 0000000..6933f8e
> (...)
>> +#ifndef __ASM_ARCH_TIMER_H
>> +#define __ASM_ARCH_TIMER_H
> 
> This #ifdef name looks confusing, what about
> #ifndef __CLKSOURCE_ARM_GENERIC_H?
> 
> I noticed you already saw the problem with naming it "arch timers"
> and renamed it to "arm generic" so a leftover here :)

Thanks! :-)

        M.
-- 
Fast, cheap, reliable. Pick two.
