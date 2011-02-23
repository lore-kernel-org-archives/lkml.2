Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1BWBlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:41:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41428 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1BWBjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        Amerigo Wang <amwang@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 04/11] rcupdate: remove dead code
Date: Tue, 22 Feb 2011 17:39:33 -0800
Message-Id: <1298425183-21265-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>

DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT, so #ifndef CONFIG_PREEMPT
is totally useless in kernel/rcupdate.c.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a23a57a..afd21d1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -215,10 +215,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
 		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON(1);
-		return 0;
-#else
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
 			WARN_ON(1);
@@ -229,7 +225,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		rcu_barrier_bh();
 		debug_object_free(head, &rcuhead_debug_descr);
 		return 1;
-#endif
 	default:
 		return 0;
 	}
-- 
1.7.3.2

