Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab2CTN7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:59:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2CTN7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:59:33 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=SIHCdkDwiDgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Q-fNiiVtAAAA:8 a=meVymXHHAAAA:8 a=tEuzPHaVrRXT7MXQN2kA:9 a=PUjeQqilurYA:10 a=lcTMV_K9oDIA:10 a=jeBq3FmKZ4MA:10 a=SC57l1L_NNr_7kfT:21 a=LFEF35qfcZ3YedDR:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332251972.23924.14.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
From: Steven Rostedt <rostedt@goodmis.org>
To: "Michael J. Wang" <mjwang@broadcom.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>
Date: Tue, 20 Mar 2012 09:59:32 -0400
In-Reply-To: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 22:26 +0000, Michael J. Wang wrote:
> From: Michael J Wang <mjwang@broadcom.com>
> 
> Avoid extra work by continuing on to the next rt_rq if the highest prio task in current rt_rq is the same priority as our candidate task.
> 
> Signed-off-by: Michael J Wang <mjwang@broadcom.com>
> 
> ---
> 
> More detailed explanation:  if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So we should avoid the extra work by continuing on to the next rt_rq if idx is equal to next->prio.
> 
> --- linux-3.3/kernel/sched/rt.c.orig	2012-03-18 16:15:34.000000000 -0700
> +++ linux-3.3/kernel/sched/rt.c	2012-03-19 14:52:54.585391702 -0700
> @@ -1403,7 +1403,7 @@ static struct task_struct *pick_next_hig
>  next_idx:
>  		if (idx >= MAX_RT_PRIO)
>  			continue;
> -		if (next && next->prio < idx)
> +		if (next && next->prio <= idx)
>  			continue;
>  		list_for_each_entry(rt_se, array->queue + idx, run_list) {
>  			struct task_struct *p;

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


