Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2BDBuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:50:35 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57116 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab2BDBqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:46:31 -0500
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
Subject: [PATCH tip/core/rcu 23/47] rcu: Clean up straggling rcu_preempt_needs_cpu() name
Date: Fri,  3 Feb 2012 17:44:58 -0800
Message-Id: <1328319922-30828-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-2398-0000-0000-000003ED6A30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The recent updates to RCU_CPU_FAST_NO_HZ have an rcu_needs_cpu() that
does more than just check for callbacks, so get the name for
rcu_preempt_needs_cpu() consistent with that change, now calling it
rcu_preempt_cpu_has_callbacks().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 +-
 kernel/rcutree.h        |    2 +-
 kernel/rcutree_plugin.h |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 49bb363..0569ba1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1958,7 +1958,7 @@ static int rcu_cpu_has_callbacks(int cpu)
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
 	       per_cpu(rcu_bh_data, cpu).nxtlist ||
-	       rcu_preempt_needs_cpu(cpu);
+	       rcu_preempt_cpu_has_callbacks(cpu);
 }
 
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 05e0367..58c9fc3 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -449,7 +449,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 			       bool wake);
 #endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
-static int rcu_preempt_needs_cpu(int cpu);
+static int rcu_preempt_cpu_has_callbacks(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_cleanup_dying_cpu(void);
 static void __init __rcu_init_preempt(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8041310..169517e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -887,9 +887,9 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Does preemptible RCU need the CPU to stay out of dynticks mode?
+ * Does preemptible RCU have callbacks on this CPU?
  */
-static int rcu_preempt_needs_cpu(int cpu)
+static int rcu_preempt_cpu_has_callbacks(int cpu)
 {
 	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
 }
@@ -1128,9 +1128,9 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Because preemptible RCU does not exist, it never needs any CPU.
+ * Because preemptible RCU does not exist, it never has callbacks
  */
-static int rcu_preempt_needs_cpu(int cpu)
+static int rcu_preempt_cpu_has_callbacks(int cpu)
 {
 	return 0;
 }
-- 
1.7.8

