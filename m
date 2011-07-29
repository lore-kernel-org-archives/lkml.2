Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1G2IoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:44:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:31205 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab1G2IoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:44:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,286,1309762800"; 
   d="scan'208";a="2277596"
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1311927650.5890.217.camel@twins>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
	 <1311924975.3938.1583.camel@minggr.sh.intel.com>
	 <20110729074635.GB10420@zhy> <1311926218.5890.215.camel@twins>
	 <20110729081800.GA12106@zhy>  <1311927650.5890.217.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 16:44:03 +0800
Message-ID: <1311929043.3938.1595.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:20 +0800, Peter Zijlstra wrote:
> On Fri, 2011-07-29 at 16:18 +0800, Yong Zhang wrote:
> > > Nah, if there is 1 runnable task it will always run, preemption simply
> > > doesn't matter. There's nothing to preempt it with.
> > 
> > Hmmm, so the newly waked task could be scheduled a little later.
> > That means schedule tick judge everything. 
> 
> Oh, are you referring to the case where a task gets woken on an idle
> remote cpu?

Yong means the case below.
At (n tick) there is only 1 task, then another task is woken before
(n+1) tick.

On Fri, 2011-07-29 at 15:46 +0800, Yong Zhang wrote:
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


