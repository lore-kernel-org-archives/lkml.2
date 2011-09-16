Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1IPIRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:17:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1IPIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:17:14 -0400
Date: Fri, 16 Sep 2011 16:17:00 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Wang Xingchao <xingchao.wang@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
Message-ID: <20110916081700.GC10741@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
 <4E72FD93.2060805@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E72FD93.2060805@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 12:41:07AM -0700, Paul Turner wrote:
> On 09/16/11 10:35, Wang Xingchao wrote:
> 
> Please include a one-line summary such as:
> sched: remove extra nr_running check in check_preempt_tick
> 
> > nr_running must be more than 1, so remove the checking
> >
> 
> Sure, reasonable.
> 
> Please expand this comment though, e.g.
> We already test for nr_running > 1 within entity_tick so there is no
> need to recheck it within check_preempt_tick().
> 
> > Signed-off-by: Wang Xingchao<xingchao.wang@intel.com>
> 
> Reviewed-by: Paul Turner <pjt@google.com>
> 
> > ---
> >   kernel/sched_fair.c |   16 ++++++++--------
> >   1 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 1ca2cd4..fef0bfd 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1106,6 +1106,8 @@ static void
> >   check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >   {
> >       unsigned long ideal_runtime, delta_exec;
> > +    struct sched_entity *se;
> > +    s64 delta;
> >
> >       ideal_runtime = sched_slice(cfs_rq, curr);
> >       delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
> > @@ -1127,16 +1129,14 @@ check_preempt_tick(struct cfs_rq *cfs_rq,
> struct sched_entity *curr)
> >       if (delta_exec<  sysctl_sched_min_granularity)
> 
> You've mangled the white space on the less-than.

But it looks ok on my side.
And on LKML: https://lkml.org/lkml/2011/9/16/11

So maybe it's not Xingchao's problem.

Thanks,
Yong

> 
> >           return;
> >
> > -    if (cfs_rq->nr_running>  1) {
> > -        struct sched_entity *se = __pick_first_entity(cfs_rq);
> > -        s64 delta = curr->vruntime - se->vruntime;
> > +    se = __pick_first_entity(cfs_rq);
> > +    delta = curr->vruntime - se->vruntime;
> >
> > -        if (delta<  0)
> > -            return;
> > +    if (delta<  0)
> 
> And here.
> 
> > +        return;
> >
> > -        if (delta>  ideal_runtime)
> > -            resched_task(rq_of(cfs_rq)->curr);
> > -    }
> > +    if (delta>  ideal_runtime)
> 
> Here too.
> 
> > +        resched_task(rq_of(cfs_rq)->curr);
> >   }
> >
> >   static void
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
