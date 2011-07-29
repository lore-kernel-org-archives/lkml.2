Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1G2Hqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:46:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42441 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1G2Hqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:46:43 -0400
Date: Fri, 29 Jul 2011 15:46:35 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in entity_tick
Message-ID: <20110729074635.GB10420@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
 <20110729062158.GA8971@zhy>
 <1311922180.3938.1573.camel@minggr.sh.intel.com>
 <20110729070356.GA10420@zhy>
 <1311924975.3938.1583.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1311924975.3938.1583.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 03:36:15PM +0800, Lin Ming wrote:
> >From another point of view, below !sched_feat(WAKEUP_PREEMPT) still
> looks like duplicated.
> 
>         if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
>                 check_preempt_tick(cfs_rq, curr);
> 
> if "!sched_feat(WAKEUP_PREEMPT)" is run,
> that implies cfs_rq->nr_running == 1.

That's true.

> 
> Why do we need to call check_preempt_tick when there is only 1 task
> runnable?

Just set_tsk_need_resched(p) if p's slice is over, thus:

	(n tick)	--->		(n+1 tick)
set_tsk_need_resched(p);
		another task Q is awaked

If we don't have !sched_feat(WAKEUP_PREEMPT), Q maybe will wait
for tick coming to get scheduled. If we have
!sched_feat(WAKEUP_PREEMPT), Q will get scheduled when some event
happen, like IRQ.

Thanks,
Yong

-- 
Only stand for myself
