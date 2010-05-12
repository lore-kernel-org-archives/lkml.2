Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab0ELVhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:37:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45248 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab0ELVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH RFC tip/core/rcu 13/23] perf_event: __rcu annotations
Date: Wed, 12 May 2010 14:33:32 -0700
Message-Id: <1273700022-16523-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    6 +++---
 include/linux/sched.h      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c8e3754..48132eb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -582,7 +582,7 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	struct perf_event		*output;
+	struct perf_event __rcu		*output;
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
@@ -643,7 +643,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	struct perf_mmap_data		*data;
+	struct perf_mmap_data __rcu	*data;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -710,7 +710,7 @@ struct perf_event_context {
 	 * These fields let us detect when two contexts have both
 	 * been cloned (inherited) from a common ancestor.
 	 */
-	struct perf_event_context	*parent_ctx;
+	struct perf_event_context __rcu *parent_ctx;
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 74b3125..34d28f7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1442,7 +1442,7 @@ struct task_struct {
 	struct futex_pi_state *pi_state_cache;
 #endif
 #ifdef CONFIG_PERF_EVENTS
-	struct perf_event_context *perf_event_ctxp;
+	struct perf_event_context __rcu *perf_event_ctxp;
 	struct mutex perf_event_mutex;
 	struct list_head perf_event_list;
 #endif
-- 
1.7.0.6

