Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0DESfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:35:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35114 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab0DESem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:34:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 08/10] rcu: rename rcutiny rcu_ctrlblk to rcu_sched_ctrlblk
Date: Mon,  5 Apr 2010 11:34:30 -0700
Message-Id: <1270492472-23222-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100405183403.GA23075@linux.vnet.ibm.com>
References: <20100405183403.GA23075@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make naming line up in preparation for CONFIG_TINY_PREEMPT_RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 272c6d2..d9f8a62 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -44,9 +44,9 @@ struct rcu_ctrlblk {
 };
 
 /* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_ctrlblk = {
-	.donetail	= &rcu_ctrlblk.rcucblist,
-	.curtail	= &rcu_ctrlblk.rcucblist,
+static struct rcu_ctrlblk rcu_sched_ctrlblk = {
+	.donetail	= &rcu_sched_ctrlblk.rcucblist,
+	.curtail	= &rcu_sched_ctrlblk.rcucblist,
 };
 
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
@@ -108,7 +108,8 @@ static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
  */
 void rcu_sched_qs(int cpu)
 {
-	if (rcu_qsctr_help(&rcu_ctrlblk) + rcu_qsctr_help(&rcu_bh_ctrlblk))
+	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
+	    rcu_qsctr_help(&rcu_bh_ctrlblk))
 		raise_softirq(RCU_SOFTIRQ);
 }
 
@@ -173,7 +174,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
  */
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
-	__rcu_process_callbacks(&rcu_ctrlblk);
+	__rcu_process_callbacks(&rcu_sched_ctrlblk);
 	__rcu_process_callbacks(&rcu_bh_ctrlblk);
 }
 
@@ -221,7 +222,7 @@ static void __call_rcu(struct rcu_head *head,
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_ctrlblk);
+	__call_rcu(head, func, &rcu_sched_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
-- 
1.7.0

