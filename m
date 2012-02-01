Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2BANzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:55:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:39098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2BANze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:55:34 -0500
Subject: Re: [PATCH] sched: At sched_fork use __set_task_cpu().
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120131084830.GA22077@linux.vnet.ibm.com>
References: <1327854877.8504.3.camel@localhost.localdomain>
	 <20120131084830.GA22077@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 14:55:27 +0100
Message-ID: <1328104527.2662.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 14:18 +0530, Kamalesh Babulal wrote:
> * Rakib Mullick <rakib.mullick@gmail.com> [2012-01-29 22:34:37]:
> 
> >  We don't use select_task_rq() from sched_fork() anymore and no chance of task gets migrated at
> > this point. Therefore, we can avoid task migration related checking/accounting, so use
> > __set_task_cpu() instead of set_task_cpu().
> > 
> > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>   Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Since we call sched_fork() with preemption enabled _long_ after the
child is copied from the parent who is to say we (parent) didn't migrate
away and are now setting a different cpu?

One could argue that that might not be a real migration from the child's
POV, maybe, but nobody seems to be making that argument.

I really don't see the point of this..

> > ---
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index df00cb0..a38026e 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1755,7 +1755,7 @@ void sched_fork(struct task_struct *p)
> >  	 * Silence PROVE_RCU.
> >  	 */
> >  	raw_spin_lock_irqsave(&p->pi_lock, flags);
> > -	set_task_cpu(p, cpu);
> > +	__set_task_cpu(p, cpu);
> >  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> > 
> >  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
> > 
> > 
> > --
> 



