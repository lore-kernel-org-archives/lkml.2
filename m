Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161335Ab2GLSo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:44:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47265 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932810Ab2GLSo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:44:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19i8yRYCIViT6SRi6xO8EH8NQDeYr24MWz473ISSP
	ecUxEBbL3F03ws
Message-ID: <1342118691.7430.39.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: remove useless code in yield_to
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 12 Jul 2012 20:44:51 +0200
In-Reply-To: <1342102029.28010.3.camel@twins>
References: <4F13EFBE.1030002@linux.vnet.ibm.com>
	 <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com>
	 <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
	 <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop>
	 <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com>
	 <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com>
	 <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com>
	 <4F260DAE.4000008@gmail.com> <4F262ED9.7040003@linux.vnet.ibm.com>
	 <4FF2925A.9060005@linux.vnet.ibm.com> <1342102029.28010.3.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 16:07 +0200, Peter Zijlstra wrote: 
> On Tue, 2012-07-03 at 14:34 +0800, Michael Wang wrote:
> > From: Michael Wang <wangyun@linux.vnet.ibm.com>
> > 
> > it's impossible to enter else branch if we have set skip_clock_update
> > in task_yield_fair(), as yield_to_task_fair() will directly return
> > true after invoke task_yield_fair().
> 
> It helps if you CC the guy who wrote the code.. I think you're right,
> although getting that skip_clock_update crap wrong is annoying.

Getting that crap wrong is ease, so Michael is probably right.

> Mike?

If it looks right to you too, it likely is.  When I have time to look
for nanoseconds again, I can squeak if/when I find some.  In any case,
for normal scheduler citizens, it's chump change, so nuke it.
> > Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> > ---
> >  kernel/sched/core.c |    7 -------
> >  1 files changed, 0 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 9bb7d28..77c14aa 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4737,13 +4737,6 @@ again:
> >  		 */
> >  		if (preempt && rq != p_rq)
> >  			resched_task(p_rq->curr);
> > -	} else {
> > -		/*
> > -		 * We might have set it in task_yield_fair(), but are
> > -		 * not going to schedule(), so don't want to skip
> > -		 * the next update.
> > -		 */
> > -		rq->skip_clock_update = 0;
> >  	}
> >  
> >  out:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


