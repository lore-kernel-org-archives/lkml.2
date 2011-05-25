Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab1EYMWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:22:36 -0400
Received: from service87.mimecast.com ([94.185.240.25]:40166 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756852Ab1EYMWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:22:35 -0400
Subject: Re: [BUG]  "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110524213924.GO27634@elte.hu>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop>  <20110524213924.GO27634@elte.hu>
Organization: ARM Ltd
Date: Wed, 25 May 2011 13:23:19 +0100
Message-ID: <1306326199.27474.153.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 25 May 2011 12:22:43.0546 (UTC) FILETIME=[72A23BA0:01CC1AD6]
X-MC-Unique: 111052513223204601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 23:39 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2011-05-24 at 19:13 +0100, Marc Zyngier wrote:
> > > Peter,
> > > 
> > > I've experienced all kind of lock-ups on ARM SMP platforms recently, and
> > > finally tracked it down to the following patch:
> > > 
> > > e4a52bcb9a18142d79e231b6733cabdbf2e67c1f [sched: Remove rq->lock from the first half of ttwu()].
> > > 
> > > Even on moderate load, the machine locks up, often silently, and
> > > sometimes with a few messages like:
> > > INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0} (detected by 1, t=12002 jiffies)
> > > 
> > > Another side effect of this patch is that the load average is always 0,
> > > whatever load I throw at the system.
> > > 
> > > Reverting the sched changes up to that patch (included) gives me a
> > > working system again, which happily survives parallel kernel
> > > compilations without complaining.
> > > 
> > > My knowledge of the scheduler being rather limited, I haven't been able
> > > to pinpoint the exact problem (though it probably have something to do
> > > with __ARCH_WANT_INTERRUPTS_ON_CTXSW being defined on ARM). The enclosed
> > > patch somehow papers over the load average problem, but the system ends
> > > up locking up anyway:
> > 
> > Hurm.. I'll try and make x86 use __ARCH_WANT_INTERRUPTS_ON_CTXSW, IIRC
> > Ingo once said that that is possible and try to see if I can reproduce.
> > No clear ideas atm.
> 
> Yes, should be possible to just disable it on x86 - no further tricks needed. 
> It's been a long time since i tested that though.

I can confirm this is SMP only. UP is fine. SMP+nosmp locks up as well.

	M.
-- 
Reality is an implementation detail.


