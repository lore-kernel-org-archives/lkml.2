Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab1EANg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:36:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53864 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab1EANW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 23/86] rcu: Use WARN_ON_ONCE for DEBUG_OBJECTS_RCU_HEAD warnings
Date: Sun,  1 May 2011 06:21:03 -0700
Message-Id: <1304256126-26015-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid additional multiple-warning confusion in memory-corruption scenarios.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index b54d6d1..7784bd2 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -147,12 +147,12 @@ static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
 		 * attempt any fixup and just print a warning.
 		 */
 #ifndef CONFIG_PREEMPT
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		return 0;
 #endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
@@ -196,12 +196,12 @@ static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 		 * attempt any fixup and just print a warning.
 		 */
 #ifndef CONFIG_PREEMPT
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		return 0;
 #endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
@@ -233,12 +233,12 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * attempt any fixup and just print a warning.
 		 */
 #ifndef CONFIG_PREEMPT
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		return 0;
 #endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
-- 
1.7.3.2

