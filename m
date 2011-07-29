Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1G2Gtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:49:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:27262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1G2Gtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,286,1309762800"; 
   d="scan'208";a="31680657"
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Lin Ming <ming.m.lin@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110729062158.GA8971@zhy>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 14:49:40 +0800
Message-ID: <1311922180.3938.1573.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 14:21 +0800, Yong Zhang wrote:
> On Thu, Jul 28, 2011 at 05:43:23PM +0800, Lin Ming wrote:
> > Currently, entity_tick calls check_preempt_tick if WAKEUP_PREEMPT feature is
> > disabled. That's wrong. It should do that if the feature is enabled.
> 
> Why is it wrong?
> check_preempt_wakeup() is used for wakeup.

I guess you mean "check_preempt_tick" here, yes?

in entity_tick(...):
        if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
                check_preempt_tick(cfs_rq, curr);

Note that, above "if" statement says "if WAKEUP_PREEMPT feature is
*disabled* then calls check_preempt_tick".

Shouldn't it be "if WAKEUP_PREEMPT feature is *enabled* then ...."?

> 
> > 
> > And actually the check is duplicate because check_preempt_tick will do
> > that. So just remove it from entity_tick.
> 
> It's not exactly duplicated. entity_tick() will resched_task(*p)
> if p's slice is over. So if there is an following wakeup(say X),
> then there is an opportunity for X to schedule quickly.

Understood this.

But what I mean is both "entity_tick" and "check_preempt_tick" check
WAKEUP_PREEMPT feature. That's duplicated.

Only need to check it in "check_preempt_tick".

Thanks,
Lin Ming

