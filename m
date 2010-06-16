Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab0FPQHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:07:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:33962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab0FPQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:35 -0400
Message-Id: <20100616160238.147795091@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/8] perf: deconstify struct pmu
References: <20100616160027.590430763@chello.nl>
Content-Disposition: inline; filename=perf-deconst-pmu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sed -ie 's/const struct pmu\>/struct pmu/g' `git grep -l "const struct pmu\>"`

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/kernel/perf_event.c             |    2 +-
 arch/powerpc/kernel/perf_event.c         |    8 ++++----
 arch/powerpc/kernel/perf_event_fsl_emb.c |    2 +-
 arch/sh/kernel/perf_event.c              |    4 ++--
 arch/sparc/kernel/perf_event.c           |   10 +++++-----
 arch/x86/kernel/cpu/perf_event.c         |   14 +++++++-------
 include/linux/perf_event.h               |   10 +++++-----
 kernel/perf_event.c                      |   26 +++++++++++++-------------
 8 files changed, 38 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -491,7 +491,7 @@ __hw_perf_event_init(struct perf_event *
 	return err;
 }
 
-const struct pmu *
+struct pmu *
 hw_perf_event_init(struct perf_event *event)
 {
 	int err = 0;
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -854,7 +854,7 @@ static void power_pmu_unthrottle(struct 
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-void power_pmu_start_txn(const struct pmu *pmu)
+void power_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -867,7 +867,7 @@ void power_pmu_start_txn(const struct pm
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-void power_pmu_cancel_txn(const struct pmu *pmu)
+void power_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -879,7 +879,7 @@ void power_pmu_cancel_txn(const struct p
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-int power_pmu_commit_txn(const struct pmu *pmu)
+int power_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	long i, n;
@@ -1011,7 +1011,7 @@ static int hw_perf_cache_event(u64 confi
 	return 0;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	u64 ev;
 	unsigned long flags;
Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -428,7 +428,7 @@ static int hw_perf_cache_event(u64 confi
 	return 0;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	u64 ev;
 	struct perf_event *events[MAX_HWEVENTS];
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -257,13 +257,13 @@ static void sh_pmu_read(struct perf_even
 	sh_perf_event_update(event, &event->hw, event->hw.idx);
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= sh_pmu_enable,
 	.disable	= sh_pmu_disable,
 	.read		= sh_pmu_read,
 };
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	int err = __hw_perf_event_init(event);
 	if (unlikely(err)) {
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1098,7 +1098,7 @@ static int __hw_perf_event_init(struct p
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-static void sparc_pmu_start_txn(const struct pmu *pmu)
+static void sparc_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -1110,7 +1110,7 @@ static void sparc_pmu_start_txn(const st
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-static void sparc_pmu_cancel_txn(const struct pmu *pmu)
+static void sparc_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -1122,7 +1122,7 @@ static void sparc_pmu_cancel_txn(const s
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-static int sparc_pmu_commit_txn(const struct pmu *pmu)
+static int sparc_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int n;
@@ -1141,7 +1141,7 @@ static int sparc_pmu_commit_txn(const st
 	return 0;
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
@@ -1151,7 +1151,7 @@ static const struct pmu pmu = {
 	.commit_txn	= sparc_pmu_commit_txn,
 };
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	int err = __hw_perf_event_init(event);
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -618,7 +618,7 @@ static void x86_pmu_enable_all(int added
 	}
 }
 
-static const struct pmu pmu;
+static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
 {
@@ -1394,7 +1394,7 @@ static inline void x86_pmu_read(struct p
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-static void x86_pmu_start_txn(const struct pmu *pmu)
+static void x86_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1407,7 +1407,7 @@ static void x86_pmu_start_txn(const stru
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-static void x86_pmu_cancel_txn(const struct pmu *pmu)
+static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1424,7 +1424,7 @@ static void x86_pmu_cancel_txn(const str
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-static int x86_pmu_commit_txn(const struct pmu *pmu)
+static int x86_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int assign[X86_PMC_IDX_MAX];
@@ -1450,7 +1450,7 @@ static int x86_pmu_commit_txn(const stru
 	return 0;
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
 	.start		= x86_pmu_start,
@@ -1536,9 +1536,9 @@ out:
 	return ret;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *tmp;
+	struct pmu *tmp;
 	int err;
 
 	err = __hw_perf_event_init(event);
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -576,19 +576,19 @@ struct pmu {
 	 * Start the transaction, after this ->enable() doesn't need
 	 * to do schedulability tests.
 	 */
-	void (*start_txn)	(const struct pmu *pmu);
+	void (*start_txn)	(struct pmu *pmu);
 	/*
 	 * If ->start_txn() disabled the ->enable() schedulability test
 	 * then ->commit_txn() is required to perform one. On success
 	 * the transaction is closed. On error the transaction is kept
 	 * open until ->cancel_txn() is called.
 	 */
-	int  (*commit_txn)	(const struct pmu *pmu);
+	int  (*commit_txn)	(struct pmu *pmu);
 	/*
 	 * Will cancel the transaction, assumes ->disable() is called for
 	 * each successfull ->enable() during the transaction.
 	 */
-	void (*cancel_txn)	(const struct pmu *pmu);
+	void (*cancel_txn)	(struct pmu *pmu);
 };
 
 /**
@@ -667,7 +667,7 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	const struct pmu		*pmu;
+	struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
@@ -845,7 +845,7 @@ struct perf_output_handle {
  */
 extern int perf_max_events;
 
-extern const struct pmu *hw_perf_event_init(struct perf_event *event);
+extern struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -75,7 +75,7 @@ static DEFINE_SPINLOCK(perf_resource_loc
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
+extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -673,7 +673,7 @@ group_sched_in(struct perf_event *group_
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group = NULL;
-	const struct pmu *pmu = group_event->pmu;
+	struct pmu *pmu = group_event->pmu;
 	bool txn = false;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
@@ -4291,7 +4291,7 @@ static int perf_swevent_int(struct perf_
 	return 0;
 }
 
-static const struct pmu perf_ops_generic = {
+static struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
 	.start		= perf_swevent_int,
@@ -4404,7 +4404,7 @@ static void cpu_clock_perf_event_read(st
 	cpu_clock_perf_event_update(event);
 }
 
-static const struct pmu perf_ops_cpu_clock = {
+static struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_event_enable,
 	.disable	= cpu_clock_perf_event_disable,
 	.read		= cpu_clock_perf_event_read,
@@ -4461,7 +4461,7 @@ static void task_clock_perf_event_read(s
 	task_clock_perf_event_update(event, time);
 }
 
-static const struct pmu perf_ops_task_clock = {
+static struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_event_enable,
 	.disable	= task_clock_perf_event_disable,
 	.read		= task_clock_perf_event_read,
@@ -4575,7 +4575,7 @@ static int swevent_hlist_get(struct perf
 
 #ifdef CONFIG_EVENT_TRACING
 
-static const struct pmu perf_ops_tracepoint = {
+static struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
 	.start		= perf_swevent_int,
@@ -4639,7 +4639,7 @@ static void tp_perf_event_destroy(struct
 	perf_trace_destroy(event);
 }
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	int err;
 
@@ -4686,7 +4686,7 @@ static void perf_event_free_filter(struc
 
 #else
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -4708,7 +4708,7 @@ static void bp_perf_event_destroy(struct
 	release_bp_slot(event);
 }
 
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	int err;
 
@@ -4732,7 +4732,7 @@ void perf_bp_event(struct perf_event *bp
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	return NULL;
 }
@@ -4754,9 +4754,9 @@ static void sw_perf_event_destroy(struct
 	swevent_hlist_put(event);
 }
 
-static const struct pmu *sw_perf_event_init(struct perf_event *event)
+static struct pmu *sw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *pmu = NULL;
+	struct pmu *pmu = NULL;
 	u64 event_id = event->attr.config;
 
 	/*
@@ -4818,7 +4818,7 @@ perf_event_alloc(struct perf_event_attr 
 		   perf_overflow_handler_t overflow_handler,
 		   gfp_t gfpflags)
 {
-	const struct pmu *pmu;
+	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err;


