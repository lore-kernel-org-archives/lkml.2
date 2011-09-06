Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1IGG1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:27:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37771 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab1IGGU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 25/55] rcu: Update documentation for additional RCU lockdep functions
Date: Tue,  6 Sep 2011 11:00:19 -0700
Message-Id: <1315332049-2604-25-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for rcu_dereference_bh_check(),
rcu_dereference_sched_check(), srcu_dereference_check(), and
rcu_dereference_index_check().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/lockdep.txt |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index 4998c63..a102d4b 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -32,9 +32,27 @@ checking of rcu_dereference() primitives:
 	srcu_dereference(p, sp):
 		Check for SRCU read-side critical section.
 	rcu_dereference_check(p, c):
-		Use explicit check expression "c".  This is useful in
-		code that is invoked by both readers and updaters.
-	rcu_dereference_raw(p)
+		Use explicit check expression "c" along with
+		rcu_read_lock_held().  This is useful in code that is
+		invoked by both RCU readers and updaters.
+	rcu_dereference_bh_check(p, c):
+		Use explicit check expression "c" along with
+		rcu_read_lock_bh_held().  This is useful in code that
+		is invoked by both RCU-bh readers and updaters.
+	rcu_dereference_sched_check(p, c):
+		Use explicit check expression "c" along with
+		rcu_read_lock_sched_held().  This is useful in code that
+		is invoked by both RCU-sched readers and updaters.
+	srcu_dereference_check(p, c):
+		Use explicit check expression "c" along with
+		srcu_read_lock_held()().  This is useful in code that
+		is invoked by both SRCU readers and updaters.
+	rcu_dereference_index_check(p, c):
+		Use explicit check expression "c", but the caller
+		must supply one of the rcu_read_lock_held() functions.
+		This is useful in code that uses RCU-protected arrays
+		that is invoked by both RCU readers and updaters.
+	rcu_dereference_raw(p):
 		Don't check.  (Use sparingly, if at all.)
 	rcu_dereference_protected(p, c):
 		Use explicit check expression "c", and omit all barriers
-- 
1.7.3.2

