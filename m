Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2FFNWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:22:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36252 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2FFNWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:18 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 21:22:16 +0800
Message-ID: <CAJd=RBCofLoqZiUX3PirgcGw3q6mC8FPxi_D4PRV9e5kQ+1auA@mail.gmail.com>
Subject: [patch] BFS 421: cleanup by removing rq_running
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again two points, good shot.


--- a/kernel/sched/bfs.c	Wed Jun  6 20:19:12 2012
+++ b/kernel/sched/bfs.c	Wed Jun  6 20:51:38 2012
@@ -246,7 +246,6 @@ struct rq {
 	int rq_time_slice;
 	u64 rq_last_ran;
 	int rq_prio;
-	bool rq_running; /* There is a task running */

 	/* Accurate timekeeping data */
 	u64 timekeep_clock;
@@ -2044,7 +2043,8 @@ unsigned long nr_active(void)
 /* Beyond a task running on this CPU, load is equal everywhere on BFS */
 unsigned long this_cpu_load(void)
 {
-	return this_rq()->rq_running +
+	struct rq *rq = this_rq();
+	return (rq->curr != rq->idle) +
 		((queued_notrunning() + nr_uninterruptible()) / grq.noc);
 }

@@ -3114,10 +3114,6 @@ static inline void set_rq_task(struct rq
 	rq->rq_last_ran = p->last_ran = rq->clock;
 	rq->rq_policy = p->policy;
 	rq->rq_prio = p->prio;
-	if (p != rq->idle)
-		rq->rq_running = true;
-	else
-		rq->rq_running = false;
 }

 static void reset_rq_task(struct rq *rq, struct task_struct *p)
--
