Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0KGCFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:05:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33850 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab0KGCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 10/12] rcu: update documentation/comments for Lai's adoption patch
Date: Sat,  6 Nov 2010 19:05:30 -0700
Message-Id: <1289095532-5398-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai's RCU-callback immediate-adoption patch changes the RCU tracing
output, so update tracing.txt.  Also update a few comments to clarify
the synchronization design.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   12 ++++--------
 kernel/rcutree.c            |   10 ++++++----
 kernel/rcutree_plugin.h     |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index ff6d3f1..6a8c73f 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -134,7 +134,8 @@ o	"ci" is the number of RCU callbacks that have been invoked for
 	been registered in absence of CPU-hotplug activity.
 
 o	"co" is the number of RCU callbacks that have been orphaned due to
-	this CPU going offline.
+	this CPU going offline.  These orphaned callbacks have been moved
+	to an arbitrarily chosen online CPU.
 
 o	"ca" is the number of RCU callbacks that have been adopted due to
 	other CPUs going offline.  Note that ci+co-ca+ql is the number of
@@ -172,12 +173,12 @@ o	"gpnum" is the number of grace periods that have started.  It is
 
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
-c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6 oqlen=0
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
 1/1 .>. 0:127 ^0    
 3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
 3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
 rcu_bh:
-c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0 oqlen=0
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
 0/1 .>. 0:127 ^0    
 0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
 0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
@@ -216,11 +217,6 @@ o	"fqlh" is the number of calls to force_quiescent_state() that
 	exited immediately (without even being counted in nfqs above)
 	due to contention on ->fqslock.
 
-o	"oqlen" is the number of callbacks on the "orphan" callback
-	list.  RCU callbacks are placed on this list by CPUs going
-	offline, and are "adopted" either by the CPU helping the outgoing
-	CPU or by the next rcu_barrier*() call, whichever comes first.
-
 o	Each element of the form "1/1 0:127 ^0" represents one struct
 	rcu_node.  Each line represents one level of the hierarchy, from
 	root to leaves.  It is best to think of the rcu_data structures
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 669d7fe..120820f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1668,7 +1668,9 @@ static void _rcu_barrier(struct rcu_state *rsp,
 	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
 	 * might complete its grace period before all of the other CPUs
 	 * did their increment, causing this function to return too
-	 * early.
+	 * early.  Note that on_each_cpu() disables irqs, which prevents
+	 * any CPUs from coming online or going offline until each online
+	 * CPU has queued its RCU-barrier callback.
 	 */
 	atomic_set(&rcu_barrier_cpu_count, 1);
 	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
@@ -1797,9 +1799,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/*
-		 * The whole machine is "stopped" except this cpu, so we can
-		 * touch any data without introducing corruption. And we send
-		 * the callbacks to an attribute chosen online cpu.
+		 * The whole machine is "stopped" except this CPU, so we can
+		 * touch any data without introducing corruption. We send the
+		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
 		 */
 		rcu_send_cbs_to_online(&rcu_bh_state);
 		rcu_send_cbs_to_online(&rcu_sched_state);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0de359b..643c8f6 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -774,7 +774,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptable DYING RCU's callbacks to other online CPU.
+ * Move preemptable RCU's callbacks from dying CPU to other online CPU.
  */
 static void rcu_preempt_send_cbs_to_online(void)
 {
-- 
1.7.0.6

