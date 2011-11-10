Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab1KJPHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:07:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933924Ab1KJPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:07:10 -0500
Date: Thu, 10 Nov 2011 16:05:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Chen Jie <chenj@lemote.com>,
        zhangfx <zhangfx@lemote.com>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
Message-ID: <20111110150521.GD29614@elte.hu>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
 <20111103211000.GA17895@elte.hu>
 <1320721740.10668.23.camel@work-vm>
 <20111108050259.GA13225@zhy>
 <1320788342.10668.49.camel@work-vm>
 <20111109014632.GA8124@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109014632.GA8124@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yong Zhang <yong.zhang0@gmail.com> wrote:

> On Tue, Nov 08, 2011 at 01:39:02PM -0800, John Stultz wrote:
> > On Tue, 2011-11-08 at 13:02 +0800, Yong Zhang wrote:
> > > On Mon, Nov 07, 2011 at 07:09:00PM -0800, John Stultz wrote:
> > > > Yong: Can you also give this a test run to make sure you don't see any
> > > > problems?
> > > 
> > > Still get warning (3.2-rc1 + your patch):
> > > 
> > > [    0.017009] ------------[ cut here ]------------
> > > [    0.022156] WARNING: at /build/linux/kernel/time/timekeeping.c:828 do_timer+0x402/0x4e0()
> > > [    0.035917] Adjusting jiffies more then 11% (1024068096 vs 1024064000)
> > 
> > Ah. We're tripping the warning here in early boot. We use jiffies as the
> > default clocksource initially even before it is registered and the
> > maxadj is then set. So since its null here, any adjustment triggers the
> > warning.
> > 
> > That's easy enough to avoid. Can you give this updated version a try to
> > make sure I didn't miss anything else?
> 
> This version boot well on my side.
> 
> echo acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource
> echo hpet > /sys/devices/system/clocksource/clocksource0/current_clocksource
> 
> both work well.
> 
> Tested-by: Yong Zhang <yong.zhang0@gmail.com>

John, mind sending a pull request for this, based against current 
tip:timers/core? I'm quite sure it will fix the boot warning i saw as 
well.

Thanks,

	Ingo
