Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2EVMqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:46:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2EVMqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:46:45 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 20:46:45 +0800
Message-ID: <CAJd=RBCqpxWPLdziiNM+NZGUoObODjwH2m5Pj5Gvj9_U8Az1wA@mail.gmail.com>
Subject: Re: BFS 420: remove requeue_task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, requeue_task has nothing to do with enqueuing task. Plus at the call
sites, schedule info should not be updated for enqueuing task. So remove it.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Tue May 22 19:58:38 2012
@@ -724,10 +724,6 @@ static inline void enqueue_task_head(str
 	sched_info_queued(p);
 }

-static inline void requeue_task(struct task_struct *p)
-{
-	sched_info_queued(p);
-}

 /*
  * Returns the relative length of deadline all compared to the shortest
@@ -2808,7 +2804,6 @@ static void task_running_tick(struct rq
 	/* p->time_slice < RESCHED_US. We only modify task_struct under grq lock */
 	p = rq->curr;
 	grq_lock();
-	requeue_task(p);
 	set_tsk_need_resched(p);
 	grq_unlock();
 }
@@ -4567,7 +4562,6 @@ SYSCALL_DEFINE0(sched_yield)
 	p = current;
 	grq_lock_irq();
 	schedstat_inc(task_rq(p), yld_count);
-	requeue_task(p);

 	/*
 	 * Since we are going to call schedule() anyway, there's
--
