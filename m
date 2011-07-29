Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1G2H4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:56:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:43750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab1G2H4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:56:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,286,1309762800"; 
   d="scan'208";a="35846336"
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Lin Ming <ming.m.lin@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110729074635.GB10420@zhy>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
	 <1311924975.3938.1583.camel@minggr.sh.intel.com>
	 <20110729074635.GB10420@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 15:56:31 +0800
Message-ID: <1311926191.3938.1586.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 15:46 +0800, Yong Zhang wrote:
> On Fri, Jul 29, 2011 at 03:36:15PM +0800, Lin Ming wrote:
> > >From another point of view, below !sched_feat(WAKEUP_PREEMPT) still
> > looks like duplicated.
> > 
> >         if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
> >                 check_preempt_tick(cfs_rq, curr);
> > 
> > if "!sched_feat(WAKEUP_PREEMPT)" is run,
> > that implies cfs_rq->nr_running == 1.
> 
> That's true.
> 
> > 
> > Why do we need to call check_preempt_tick when there is only 1 task
> > runnable?
> 
> Just set_tsk_need_resched(p) if p's slice is over, thus:
> 
> 	(n tick)	--->		(n+1 tick)
> set_tsk_need_resched(p);
> 		another task Q is awaked
> 
> If we don't have !sched_feat(WAKEUP_PREEMPT), Q maybe will wait
> for tick coming to get scheduled. If we have
> !sched_feat(WAKEUP_PREEMPT), Q will get scheduled when some event
> happen, like IRQ.

Wow. That's really clear explanation.
Got it now.

Thanks!

> 
> Thanks,
> Yong
> 


