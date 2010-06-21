Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0FURHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:07:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:37219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab0FURHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:07:03 -0400
Subject: Re: [PATCH] rcutorture: add random preemption
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100621170505.GE2354@linux.vnet.ibm.com>
References: <4C1F2986.7080006@cn.fujitsu.com>
	 <20100621164306.GC2354@linux.vnet.ibm.com>
	 <1277139011.1875.522.camel@laptop>
	 <20100621170505.GE2354@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Jun 2010 19:06:57 +0200
Message-ID: <1277140017.1875.523.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 10:05 -0700, Paul E. McKenney wrote:
> On Mon, Jun 21, 2010 at 06:50:11PM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-06-21 at 09:43 -0700, Paul E. McKenney wrote:
> > > > +#ifdef CONFIG_PREEMPT
> > > > +     if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
> > > > +             preempt_schedule();
> > > > +#endif
> > > 
> > > This one scared me for a bit -- then I realized that preempt_schedule()
> > > won't actually schedule if preemption is in any way disabled.  So the
> > > above really is OK, because Classic RCU and RCU-bh disable preemption.
> > > 
> > > So, should we have a comment to this effect, or is my hypersensitivity to
> > > RCU semantics unique to me? 
> > 
> > Well it seems to do a !preempt_count() test too, so I wouldn't worry too
> > much about it, still using preempt_schedule() doesn't seem right, why
> > not use cond_resched()?
> 
> My guess is that Lai wants to force a call to rcu_sched_qs() even if
> !need_resched(). 

Ah, d'0h yeah, I'm not having the best of days.. monday or something :-)
