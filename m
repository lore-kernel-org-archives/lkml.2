Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1IGG3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:29:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40055 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1IGGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 26/55] rcu: Remove unused and redundant interfaces
Date: Tue,  6 Sep 2011 11:00:20 -0700
Message-Id: <1315332049-2604-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_dereference_bh_protected() and rcu_dereference_sched_protected()
macros are synonyms for rcu_dereference_protected() and are not used
anywhere in mainline.  This commit therefore removes them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c61a535..ea80396 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -578,26 +578,6 @@ extern int rcu_my_thread_group_empty(void);
 #define rcu_dereference_protected(p, c) \
 	__rcu_dereference_protected((p), (c), __rcu)
 
-/**
- * rcu_dereference_bh_protected() - fetch RCU-bh pointer when updates prevented
- * @p: The pointer to read, prior to dereferencing
- * @c: The conditions under which the dereference will take place
- *
- * This is the RCU-bh counterpart to rcu_dereference_protected().
- */
-#define rcu_dereference_bh_protected(p, c) \
-	__rcu_dereference_protected((p), (c), __rcu)
-
-/**
- * rcu_dereference_sched_protected() - fetch RCU-sched pointer when updates prevented
- * @p: The pointer to read, prior to dereferencing
- * @c: The conditions under which the dereference will take place
- *
- * This is the RCU-sched counterpart to rcu_dereference_protected().
- */
-#define rcu_dereference_sched_protected(p, c) \
-	__rcu_dereference_protected((p), (c), __rcu)
-
 
 /**
  * rcu_dereference() - fetch RCU-protected pointer for dereferencing
-- 
1.7.3.2

