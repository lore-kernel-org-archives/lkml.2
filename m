Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1EXVjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab1EXVjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:37 -0400
Date: Tue, 24 May 2011 23:39:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG]  "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
Message-ID: <20110524213924.GO27634@elte.hu>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
 <1306272750.2497.79.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306272750.2497.79.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-05-24 at 19:13 +0100, Marc Zyngier wrote:
> > Peter,
> > 
> > I've experienced all kind of lock-ups on ARM SMP platforms recently, and
> > finally tracked it down to the following patch:
> > 
> > e4a52bcb9a18142d79e231b6733cabdbf2e67c1f [sched: Remove rq->lock from the first half of ttwu()].
> > 
> > Even on moderate load, the machine locks up, often silently, and
> > sometimes with a few messages like:
> > INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0} (detected by 1, t=12002 jiffies)
> > 
> > Another side effect of this patch is that the load average is always 0,
> > whatever load I throw at the system.
> > 
> > Reverting the sched changes up to that patch (included) gives me a
> > working system again, which happily survives parallel kernel
> > compilations without complaining.
> > 
> > My knowledge of the scheduler being rather limited, I haven't been able
> > to pinpoint the exact problem (though it probably have something to do
> > with __ARCH_WANT_INTERRUPTS_ON_CTXSW being defined on ARM). The enclosed
> > patch somehow papers over the load average problem, but the system ends
> > up locking up anyway:
> 
> Hurm.. I'll try and make x86 use __ARCH_WANT_INTERRUPTS_ON_CTXSW, IIRC
> Ingo once said that that is possible and try to see if I can reproduce.
> No clear ideas atm.

Yes, should be possible to just disable it on x86 - no further tricks needed. 
It's been a long time since i tested that though.

Thanks,

	Ingo
