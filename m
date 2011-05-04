Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1EDHNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:13:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:59536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1EDHNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:13:47 -0400
Date: Wed, 4 May 2011 07:13:26 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-yv4hwf9yhnzoada8pcpb3a97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Clean up definitions and initializers, update copyrights
Git-Commit-ID: e7e7ee2eab2080248084d71fe0a115ab745eb2aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 07:13:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7e7ee2eab2080248084d71fe0a115ab745eb2aa
Gitweb:     http://git.kernel.org/tip/e7e7ee2eab2080248084d71fe0a115ab745eb2aa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 4 May 2011 08:42:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 May 2011 08:49:24 +0200

perf events: Clean up definitions and initializers, update copyrights

Fix a few inconsistent style bits that were added over the past few
months.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-yv4hwf9yhnzoada8pcpb3a97@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   96 ++++++++++++++++++++------------------------
 kernel/events/core.c       |   40 +++++++++---------
 2 files changed, 64 insertions(+), 72 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9eec53d..207c169 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -2,8 +2,8 @@
  * Performance events:
  *
  *    Copyright (C) 2008-2009, Thomas Gleixner <tglx@linutronix.de>
- *    Copyright (C) 2008-2009, Red Hat, Inc., Ingo Molnar
- *    Copyright (C) 2008-2009, Red Hat, Inc., Peter Zijlstra
+ *    Copyright (C) 2008-2011, Red Hat, Inc., Ingo Molnar
+ *    Copyright (C) 2008-2011, Red Hat, Inc., Peter Zijlstra
  *
  * Data type definitions, declarations, prototypes.
  *
@@ -468,9 +468,9 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
-#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
-#define PERF_FLAG_FD_OUTPUT	(1U << 1)
-#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
+#define PERF_FLAG_FD_OUTPUT		(1U << 1)
+#define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
 #ifdef __KERNEL__
 /*
@@ -484,9 +484,9 @@ enum perf_callchain_context {
 #endif
 
 struct perf_guest_info_callbacks {
-	int (*is_in_guest) (void);
-	int (*is_user_mode) (void);
-	unsigned long (*get_guest_ip) (void);
+	int				(*is_in_guest)(void);
+	int				(*is_user_mode)(void);
+	unsigned long			(*get_guest_ip)(void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -652,19 +652,19 @@ struct pmu {
 	 * Start the transaction, after this ->add() doesn't need to
 	 * do schedulability tests.
 	 */
-	void (*start_txn)	(struct pmu *pmu); /* optional */
+	void (*start_txn)		(struct pmu *pmu); /* optional */
 	/*
 	 * If ->start_txn() disabled the ->add() schedulability test
 	 * then ->commit_txn() is required to perform one. On success
 	 * the transaction is closed. On error the transaction is kept
 	 * open until ->cancel_txn() is called.
 	 */
-	int  (*commit_txn)	(struct pmu *pmu); /* optional */
+	int  (*commit_txn)		(struct pmu *pmu); /* optional */
 	/*
 	 * Will cancel the transaction, assumes ->del() is called
 	 * for each successful ->add() during the transaction.
 	 */
-	void (*cancel_txn)	(struct pmu *pmu); /* optional */
+	void (*cancel_txn)		(struct pmu *pmu); /* optional */
 };
 
 /**
@@ -712,15 +712,15 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
 					struct pt_regs *regs);
 
 enum perf_group_flag {
-	PERF_GROUP_SOFTWARE = 0x1,
+	PERF_GROUP_SOFTWARE		= 0x1,
 };
 
-#define SWEVENT_HLIST_BITS	8
-#define SWEVENT_HLIST_SIZE	(1 << SWEVENT_HLIST_BITS)
+#define SWEVENT_HLIST_BITS		8
+#define SWEVENT_HLIST_SIZE		(1 << SWEVENT_HLIST_BITS)
 
 struct swevent_hlist {
-	struct hlist_head	heads[SWEVENT_HLIST_SIZE];
-	struct rcu_head		rcu_head;
+	struct hlist_head		heads[SWEVENT_HLIST_SIZE];
+	struct rcu_head			rcu_head;
 };
 
 #define PERF_ATTACH_CONTEXT	0x01
@@ -733,13 +733,13 @@ struct swevent_hlist {
  * This is a per-cpu dynamically allocated data structure.
  */
 struct perf_cgroup_info {
-	u64 time;
-	u64 timestamp;
+	u64				time;
+	u64				timestamp;
 };
 
 struct perf_cgroup {
-	struct cgroup_subsys_state css;
-	struct perf_cgroup_info *info;	/* timing info, one per cpu */
+	struct				cgroup_subsys_state css;
+	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
 };
 #endif
 
