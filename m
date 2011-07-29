Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1G2ISL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:18:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42927 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1G2ISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:18:09 -0400
Date: Fri, 29 Jul 2011 16:18:00 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in entity_tick
Message-ID: <20110729081800.GA12106@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
 <20110729062158.GA8971@zhy>
 <1311922180.3938.1573.camel@minggr.sh.intel.com>
 <20110729070356.GA10420@zhy>
 <1311924975.3938.1583.camel@minggr.sh.intel.com>
 <20110729074635.GB10420@zhy>
 <1311926218.5890.215.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1311926218.5890.215.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:56:58AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-29 at 15:46 +0800, Yong Zhang wrote:
> > On Fri, Jul 29, 2011 at 03:36:15PM +0800, Lin Ming wrote:
> > > >From another point of view, below !sched_feat(WAKEUP_PREEMPT) still
> > > looks like duplicated.
> > > 
> > >         if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
> > >                 check_preempt_tick(cfs_rq, curr);
> > > 
> > > if "!sched_feat(WAKEUP_PREEMPT)" is run,
> > > that implies cfs_rq->nr_running == 1.
> > 
> > That's true.
> > 
> > > 
> > > Why do we need to call check_preempt_tick when there is only 1 task
> > > runnable?
> > 
> > Just set_tsk_need_resched(p) if p's slice is over, thus:
> > 
> > 	(n tick)	--->		(n+1 tick)
> > set_tsk_need_resched(p);
> > 		another task Q is awaked
> > 
> > If we don't have !sched_feat(WAKEUP_PREEMPT), Q maybe will wait
> > for tick coming to get scheduled. If we have
> > !sched_feat(WAKEUP_PREEMPT), Q will get scheduled when some event
> > happen, like IRQ.
> 
> Nah, if there is 1 runnable task it will always run, preemption simply
> doesn't matter. There's nothing to preempt it with.

Hmmm, so the newly waked task could be scheduled a little later.
That means schedule tick judge everything.

Thanks,
Yong

> 
> I've queued Lin's patch as I don't see the point of this thing either,
> normally WAKEUP_PREEMPT is enabled so it says || 0 which is kinda
> useless :-)
> 
> And I'm starting to think we should just kill all of WAKEUP_PREEMPT I
> don't think we ever want to disable it anyway.. 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
