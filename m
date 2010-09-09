Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0IITs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:48:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:32961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0IITs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:48:26 -0400
Date: Thu, 9 Sep 2010 19:47:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Deconstify struct pmu
Message-ID: <tip-51b0fe39549a04858001922919ab355dee9bdfcf@git.kernel.org>
Git-Commit-ID: 51b0fe39549a04858001922919ab355dee9bdfcf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:47:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51b0fe39549a04858001922919ab355dee9bdfcf
Gitweb:     http://git.kernel.org/tip/51b0fe39549a04858001922919ab355dee9bdfcf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Jun 2010 13:35:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:27 +0200

perf: Deconstify struct pmu

sed -ie 's/const struct pmu\>/struct pmu/g' `git grep -l "const struct pmu\>"`

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Michael Cree <mcree@orcon.net.nz>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/kernel/perf_event.c           |    4 ++--
 arch/arm/kernel/perf_event.c             |    2 +-
 arch/powerpc/kernel/perf_event.c         |    8 ++++----
 arch/powerpc/kernel/perf_event_fsl_emb.c |    2 +-
 arch/sh/kernel/perf_event.c              |    4 ++--
 arch/sparc/kernel/perf_event.c           |   10 +++++-----
 arch/x86/kernel/cpu/perf_event.c         |   14 +++++++-------
 include/linux/perf_event.h               |   10 +++++-----
 kernel/perf_event.c                      |   26 +++++++++++++-------------
 9 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 51c39fa..56fa415 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -642,7 +642,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return 0;
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= alpha_pmu_enable,
 	.disable	= alpha_pmu_disable,
 	.read		= alpha_pmu_read,
@@ -653,7 +653,7 @@ static const struct pmu pmu = {
 /*
  * Main entry point to initialise a HW performance event.
  */
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	int err;
 
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 64ca8c3..0671e92 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -491,7 +491,7 @@ __hw_perf_event_init(struct perf_event *event)
 	return err;
 }
 
-const struct pmu *
+struct pmu *
 hw_perf_event_init(struct perf_event *event)
 {
 	int err = 0;
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index d301a30..5f78681 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -857,7 +857,7 @@ static void power_pmu_unthrottle(struct perf_event *event)
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-void power_pmu_start_txn(const struct pmu *pmu)
+void power_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -870,7 +870,7 @@ void power_pmu_start_txn(const struct pmu *pmu)
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-void power_pmu_cancel_txn(const struct pmu *pmu)
+void power_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -882,7 +882,7 @@ void power_pmu_cancel_txn(const struct pmu *pmu)
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-int power_pmu_commit_txn(const struct pmu *pmu)
+int power_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	long i, n;
@@ -1014,7 +1014,7 @@ static int hw_perf_cache_event(u64 config, u64 *eventp)
 	return 0;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	u64 ev;
 	unsigned long flags;
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index 1ba4547..d7619b5 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -428,7 +428,7 @@ static int hw_perf_cache_event(u64 config, u64 *eventp)
 	return 0;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	u64 ev;
 	struct perf_event *events[MAX_HWEVENTS];
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 7a3dc35..395572c 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -257,13 +257,13 @@ static void sh_pmu_read(struct perf_event *event)
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
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 4bc4029..481b894 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1099,7 +1099,7 @@ static int __hw_perf_event_init(struct perf_event *event)
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-static void sparc_pmu_start_txn(const struct pmu *pmu)
+static void sparc_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -1111,7 +1111,7 @@ static void sparc_pmu_start_txn(const struct pmu *pmu)
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-static void sparc_pmu_cancel_txn(const struct pmu *pmu)
+static void sparc_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
@@ -1123,7 +1123,7 @@ static void sparc_pmu_cancel_txn(const struct pmu *pmu)
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-static int sparc_pmu_commit_txn(const struct pmu *pmu)
+static int sparc_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int n;
@@ -1142,7 +1142,7 @@ static int sparc_pmu_commit_txn(const struct pmu *pmu)
 	return 0;
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
@@ -1152,7 +1152,7 @@ static const struct pmu pmu = {
 	.commit_txn	= sparc_pmu_commit_txn,
 };
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	int err = __hw_perf_event_init(event);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index de6569c..fdd97f2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -618,7 +618,7 @@ static void x86_pmu_enable_all(int added)
 	}
 }
 
