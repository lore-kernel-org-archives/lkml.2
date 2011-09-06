Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1IGGZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52605 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab1IGGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/55] rcu: Move RCU_BOOST declarations to allow compiler checking
Date: Tue,  6 Sep 2011 11:00:13 -0700
Message-Id: <1315332049-2604-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Andi Kleen noticed that one of the RCU_BOOST data declarations was
out of sync with the definition.  Move the declarations so that the
compiler can do the checking in the future.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h       |    7 +++++++
 kernel/rcutree_trace.c |    5 -----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 01b2ccd..eee6c94 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -417,6 +417,13 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
+DECLARE_PER_CPU(char, rcu_cpu_has_work);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 #ifndef RCU_TREE_NONCORE
 
 /* Forward declarations for rcutree_plugin.h */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 8827b34..e623564 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -48,11 +48,6 @@
 
 #ifdef CONFIG_RCU_BOOST
 
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
-DECLARE_PER_CPU(char, rcu_cpu_has_work);
-
 static char convert_kthread_status(unsigned int kthread_status)
 {
 	if (kthread_status > RCU_KTHREAD_MAX)
-- 
1.7.3.2

