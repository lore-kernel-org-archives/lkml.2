Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2GIGvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:51:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42730 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2GIGvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:51:01 -0400
Message-ID: <1341816515.3462.3.camel@twins>
Subject: Re: [Question] sched/rt_mutex: re-enqueue_task on rt_mutex_setprio()
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jul 2012 08:48:35 +0200
In-Reply-To: <87obnp92r8.fsf@sejong.aot.lge.com>
References: <87zk7cgm6u.fsf@sejong.aot.lge.com>
	 <1341710959.2783.2.camel@acer.local.home>
	 <87obnp92r8.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 09:50 +0900, Namhyung Kim wrote:
> On Sat, 07 Jul 2012 21:29:19 -0400, Steven Rostedt wrote:
> > On Sat, 2012-07-07 at 14:44 +0900, Namhyung Kim wrote:
> >> Hi,
> >> 
> >> I have a question on the code below:
> >> 
> >> void rt_mutex_setprio(struct task_struct *p, int prio)
> >> {
> >>         ...
> >> 	if (on_rq)
> >> 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
> >> 
> >> When enqueueing @p with new @prio, it seems put @p at the head of a
> >> rq if appropriate. I guess it's the case of boosting @p with higher
> >> priority, right?
> >
> > Actually, no. We put @p at the head of the queue when unboosting. If a
> > task is going from a high priority into a lower priority, it is still
> > treated as "important" for that priority, and is put to the front of the
> > queue (it was just higher than everything else on that queue). But if we
> > are boosting a task from a low priority, why put it to the head of other
> > tasks of its new priority, when those tasks were just higher than this
> > task, and this task is now just an "equal".
> 
> Thanks for the explanation. (Isn't it worth getting commented?) :)

Possibly, note that this part is well spec'ed by POSIX, see 

http://pubs.opengroup.org/onlinepubs/009695299/functions/xsh_chap02_08.html

SCHED_FIFO.8