@@ -923,7 +923,7 @@ struct perf_event_context {
 
 /*
  * Number of contexts where an event can trigger:
- * 	task, softirq, hardirq, nmi.
+ *	task, softirq, hardirq, nmi.
  */
 #define PERF_NR_CONTEXTS	4
 
@@ -1001,8 +1001,7 @@ struct perf_sample_data {
 	struct perf_raw_record		*raw;
 };
 
-static inline
-void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
+static inline void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
 {
 	data->addr = addr;
 	data->raw  = NULL;
@@ -1039,8 +1038,7 @@ extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
 #ifndef perf_arch_fetch_caller_regs
-static inline void
-perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
+static inline void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
 #endif
 
 /*
@@ -1080,8 +1078,7 @@ static inline void perf_event_task_sched_in(struct task_struct *task)
 		__perf_event_task_sched_in(task);
 }
 
-static inline
-void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
+static inline void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
@@ -1099,14 +1096,10 @@ extern void perf_event_fork(struct task_struct *tsk);
 /* Callchains */
 DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
-extern void perf_callchain_user(struct perf_callchain_entry *entry,
-				struct pt_regs *regs);
-extern void perf_callchain_kernel(struct perf_callchain_entry *entry,
-				  struct pt_regs *regs);
-
+extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs);
+extern void perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs);
 
-static inline void
-perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
+static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
 {
 	if (entry->nr < PERF_MAX_STACK_DEPTH)
 		entry->ip[entry->nr++] = ip;
@@ -1142,9 +1135,9 @@ extern void perf_tp_event(u64 addr, u64 count, void *record,
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
-#define perf_misc_flags(regs)	(user_mode(regs) ? PERF_RECORD_MISC_USER : \
-				 PERF_RECORD_MISC_KERNEL)
-#define perf_instruction_pointer(regs)	instruction_pointer(regs)
+# define perf_misc_flags(regs) \
+		(user_mode(regs) ? PERF_RECORD_MISC_USER : PERF_RECORD_MISC_KERNEL)
+# define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
 extern int perf_output_begin(struct perf_output_handle *handle,
@@ -1179,9 +1172,9 @@ static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
 static inline int perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *callbacks) { return 0; }
+(struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 static inline int perf_unregister_guest_info_callbacks
-(struct perf_guest_info_callbacks *callbacks) { return 0; }
+(struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
@@ -1194,23 +1187,22 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
-#define perf_output_put(handle, x) \
-	perf_output_copy((handle), &(x), sizeof(x))
+#define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
 /*
  * This has to have a higher priority than migration_notifier in sched.c.
  */
-#define perf_cpu_notifier(fn)					\
-do {								\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = CPU_PRI_PERF }; \
-	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,		\
-		(void *)(unsigned long)smp_processor_id());	\
-	fn(&fn##_nb, (unsigned long)CPU_STARTING,		\
-		(void *)(unsigned long)smp_processor_id());	\
-	fn(&fn##_nb, (unsigned long)CPU_ONLINE,			\
-		(void *)(unsigned long)smp_processor_id());	\
-	register_cpu_notifier(&fn##_nb);			\
+#define perf_cpu_notifier(fn)						\
+do {									\
+	static struct notifier_block fn##_nb __cpuinitdata =		\
+		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
+		(void *)(unsigned long)smp_processor_id());		\
+	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
+		(void *)(unsigned long)smp_processor_id());		\
+	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
+		(void *)(unsigned long)smp_processor_id());		\
+	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 
 #endif /* __KERNEL__ */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 440bc48..0fc34a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2,8 +2,8 @@
  * Performance events core code:
  *
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
- *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
@@ -39,10 +39,10 @@
 #include <asm/irq_regs.h>
 
 struct remote_function_call {
-	struct task_struct *p;
-	int (*func)(void *info);
-	void *info;
-	int ret;
+	struct task_struct	*p;
+	int			(*func)(void *info);
+	void			*info;
+	int			ret;
 };
 
 static void remote_function(void *data)
@@ -76,10 +76,10 @@ static int
 task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
 {
 	struct remote_function_call data = {
-		.p = p,
-		.func = func,
-		.info = info,
-		.ret = -ESRCH, /* No such (running) process */
+		.p	= p,
+		.func	= func,
+		.info	= info,
+		.ret	= -ESRCH, /* No such (running) process */
 	};
 
 	if (task_curr(p))
@@ -100,10 +100,10 @@ task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
 static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 {
 	struct remote_function_call data = {
-		.p = NULL,
-		.func = func,
-		.info = info,
-		.ret = -ENXIO, /* No such CPU */
+		.p	= NULL,
+		.func	= func,
+		.info	= info,
+		.ret	= -ENXIO, /* No such CPU */
 	};
 
 	smp_call_function_single(cpu, remote_function, &data, 1);
@@ -7445,11 +7445,11 @@ static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 }
 
 struct cgroup_subsys perf_subsys = {
-	.name = "perf_event",
-	.subsys_id = perf_subsys_id,
-	.create = perf_cgroup_create,
-	.destroy = perf_cgroup_destroy,
-	.exit = perf_cgroup_exit,
-	.attach = perf_cgroup_attach,
+	.name		= "perf_event",
+	.subsys_id	= perf_subsys_id,
+	.create		= perf_cgroup_create,
+	.destroy	= perf_cgroup_destroy,
+	.exit		= perf_cgroup_exit,
+	.attach		= perf_cgroup_attach,
 };
 #endif /* CONFIG_CGROUP_PERF */
