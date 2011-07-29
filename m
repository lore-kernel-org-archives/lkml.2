Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1G2IcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:32:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:27197 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1G2IcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:32:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,286,1309762800"; 
   d="scan'208";a="33691782"
Subject: Re: [RFC PATCH] sched: Kill WAKEUP_PREEMPT
From: Lin Ming <ming.m.lin@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1311928237.3938.1588.camel@minggr.sh.intel.com>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
	 <1311924975.3938.1583.camel@minggr.sh.intel.com>
	 <20110729074635.GB10420@zhy> <1311926218.5890.215.camel@twins>
	 <20110729082033.GB12106@zhy>
	 <1311928237.3938.1588.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 16:32:02 +0800
Message-ID: <1311928322.3938.1589.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:30 +0800, Lin Ming wrote:
> On Fri, 2011-07-29 at 16:20 +0800, Yong Zhang wrote:
> > On Fri, Jul 29, 2011 at 09:56:58AM +0200, Peter Zijlstra wrote:
> > > I've queued Lin's patch as I don't see the point of this thing either,
> > > normally WAKEUP_PREEMPT is enabled so it says || 0 which is kinda
> > > useless :-)
> > > 
> > > And I'm starting to think we should just kill all of WAKEUP_PREEMPT I
> > > don't think we ever want to disable it anyway.. 
> > 
> > Someting like this?
> > 
> > ---
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > Subject: [RFC PATCH] sched: Kill WAKEUP_PREEMPT
> > 
> > Per Peter Zijlstra:
> > > And I'm starting to think we should just kill all of WAKEUP_PREEMPT I
> > > don't think we ever want to disable it anyway..
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > ---
> >  kernel/sched_fair.c     |    8 +-------
> >  kernel/sched_features.h |    5 -----
> >  2 files changed, 1 insertions(+), 12 deletions(-)
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 46b7855..3c58042 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1114,9 +1114,6 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >  	 * narrow margin doesn't have to wait for a full slice.
> >  	 * This also mitigates buddy induced latencies under load.
> >  	 */
> > -	if (!sched_feat(WAKEUP_PREEMPT))
> > -		return;
> > -
> 
> -       /*
> -        * Ensure that a task that missed wakeup preemption by a
> -        * narrow margin doesn't have to wait for a full slice.
> -        * This also mitigates buddy induced latencies under load.
> -        */
> -       if (!sched_feat(WAKEUP_PREEMPT))
> -               return;
> -
> 
> Then remove the comments also.

Sorry, don't remove that comments.


