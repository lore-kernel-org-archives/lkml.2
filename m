Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab1EXV3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:29:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1EXV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:29:12 -0400
Subject: Re: [BUG]  "sched: Remove rq->lock from the first half of ttwu()" 
 locks up on ARM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 23:32:30 +0200
Message-ID: <1306272750.2497.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 19:13 +0100, Marc Zyngier wrote:
> Peter,
> 
> I've experienced all kind of lock-ups on ARM SMP platforms recently, and
> finally tracked it down to the following patch:
> 
> e4a52bcb9a18142d79e231b6733cabdbf2e67c1f [sched: Remove rq->lock from the first half of ttwu()].
> 
> Even on moderate load, the machine locks up, often silently, and
> sometimes with a few messages like:
> INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0} (detected by 1, t=12002 jiffies)
> 
> Another side effect of this patch is that the load average is always 0,
> whatever load I throw at the system.
> 
> Reverting the sched changes up to that patch (included) gives me a
> working system again, which happily survives parallel kernel
> compilations without complaining.
> 
> My knowledge of the scheduler being rather limited, I haven't been able
> to pinpoint the exact problem (though it probably have something to do
> with __ARCH_WANT_INTERRUPTS_ON_CTXSW being defined on ARM). The enclosed
> patch somehow papers over the load average problem, but the system ends
> up locking up anyway:

Hurm.. I'll try and make x86 use __ARCH_WANT_INTERRUPTS_ON_CTXSW, IIRC
Ingo once said that that is possible and try to see if I can reproduce.
No clear ideas atm.

Thanks for reporting.

