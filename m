Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1A3KX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 05:23:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab1A3KX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 05:23:27 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: [Patch] rcupdate: remove dead code
Date: Sun, 30 Jan 2011 18:23:08 +0800
Message-Id: <1296382988-16564-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT, so #ifndef CONFIG_PREEMPT
is totally useless in kernel/rcupdate.c.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


---
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
