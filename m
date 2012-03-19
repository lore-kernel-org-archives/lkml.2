Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab2CSGct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:32:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44720 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab2CSGcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:32:21 -0400
Date: Mon, 19 Mar 2012 14:32:04 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Michael J. Wang" <mjwang@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: minor improvement to pick_next_highest_task_rt ?
Message-ID: <20120319063204.GA1361@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83935@IRVEXCHMB08.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2EF88150C0EF2C43A218742ED384C1BC0FC83935@IRVEXCHMB08.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing more people.

And comments below.

On Fri, Mar 16, 2012 at 01:22:56AM +0000, Michael J. Wang wrote:
> Hi RT Scheduler experts,
> 
> I was studying pick_next_highest_task_rt() and was wondering if this is a valid improvement:
> 
> --- rt.c-3.3-rc7	2012-03-15 17:53:27.774190199 -0700
> +++ rt.c	2012-03-15 17:53:44.541979403 -0700
> @@ -1403,7 +1403,7 @@
>  next_idx:
>  		if (idx >= MAX_RT_PRIO)
>  			continue;
> -		if (next && next->prio < idx)
> +		if (next && next->prio <= idx)
>  			continue;
>  		list_for_each_entry(rt_se, array->queue + idx, run_list) {
>  			struct task_struct *p;
> 
> 
> My reasoning is: if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3-rc7 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So shouldn't we just skip that rt_rq if next->prio is less than *or equal to* idx ?

Yeah, I think this make sense.

But you should remake your patch according to
Documentation/SubmittingPatches.

Thanks,
Yong

> 
> I know this is just a minor improvement and probably results in no measurable performance gain.  But it just seems more correct this way.  (Or if it is not correct, maybe I'll learn something :-)
> 
> I do not subscribe to the LKML (but I have read the FAQ), so I would appreciate it if you can cc me on your responses.
> 
> Thanks,
> Michael
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
