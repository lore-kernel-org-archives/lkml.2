Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab2CUSd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:33:59 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1615 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2CUSd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:33:57 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
From: "Michael J. Wang" <mjwang@broadcom.com>
To: "Peter Zijlstra" <peterz@infradead.org>
cc: "Yong Zhang" <yong.zhang0@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Michael J. Wang" <mjwang@broadcom.com>
Subject: RE: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Topic: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Index: Ac0GHwijHkYM9zt3RLiiFsMKptWd3QBH0jYAAA4wyTD//5dRgIAAF8jwgABcB4D//9gBMA==
Date: Wed, 21 Mar 2012 18:33:45 +0000
Message-ID: <2EF88150C0EF2C43A218742ED384C1BC0FC85433@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120321014050.GA19766@zhy>
 <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120321021229.GB19766@zhy>
 <2EF88150C0EF2C43A218742ED384C1BC0FC8438B@IRVEXCHMB08.corp.ad.broadcom.com>
 <1332320819.18960.468.camel@twins>
In-Reply-To: <1332320819.18960.468.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.161.125]
MIME-Version: 1.0
X-WSS-ID: 6374FEB23E07508610-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, March 21, 2012 2:07 AM
> To: Michael J. Wang
> Cc: Yong Zhang; mingo@elte.hu; linux-kernel@vger.kernel.org;
> rostedt@goodmis.org
> Subject: RE: [PATCH 1/1] scheduler: minor improvement to
> pick_next_highest_task_rt in linux-3.3
> 
> On Wed, 2012-03-21 at 07:49 +0000, Michael J. Wang wrote:
> > > > Should I reformat my patch and send it again?
> > >
> > > It'll be better, and I think Peter/Ingo will happy with it.
> > >
> >
> > OK.  I will resend now.  Thanks for all your help!
> 
> The resend didn't include the more details thing, so I fudged it by
> hand. The queued thing now looks like this:
> 

OK.  Thanks.  I was afraid the details were too verbose when the fix
was obvious to the experts.  Anyways, I now know the format you
are expecting, so I will do better next time.

Michael

> ---
> Subject: sched, rt: Minor improvement to pick_next_highest_task_rt
> From: Michael J Wang <mjwang@broadcom.com>
> Date: Mon, 19 Mar 2012 22:26:19 +0000
> 
> Avoid extra work by continuing on to the next rt_rq if the highest
> prio task in current rt_rq is the same priority as our candidate
> task.
> 
> More detailed explanation:  if next is not NULL, then we have found a
> candidate task, and its priority is next->prio.  Now we are looking
> for an even higher priority task in the other rt_rq's.  idx is the
> highest priority in the current candidate rt_rq.  In the current 3.3
> code, if idx is equal to next->prio, we would start scanning the tasks
> in that rt_rq and replace the current candidate task with a task from
> that rt_rq.  But the new task would only have a priority that is equal
> to our previous candidate task, so we have not advanced our goal of
> finding a higher prio task.  So we should avoid the extra work by
> continuing on to the next rt_rq if idx is equal to next->prio.
> 
> Signed-off-by: Michael J Wang <mjwang@broadcom.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link:
> http://lkml.kernel.org/r/2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEX
> CHMB08.corp.ad.broadcom.com
> ---
>  kernel/sched/rt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1428,7 +1428,7 @@ static struct task_struct *pick_next_hig
>  next_idx:
>  		if (idx >= MAX_RT_PRIO)
>  			continue;
> -		if (next && next->prio < idx)
> +		if (next && next->prio <= idx)
>  			continue;
>  		list_for_each_entry(rt_se, array->queue + idx, run_list) {
>  			struct task_struct *p;
> 


