Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2HJFw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 01:52:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53308 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752151Ab2HJFw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 01:52:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+KVSUajSWKLV1Mbq37/5lB0H0Fwu0ZM0Cy/CEb5g
	Iy0661WIB3ShkP
Message-ID: <1344577972.4330.15.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: remove useless code in yield_to
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 10 Aug 2012 07:52:52 +0200
In-Reply-To: <50247BA4.7060504@linux.vnet.ibm.com>
References: <4F13EFBE.1030002@linux.vnet.ibm.com>
	 <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com>
	 <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
	 <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop>
	 <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com>
	 <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com>
	 <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com>
	 <4F260DAE.4000008@gmail.com> <4F262ED9.7040003@linux.vnet.ibm.com>
	 <4FF2925A.9060005@linux.vnet.ibm.com> <50247A97.4000905@linux.vnet.ibm.com>
	 <50247BA4.7060504@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-10 at 11:10 +0800, Michael Wang wrote: 
> On 08/10/2012 11:05 AM, Michael Wang wrote:
> > On 07/03/2012 02:34 PM, Michael Wang wrote:
> >> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> >>
> >> it's impossible to enter else branch if we have set skip_clock_update
> >> in task_yield_fair(), as yield_to_task_fair() will directly return
> >> true after invoke task_yield_fair().
> > 
> > Could I get some conclusion on this patch? Should we clean up that peace
> > of code or leave it there?
> s /peace/piece and cc mike...

If some other class grows yield_to_task (ick), it'll have to be looked
at again, but hopefully for all eternity that branch is dead.  Bury it.

> > 
> > Regards,
> > Michael Wang
> > 
> >>
> >> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> >> ---
> >>  kernel/sched/core.c |    7 -------
> >>  1 files changed, 0 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> index 9bb7d28..77c14aa 100644
> >> --- a/kernel/sched/core.c
> >> +++ b/kernel/sched/core.c
> >> @@ -4737,13 +4737,6 @@ again:
> >>  		 */
> >>  		if (preempt && rq != p_rq)
> >>  			resched_task(p_rq->curr);
> >> -	} else {
> >> -		/*
> >> -		 * We might have set it in task_yield_fair(), but are
> >> -		 * not going to schedule(), so don't want to skip
> >> -		 * the next update.
> >> -		 */
> >> -		rq->skip_clock_update = 0;
> >>  	}
> >>
> >>  out:
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 


