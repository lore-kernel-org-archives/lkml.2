Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0DOSOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:14:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37851 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab0DOSN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/16] rcu: fix now-bogus rcu_scheduler_active comments.
Date: Thu, 15 Apr 2010 11:13:29 -0700
Message-Id: <1271355219-20714-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100415181255.GA19588@linux.vnet.ibm.com>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_scheduler_active check has been wrapped into the new
debug_lockdep_rcu_enabled() function, so update the comments to
reflect this new reality.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 91a5473..804ce3e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -114,7 +114,8 @@ static inline int debug_lockdep_rcu_enabled(void)
  * this assumes we are in an RCU read-side critical section unless it can
  * prove otherwise.
  *
- * Check rcu_scheduler_active to prevent false positives during boot.
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
  */
 static inline int rcu_read_lock_held(void)
 {
@@ -139,7 +140,8 @@ extern int rcu_read_lock_bh_held(void);
  * of preemption (including disabling irqs) counts as an RCU-sched
  * read-side critical section.
  *
- * Check rcu_scheduler_active to prevent false positives during boot.
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
  */
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
-- 
1.7.0

