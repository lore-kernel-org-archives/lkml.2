Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2GIAzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 20:55:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46715 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2GIAzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 20:55:00 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-8b-4ffa2be26029
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Question] sched/rt_mutex: re-enqueue_task on rt_mutex_setprio()
References: <87zk7cgm6u.fsf@sejong.aot.lge.com>
	<1341710959.2783.2.camel@acer.local.home>
Date: Mon, 09 Jul 2012 09:50:19 +0900
In-Reply-To: <1341710959.2783.2.camel@acer.local.home> (Steven Rostedt's
	message of "Sat, 07 Jul 2012 21:29:19 -0400")
Message-ID: <87obnp92r8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jul 2012 21:29:19 -0400, Steven Rostedt wrote:
> On Sat, 2012-07-07 at 14:44 +0900, Namhyung Kim wrote:
>> Hi,
>> 
>> I have a question on the code below:
>> 
>> void rt_mutex_setprio(struct task_struct *p, int prio)
>> {
>>         ...
>> 	if (on_rq)
>> 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
>> 
>> When enqueueing @p with new @prio, it seems put @p at the head of a
>> rq if appropriate. I guess it's the case of boosting @p with higher
>> priority, right?
>
> Actually, no. We put @p at the head of the queue when unboosting. If a
> task is going from a high priority into a lower priority, it is still
> treated as "important" for that priority, and is put to the front of the
> queue (it was just higher than everything else on that queue). But if we
> are boosting a task from a low priority, why put it to the head of other
> tasks of its new priority, when those tasks were just higher than this
> task, and this task is now just an "equal".

Thanks for the explanation. (Isn't it worth getting commented?) :)

Thanks,
Namhyung

