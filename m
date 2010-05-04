Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0EDUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:31:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36794 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933608Ab0EDUUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:13 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH tip/core/rcu 33/48] cgroups: __rcu annotations
Date: Tue,  4 May 2010 13:19:43 -0700
Message-Id: <1273004398-19760-33-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    4 ++--
 include/linux/sched.h  |    2 +-
 kernel/cgroup.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8f78073..b147fd5 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -75,7 +75,7 @@ struct cgroup_subsys_state {
 
 	unsigned long flags;
 	/* ID for this css, if possible */
-	struct css_id *id;
+	struct css_id __rcu *id;
 };
 
 /* bits in struct cgroup_subsys_state flags field */
@@ -205,7 +205,7 @@ struct cgroup {
 	struct list_head children;	/* my children */
 
 	struct cgroup *parent;		/* my parent */
-	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */
+	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..7307c74 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1429,7 +1429,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_CGROUPS
 	/* Control Group info protected by css_set_lock */
-	struct css_set *cgroups;
+	struct css_set __rcu *cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
 #endif
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3a53c77..5cfbc93 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -138,7 +138,7 @@ struct css_id {
 	 * is called after synchronize_rcu(). But for safe use, css_is_removed()
 	 * css_tryget() should be used for avoiding race.
 	 */
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state __rcu *css;
 	/*
 	 * ID of this css.
 	 */
-- 
1.7.0

