Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0GNULm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:11:42 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36014 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab0GNUKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:22 -0400
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
Subject: [PATCH RFC tip/core/rcu 09/30] perf_event: __rcu annotations
Date: Wed, 14 Jul 2010 13:09:43 -0700
Message-Id: <1279138204-12849-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
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
index 5d0266d..b30ee92 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -645,7 +645,7 @@ struct perf_event {
 	struct hlist_node		hlist_entry;
 	int				nr_siblings;
 	int				group_flags;
-	struct perf_event		*group_leader;
+	struct perf_event __rcu		*group_leader;
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
@@ -709,7 +709,7 @@ struct perf_event {
 	atomic_t			mmap_count;
 	int				mmap_locked;
 	struct user_struct		*mmap_user;
-	struct perf_mmap_data		*data;
+	struct perf_mmap_data __rcu	*data;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -777,7 +777,7 @@ struct perf_event_context {
 	 * These fields let us detect when two contexts have both
 	 * been cloned (inherited) from a common ancestor.
 	 */
-	struct perf_event_context	*parent_ctx;
+	struct perf_event_context __rcu *parent_ctx;
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9a2d9a0..26b85fe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1440,7 +1440,7 @@ struct task_struct {
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

