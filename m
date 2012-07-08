Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2GHB3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 21:29:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2GHB3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 21:29:37 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XLVj4xrnBqQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ram7ugeDRuyTZ3PFgDIA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [Question] sched/rt_mutex: re-enqueue_task on
 rt_mutex_setprio()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87zk7cgm6u.fsf@sejong.aot.lge.com>
References: <87zk7cgm6u.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Jul 2012 21:29:19 -0400
Message-ID: <1341710959.2783.2.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 14:44 +0900, Namhyung Kim wrote:
> Hi,
> 
> I have a question on the code below:
> 
> void rt_mutex_setprio(struct task_struct *p, int prio)
> {
>         ...
> 	if (on_rq)
> 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
> 
> When enqueueing @p with new @prio, it seems put @p at the head of a
> rq if appropriate. I guess it's the case of boosting @p with higher
> priority, right?

Actually, no. We put @p at the head of the queue when unboosting. If a
task is going from a high priority into a lower priority, it is still
treated as "important" for that priority, and is put to the front of the
queue (it was just higher than everything else on that queue). But if we
are boosting a task from a low priority, why put it to the head of other
tasks of its new priority, when those tasks were just higher than this
task, and this task is now just an "equal".

-- Steve

>  So Should the conditional be a reverse form (provided
> that less number means higher priority)? Please shed some light on me.
> 
> Thanks,
> Namhyung


