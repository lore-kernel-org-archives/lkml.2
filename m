Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2DWQRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:17:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49488 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab2DWQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:12 -0400
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
Subject: [PATCH RFC tip/core/rcu 1/4] rcu: Add RCU_FAST_NO_HZ tracing for idle exit
Date: Mon, 23 Apr 2012 09:15:58 -0700
Message-Id: <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120423161539.GA6467@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-4242-0000-0000-0000016DA4E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Traces of rcu_prep_idle events can be confusing because
rcu_cleanup_after_idle() does no tracing.  This commit therefore adds
this tracing.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |    1 +
 kernel/rcutree_plugin.h    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 3370997..aaa55e1 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -292,6 +292,7 @@ TRACE_EVENT(rcu_dyntick,
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
+ *	"Cleanup after idle": Idle exited, timer canceled.
  */
 TRACE_EVENT(rcu_prep_idle,
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..1e561ab 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2085,6 +2085,7 @@ static void rcu_prepare_for_idle_init(int cpu)
 static void rcu_cleanup_after_idle(int cpu)
 {
 	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+	trace_rcu_prep_idle("Cleanup after idle");
 }
 
 /*
-- 
1.7.8

