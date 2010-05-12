Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0ELVdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:33:55 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51970 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050Ab0ELVdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH RFC tip/core/rcu 09/23] credentials: rcu annotation
Date: Wed, 12 May 2010 14:33:28 -0700
Message-Id: <1273700022-16523-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/sched.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7307c74..74b3125 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1301,9 +1301,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	const struct cred *real_cred;	/* objective and real subjective task
+	const struct cred __rcu *real_cred; /* objective and real subjective task
 					 * credentials (COW) */
-	const struct cred *cred;	/* effective (overridable) subjective task
+	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
-- 
1.7.0.6