-static const struct pmu pmu;
+static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
 {
@@ -1427,7 +1427,7 @@ static inline void x86_pmu_read(struct perf_event *event)
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-static void x86_pmu_start_txn(const struct pmu *pmu)
+static void x86_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1440,7 +1440,7 @@ static void x86_pmu_start_txn(const struct pmu *pmu)
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-static void x86_pmu_cancel_txn(const struct pmu *pmu)
+static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1457,7 +1457,7 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-static int x86_pmu_commit_txn(const struct pmu *pmu)
+static int x86_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int assign[X86_PMC_IDX_MAX];
@@ -1483,7 +1483,7 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	return 0;
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
 	.start		= x86_pmu_start,
@@ -1569,9 +1569,9 @@ out:
 	return ret;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *tmp;
+	struct pmu *tmp;
 	int err;
 
 	err = __hw_perf_event_init(event);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 000610c..09d048b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -578,19 +578,19 @@ struct pmu {
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
@@ -669,7 +669,7 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	const struct pmu		*pmu;
+	struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
@@ -849,7 +849,7 @@ struct perf_output_handle {
  */
 extern int perf_max_events;
 
-extern const struct pmu *hw_perf_event_init(struct perf_event *event);
+extern struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2d74f31..fb46fd1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -75,7 +75,7 @@ static DEFINE_SPINLOCK(perf_resource_lock);
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
+extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -691,7 +691,7 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group = NULL;
-	const struct pmu *pmu = group_event->pmu;
+	struct pmu *pmu = group_event->pmu;
 	bool txn = false;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
@@ -4501,7 +4501,7 @@ static int perf_swevent_int(struct perf_event *event)
 	return 0;
 }
 
-static const struct pmu perf_ops_generic = {
+static struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
 	.start		= perf_swevent_int,
@@ -4614,7 +4614,7 @@ static void cpu_clock_perf_event_read(struct perf_event *event)
 	cpu_clock_perf_event_update(event);
 }
 
-static const struct pmu perf_ops_cpu_clock = {
+static struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_event_enable,
 	.disable	= cpu_clock_perf_event_disable,
 	.read		= cpu_clock_perf_event_read,
@@ -4671,7 +4671,7 @@ static void task_clock_perf_event_read(struct perf_event *event)
 	task_clock_perf_event_update(event, time);
 }
 
-static const struct pmu perf_ops_task_clock = {
+static struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_event_enable,
 	.disable	= task_clock_perf_event_disable,
 	.read		= task_clock_perf_event_read,
@@ -4785,7 +4785,7 @@ static int swevent_hlist_get(struct perf_event *event)
 
 #ifdef CONFIG_EVENT_TRACING
 
-static const struct pmu perf_ops_tracepoint = {
+static struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
 	.start		= perf_swevent_int,
@@ -4849,7 +4849,7 @@ static void tp_perf_event_destroy(struct perf_event *event)
 	perf_trace_destroy(event);
 }
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	int err;
 
@@ -4896,7 +4896,7 @@ static void perf_event_free_filter(struct perf_event *event)
 
 #else
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -4918,7 +4918,7 @@ static void bp_perf_event_destroy(struct perf_event *event)
 	release_bp_slot(event);
 }
 
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	int err;
 
@@ -4942,7 +4942,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	return NULL;
 }
@@ -4964,9 +4964,9 @@ static void sw_perf_event_destroy(struct perf_event *event)
 	swevent_hlist_put(event);
 }
 
-static const struct pmu *sw_perf_event_init(struct perf_event *event)
+static struct pmu *sw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *pmu = NULL;
+	struct pmu *pmu = NULL;
 	u64 event_id = event->attr.config;
 
 	/*
@@ -5028,7 +5028,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		   perf_overflow_handler_t overflow_handler,
 		   gfp_t gfpflags)
 {
-	const struct pmu *pmu;
+	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err;
