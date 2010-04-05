Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0DESfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:35:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59780 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab0DESel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:34:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 05/10] rcu: Fix bogus CONFIG_PROVE_LOCKING in comments to reflect reality.
Date: Mon,  5 Apr 2010 11:34:27 -0700
Message-Id: <1270492472-23222-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100405183403.GA23075@linux.vnet.ibm.com>
References: <20100405183403.GA23075@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is CONFIG_DEBUG_LOCK_ALLOC rather than CONFIG_PROVE_LOCKING, so fix it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   15 ++++++++-------
 include/linux/srcu.h     |    4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 872a98e..91a5473 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -109,8 +109,8 @@ static inline int debug_lockdep_rcu_enabled(void)
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
  *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
+ * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an RCU read-side critical section unless it can
  * prove otherwise.
  *
@@ -132,11 +132,12 @@ extern int rcu_read_lock_bh_held(void);
 /**
  * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
  *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in an
- * RCU-sched read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
- * this assumes we are in an RCU-sched read-side critical section unless it
- * can prove otherwise.  Note that disabling of preemption (including
- * disabling irqs) counts as an RCU-sched read-side critical section.
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an
+ * RCU-sched read-side critical section.  In absence of
+ * CONFIG_DEBUG_LOCK_ALLOC, this assumes we are in an RCU-sched read-side
+ * critical section unless it can prove otherwise.  Note that disabling
+ * of preemption (including disabling irqs) counts as an RCU-sched
+ * read-side critical section.
  *
  * Check rcu_scheduler_active to prevent false positives during boot.
  */
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4d5ecb2..9c01f10 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -84,8 +84,8 @@ long srcu_batches_completed(struct srcu_struct *sp);
 /**
  * srcu_read_lock_held - might we be in SRCU read-side critical section?
  *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an SRCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an SRCU
+ * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
  */
-- 
1.7.0

