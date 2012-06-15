Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2FOVG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:06:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49622 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882Ab2FOVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:06:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/15] rcu: Prevent excessive line length in RCU_STATE_INITIALIZER()
Date: Fri, 15 Jun 2012 14:05:58 -0700
Message-Id: <1339794370-28119-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-5806-0000-0000-00001643FB23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Upcoming rcu_barrier() concurrency commits will result in line lengths
greater than 80 characters in the RCU_STATE_INITIALIZER(), so this commit
shortens the name of the macro's argument to prevent this.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9098910..8ce1b1d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -62,18 +62,18 @@
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 
-#define RCU_STATE_INITIALIZER(structname) { \
-	.level = { &structname##_state.node[0] }, \
+#define RCU_STATE_INITIALIZER(sname) { \
+	.level = { &sname##_state.node[0] }, \
 	.fqs_state = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
-	.orphan_nxttail = &structname##_state.orphan_nxtlist, \
-	.orphan_donetail = &structname##_state.orphan_donelist, \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.fqslock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.onofflock), \
+	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
+	.orphan_donetail = &sname##_state.orphan_donelist, \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
-	.name = #structname, \
+	.name = #sname, \
 }
 
 struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched);
-- 
1.7.8

