Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab2GLASo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:18:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63421 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030511Ab2GLASn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <1341608777-12982-34-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<1341608777-12982-34-git-send-email-catalin.marinas@arm.com>
Date: Thu, 12 Jul 2012 02:18:42 +0200
Message-ID: <CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm reviewing the only patch I really understand...

2012/7/6 Catalin Marinas <catalin.marinas@arm.com>:

> +/* This isn't really used any more */
> +#define CLOCK_TICK_RATE 1000

Is it still necessary to even have it there?

> +       /* Try to determine the frequency from the device tree or CNTFRQ */
> +       if (!of_property_read_u32(np, "clock-frequency", &freq))
> +               arch_timer_rate = freq;

Have you documented the bindings for this thing?

> +       arch_timer_calibrate();

Why is the ability to get this from a clk not contemplated?
I think this will be common. You could make it optional I think,
just like in the SMP TWD.

> diff --git a/include/clocksource/arm_generic.h b/include/clocksource/arm_generic.h
> new file mode 100644
> index 0000000..6933f8e
(...)
> +#ifndef __ASM_ARCH_TIMER_H
> +#define __ASM_ARCH_TIMER_H

This #ifdef name looks confusing, what about
#ifndef __CLKSOURCE_ARM_GENERIC_H?

I noticed you already saw the problem with naming it "arch timers"
and renamed it to "arm generic" so a leftover here :)

Yours,
Linus Walleij
