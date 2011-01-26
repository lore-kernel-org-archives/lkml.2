Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1AZMOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:14:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:39826 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1AZMOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:14:17 -0500
Date: Wed, 26 Jan 2011 12:13:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify the idle scheduling class
Message-ID: <tip-a8941d7ec81678fb69aea7183338175f112f3e0d@git.kernel.org>
Git-Commit-ID: a8941d7ec81678fb69aea7183338175f112f3e0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:13:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8941d7ec81678fb69aea7183338175f112f3e0d
Gitweb:     http://git.kernel.org/tip/a8941d7ec81678fb69aea7183338175f112f3e0d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 25 Jan 2011 16:30:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:22 +0100

sched: Simplify the idle scheduling class

Since commit 48c5ccae88dcd (sched: Simplify cpu-hot-unplug task
migration) this should no longer happen, so remove the code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_idletask.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9fa0f40..41eb62a 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -52,31 +52,16 @@ static void set_curr_task_idle(struct rq *rq)
 {
 }
 
-static void switched_to_idle(struct rq *rq, struct task_struct *p,
-			     int running)
+static void
+switched_to_idle(struct rq *rq, struct task_struct *p, int running)
 {
-	/* Can this actually happen?? */
-	if (running)
-		resched_task(rq->curr);
-	else
-		check_preempt_curr(rq, p, 0);
+	BUG();
 }
 
 static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 			      int oldprio, int running)
 {
-	/* This can happen for hot plug CPUS */
-
-	/*
-	 * Reschedule if we are currently running on this runqueue and
-	 * our priority decreased, or if we are not currently running on
-	 * this runqueue and our priority is higher than the current's
-	 */
-	if (running) {
-		if (p->prio > oldprio)
-			resched_task(rq->curr);
-	} else
-		check_preempt_curr(rq, p, 0);
+	BUG();
 }
 
 static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
