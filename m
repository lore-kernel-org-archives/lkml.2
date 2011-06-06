Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1FFK3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:29:12 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35390 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998Ab1FFK3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:29:08 -0400
Date: Mon, 6 Jun 2011 12:29:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
	locks up on ARM
Message-ID: <20110606102905.GB5820@atrey.karlin.mff.cuni.cz>
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com> <1306405979.1200.63.camel@twins> <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com> <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins> <20110526122623.GA11875@elte.hu> <20110526123137.GG24876@n2100.arm.linux.org.uk> <20110526125007.GA27083@elte.hu> <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com> <20110527120629.GA32617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527120629.GA32617@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The expectations are to have irqs off (we are holding the runqueue 
> lock if !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so that's not workable i 
> suspect.
> 
> But in theory we could drop the rq lock and restart the scheduler 
> task-pick and balancing sequence when the ARM TLB tag rolls over. So 
> instead of this fragile and assymetric method we'd have a 
> straightforward retry-in-rare-cases method.
> 
> That means some modifications to switch_mm() but should be solvable.
> 
> That would make ARM special only in so far that it's one of the few 
> architectures that signal 'retry task pickup' via switch_mm() - it 
> would use the stock scheduler otherwise and we could remove 
> __ARCH_WANT_INTERRUPTS_ON_CTXSW and perhaps even 
> __ARCH_WANT_UNLOCKED_CTXSW altogether.
> 
> I'd suggest doing this once modern ARM chips get so widespread that 
> you can realistically induce a ~700 usecs irqs-off delays on old, 
> virtual-cache ARM chips. Old chips would likely use old kernels 
> anyway, right?

Not really. Equivalent machines (400g) with new chips do not exist, so
many people are stuck with Sharp Zaurus, and track latest kernels,
because support is actually improving there.

(And yes, I'd like to keep using bluetooth CF card with 16550-style
chip.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
