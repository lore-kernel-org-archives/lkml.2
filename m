Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2GXAOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 20:14:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41184 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2GXAOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 20:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRR2-VjUeL2XPKubeaG=iLV5NE-i_sVYbuMAryXLxsbo1g@mail.gmail.com>
References: <1342567672-29071-1-git-send-email-ccross@android.com>
	<CACRpkdaHdCvx1HJNDsyJSZAN--sF+4-V1TbzXZL1v+7Asoe_oA@mail.gmail.com>
	<CAMbhsRR2-VjUeL2XPKubeaG=iLV5NE-i_sVYbuMAryXLxsbo1g@mail.gmail.com>
Date: Tue, 24 Jul 2012 02:14:22 +0200
Message-ID: <CACRpkdYayLaKzUSq5V9N5sRkV74a+nZ1CbLJzRW7RP=pOU9bfw@mail.gmail.com>
Subject: Re: [RFC] ARM: sched_clock: update epoch_cyc on resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Krzysztof Halasa <khc@pm.waw.pl>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 9:27 PM, Colin Cross <ccross@android.com> wrote:
> On Mon, Jul 23, 2012 at 11:55 AM, Linus Walleij

> Does the clock you use for sched_clock continue to run in all suspend
> modes? All the SoC's I've used only have a 32kHz clock in the deepest
> suspend mode,

Yes, and yes it is 32kHz.

> which is not ideal for sched_clock.

Not that I know why scheduling with 32kHz is so bad compared to the
default system scheduling granularity which is HZ if you don't have
sched_clock() implemented.

Since this seems to be such an important point, what makes you
want MHz:es for scheduling granularity? To me the biggest impact
is actually the granularity of the timestamps in the printk:s.

(It's not that I doubt your needs, more curiosity.)

>  For example, on
> Tegra2 the faster 1MHz clock used for sched_clock resets in the
> deepest suspend state (LP0) but not the shallowest suspend state
> (LP2), and which suspend state the chip hits depends on which hardware
> is active.  Opting out of this patch would cause Tegra's clock to
> sometimes run in suspend, and sometimes not, which seems worse for
> debugging than consistently not running in suspend.  I'd be surprised
> if a similar situation didn't apply to your platform.

Well being able to switch between different sched_clock() providers
may be the ideal...

>> - If it absolutely needs to be in the core code, also have a bool
>>   field indicating whether the clock is going to die during suspend
>>   and add new registration functions for setting that sched_clock
>>   type, e.g. setup_sched_clock_nonsuspendable()
>
> Sounds reasonable if some platforms need the extra complexity.

OK agreed.

A connecting theme is that of being avle to flag clock sources as
sched_clock providers. If all clocksources were tagged with
rating, and only clocksources were used for sched_clock(), the
kernel could select the highest-rated clock under all circumstances.

But that's quite intrusive, more of an idea. :-P

Yours,
Linus Walleij
