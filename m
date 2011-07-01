Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1GAPQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:16:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:33095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1GAPQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:16:38 -0400
Date: Fri, 1 Jul 2011 15:16:25 GMT
From: "tip-bot for Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Message-ID: <tip-2a46dae38087e62dd5fb08a6dadf1407717ed13c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, nikunj@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        nikunj@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
References: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove rcu_read_lock() from wake_affine()
Git-Commit-ID: 2a46dae38087e62dd5fb08a6dadf1407717ed13c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:16:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a46dae38087e62dd5fb08a6dadf1407717ed13c
Gitweb:     http://git.kernel.org/tip/2a46dae38087e62dd5fb08a6dadf1407717ed13c
Author:     Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
AuthorDate: Tue, 7 Jun 2011 15:43:22 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 10:39:06 +0200

sched: Remove rcu_read_lock() from wake_affine()

wake_affine() is only called from one path: select_task_rq_fair(),
which already has the RCU read lock held.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..eb98f77 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1481,7 +1481,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
-	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1517,7 +1516,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
-	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within
