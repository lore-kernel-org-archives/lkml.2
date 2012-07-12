Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621Ab2GLK4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:56:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64028 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608Ab2GLK4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <12a7f9b8e6d0b4dc3e3f6fcf91ad2a18@localhost>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<1341608777-12982-34-git-send-email-catalin.marinas@arm.com>
	<CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com>
	<12a7f9b8e6d0b4dc3e3f6fcf91ad2a18@localhost>
Date: Thu, 12 Jul 2012 12:56:31 +0200
Message-ID: <CACRpkdbMjRzTVo6o-+z6mNNkKWp1mFL76ptKd8PFV8orgFLeOg@mail.gmail.com>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
From: Linus Walleij <linus.walleij@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>, John Stultz <john.stultz@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 12:09 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:

> On Thu, 12 Jul 2012 02:18:42 +0200, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
>
> Hi Linus,
>
>> I'm reviewing the only patch I really understand...
>>
>> 2012/7/6 Catalin Marinas <catalin.marinas@arm.com>:
>>
>>> +/* This isn't really used any more */
>>> +#define CLOCK_TICK_RATE 1000
>>
>> Is it still necessary to even have it there?
>
> It is used as part of the LATCH/TICK_* computation in
> include/linux/jiffies.h. It seems that any value could do, actually, and it
> only seem to be used in kernel/time/ntp.c. Any guidance on this much
> appreciated.
>
> By the way, there is a very interesting comment about this in
> arch/ia64/include/asm/timex.h.

Hmmmm paging John Stultz, TGLX, Deepak Saxena who have been in
this area...

>>> +       arch_timer_calibrate();
>>
>> Why is the ability to get this from a clk not contemplated?
>> I think this will be common. You could make it optional I think,
>> just like in the SMP TWD.
>
> _calibrate() is a misnomer here. It should really be _get_freq(). But your
> point still stand, and we could indeed use a clk to obtain the frequency.
>
> It should probably be selected in the following order: clock-frequency
> (DT), clk, CNTFRQ.

I agree. It can be bolted on later too, just trying to think ahead a bit.

I'm half-guessing that for mobile embedded with their complex clock trees
it will likely come from a clk whereas in servers etc there will be one
big clock for all and it will be fine to use the DT node.

Yours,
Linus Walleij
