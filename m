Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0EXT0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:26:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0EXT0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:26:16 -0400
Date: Mon, 24 May 2010 21:25:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes
Message-ID: <20100524192531.GA15614@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus

Most of these changes are fixes and dead code removal, but 
also a set of optimizations and a series of tracing 
size-optimization bits that we kept pending because they 
conflicted with the previous push - and some TUI 
enhancements.

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86/mmiotrace: Remove redundant instruction prefix checks

Arnaldo Carvalho de Melo (15):
      perf tui: Fix build problem with slang <= 2.0.6
      perf tools: Remove some unused functions
      perf probe: Fix some error exit paths
      perf probe: Don't call die()
      perf tools: remove xstrndup, xmalloc, xzalloc
      perf symbols: Don't try to read the build-id twice
      perf session: Make read_build_id routines look at the host_machine too
      perf TUI: Make 'space' be an alias to 'PgDn'
      perf annotate: Use build-ids to find the right DSO
      perf tui: Allow disabling the TUI on a per command basis in ~/.perfconfig
      perf report: Don't start the TUI if -D is used
      perf tui: Remove annotate from popup menu after failure
      perf annotate: Add TUI interface
      perf annotate: Fix up usage of the build id cache
      perf report: Support multiple events on the TUI

Cyrill Gorcunov (5):
      perf, x86: P4 PMU -- handle unflagged events
      perf, x86: P4 PMU -- fix typo in unflagged NMI handling
      perf, x86: P4 PMU -- do a real check for ESCR address being in hash
      perf, x86: P4_pmu_schedule_events -- use smp_processor_id instead of raw_
      perf, x86: P4 PMU -- add missing bit in CCCR mask

Frederic Weisbecker (4):
      perf: Comply with new rcu checks API
      perf: Fix unaligned accesses while fetching trace values
      perf: Fix forgotten preempt_enable by nested writers
      perf: Fix getline undeclared

Li Zefan (1):
      tracing: Fix function declarations if !CONFIG_STACKTRACE

Lin Ming (1):
      perf, sparc: Implement group scheduling transactional APIs

Masami Hiramatsu (1):
      perf probe: Don't compile CFI related code if elfutils is old

Mathieu Desnoyers (1):
      tracepoints: Add check trace callback type

Peter Zijlstra (16):
      perf/ftrace: Optimize perf/tracepoint interaction for single events
      perf: Optimize buffer placement by allocating buffers NUMA aware
      perf: Disallow mmap() on per-task inherited events
      perf: Optimize the perf_output() path by removing IRQ-disables
      perf: Optimize the hotpath by converting the perf output buffer to local_t
      perf: Optimize perf_output_*() by avoiding local_xchg()
      perf, trace: Optimize tracepoints by removing IRQ-disable from perf/tracepoint interaction
      perf, trace: Optimize tracepoints by using per-tracepoint-per-cpu hlist to track events
      perf: Ensure that IOC_OUTPUT isn't used to create multi-writer buffers
      perf-record: Remove -M
      perf-record: Share per-cpu buffers
      perf: Fix wakeup storm for RO mmap()s
      perf: Optimize perf_output_copy()
      perf: Optimize the !vmalloc backed buffer
      perf: Remove more code from the fastpath
      perf: Optimize perf_tp_event_match()

Russ Anderson (1):
      perf record: remove unneeded gettimeofday() call

Stephane Eranian (2):
      perf: Fix errors path in perf_output_begin()
      perf stat: add perf stat -B to pretty print large numbers

Steven Rostedt (10):
      tracing: Create class struct for events
      tracing: Let tracepoints have data passed to tracepoint callbacks
      tracing: Remove per event trace registering
      tracing: Move fields from event to class structure
      tracing: Move raw_init from events to class
      tracing: Allow events to share their print functions
      tracing: Move print functions into event class
      tracing: Remove duplicate id information in event structure
      tracing: Combine event filter_active and enable into single flags field
      tracing: Comment the use of event_mutex with trace event flags

Tom Zanussi (1):
      perf: Use read() instead of lseek() in trace_event_read.c:skip()


 arch/sparc/kernel/perf_event.c                 |  108 ++++---
 arch/x86/include/asm/perf_event_p4.h           |    3 +-
 arch/x86/kernel/cpu/perf_event_p4.c            |   41 ++-
 arch/x86/mm/pf_in.c                            |    2 +-
 include/linux/ftrace_event.h                   |  103 ++++--
 include/linux/perf_event.h                     |   28 +-
 include/linux/syscalls.h                       |   57 +--
 include/linux/tracepoint.h                     |   98 ++++--
 include/trace/ftrace.h                         |  247 +++++--------
 include/trace/syscall.h                        |   10 +-
 kernel/perf_event.c                            |  389 +++++++++++---------
 kernel/trace/blktrace.c                        |  138 ++++---
 kernel/trace/ftrace.c                          |    7 +-
 kernel/trace/kmemtrace.c                       |   70 +++--
 kernel/trace/trace.c                           |    9 +-
 kernel/trace/trace.h                           |    9 +-
 kernel/trace/trace_branch.c                    |    8 +-
 kernel/trace/trace_event_perf.c                |  183 +++++-----
 kernel/trace/trace_events.c                    |  139 +++++---
 kernel/trace/trace_events_filter.c             |   28 +-
 kernel/trace/trace_export.c                    |   16 +-
 kernel/trace/trace_functions_graph.c           |   13 +-
 kernel/trace/trace_kprobe.c                    |  113 ++++---
 kernel/trace/trace_output.c                    |  137 +++++---
 kernel/trace/trace_output.h                    |    2 +-
 kernel/trace/trace_sched_switch.c              |   20 +-
 kernel/trace/trace_sched_wakeup.c              |   28 +-
 kernel/trace/trace_syscalls.c                  |  146 ++++++--
 kernel/trace/trace_workqueue.c                 |   26 +-
 kernel/tracepoint.c                            |   91 +++--
 net/core/drop_monitor.c                        |   12 +-
 samples/tracepoints/tp-samples-trace.h         |    4 +-
 samples/tracepoints/tracepoint-probe-sample.c  |   13 +-
 samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
 tools/perf/Documentation/perf-stat.txt         |    3 +
 tools/perf/builtin-annotate.c                  |   61 +++-
 tools/perf/builtin-probe.c                     |   10 +-
 tools/perf/builtin-record.c                    |   72 ++---
 tools/perf/builtin-report.c                    |   64 ++--
 tools/perf/builtin-stat.c                      |   18 +-
 tools/perf/perf.c                              |   25 ++-
 tools/perf/util/abspath.c                      |   81 -----
 tools/perf/util/build-id.c                     |   22 ++
 tools/perf/util/build-id.h                     |    2 +
 tools/perf/util/cache.h                        |   57 +---
 tools/perf/util/callchain.c                    |    1 +
 tools/perf/util/callchain.h                    |    1 -
 tools/perf/util/config.c                       |  461 +-----------------------
 tools/perf/util/exec_cmd.c                     |    6 +-
 tools/perf/util/exec_cmd.h                     |    1 -
 tools/perf/util/header.c                       |   84 +++--
 tools/perf/util/help.c                         |   30 +--
 tools/perf/util/hist.c                         |   42 ++-
 tools/perf/util/hist.h                         |   24 ++-
 tools/perf/util/newt.c                         |  150 ++++++--
 tools/perf/util/path.c                         |  204 +-----------
 tools/perf/util/probe-finder.c                 |   33 ++-
 tools/perf/util/probe-finder.h                 |    3 +
 tools/perf/util/quote.c                        |  433 +----------------------
 tools/perf/util/quote.h                        |   39 --
 tools/perf/util/run-command.c                  |   90 -----
 tools/perf/util/run-command.h                  |   30 --
 tools/perf/util/session.c                      |    8 +
 tools/perf/util/session.h                      |    8 +-
 tools/perf/util/sigchain.c                     |    2 +-
 tools/perf/util/sigchain.h                     |    1 -
 tools/perf/util/strbuf.c                       |  229 +------------
 tools/perf/util/strbuf.h                       |   45 ---
 tools/perf/util/symbol.c                       |   25 +-
 tools/perf/util/symbol.h                       |    1 +
 tools/perf/util/trace-event-read.c             |   19 +-
 tools/perf/util/trace-event.h                  |    7 +-
 tools/perf/util/util.h                         |  177 +---------
 tools/perf/util/wrapper.c                      |  110 ------
 74 files changed, 1839 insertions(+), 3145 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index e277193..cf4ce26 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -91,6 +91,8 @@ struct cpu_hw_events {
 
 	/* Enabled/disable state.  */
 	int			enabled;
+
+	unsigned int		group_flag;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = { .enabled = 1, };
 
@@ -980,53 +982,6 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
-static void event_sched_in(struct perf_event *event)
-{
-	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = smp_processor_id();
-	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
-	if (is_software_event(event))
-		event->pmu->enable(event);
-}
-
-int hw_perf_group_sched_in(struct perf_event *group_leader,
-			   struct perf_cpu_context *cpuctx,
-			   struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct perf_event *sub;
-	int n0, n;
-
-	if (!sparc_pmu)
-		return 0;
-
-	n0 = cpuc->n_events;
-	n = collect_events(group_leader, perf_max_events - n0,
-			   &cpuc->event[n0], &cpuc->events[n0],
-			   &cpuc->current_idx[n0]);
-	if (n < 0)
-		return -EAGAIN;
-	if (check_excludes(cpuc->event, n0, n))
-		return -EINVAL;
-	if (sparc_check_constraints(cpuc->event, cpuc->events, n + n0))
-		return -EAGAIN;
-	cpuc->n_events = n0 + n;
-	cpuc->n_added += n;
-
-	cpuctx->active_oncpu += n;
-	n = 1;
-	event_sched_in(group_leader);
-	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub);
-			n++;
-		}
-	}
-	ctx->nr_active += n;
-
-	return 1;
-}
-
 static int sparc_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1044,11 +999,20 @@ static int sparc_pmu_enable(struct perf_event *event)
 	cpuc->events[n0] = event->hw.event_base;
 	cpuc->current_idx[n0] = PIC_NO_INDEX;
 
+	/*
+	 * If group events scheduling transaction was started,
+	 * skip the schedulability test here, it will be peformed
+	 * at commit time(->commit_txn) as a whole
+	 */
+	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+		goto nocheck;
+
 	if (check_excludes(cpuc->event, n0, 1))
 		goto out;
 	if (sparc_check_constraints(cpuc->event, cpuc->events, n0 + 1))
 		goto out;
 
+nocheck:
 	cpuc->n_events++;
 	cpuc->n_added++;
 
@@ -1128,11 +1092,61 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * Start group events scheduling transaction
+ * Set the flag to make pmu::enable() not perform the
+ * schedulability test, it will be performed at commit time
+ */
+static void sparc_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Stop group events scheduling transaction
+ * Clear the flag and pmu::enable() will perform the
+ * schedulability test.
+ */
+static void sparc_pmu_cancel_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Commit group events scheduling transaction
+ * Perform the group schedulability test as a whole
+ * Return 0 if success
+ */
+static int sparc_pmu_commit_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int n;
+
+	if (!sparc_pmu)
+		return -EINVAL;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+	n = cpuc->n_events;
+	if (check_excludes(cpuc->event, 0, n))
+		return -EINVAL;
+	if (sparc_check_constraints(cpuc->event, cpuc->events, n))
+		return -EAGAIN;
+
+	return 0;
+}
+
 static const struct pmu pmu = {
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
 	.unthrottle	= sparc_pmu_unthrottle,
+	.start_txn	= sparc_pmu_start_txn,
+	.cancel_txn	= sparc_pmu_cancel_txn,
+	.commit_txn	= sparc_pmu_commit_txn,
 };
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)
diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index b05400a..64a8ebf 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -89,7 +89,8 @@
 	P4_CCCR_ENABLE)
 
 /* HT mask */
-#define P4_CCCR_MASK_HT	(P4_CCCR_MASK | P4_CCCR_THREAD_ANY)
+#define P4_CCCR_MASK_HT				\
+	(P4_CCCR_MASK | P4_CCCR_OVF_PMI_T1 | P4_CCCR_THREAD_ANY)
 
 #define P4_GEN_ESCR_EMASK(class, name, bit)	\
 	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 424fc8d..ae85d69 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -465,15 +465,21 @@ out:
 	return rc;
 }
 
-static inline void p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
+static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 {
-	unsigned long dummy;
+	int overflow = 0;
+	u32 low, high;
 
-	rdmsrl(hwc->config_base + hwc->idx, dummy);
-	if (dummy & P4_CCCR_OVF) {
+	rdmsr(hwc->config_base + hwc->idx, low, high);
+
+	/* we need to check high bit for unflagged overflows */
+	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
+		overflow = 1;
 		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
-			((u64)dummy) & ~P4_CCCR_OVF);
+			((u64)low) & ~P4_CCCR_OVF);
 	}
+
+	return overflow;
 }
 
 static inline void p4_pmu_disable_event(struct perf_event *event)
@@ -584,21 +590,15 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 
 		WARN_ON_ONCE(hwc->idx != idx);
 
-		/*
-		 * FIXME: Redundant call, actually not needed
-		 * but just to check if we're screwed
-		 */
-		p4_pmu_clear_cccr_ovf(hwc);
+		/* it might be unflagged overflow */
+		handled = p4_pmu_clear_cccr_ovf(hwc);
 
 		val = x86_perf_event_update(event);
-		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
+		if (!handled && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
 			continue;
 
-		/*
-		 * event overflow
-		 */
-		handled		= 1;
-		data.period	= event->hw.last_period;
+		/* event overflow for sure */
+		data.period = event->hw.last_period;
 
 		if (!x86_perf_event_set_period(event))
 			continue;
@@ -670,7 +670,7 @@ static void p4_pmu_swap_config_ts(struct hw_perf_event *hwc, int cpu)
 
 /*
  * ESCR address hashing is tricky, ESCRs are not sequential
- * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03e0) and
+ * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03a0) and
  * the metric between any ESCRs is laid in range [0xa0,0xe1]
  *
  * so we make ~70% filled hashtable
@@ -735,8 +735,9 @@ static int p4_get_escr_idx(unsigned int addr)
 {
 	unsigned int idx = P4_ESCR_MSR_IDX(addr);
 
-	if (unlikely(idx >= P4_ESCR_MSR_TABLE_SIZE ||
-			!p4_escr_table[idx])) {
+	if (unlikely(idx >= P4_ESCR_MSR_TABLE_SIZE	||
+			!p4_escr_table[idx]		||
+			p4_escr_table[idx] != addr)) {
 		WARN_ONCE(1, "P4 PMU: Wrong address passed: %x\n", addr);
 		return -1;
 	}
@@ -762,7 +763,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index df3d5c8..308e325 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -34,7 +34,7 @@
 /* IA32 Manual 3, 2-1 */
 static unsigned char prefix_codes[] = {
 	0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64,
-	0x65, 0x2E, 0x3E, 0x66, 0x67
+	0x65, 0x66, 0x67
 };
 /* IA32 Manual 3, 3-432*/
 static unsigned int reg_rop[] = {
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 39e71b0..ee8a841 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -70,18 +70,25 @@ struct trace_iterator {
 };
 
 
+struct trace_event;
+
 typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
-					      int flags);
-struct trace_event {
-	struct hlist_node	node;
-	struct list_head	list;
-	int			type;
+				      int flags, struct trace_event *event);
+
+struct trace_event_functions {
 	trace_print_func	trace;
 	trace_print_func	raw;
 	trace_print_func	hex;
 	trace_print_func	binary;
 };
 
+struct trace_event {
+	struct hlist_node		node;
+	struct list_head		list;
+	int				type;
+	struct trace_event_functions	*funcs;
+};
+
 extern int register_ftrace_event(struct trace_event *event);
 extern int unregister_ftrace_event(struct trace_event *event);
 
@@ -113,28 +120,70 @@ void tracing_record_cmdline(struct task_struct *tsk);
 
 struct event_filter;
 
+enum trace_reg {
+	TRACE_REG_REGISTER,
+	TRACE_REG_UNREGISTER,
+	TRACE_REG_PERF_REGISTER,
+	TRACE_REG_PERF_UNREGISTER,
+};
+
+struct ftrace_event_call;
+
+struct ftrace_event_class {
+	char			*system;
+	void			*probe;
+#ifdef CONFIG_PERF_EVENTS
+	void			*perf_probe;
+#endif
+	int			(*reg)(struct ftrace_event_call *event,
+				       enum trace_reg type);
+	int			(*define_fields)(struct ftrace_event_call *);
+	struct list_head	*(*get_fields)(struct ftrace_event_call *);
+	struct list_head	fields;
+	int			(*raw_init)(struct ftrace_event_call *);
+};
+
+enum {
+	TRACE_EVENT_FL_ENABLED_BIT,
+	TRACE_EVENT_FL_FILTERED_BIT,
+};
+
+enum {
+	TRACE_EVENT_FL_ENABLED	= (1 << TRACE_EVENT_FL_ENABLED_BIT),
+	TRACE_EVENT_FL_FILTERED	= (1 << TRACE_EVENT_FL_FILTERED_BIT),
+};
+
 struct ftrace_event_call {
 	struct list_head	list;
+	struct ftrace_event_class *class;
 	char			*name;
-	char			*system;
 	struct dentry		*dir;
-	struct trace_event	*event;
-	int			enabled;
-	int			(*regfunc)(struct ftrace_event_call *);
-	void			(*unregfunc)(struct ftrace_event_call *);
-	int			id;
+	struct trace_event	event;
 	const char		*print_fmt;
-	int			(*raw_init)(struct ftrace_event_call *);
-	int			(*define_fields)(struct ftrace_event_call *);
-	struct list_head	fields;
-	int			filter_active;
 	struct event_filter	*filter;
 	void			*mod;
 	void			*data;
 
+	/*
+	 * 32 bit flags:
+	 *   bit 1:		enabled
+	 *   bit 2:		filter_active
+	 *
+	 * Changes to flags must hold the event_mutex.
+	 *
+	 * Note: Reads of flags do not hold the event_mutex since
+	 * they occur in critical sections. But the way flags
+	 * is currently used, these changes do no affect the code
+	 * except that when a change is made, it may have a slight
+	 * delay in propagating the changes to other CPUs due to
+	 * caching and such.
+	 */
+	unsigned int		flags;
+
+#ifdef CONFIG_PERF_EVENTS
 	int			perf_refcount;
-	int			(*perf_event_enable)(struct ftrace_event_call *);
-	void			(*perf_event_disable)(struct ftrace_event_call *);
+	struct hlist_head	*perf_events;
+#endif
 };
 
 #define PERF_MAX_TRACE_SIZE	2048
@@ -191,24 +240,22 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int perf_trace_enable(int event_id);
-extern void perf_trace_disable(int event_id);
-extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
+extern int  perf_trace_init(struct perf_event *event);
+extern void perf_trace_destroy(struct perf_event *event);
+extern int  perf_trace_enable(struct perf_event *event);
+extern void perf_trace_disable(struct perf_event *event);
+extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
-extern void *
-perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
-			 unsigned long *irq_flags);
+extern void *perf_trace_buf_prepare(int size, unsigned short type,
+				    struct pt_regs *regs, int *rctxp);
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
+		       u64 count, struct pt_regs *regs, void *head)
 {
-	struct trace_entry *entry = raw_data;
-
-	perf_tp_event(entry->type, addr, count, raw_data, size, regs);
+	perf_tp_event(addr, count, raw_data, size, regs, head);
 	perf_swevent_put_recursion_context(rctx);
-	local_irq_restore(irq_flags);
 }
 #endif
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3fd5c82..fb6c91e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -485,6 +485,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <asm/atomic.h>
+#include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
 
@@ -587,21 +588,19 @@ struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
+	int				page_order;	/* allocation order  */
 #endif
-	int				data_order;
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
-	atomic_t			events;		/* event_id limit       */
 
-	atomic_long_t			head;		/* write position    */
-	atomic_long_t			done_head;	/* completed head    */
-
-	atomic_t			lock;		/* concurrent writes */
-	atomic_t			wakeup;		/* needs a wakeup    */
-	atomic_t			lost;		/* nr records lost   */
+	local_t				head;		/* write position    */
+	local_t				nest;		/* nested writers    */
+	local_t				events;		/* event limit       */
+	local_t				wakeup;		/* wakeup stamp      */
+	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
 
@@ -728,6 +727,7 @@ struct perf_event {
 	perf_overflow_handler_t		overflow_handler;
 
 #ifdef CONFIG_EVENT_TRACING
+	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
 #endif
 
@@ -803,11 +803,12 @@ struct perf_cpu_context {
 struct perf_output_handle {
 	struct perf_event		*event;
 	struct perf_mmap_data		*data;
-	unsigned long			head;
-	unsigned long			offset;
+	unsigned long			wakeup;
+	unsigned long			size;
+	void				*addr;
+	int				page;
 	int				nmi;
 	int				sample;
-	int				locked;
 };
 
 #ifdef CONFIG_PERF_EVENTS
@@ -993,8 +994,9 @@ static inline bool perf_paranoid_kernel(void)
 }
 
 extern void perf_event_init(void);
-extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-			  int entry_size, struct pt_regs *regs);
+extern void perf_tp_event(u64 addr, u64 count, void *record,
+			  int entry_size, struct pt_regs *regs,
+			  struct hlist_head *head);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 057929b..a1a86a5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -103,22 +103,6 @@ struct perf_event_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#ifdef CONFIG_PERF_EVENTS
-
-#define TRACE_SYS_ENTER_PERF_INIT(sname)				       \
-	.perf_event_enable = perf_sysenter_enable,			       \
-	.perf_event_disable = perf_sysenter_disable,
-
-#define TRACE_SYS_EXIT_PERF_INIT(sname)					       \
-	.perf_event_enable = perf_sysexit_enable,			       \
-	.perf_event_disable = perf_sysexit_disable,
-#else
-#define TRACE_SYS_ENTER_PERF(sname)
-#define TRACE_SYS_ENTER_PERF_INIT(sname)
-#define TRACE_SYS_EXIT_PERF(sname)
-#define TRACE_SYS_EXIT_PERF_INIT(sname)
-#endif /* CONFIG_PERF_EVENTS */
-
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
@@ -134,54 +118,43 @@ struct perf_event_attr;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
+extern struct ftrace_event_class event_class_syscall_enter;
+extern struct ftrace_event_class event_class_syscall_exit;
+extern struct trace_event_functions enter_syscall_print_funcs;
+extern struct trace_event_functions exit_syscall_print_funcs;
+
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static const struct syscall_metadata __syscall_meta_##sname;	\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
-	static struct trace_event enter_syscall_print_##sname = {	\
-		.trace                  = print_syscall_enter,		\
-	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
-		.system                 = "syscalls",			\
-		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
-		.define_fields		= syscall_enter_define_fields,	\
-		.regfunc		= reg_event_syscall_enter,	\
-		.unregfunc		= unreg_event_syscall_enter,	\
+		.class			= &event_class_syscall_enter,	\
+		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_ENTER_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static const struct syscall_metadata __syscall_meta_##sname;	\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
-	static struct trace_event exit_syscall_print_##sname = {	\
-		.trace                  = print_syscall_exit,		\
-	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
-		.system                 = "syscalls",			\
-		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
-		.define_fields		= syscall_exit_define_fields,	\
-		.regfunc		= reg_event_syscall_exit,	\
-		.unregfunc		= unreg_event_syscall_exit,	\
+		.class			= &event_class_syscall_exit,	\
+		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_EXIT_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
-	static const struct syscall_metadata __used		\
+	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
@@ -191,12 +164,14 @@ struct perf_event_attr;
 		.args		= args_##sname,			\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
+		.exit_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.exit_fields), \
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
-	static const struct syscall_metadata __used		\
+	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
@@ -204,6 +179,8 @@ struct perf_event_attr;
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
+		.exit_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.exit_fields), \
 	};							\
 	asmlinkage long sys_##sname(void)
 #else
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 1d85f9a..9a59d1f 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -20,12 +20,17 @@
 struct module;
 struct tracepoint;
 
+struct tracepoint_func {
+	void *func;
+	void *data;
+};
+
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	int state;			/* State. */
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
-	void **funcs;
+	struct tracepoint_func *funcs;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
 					 * globally visible and gcc happily
@@ -37,16 +42,19 @@ struct tracepoint {
  * Connect a probe to a tracepoint.
  * Internal API, should not be used directly.
  */
-extern int tracepoint_probe_register(const char *name, void *probe);
+extern int tracepoint_probe_register(const char *name, void *probe, void *data);
 
 /*
  * Disconnect a probe from a tracepoint.
  * Internal API, should not be used directly.
  */
-extern int tracepoint_probe_unregister(const char *name, void *probe);
+extern int
+tracepoint_probe_unregister(const char *name, void *probe, void *data);
 
-extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
-extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
+extern int tracepoint_probe_register_noupdate(const char *name, void *probe,
+					      void *data);
+extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
+						void *data);
 extern void tracepoint_probe_update_all(void);
 
 struct tracepoint_iter {
@@ -102,17 +110,27 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 /*
  * it_func[0] is never NULL because there is at least one element in the array
  * when the array itself is non NULL.
+ *
+ * Note, the proto and args passed in includes "__data" as the first parameter.
+ * The reason for this is to handle the "void" prototype. If a tracepoint
+ * has a "void" prototype, then it is invalid to declare a function
+ * as "(void *, void)". The DECLARE_TRACE_NOARGS() will pass in just
+ * "void *data", where as the DECLARE_TRACE() will pass in "void *data, proto".
  */
 #define __DO_TRACE(tp, proto, args)					\
 	do {								\
-		void **it_func;						\
+		struct tracepoint_func *it_func_ptr;			\
+		void *it_func;						\
+		void *__data;						\
 									\
 		rcu_read_lock_sched_notrace();				\
-		it_func = rcu_dereference_sched((tp)->funcs);		\
-		if (it_func) {						\
+		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
+		if (it_func_ptr) {					\
 			do {						\
-				((void(*)(proto))(*it_func))(args);	\
-			} while (*(++it_func));				\
+				it_func = (it_func_ptr)->func;		\
+				__data = (it_func_ptr)->data;		\
+				((void(*)(proto))(it_func))(args);	\
+			} while ((++it_func_ptr)->func);		\
 		}							\
 		rcu_read_unlock_sched_notrace();			\
 	} while (0)
@@ -122,24 +140,32 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DECLARE_TRACE(name, proto, args)				\
+#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
 		if (unlikely(__tracepoint_##name.state))		\
 			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args));			\
+	}								\
+	static inline int						\
+	register_trace_##name(void (*probe)(data_proto), void *data)	\
+	{								\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 data);			\
 	}								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
+		return tracepoint_probe_unregister(#name, (void *)probe, \
+						   data);		\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline void						\
+	check_trace_callback_type_##name(void (*cb)(data_proto))	\
 	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
-
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -156,18 +182,23 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
-	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
-	{ }								\
+#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
 	static inline void trace_##name(proto)				\
 	{ }								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	register_trace_##name(void (*probe)(data_proto),		\
+			      void *data)				\
 	{								\
 		return -ENOSYS;						\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(data_proto),		\
+				void *data)				\
 	{								\
 		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
+	{								\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
@@ -176,6 +207,29 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
 #endif /* CONFIG_TRACEPOINTS */
+
+/*
+ * The need for the DECLARE_TRACE_NOARGS() is to handle the prototype
+ * (void). "void" is a special value in a function prototype and can
+ * not be combined with other arguments. Since the DECLARE_TRACE()
+ * macro adds a data element at the beginning of the prototype,
+ * we need a way to differentiate "(void *data, proto)" from
+ * "(void *data, void)". The second prototype is invalid.
+ *
+ * DECLARE_TRACE_NOARGS() passes "void" as the tracepoint prototype
+ * and "void *__data" as the callback prototype.
+ *
+ * DECLARE_TRACE() passes "proto" as the tracepoint protoype and
+ * "void *__data, proto" as the callback prototype.
+ */
+#define DECLARE_TRACE_NOARGS(name)					\
+		__DECLARE_TRACE(name, void, , void *__data, __data)
+
+#define DECLARE_TRACE(name, proto, args)				\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
+				PARAMS(void *__data, proto),		\
+				PARAMS(__data, args))
+
 #endif /* DECLARE_TRACE */
 
 #ifndef TRACE_EVENT
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 16253db..0152b86 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -62,7 +62,10 @@
 		struct trace_entry	ent;				\
 		tstruct							\
 		char			__data[0];			\
-	};
+	};								\
+									\
+	static struct ftrace_event_class event_class_##name;
+
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call			\
@@ -147,7 +150,7 @@
  *
  *	entry = iter->ent;
  *
- *	if (entry->type != event_<call>.id) {
+ *	if (entry->type != event_<call>->event.type) {
  *		WARN_ON_ONCE(1);
  *		return TRACE_TYPE_UNHANDLED;
  *	}
@@ -203,18 +206,22 @@
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace enum print_line_t					\
-ftrace_raw_output_id_##call(int event_id, const char *name,		\
-			    struct trace_iterator *iter, int flags)	\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
+			 struct trace_event *trace_event)		\
 {									\
+	struct ftrace_event_call *event;				\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p;						\
 	int ret;							\
 									\
+	event = container_of(trace_event, struct ftrace_event_call,	\
+			     event);					\
+									\
 	entry = iter->ent;						\
 									\
-	if (entry->type != event_id) {					\
+	if (entry->type != event->event.type) {				\
 		WARN_ON_ONCE(1);					\
 		return TRACE_TYPE_UNHANDLED;				\
 	}								\
@@ -223,7 +230,7 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 									\
 	p = &get_cpu_var(ftrace_event_seq);				\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", name);			\
+	ret = trace_seq_printf(s, "%s: ", event->name);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
 	put_cpu();							\
@@ -231,21 +238,16 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
 	return TRACE_TYPE_HANDLED;					\
-}
-
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)			\
-static notrace enum print_line_t					\
-ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
-{									\
-	return ftrace_raw_output_id_##template(event_##name.id,		\
-					       #name, iter, flags);	\
-}
+}									\
+static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
+	.trace			= ftrace_raw_output_##call,		\
+};
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 static notrace enum print_line_t					\
-ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
+			 struct trace_event *event)			\
 {									\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
@@ -255,7 +257,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	entry = iter->ent;						\
 									\
-	if (entry->type != event_##call.id) {				\
+	if (entry->type != event_##call.event.type) {			\
 		WARN_ON_ONCE(1);					\
 		return TRACE_TYPE_UNHANDLED;				\
 	}								\
@@ -272,7 +274,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
 	return TRACE_TYPE_HANDLED;					\
-}
+}									\
+static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
+	.trace			= ftrace_raw_output_##call,		\
+};
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -378,80 +383,18 @@ static inline notrace int ftrace_get_offsets_##call(			\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#ifdef CONFIG_PERF_EVENTS
-
-/*
- * Generate the functions needed for tracepoint perf_event support.
- *
- * NOTE: The insertion profile callback (ftrace_profile_<call>) is defined later
- *
- * static int ftrace_profile_enable_<call>(void)
- * {
- * 	return register_trace_<call>(ftrace_profile_<call>);
- * }
- *
- * static void ftrace_profile_disable_<call>(void)
- * {
- * 	unregister_trace_<call>(ftrace_profile_<call>);
- * }
- *
- */
-
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
-
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)			\
-									\
-static void perf_trace_##name(proto);					\
-									\
-static notrace int							\
-perf_trace_enable_##name(struct ftrace_event_call *unused)		\
-{									\
-	return register_trace_##name(perf_trace_##name);		\
-}									\
-									\
-static notrace void							\
-perf_trace_disable_##name(struct ftrace_event_call *unused)		\
-{									\
-	unregister_trace_##name(perf_trace_##name);			\
-}
-
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
-
-#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-
-#endif /* CONFIG_PERF_EVENTS */
-
 /*
  * Stage 4 of the trace events.
  *
  * Override the macros in <trace/trace_events.h> to include the following:
  *
- * static void ftrace_event_<call>(proto)
- * {
- *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
- * }
- *
- * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	return register_trace_<call>(ftrace_event_<call>);
- * }
- *
- * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	unregister_trace_<call>(ftrace_event_<call>);
- * }
- *
- *
  * For those macros defined with TRACE_EVENT:
  *
  * static struct ftrace_event_call event_<call>;
  *
- * static void ftrace_raw_event_<call>(proto)
+ * static void ftrace_raw_event_<call>(void *__data, proto)
  * {
+ *	struct ftrace_event_call *event_call = __data;
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
@@ -466,7 +409,7 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
  *
  *	event = trace_current_buffer_lock_reserve(&buffer,
- *				  event_<call>.id,
+ *				  event_<call>->event.type,
  *				  sizeof(*entry) + __data_size,
  *				  irq_flags, pc);
  *	if (!event)
@@ -481,43 +424,42 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *						   event, irq_flags, pc);
  * }
  *
- * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	return register_trace_<call>(ftrace_raw_event_<call>);
- * }
- *
- * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	unregister_trace_<call>(ftrace_raw_event_<call>);
- * }
- *
  * static struct trace_event ftrace_event_type_<call> = {
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
  * static const char print_fmt_<call>[] = <TP_printk>;
  *
+ * static struct ftrace_event_class __used event_class_<template> = {
+ *	.system			= "<system>",
+ *	.define_fields		= ftrace_define_fields_<call>,
+ *	.fields			= LIST_HEAD_INIT(event_class_##call.fields),
+ *	.raw_init		= trace_event_raw_init,
+ *	.probe			= ftrace_raw_event_##call,
+ * };
+ *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
- *	.system			= "<system>",
- *	.raw_init		= trace_event_raw_init,
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.class			= event_class_<template>,
+ *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
- *	.define_fields		= ftrace_define_fields_<call>,
- * }
+ * };
  *
  */
 
 #ifdef CONFIG_PERF_EVENTS
 
+#define _TRACE_PERF_PROTO(call, proto)					\
+	static notrace void						\
+	perf_trace_##call(void *__data, proto);
+
 #define _TRACE_PERF_INIT(call)						\
-	.perf_event_enable = perf_trace_enable_##call,			\
-	.perf_event_disable = perf_trace_disable_##call,
+	.perf_probe		= perf_trace_##call,
 
 #else
+#define _TRACE_PERF_PROTO(call, proto)
 #define _TRACE_PERF_INIT(call)
 #endif /* CONFIG_PERF_EVENTS */
 
@@ -551,9 +493,9 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
 static notrace void							\
-ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
-				       proto)				\
+ftrace_raw_event_##call(void *__data, proto)				\
 {									\
+	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
@@ -568,7 +510,7 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
 	event = trace_current_buffer_lock_reserve(&buffer,		\
-				 event_call->id,			\
+				 event_call->event.type,		\
 				 sizeof(*entry) + __data_size,		\
 				 irq_flags, pc);			\
 	if (!event)							\
@@ -583,34 +525,21 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 		trace_nowake_buffer_unlock_commit(buffer,		\
 						  event, irq_flags, pc); \
 }
+/*
+ * The ftrace_test_probe is compiled out, it is only here as a build time check
+ * to make sure that if the tracepoint handling changes, the ftrace probe will
+ * fail to compile unless it too is updated.
+ */
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
-									\
-static notrace void ftrace_raw_event_##call(proto)			\
-{									\
-	ftrace_raw_event_id_##template(&event_##call, args);		\
-}									\
-									\
-static notrace int							\
-ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)		\
+static inline void ftrace_test_probe_##call(void)			\
 {									\
-	return register_trace_##call(ftrace_raw_event_##call);		\
-}									\
-									\
-static notrace void							\
-ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)		\
-{									\
-	unregister_trace_##call(ftrace_raw_event_##call);		\
-}									\
-									\
-static struct trace_event ftrace_event_type_##call = {			\
-	.trace			= ftrace_raw_output_##call,		\
-};
+	check_trace_callback_type_##call(ftrace_raw_event_##template);	\
+}
 
 #undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -627,7 +556,16 @@ static struct trace_event ftrace_event_type_##call = {			\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static const char print_fmt_##call[] = print;
+_TRACE_PERF_PROTO(call, PARAMS(proto));					\
+static const char print_fmt_##call[] = print;				\
+static struct ftrace_event_class __used event_class_##call = {		\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.define_fields		= ftrace_define_fields_##call,		\
+	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
+	.raw_init		= trace_event_raw_init,			\
+	.probe			= ftrace_raw_event_##call,		\
+	_TRACE_PERF_INIT(call)						\
+};
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -636,15 +574,10 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= trace_event_raw_init,			\
-	.regfunc		= ftrace_raw_reg_event_##call,		\
-	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.class			= &event_class_##template,		\
+	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
-	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PERF_INIT(call)					\
-}
+};
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
@@ -655,14 +588,9 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= trace_event_raw_init,			\
-	.regfunc		= ftrace_raw_reg_event_##call,		\
-	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.class			= &event_class_##template,		\
+	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
-	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PERF_INIT(call)					\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
@@ -762,17 +690,20 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
-perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
-			struct pt_regs *__regs, proto)			\
+perf_trace_##call(void *__data, proto)					\
 {									\
+	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
+	struct pt_regs __regs;						\
 	u64 __addr = 0, __count = 1;					\
-	unsigned long irq_flags;					\
+	struct hlist_head *head;					\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
 									\
+	perf_fetch_caller_regs(&__regs, 1);				\
+									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
@@ -781,32 +712,34 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
 		      "profile buffer not large enough"))		\
 		return;							\
+									\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->id, &rctx, &irq_flags);	\
+		__entry_size, event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
 		return;							\
+									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
+	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags, __regs);		\
+		__count, &__regs, head);				\
 }
 
+/*
+ * This part is compiled out, it is only here as a build time check
+ * to make sure that if the tracepoint handling changes, the
+ * perf probe will fail to compile unless it too is updated.
+ */
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
-static notrace void perf_trace_##call(proto)				\
+static inline void perf_test_probe_##call(void)				\
 {									\
-	struct ftrace_event_call *event_call = &event_##call;		\
-	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
-									\
-	perf_fetch_caller_regs(__regs, 1);				\
-									\
-	perf_trace_templ_##template(event_call, __regs, args);		\
-									\
-	put_cpu_var(perf_trace_regs);					\
+	check_trace_callback_type_##call(perf_trace_##template);	\
 }
 
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index e5e5f48..257e089 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -25,6 +25,8 @@ struct syscall_metadata {
 	int		nb_args;
 	const char	**types;
 	const char	**args;
+	struct list_head enter_fields;
+	struct list_head exit_fields;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
@@ -34,16 +36,16 @@ struct syscall_metadata {
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
-extern int syscall_enter_define_fields(struct ftrace_event_call *call);
-extern int syscall_exit_define_fields(struct ftrace_event_call *call);
 extern int reg_event_syscall_enter(struct ftrace_event_call *call);
 extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
 extern int reg_event_syscall_exit(struct ftrace_event_call *call);
 extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
 extern int
 ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
-enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
-enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
+enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
+				      struct trace_event *event);
+enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
+				     struct trace_event *event);
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..e099650 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2297,11 +2297,6 @@ unlock:
 	rcu_read_unlock();
 }
 
-static unsigned long perf_data_size(struct perf_mmap_data *data)
-{
-	return data->nr_pages << (PAGE_SHIFT + data->data_order);
-}
-
 #ifndef CONFIG_PERF_USE_VMALLOC
 
 /*
@@ -2320,6 +2315,19 @@ perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
 	return virt_to_page(data->data_pages[pgoff - 1]);
 }
 
+static void *perf_mmap_alloc_page(int cpu)
+{
+	struct page *page;
+	int node;
+
+	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct perf_mmap_data *
 perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 {
@@ -2336,17 +2344,16 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	if (!data)
 		goto fail;
 
-	data->user_page = (void *)get_zeroed_page(GFP_KERNEL);
+	data->user_page = perf_mmap_alloc_page(event->cpu);
 	if (!data->user_page)
 		goto fail_user_page;
 
 	for (i = 0; i < nr_pages; i++) {
-		data->data_pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		data->data_pages[i] = perf_mmap_alloc_page(event->cpu);
 		if (!data->data_pages[i])
 			goto fail_data_pages;
 	}
 
-	data->data_order = 0;
 	data->nr_pages = nr_pages;
 
 	return data;
@@ -2382,6 +2389,11 @@ static void perf_mmap_data_free(struct perf_mmap_data *data)
 	kfree(data);
 }
 
+static inline int page_order(struct perf_mmap_data *data)
+{
+	return 0;
+}
+
 #else
 
 /*
@@ -2390,10 +2402,15 @@ static void perf_mmap_data_free(struct perf_mmap_data *data)
  * Required for architectures that have d-cache aliasing issues.
  */
 
+static inline int page_order(struct perf_mmap_data *data)
+{
+	return data->page_order;
+}
+
 static struct page *
 perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
 {
-	if (pgoff > (1UL << data->data_order))
+	if (pgoff > (1UL << page_order(data)))
 		return NULL;
 
 	return vmalloc_to_page((void *)data->user_page + pgoff * PAGE_SIZE);
@@ -2413,7 +2430,7 @@ static void perf_mmap_data_free_work(struct work_struct *work)
 	int i, nr;
 
 	data = container_of(work, struct perf_mmap_data, work);
-	nr = 1 << data->data_order;
+	nr = 1 << page_order(data);
 
 	base = data->user_page;
 	for (i = 0; i < nr + 1; i++)
@@ -2452,7 +2469,7 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 
 	data->user_page = all_buf;
 	data->data_pages[0] = all_buf + PAGE_SIZE;
-	data->data_order = ilog2(nr_pages);
+	data->page_order = ilog2(nr_pages);
 	data->nr_pages = 1;
 
 	return data;
@@ -2466,6 +2483,11 @@ fail:
 
 #endif
 
+static unsigned long perf_data_size(struct perf_mmap_data *data)
+{
+	return data->nr_pages << (PAGE_SHIFT + page_order(data));
+}
+
 static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
@@ -2506,8 +2528,6 @@ perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
 {
 	long max_size = perf_data_size(data);
 
-	atomic_set(&data->lock, -1);
-
 	if (event->attr.watermark) {
 		data->watermark = min_t(long, max_size,
 					event->attr.wakeup_watermark);
@@ -2580,6 +2600,14 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	long user_extra, extra;
 	int ret = 0;
 
+	/*
+	 * Don't allow mmap() of inherited per-task counters. This would
+	 * create a performance issue due to all children writing to the
+	 * same buffer.
+	 */
+	if (event->cpu == -1 && event->attr.inherit)
+		return -EINVAL;
+
 	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
@@ -2885,120 +2913,80 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
 }
 
 /*
- * Curious locking construct.
- *
  * We need to ensure a later event_id doesn't publish a head when a former
- * event_id isn't done writing. However since we need to deal with NMIs we
+ * event isn't done writing. However since we need to deal with NMIs we
  * cannot fully serialize things.
  *
- * What we do is serialize between CPUs so we only have to deal with NMI
- * nesting on a single CPU.
- *
  * We only publish the head (and generate a wakeup) when the outer-most
- * event_id completes.
+ * event completes.
  */
-static void perf_output_lock(struct perf_output_handle *handle)
+static void perf_output_get_handle(struct perf_output_handle *handle)
 {
 	struct perf_mmap_data *data = handle->data;
-	int cur, cpu = get_cpu();
-
-	handle->locked = 0;
-
-	for (;;) {
-		cur = atomic_cmpxchg(&data->lock, -1, cpu);
-		if (cur == -1) {
-			handle->locked = 1;
-			break;
-		}
-		if (cur == cpu)
-			break;
 
-		cpu_relax();
-	}
+	preempt_disable();
+	local_inc(&data->nest);
+	handle->wakeup = local_read(&data->wakeup);
 }
 
-static void perf_output_unlock(struct perf_output_handle *handle)
+static void perf_output_put_handle(struct perf_output_handle *handle)
 {
 	struct perf_mmap_data *data = handle->data;
 	unsigned long head;
-	int cpu;
-
-	data->done_head = data->head;
-
-	if (!handle->locked)
-		goto out;
 
 again:
-	/*
-	 * The xchg implies a full barrier that ensures all writes are done
-	 * before we publish the new head, matched by a rmb() in userspace when
-	 * reading this position.
-	 */
-	while ((head = atomic_long_xchg(&data->done_head, 0)))
-		data->user_page->data_head = head;
+	head = local_read(&data->head);
 
 	/*
-	 * NMI can happen here, which means we can miss a done_head update.
+	 * IRQ/NMI can happen here, which means we can miss a head update.
 	 */
 
-	cpu = atomic_xchg(&data->lock, -1);
-	WARN_ON_ONCE(cpu != smp_processor_id());
+	if (!local_dec_and_test(&data->nest))
+		goto out;
 
 	/*
-	 * Therefore we have to validate we did not indeed do so.
+	 * Publish the known good head. Rely on the full barrier implied
+	 * by atomic_dec_and_test() order the data->head read and this
+	 * write.
 	 */
-	if (unlikely(atomic_long_read(&data->done_head))) {
-		/*
-		 * Since we had it locked, we can lock it again.
-		 */
-		while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
-			cpu_relax();
+	data->user_page->data_head = head;
 
+	/*
+	 * Now check if we missed an update, rely on the (compiler)
+	 * barrier in atomic_dec_and_test() to re-read data->head.
+	 */
+	if (unlikely(head != local_read(&data->head))) {
+		local_inc(&data->nest);
 		goto again;
 	}
 
-	if (atomic_xchg(&data->wakeup, 0))
+	if (handle->wakeup != local_read(&data->wakeup))
 		perf_output_wakeup(handle);
-out:
-	put_cpu();
+
+ out:
+	preempt_enable();
 }
 
-void perf_output_copy(struct perf_output_handle *handle,
+__always_inline void perf_output_copy(struct perf_output_handle *handle,
 		      const void *buf, unsigned int len)
 {
-	unsigned int pages_mask;
-	unsigned long offset;
-	unsigned int size;
-	void **pages;
-
-	offset		= handle->offset;
-	pages_mask	= handle->data->nr_pages - 1;
-	pages		= handle->data->data_pages;
-
 	do {
-		unsigned long page_offset;
-		unsigned long page_size;
-		int nr;
+		unsigned long size = min_t(unsigned long, handle->size, len);
 
-		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
-		page_size   = 1UL << (handle->data->data_order + PAGE_SHIFT);
-		page_offset = offset & (page_size - 1);
-		size	    = min_t(unsigned int, page_size - page_offset, len);
+		memcpy(handle->addr, buf, size);
 
-		memcpy(pages[nr] + page_offset, buf, size);
+		len -= size;
+		handle->addr += size;
+		handle->size -= size;
+		if (!handle->size) {
+			struct perf_mmap_data *data = handle->data;
 
-		len	    -= size;
-		buf	    += size;
-		offset	    += size;
+			handle->page++;
+			handle->page &= data->nr_pages - 1;
+			handle->addr = data->data_pages[handle->page];
+			handle->size = PAGE_SIZE << page_order(data);
+		}
 	} while (len);
-
-	handle->offset = offset;
-
-	/*
-	 * Check we didn't copy past our reservation window, taking the
-	 * possible unsigned int wrap into account.
-	 */
-	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
 }
 
 int perf_output_begin(struct perf_output_handle *handle,
@@ -3036,13 +3024,13 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->sample	= sample;
 
 	if (!data->nr_pages)
-		goto fail;
+		goto out;
 
-	have_lost = atomic_read(&data->lost);
+	have_lost = local_read(&data->lost);
 	if (have_lost)
 		size += sizeof(lost_event);
 
-	perf_output_lock(handle);
+	perf_output_get_handle(handle);
 
 	do {
 		/*
@@ -3052,24 +3040,28 @@ int perf_output_begin(struct perf_output_handle *handle,
 		 */
 		tail = ACCESS_ONCE(data->user_page->data_tail);
 		smp_rmb();
-		offset = head = atomic_long_read(&data->head);
+		offset = head = local_read(&data->head);
 		head += size;
 		if (unlikely(!perf_output_space(data, tail, offset, head)))
 			goto fail;
-	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
+	} while (local_cmpxchg(&data->head, offset, head) != offset);
 
-	handle->offset	= offset;
-	handle->head	= head;
+	if (head - local_read(&data->wakeup) > data->watermark)
+		local_add(data->watermark, &data->wakeup);
 
-	if (head - tail > data->watermark)
-		atomic_set(&data->wakeup, 1);
+	handle->page = offset >> (PAGE_SHIFT + page_order(data));
+	handle->page &= data->nr_pages - 1;
+	handle->size = offset & ((PAGE_SIZE << page_order(data)) - 1);
+	handle->addr = data->data_pages[handle->page];
+	handle->addr += handle->size;
+	handle->size = (PAGE_SIZE << page_order(data)) - handle->size;
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
 		lost_event.header.size = sizeof(lost_event);
 		lost_event.id          = event->id;
-		lost_event.lost        = atomic_xchg(&data->lost, 0);
+		lost_event.lost        = local_xchg(&data->lost, 0);
 
 		perf_output_put(handle, lost_event);
 	}
@@ -3077,8 +3069,8 @@ int perf_output_begin(struct perf_output_handle *handle,
 	return 0;
 
 fail:
-	atomic_inc(&data->lost);
-	perf_output_unlock(handle);
+	local_inc(&data->lost);
+	perf_output_put_handle(handle);
 out:
 	rcu_read_unlock();
 
@@ -3093,14 +3085,14 @@ void perf_output_end(struct perf_output_handle *handle)
 	int wakeup_events = event->attr.wakeup_events;
 
 	if (handle->sample && wakeup_events) {
-		int events = atomic_inc_return(&data->events);
+		int events = local_inc_return(&data->events);
 		if (events >= wakeup_events) {
-			atomic_sub(wakeup_events, &data->events);
-			atomic_set(&data->wakeup, 1);
+			local_sub(wakeup_events, &data->events);
+			local_inc(&data->wakeup);
 		}
 	}
 
-	perf_output_unlock(handle);
+	perf_output_put_handle(handle);
 	rcu_read_unlock();
 }
 
@@ -3436,22 +3428,13 @@ static void perf_event_task_output(struct perf_event *event,
 {
 	struct perf_output_handle handle;
 	struct task_struct *task = task_event->task;
-	unsigned long flags;
 	int size, ret;
 
-	/*
-	 * If this CPU attempts to acquire an rq lock held by a CPU spinning
-	 * in perf_output_lock() from interrupt context, it's game over.
-	 */
-	local_irq_save(flags);
-
 	size  = task_event->event_id.header.size;
 	ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret) {
-		local_irq_restore(flags);
+	if (ret)
 		return;
-	}
 
 	task_event->event_id.pid = perf_event_pid(event, task);
 	task_event->event_id.ppid = perf_event_pid(event, current);
@@ -3462,7 +3445,6 @@ static void perf_event_task_output(struct perf_event *event,
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
-	local_irq_restore(flags);
 }
 
 static int perf_event_task_match(struct perf_event *event)
@@ -4020,9 +4002,6 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 	perf_swevent_overflow(event, 0, nmi, data, regs);
 }
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data);
-
 static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
@@ -4052,10 +4031,6 @@ static int perf_swevent_match(struct perf_event *event,
 	if (perf_exclude_event(event, regs))
 		return 0;
 
-	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
-	    !perf_tp_event_match(event, data))
-		return 0;
-
 	return 1;
 }
 
@@ -4066,19 +4041,46 @@ static inline u64 swevent_hash(u64 type, u32 event_id)
 	return hash_64(val, SWEVENT_HLIST_BITS);
 }
 
-static struct hlist_head *
-find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+static inline struct hlist_head *
+__find_swevent_head(struct swevent_hlist *hlist, u64 type, u32 event_id)
 {
-	u64 hash;
-	struct swevent_hlist *hlist;
+	u64 hash = swevent_hash(type, event_id);
+
+	return &hlist->heads[hash];
+}
 
-	hash = swevent_hash(type, event_id);
+/* For the read side: events when they trigger */
+static inline struct hlist_head *
+find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+{
+	struct swevent_hlist *hlist;
 
 	hlist = rcu_dereference(ctx->swevent_hlist);
 	if (!hlist)
 		return NULL;
 
-	return &hlist->heads[hash];
+	return __find_swevent_head(hlist, type, event_id);
+}
+
+/* For the event head insertion and removal in the hlist */
+static inline struct hlist_head *
+find_swevent_head(struct perf_cpu_context *ctx, struct perf_event *event)
+{
+	struct swevent_hlist *hlist;
+	u32 event_id = event->attr.config;
+	u64 type = event->attr.type;
+
+	/*
+	 * Event scheduling is always serialized against hlist allocation
+	 * and release. Which makes the protected version suitable here.
+	 * The context lock guarantees that.
+	 */
+	hlist = rcu_dereference_protected(ctx->swevent_hlist,
+					  lockdep_is_held(&event->ctx->lock));
+	if (!hlist)
+		return NULL;
+
+	return __find_swevent_head(hlist, type, event_id);
 }
 
 static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
@@ -4095,7 +4097,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 
 	rcu_read_lock();
 
-	head = find_swevent_head(cpuctx, type, event_id);
+	head = find_swevent_head_rcu(cpuctx, type, event_id);
 
 	if (!head)
 		goto end;
@@ -4110,7 +4112,7 @@ end:
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	int rctx;
 
 	if (in_nmi())
@@ -4122,10 +4124,8 @@ int perf_swevent_get_recursion_context(void)
 	else
 		rctx = 0;
 
-	if (cpuctx->recursion[rctx]) {
-		put_cpu_var(perf_cpu_context);
+	if (cpuctx->recursion[rctx])
 		return -1;
-	}
 
 	cpuctx->recursion[rctx]++;
 	barrier();
@@ -4139,7 +4139,6 @@ void perf_swevent_put_recursion_context(int rctx)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	barrier();
 	cpuctx->recursion[rctx]--;
-	put_cpu_var(perf_cpu_context);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
@@ -4150,6 +4149,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 	struct perf_sample_data data;
 	int rctx;
 
+	preempt_disable_notrace();
 	rctx = perf_swevent_get_recursion_context();
 	if (rctx < 0)
 		return;
@@ -4159,6 +4159,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
 
 	perf_swevent_put_recursion_context(rctx);
+	preempt_enable_notrace();
 }
 
 static void perf_swevent_read(struct perf_event *event)
@@ -4178,7 +4179,7 @@ static int perf_swevent_enable(struct perf_event *event)
 		perf_swevent_set_period(event);
 	}
 
-	head = find_swevent_head(cpuctx, event->attr.type, event->attr.config);
+	head = find_swevent_head(cpuctx, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
 
@@ -4366,6 +4367,14 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_event_read,
 };
 
+/* Deref the hlist from the update side */
+static inline struct swevent_hlist *
+swevent_hlist_deref(struct perf_cpu_context *cpuctx)
+{
+	return rcu_dereference_protected(cpuctx->swevent_hlist,
+					 lockdep_is_held(&cpuctx->hlist_mutex));
+}
+
 static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
 {
 	struct swevent_hlist *hlist;
@@ -4376,12 +4385,11 @@ static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
 
 static void swevent_hlist_release(struct perf_cpu_context *cpuctx)
 {
-	struct swevent_hlist *hlist;
+	struct swevent_hlist *hlist = swevent_hlist_deref(cpuctx);
 
-	if (!cpuctx->swevent_hlist)
+	if (!hlist)
 		return;
 
-	hlist = cpuctx->swevent_hlist;
 	rcu_assign_pointer(cpuctx->swevent_hlist, NULL);
 	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
 }
@@ -4418,7 +4426,7 @@ static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
 
 	mutex_lock(&cpuctx->hlist_mutex);
 
-	if (!cpuctx->swevent_hlist && cpu_online(cpu)) {
+	if (!swevent_hlist_deref(cpuctx) && cpu_online(cpu)) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
@@ -4467,10 +4475,46 @@ static int swevent_hlist_get(struct perf_event *event)
 
 #ifdef CONFIG_EVENT_TRACING
 
-void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-		   int entry_size, struct pt_regs *regs)
+static const struct pmu perf_ops_tracepoint = {
+	.enable		= perf_trace_enable,
+	.disable	= perf_trace_disable,
+	.read		= perf_swevent_read,
+	.unthrottle	= perf_swevent_unthrottle,
+};
+
+static int perf_tp_filter_match(struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	void *record = data->raw->data;
+
+	if (likely(!event->filter) || filter_match_preds(event->filter, record))
+		return 1;
+	return 0;
+}
+
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	/*
+	 * All tracepoints are from kernel-space.
+	 */
+	if (event->attr.exclude_kernel)
+		return 0;
+
+	if (!perf_tp_filter_match(event, data))
+		return 0;
+
+	return 1;
+}
+
+void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
+		   struct pt_regs *regs, struct hlist_head *head)
 {
 	struct perf_sample_data data;
+	struct perf_event *event;
+	struct hlist_node *node;
+
 	struct perf_raw_record raw = {
 		.size = entry_size,
 		.data = record,
@@ -4479,26 +4523,18 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 	perf_sample_data_init(&data, addr);
 	data.raw = &raw;
 
-	/* Trace events already protected against recursion */
-	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-			 &data, regs);
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
+		if (perf_tp_event_match(event, &data, regs))
+			perf_swevent_add(event, count, 1, &data, regs);
+	}
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data)
-{
-	void *record = data->raw->data;
-
-	if (likely(!event->filter) || filter_match_preds(event->filter, record))
-		return 1;
-	return 0;
-}
-
 static void tp_perf_event_destroy(struct perf_event *event)
 {
-	perf_trace_disable(event->attr.config);
-	swevent_hlist_put(event);
+	perf_trace_destroy(event);
 }
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
@@ -4514,17 +4550,13 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (perf_trace_enable(event->attr.config))
+	err = perf_trace_init(event);
+	if (err)
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
-	err = swevent_hlist_get(event);
-	if (err) {
-		perf_trace_disable(event->attr.config);
-		return ERR_PTR(err);
-	}
 
-	return &perf_ops_generic;
+	return &perf_ops_tracepoint;
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
@@ -4552,12 +4584,6 @@ static void perf_event_free_filter(struct perf_event *event)
 
 #else
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data)
-{
-	return 1;
-}
-
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
@@ -4894,6 +4920,13 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
 	int fput_needed = 0;
 	int ret = -EINVAL;
 
+	/*
+	 * Don't allow output of inherited per-task events. This would
+	 * create performance issues due to cross cpu access.
+	 */
+	if (event->cpu == -1 && event->attr.inherit)
+		return -EINVAL;
+
 	if (!output_fd)
 		goto set;
 
@@ -4914,6 +4947,18 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
 	if (event->data)
 		goto out;
 
+	/*
+	 * Don't allow cross-cpu buffers
+	 */
+	if (output_event->cpu != event->cpu)
+		goto out;
+
+	/*
+	 * If its not a per-cpu buffer, it must be the same task.
+	 */
+	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+		goto out;
+
 	atomic_long_inc(&output_file->f_count);
 
 set:
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b3bc91a..36ea2b6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -675,28 +675,33 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	}
 }
 
-static void blk_add_trace_rq_abort(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_abort(void *ignore,
+				   struct request_queue *q, struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_ABORT);
 }
 
-static void blk_add_trace_rq_insert(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_insert(void *ignore,
+				    struct request_queue *q, struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_INSERT);
 }
 
-static void blk_add_trace_rq_issue(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_issue(void *ignore,
+				   struct request_queue *q, struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
 }
 
-static void blk_add_trace_rq_requeue(struct request_queue *q,
+static void blk_add_trace_rq_requeue(void *ignore,
+				     struct request_queue *q,
 				     struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
 }
 
-static void blk_add_trace_rq_complete(struct request_queue *q,
+static void blk_add_trace_rq_complete(void *ignore,
+				      struct request_queue *q,
 				      struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_COMPLETE);
@@ -724,34 +729,40 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 			!bio_flagged(bio, BIO_UPTODATE), 0, NULL);
 }
 
-static void blk_add_trace_bio_bounce(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_bounce(void *ignore,
+				     struct request_queue *q, struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE);
 }
 
-static void blk_add_trace_bio_complete(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_complete(void *ignore,
+				       struct request_queue *q, struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
 }
 
-static void blk_add_trace_bio_backmerge(struct request_queue *q,
+static void blk_add_trace_bio_backmerge(void *ignore,
+					struct request_queue *q,
 					struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
 }
 
-static void blk_add_trace_bio_frontmerge(struct request_queue *q,
+static void blk_add_trace_bio_frontmerge(void *ignore,
+					 struct request_queue *q,
 					 struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
 }
 
-static void blk_add_trace_bio_queue(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_queue(void *ignore,
+				    struct request_queue *q, struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
 }
 
-static void blk_add_trace_getrq(struct request_queue *q,
+static void blk_add_trace_getrq(void *ignore,
+				struct request_queue *q,
 				struct bio *bio, int rw)
 {
 	if (bio)
@@ -765,7 +776,8 @@ static void blk_add_trace_getrq(struct request_queue *q,
 }
 
 
-static void blk_add_trace_sleeprq(struct request_queue *q,
+static void blk_add_trace_sleeprq(void *ignore,
+				  struct request_queue *q,
 				  struct bio *bio, int rw)
 {
 	if (bio)
@@ -779,7 +791,7 @@ static void blk_add_trace_sleeprq(struct request_queue *q,
 	}
 }
 
-static void blk_add_trace_plug(struct request_queue *q)
+static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -787,7 +799,7 @@ static void blk_add_trace_plug(struct request_queue *q)
 		__blk_add_trace(bt, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL);
 }
 
-static void blk_add_trace_unplug_io(struct request_queue *q)
+static void blk_add_trace_unplug_io(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -800,7 +812,7 @@ static void blk_add_trace_unplug_io(struct request_queue *q)
 	}
 }
 
-static void blk_add_trace_unplug_timer(struct request_queue *q)
+static void blk_add_trace_unplug_timer(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -813,7 +825,8 @@ static void blk_add_trace_unplug_timer(struct request_queue *q)
 	}
 }
 
-static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
+static void blk_add_trace_split(void *ignore,
+				struct request_queue *q, struct bio *bio,
 				unsigned int pdu)
 {
 	struct blk_trace *bt = q->blk_trace;
@@ -839,8 +852,9 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  *     it spans a stripe (or similar). Add a trace for that action.
  *
  **/
-static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from)
+static void blk_add_trace_remap(void *ignore,
+				struct request_queue *q, struct bio *bio,
+				dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -869,7 +883,8 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
  *     Add a trace for that action.
  *
  **/
-static void blk_add_trace_rq_remap(struct request_queue *q,
+static void blk_add_trace_rq_remap(void *ignore,
+				   struct request_queue *q,
 				   struct request *rq, dev_t dev,
 				   sector_t from)
 {
@@ -921,64 +936,64 @@ static void blk_register_tracepoints(void)
 {
 	int ret;
 
-	ret = register_trace_block_rq_abort(blk_add_trace_rq_abort);
+	ret = register_trace_block_rq_abort(blk_add_trace_rq_abort, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert);
+	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue);
+	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_requeue(blk_add_trace_rq_requeue);
+	ret = register_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete);
+	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_bounce(blk_add_trace_bio_bounce);
+	ret = register_trace_block_bio_bounce(blk_add_trace_bio_bounce, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete);
+	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge);
+	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge);
+	ret = register_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_queue(blk_add_trace_bio_queue);
+	ret = register_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_getrq(blk_add_trace_getrq);
+	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq);
+	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_plug(blk_add_trace_plug);
+	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_unplug_timer(blk_add_trace_unplug_timer);
+	ret = register_trace_block_unplug_timer(blk_add_trace_unplug_timer, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_unplug_io(blk_add_trace_unplug_io);
+	ret = register_trace_block_unplug_io(blk_add_trace_unplug_io, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_split(blk_add_trace_split);
+	ret = register_trace_block_split(blk_add_trace_split, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_remap(blk_add_trace_remap);
+	ret = register_trace_block_remap(blk_add_trace_remap, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap);
+	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
 	WARN_ON(ret);
 }
 
 static void blk_unregister_tracepoints(void)
 {
-	unregister_trace_block_rq_remap(blk_add_trace_rq_remap);
-	unregister_trace_block_remap(blk_add_trace_remap);
-	unregister_trace_block_split(blk_add_trace_split);
-	unregister_trace_block_unplug_io(blk_add_trace_unplug_io);
-	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer);
-	unregister_trace_block_plug(blk_add_trace_plug);
-	unregister_trace_block_sleeprq(blk_add_trace_sleeprq);
-	unregister_trace_block_getrq(blk_add_trace_getrq);
-	unregister_trace_block_bio_queue(blk_add_trace_bio_queue);
-	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge);
-	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge);
-	unregister_trace_block_bio_complete(blk_add_trace_bio_complete);
-	unregister_trace_block_bio_bounce(blk_add_trace_bio_bounce);
-	unregister_trace_block_rq_complete(blk_add_trace_rq_complete);
-	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue);
-	unregister_trace_block_rq_issue(blk_add_trace_rq_issue);
-	unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
-	unregister_trace_block_rq_abort(blk_add_trace_rq_abort);
+	unregister_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
+	unregister_trace_block_remap(blk_add_trace_remap, NULL);
+	unregister_trace_block_split(blk_add_trace_split, NULL);
+	unregister_trace_block_unplug_io(blk_add_trace_unplug_io, NULL);
+	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer, NULL);
+	unregister_trace_block_plug(blk_add_trace_plug, NULL);
+	unregister_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
+	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
+	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
+	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
+	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
+	unregister_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
+	unregister_trace_block_bio_bounce(blk_add_trace_bio_bounce, NULL);
+	unregister_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
+	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
+	unregister_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
+	unregister_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
+	unregister_trace_block_rq_abort(blk_add_trace_rq_abort, NULL);
 
 	tracepoint_synchronize_unregister();
 }
@@ -1321,7 +1336,7 @@ out:
 }
 
 static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
-					       int flags)
+					       int flags, struct trace_event *event)
 {
 	return print_one_line(iter, false);
 }
@@ -1343,7 +1358,8 @@ static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 }
 
 static enum print_line_t
-blk_trace_event_print_binary(struct trace_iterator *iter, int flags)
+blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
+			     struct trace_event *event)
 {
 	return blk_trace_synthesize_old_trace(iter) ?
 			TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
@@ -1381,12 +1397,16 @@ static struct tracer blk_tracer __read_mostly = {
 	.set_flag	= blk_tracer_set_flag,
 };
 
-static struct trace_event trace_blk_event = {
-	.type		= TRACE_BLK,
+static struct trace_event_functions trace_blk_event_funcs = {
 	.trace		= blk_trace_event_print,
 	.binary		= blk_trace_event_print_binary,
 };
 
+static struct trace_event trace_blk_event = {
+	.type		= TRACE_BLK,
+	.funcs		= &trace_blk_event_funcs,
+};
+
 static int __init init_blk_tracer(void)
 {
 	if (!register_ftrace_event(&trace_blk_event)) {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 32837e1..6d2cb14 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3234,7 +3234,8 @@ free:
 }
 
 static void
-ftrace_graph_probe_sched_switch(struct task_struct *prev, struct task_struct *next)
+ftrace_graph_probe_sched_switch(void *ignore,
+			struct task_struct *prev, struct task_struct *next)
 {
 	unsigned long long timestamp;
 	int index;
@@ -3288,7 +3289,7 @@ static int start_graph_tracing(void)
 	} while (ret == -EAGAIN);
 
 	if (!ret) {
-		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch);
+		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 		if (ret)
 			pr_info("ftrace_graph: Couldn't activate tracepoint"
 				" probe to kernel_sched_switch\n");
@@ -3364,7 +3365,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
-	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
+	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
  out:
 	mutex_unlock(&ftrace_lock);
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index a91da69..bbfc1bb 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -95,7 +95,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	trace_wake_up();
 }
 
-static void kmemtrace_kmalloc(unsigned long call_site,
+static void kmemtrace_kmalloc(void *ignore,
+			      unsigned long call_site,
 			      const void *ptr,
 			      size_t bytes_req,
 			      size_t bytes_alloc,
@@ -105,7 +106,8 @@ static void kmemtrace_kmalloc(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, -1);
 }
 
-static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
+static void kmemtrace_kmem_cache_alloc(void *ignore,
+				       unsigned long call_site,
 				       const void *ptr,
 				       size_t bytes_req,
 				       size_t bytes_alloc,
@@ -115,7 +117,8 @@ static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, -1);
 }
 
-static void kmemtrace_kmalloc_node(unsigned long call_site,
+static void kmemtrace_kmalloc_node(void *ignore,
+				   unsigned long call_site,
 				   const void *ptr,
 				   size_t bytes_req,
 				   size_t bytes_alloc,
@@ -126,7 +129,8 @@ static void kmemtrace_kmalloc_node(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, node);
 }
 
-static void kmemtrace_kmem_cache_alloc_node(unsigned long call_site,
+static void kmemtrace_kmem_cache_alloc_node(void *ignore,
+					    unsigned long call_site,
 					    const void *ptr,
 					    size_t bytes_req,
 					    size_t bytes_alloc,
@@ -137,12 +141,14 @@ static void kmemtrace_kmem_cache_alloc_node(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, node);
 }
 
-static void kmemtrace_kfree(unsigned long call_site, const void *ptr)
+static void
+kmemtrace_kfree(void *ignore, unsigned long call_site, const void *ptr)
 {
 	kmemtrace_free(KMEMTRACE_TYPE_KMALLOC, call_site, ptr);
 }
 
-static void kmemtrace_kmem_cache_free(unsigned long call_site, const void *ptr)
+static void kmemtrace_kmem_cache_free(void *ignore,
+				      unsigned long call_site, const void *ptr)
 {
 	kmemtrace_free(KMEMTRACE_TYPE_CACHE, call_site, ptr);
 }
@@ -151,34 +157,34 @@ static int kmemtrace_start_probes(void)
 {
 	int err;
 
-	err = register_trace_kmalloc(kmemtrace_kmalloc);
+	err = register_trace_kmalloc(kmemtrace_kmalloc, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmalloc_node(kmemtrace_kmalloc_node);
+	err = register_trace_kmalloc_node(kmemtrace_kmalloc_node, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
+	err = register_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node, NULL);
 	if (err)
 		return err;
-	err = register_trace_kfree(kmemtrace_kfree);
+	err = register_trace_kfree(kmemtrace_kfree, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free, NULL);
 
 	return err;
 }
 
 static void kmemtrace_stop_probes(void)
 {
-	unregister_trace_kmalloc(kmemtrace_kmalloc);
-	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
-	unregister_trace_kmalloc_node(kmemtrace_kmalloc_node);
-	unregister_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
-	unregister_trace_kfree(kmemtrace_kfree);
-	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+	unregister_trace_kmalloc(kmemtrace_kmalloc, NULL);
+	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc, NULL);
+	unregister_trace_kmalloc_node(kmemtrace_kmalloc_node, NULL);
+	unregister_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node, NULL);
+	unregister_trace_kfree(kmemtrace_kfree, NULL);
+	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free, NULL);
 }
 
 static int kmem_trace_init(struct trace_array *tr)
@@ -237,7 +243,8 @@ struct kmemtrace_user_event_alloc {
 };
 
 static enum print_line_t
-kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
+kmemtrace_print_alloc(struct trace_iterator *iter, int flags,
+		      struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_alloc_entry *entry;
@@ -257,7 +264,8 @@ kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_free(struct trace_iterator *iter, int flags)
+kmemtrace_print_free(struct trace_iterator *iter, int flags,
+		     struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_free_entry *entry;
@@ -275,7 +283,8 @@ kmemtrace_print_free(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
+kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags,
+			   struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_alloc_entry *entry;
@@ -309,7 +318,8 @@ kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
+kmemtrace_print_free_user(struct trace_iterator *iter, int flags,
+			  struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_free_entry *entry;
@@ -463,18 +473,26 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	}
 }
 
-static struct trace_event kmem_trace_alloc = {
-	.type			= TRACE_KMEM_ALLOC,
+static struct trace_event_functions kmem_trace_alloc_funcs = {
 	.trace			= kmemtrace_print_alloc,
 	.binary			= kmemtrace_print_alloc_user,
 };
 
-static struct trace_event kmem_trace_free = {
-	.type			= TRACE_KMEM_FREE,
+static struct trace_event kmem_trace_alloc = {
+	.type			= TRACE_KMEM_ALLOC,
+	.funcs			= &kmem_trace_alloc_funcs,
+};
+
+static struct trace_event_functions kmem_trace_free_funcs = {
 	.trace			= kmemtrace_print_free,
 	.binary			= kmemtrace_print_free_user,
 };
 
+static struct trace_event kmem_trace_free = {
+	.type			= TRACE_KMEM_FREE,
+	.funcs			= &kmem_trace_free_funcs,
+};
+
 static struct tracer kmem_tracer __read_mostly = {
 	.name			= "kmemtrace",
 	.init			= kmem_trace_init,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 756d728..ba0ec81 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1936,7 +1936,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	}
 
 	if (event)
-		return event->trace(iter, sym_flags);
+		return event->funcs->trace(iter, sym_flags, event);
 
 	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
 		goto partial;
@@ -1962,7 +1962,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event)
-		return event->raw(iter, 0);
+		return event->funcs->raw(iter, 0, event);
 
 	if (!trace_seq_printf(s, "%d ?\n", entry->type))
 		goto partial;
@@ -1989,7 +1989,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event) {
-		enum print_line_t ret = event->hex(iter, 0);
+		enum print_line_t ret = event->funcs->hex(iter, 0, event);
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
 	}
@@ -2014,7 +2014,8 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	}
 
 	event = ftrace_find_event(entry->type);
-	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
+	return event ? event->funcs->binary(iter, 0, event) :
+		TRACE_TYPE_HANDLED;
 }
 
 int trace_empty(struct trace_iterator *iter)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d1ce0be..2cd9639 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -405,12 +405,12 @@ void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc);
 #else
-static inline void ftrace_trace_stack(struct trace_array *tr,
+static inline void ftrace_trace_stack(struct ring_buffer *buffer,
 				      unsigned long flags, int skip, int pc)
 {
 }
 
-static inline void ftrace_trace_userstack(struct trace_array *tr,
+static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
 					  unsigned long flags, int pc)
 {
 }
@@ -778,12 +778,15 @@ extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);
 
+struct list_head *
+trace_get_fields(struct ftrace_event_call *event_call);
+
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->filter_active) &&
+	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
 	    !filter_match_preds(call->filter, rec)) {
 		ring_buffer_discard_commit(buffer, event);
 		return 1;
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index b9bc4d4..8d3538b 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -143,7 +143,7 @@ static void branch_trace_reset(struct trace_array *tr)
 }
 
 static enum print_line_t trace_branch_print(struct trace_iterator *iter,
-					    int flags)
+					    int flags, struct trace_event *event)
 {
 	struct trace_branch *field;
 
@@ -167,9 +167,13 @@ static void branch_print_header(struct seq_file *s)
 		"    |\n");
 }
 
+static struct trace_event_functions trace_branch_funcs = {
+	.trace		= trace_branch_print,
+};
+
 static struct trace_event trace_branch_event = {
 	.type		= TRACE_BRANCH,
-	.trace		= trace_branch_print,
+	.funcs		= &trace_branch_funcs,
 };
 
 static struct tracer branch_trace __read_mostly =
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0565bb4..26b8607 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -9,13 +9,9 @@
 #include <linux/kprobes.h>
 #include "trace.h"
 
-DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
-EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
-
 EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
 
-static char *perf_trace_buf;
-static char *perf_trace_buf_nmi;
+static char *perf_trace_buf[4];
 
 /*
  * Force it to be aligned to unsigned long to avoid misaligned accesses
@@ -27,57 +23,82 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
-static int perf_trace_event_enable(struct ftrace_event_call *event)
+static int perf_trace_event_init(struct ftrace_event_call *tp_event,
+				 struct perf_event *p_event)
 {
-	char *buf;
+	struct hlist_head *list;
 	int ret = -ENOMEM;
+	int cpu;
 
-	if (event->perf_refcount++ > 0)
+	p_event->tp_event = tp_event;
+	if (tp_event->perf_refcount++ > 0)
 		return 0;
 
-	if (!total_ref_count) {
-		buf = (char *)alloc_percpu(perf_trace_t);
-		if (!buf)
-			goto fail_buf;
+	list = alloc_percpu(struct hlist_head);
+	if (!list)
+		goto fail;
 
-		rcu_assign_pointer(perf_trace_buf, buf);
+	for_each_possible_cpu(cpu)
+		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
 
-		buf = (char *)alloc_percpu(perf_trace_t);
-		if (!buf)
-			goto fail_buf_nmi;
+	tp_event->perf_events = list;
 
-		rcu_assign_pointer(perf_trace_buf_nmi, buf);
-	}
+	if (!total_ref_count) {
+		char *buf;
+		int i;
 
-	ret = event->perf_event_enable(event);
-	if (!ret) {
-		total_ref_count++;
-		return 0;
+		for (i = 0; i < 4; i++) {
+			buf = (char *)alloc_percpu(perf_trace_t);
+			if (!buf)
+				goto fail;
+
+			perf_trace_buf[i] = buf;
+		}
 	}
 
-fail_buf_nmi:
+	if (tp_event->class->reg)
+		ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
+	else
+		ret = tracepoint_probe_register(tp_event->name,
+						tp_event->class->perf_probe,
+						tp_event);
+
+	if (ret)
+		goto fail;
+
+	total_ref_count++;
+	return 0;
+
+fail:
 	if (!total_ref_count) {
-		free_percpu(perf_trace_buf_nmi);
-		free_percpu(perf_trace_buf);
-		perf_trace_buf_nmi = NULL;
-		perf_trace_buf = NULL;
+		int i;
+
+		for (i = 0; i < 4; i++) {
+			free_percpu(perf_trace_buf[i]);
+			perf_trace_buf[i] = NULL;
+		}
+	}
+
+	if (!--tp_event->perf_refcount) {
+		free_percpu(tp_event->perf_events);
+		tp_event->perf_events = NULL;
 	}
-fail_buf:
-	event->perf_refcount--;
 
 	return ret;
 }
 
-int perf_trace_enable(int event_id)
+int perf_trace_init(struct perf_event *p_event)
 {
-	struct ftrace_event_call *event;
+	struct ftrace_event_call *tp_event;
+	int event_id = p_event->attr.config;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->perf_event_enable &&
-		    try_module_get(event->mod)) {
-			ret = perf_trace_event_enable(event);
+	list_for_each_entry(tp_event, &ftrace_events, list) {
+		if (tp_event->event.type == event_id &&
+		    tp_event->class && tp_event->class->perf_probe &&
+		    try_module_get(tp_event->mod)) {
+			ret = perf_trace_event_init(tp_event, p_event);
 			break;
 		}
 	}
@@ -86,90 +107,76 @@ int perf_trace_enable(int event_id)
 	return ret;
 }
 
-static void perf_trace_event_disable(struct ftrace_event_call *event)
+int perf_trace_enable(struct perf_event *p_event)
 {
-	char *buf, *nmi_buf;
-
-	if (--event->perf_refcount > 0)
-		return;
-
-	event->perf_event_disable(event);
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	struct hlist_head *list;
 
-	if (!--total_ref_count) {
-		buf = perf_trace_buf;
-		rcu_assign_pointer(perf_trace_buf, NULL);
+	list = tp_event->perf_events;
+	if (WARN_ON_ONCE(!list))
+		return -EINVAL;
 
-		nmi_buf = perf_trace_buf_nmi;
-		rcu_assign_pointer(perf_trace_buf_nmi, NULL);
+	list = per_cpu_ptr(list, smp_processor_id());
+	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
-		/*
-		 * Ensure every events in profiling have finished before
-		 * releasing the buffers
-		 */
-		synchronize_sched();
+	return 0;
+}
 
-		free_percpu(buf);
-		free_percpu(nmi_buf);
-	}
+void perf_trace_disable(struct perf_event *p_event)
+{
+	hlist_del_rcu(&p_event->hlist_entry);
 }
 
-void perf_trace_disable(int event_id)
+void perf_trace_destroy(struct perf_event *p_event)
 {
-	struct ftrace_event_call *event;
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	int i;
 
-	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id) {
-			perf_trace_event_disable(event);
-			module_put(event->mod);
-			break;
+	if (--tp_event->perf_refcount > 0)
+		return;
+
+	if (tp_event->class->reg)
+		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
+	else
+		tracepoint_probe_unregister(tp_event->name,
+					    tp_event->class->perf_probe,
+					    tp_event);
+
+	free_percpu(tp_event->perf_events);
+	tp_event->perf_events = NULL;
+
+	if (!--total_ref_count) {
+		for (i = 0; i < 4; i++) {
+			free_percpu(perf_trace_buf[i]);
+			perf_trace_buf[i] = NULL;
 		}
 	}
-	mutex_unlock(&event_mutex);
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       int *rctxp, unsigned long *irq_flags)
+				       struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
-	char *trace_buf, *raw_data;
-	int pc, cpu;
+	char *raw_data;
+	int pc;
 
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	pc = preempt_count();
 
-	/* Protect the per cpu buffer, begin the rcu read side */
-	local_irq_save(*irq_flags);
-
 	*rctxp = perf_swevent_get_recursion_context();
 	if (*rctxp < 0)
-		goto err_recursion;
-
-	cpu = smp_processor_id();
-
-	if (in_nmi())
-		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference_sched(perf_trace_buf);
-
-	if (!trace_buf)
-		goto err;
+		return NULL;
 
-	raw_data = per_cpu_ptr(trace_buf, cpu);
+	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
-	tracing_generic_entry_update(entry, *irq_flags, pc);
+	tracing_generic_entry_update(entry, regs->flags, pc);
 	entry->type = type;
 
 	return raw_data;
-err:
-	perf_swevent_put_recursion_context(*rctxp);
-err_recursion:
-	local_irq_restore(*irq_flags);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c697c70..53cffc0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -29,11 +29,23 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
+struct list_head *
+trace_get_fields(struct ftrace_event_call *event_call)
+{
+	if (!event_call->class->get_fields)
+		return &event_call->class->fields;
+	return event_call->class->get_fields(event_call);
+}
+
 int trace_define_field(struct ftrace_event_call *call, const char *type,
 		       const char *name, int offset, int size, int is_signed,
 		       int filter_type)
 {
 	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	if (WARN_ON(!call->class))
+		return 0;
 
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
@@ -56,7 +68,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	field->size = size;
 	field->is_signed = is_signed;
 
-	list_add(&field->link, &call->fields);
+	head = trace_get_fields(call);
+	list_add(&field->link, head);
 
 	return 0;
 
@@ -94,8 +107,10 @@ static int trace_define_common_fields(struct ftrace_event_call *call)
 void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
+	struct list_head *head;
 
-	list_for_each_entry_safe(field, next, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry_safe(field, next, head, link) {
 		list_del(&field->link);
 		kfree(field->type);
 		kfree(field->name);
@@ -107,11 +122,9 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 {
 	int id;
 
-	id = register_ftrace_event(call->event);
+	id = register_ftrace_event(&call->event);
 	if (!id)
 		return -ENODEV;
-	call->id = id;
-	INIT_LIST_HEAD(&call->fields);
 
 	return 0;
 }
@@ -124,23 +137,33 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 
 	switch (enable) {
 	case 0:
-		if (call->enabled) {
-			call->enabled = 0;
+		if (call->flags & TRACE_EVENT_FL_ENABLED) {
+			call->flags &= ~TRACE_EVENT_FL_ENABLED;
 			tracing_stop_cmdline_record();
-			call->unregfunc(call);
+			if (call->class->reg)
+				call->class->reg(call, TRACE_REG_UNREGISTER);
+			else
+				tracepoint_probe_unregister(call->name,
+							    call->class->probe,
+							    call);
 		}
 		break;
 	case 1:
-		if (!call->enabled) {
+		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
 			tracing_start_cmdline_record();
-			ret = call->regfunc(call);
+			if (call->class->reg)
+				ret = call->class->reg(call, TRACE_REG_REGISTER);
+			else
+				ret = tracepoint_probe_register(call->name,
+								call->class->probe,
+								call);
 			if (ret) {
 				tracing_stop_cmdline_record();
 				pr_info("event trace: Could not enable event "
 					"%s\n", call->name);
 				break;
 			}
-			call->enabled = 1;
+			call->flags |= TRACE_EVENT_FL_ENABLED;
 		}
 		break;
 	}
@@ -171,15 +194,16 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 
-		if (!call->name || !call->regfunc)
+		if (!call->name || !call->class ||
+		    (!call->class->probe && !call->class->reg))
 			continue;
 
 		if (match &&
 		    strcmp(match, call->name) != 0 &&
-		    strcmp(match, call->system) != 0)
+		    strcmp(match, call->class->system) != 0)
 			continue;
 
-		if (sub && strcmp(sub, call->system) != 0)
+		if (sub && strcmp(sub, call->class->system) != 0)
 			continue;
 
 		if (event && strcmp(event, call->name) != 0)
@@ -297,7 +321,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
 		 */
-		if (call->regfunc)
+		if (call->class && (call->class->probe || call->class->reg))
 			return call;
 	}
 
@@ -328,7 +352,7 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
 	(*pos)++;
 
 	list_for_each_entry_continue(call, &ftrace_events, list) {
-		if (call->enabled)
+		if (call->flags & TRACE_EVENT_FL_ENABLED)
 			return call;
 	}
 
@@ -355,8 +379,8 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_event_call *call = v;
 
-	if (strcmp(call->system, TRACE_SYSTEM) != 0)
-		seq_printf(m, "%s:", call->system);
+	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
+		seq_printf(m, "%s:", call->class->system);
 	seq_printf(m, "%s\n", call->name);
 
 	return 0;
@@ -387,7 +411,7 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 	struct ftrace_event_call *call = filp->private_data;
 	char *buf;
 
-	if (call->enabled)
+	if (call->flags & TRACE_EVENT_FL_ENABLED)
 		buf = "1\n";
 	else
 		buf = "0\n";
@@ -450,10 +474,11 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->name || !call->regfunc)
+		if (!call->name || !call->class ||
+		    (!call->class->probe && !call->class->reg))
 			continue;
 
-		if (system && strcmp(call->system, system) != 0)
+		if (system && strcmp(call->class->system, system) != 0)
 			continue;
 
 		/*
@@ -461,7 +486,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		 * or if all events or cleared, or if we have
 		 * a mixture.
 		 */
-		set |= (1 << !!call->enabled);
+		set |= (1 << !!(call->flags & TRACE_EVENT_FL_ENABLED));
 
 		/*
 		 * If we have a mixture, no need to look further.
@@ -525,6 +550,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 {
 	struct ftrace_event_call *call = filp->private_data;
 	struct ftrace_event_field *field;
+	struct list_head *head;
 	struct trace_seq *s;
 	int common_field_count = 5;
 	char *buf;
@@ -540,10 +566,11 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	trace_seq_printf(s, "name: %s\n", call->name);
-	trace_seq_printf(s, "ID: %d\n", call->id);
+	trace_seq_printf(s, "ID: %d\n", call->event.type);
 	trace_seq_printf(s, "format:\n");
 
-	list_for_each_entry_reverse(field, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry_reverse(field, head, link) {
 		/*
 		 * Smartly shows the array type(except dynamic array).
 		 * Normal:
@@ -613,7 +640,7 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 		return -ENOMEM;
 
 	trace_seq_init(s);
-	trace_seq_printf(s, "%d\n", call->id);
+	trace_seq_printf(s, "%d\n", call->event.type);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, s->len);
@@ -919,14 +946,15 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *filter,
 		 const struct file_operations *format)
 {
+	struct list_head *head;
 	int ret;
 
 	/*
 	 * If the trace point header did not define TRACE_SYSTEM
 	 * then the system would be called "TRACE_SYSTEM".
 	 */
-	if (strcmp(call->system, TRACE_SYSTEM) != 0)
-		d_events = event_subsystem_dir(call->system, d_events);
+	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
+		d_events = event_subsystem_dir(call->class->system, d_events);
 
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
@@ -935,22 +963,31 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		return -1;
 	}
 
-	if (call->regfunc)
+	if (call->class->probe || call->class->reg)
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
-	if (call->id && call->perf_event_enable)
+#ifdef CONFIG_PERF_EVENTS
+	if (call->event.type && (call->class->perf_probe || call->class->reg))
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
+#endif
 
-	if (call->define_fields) {
-		ret = trace_define_common_fields(call);
-		if (!ret)
-			ret = call->define_fields(call);
-		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", call->name);
-			return ret;
+	if (call->class->define_fields) {
+		/*
+		 * Other events may have the same class. Only update
+		 * the fields if they are not already defined.
+		 */
+		head = trace_get_fields(call);
+		if (list_empty(head)) {
+			ret = trace_define_common_fields(call);
+			if (!ret)
+				ret = call->class->define_fields(call);
+			if (ret < 0) {
+				pr_warning("Could not initialize trace point"
+					   " events/%s\n", call->name);
+				return ret;
+			}
 		}
 		trace_create_file("filter", 0644, call->dir, call,
 				  filter);
@@ -970,8 +1007,8 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 	if (!call->name)
 		return -EINVAL;
 
-	if (call->raw_init) {
-		ret = call->raw_init(call);
+	if (call->class->raw_init) {
+		ret = call->class->raw_init(call);
 		if (ret < 0) {
 			if (ret != -ENOSYS)
 				pr_warning("Could not initialize trace "
@@ -1035,13 +1072,13 @@ static void remove_subsystem_dir(const char *name)
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	ftrace_event_enable_disable(call, 0);
-	if (call->event)
-		__unregister_ftrace_event(call->event);
+	if (call->event.funcs)
+		__unregister_ftrace_event(&call->event);
 	debugfs_remove_recursive(call->dir);
 	list_del(&call->list);
 	trace_destroy_fields(call);
 	destroy_preds(call);
-	remove_subsystem_dir(call->system);
+	remove_subsystem_dir(call->class->system);
 }
 
 /* Remove an event_call */
@@ -1132,8 +1169,8 @@ static void trace_module_add_events(struct module *mod)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-		if (call->raw_init) {
-			ret = call->raw_init(call);
+		if (call->class->raw_init) {
+			ret = call->class->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
@@ -1286,8 +1323,8 @@ static __init int event_trace_init(void)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-		if (call->raw_init) {
-			ret = call->raw_init(call);
+		if (call->class->raw_init) {
+			ret = call->class->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
@@ -1388,8 +1425,8 @@ static __init void event_trace_self_tests(void)
 
 	list_for_each_entry(call, &ftrace_events, list) {
 
-		/* Only test those that have a regfunc */
-		if (!call->regfunc)
+		/* Only test those that have a probe */
+		if (!call->class || !call->class->probe)
 			continue;
 
 /*
@@ -1399,8 +1436,8 @@ static __init void event_trace_self_tests(void)
  * syscalls as we test.
  */
 #ifndef CONFIG_EVENT_TRACE_TEST_SYSCALLS
-		if (call->system &&
-		    strcmp(call->system, "syscalls") == 0)
+		if (call->class->system &&
+		    strcmp(call->class->system, "syscalls") == 0)
 			continue;
 #endif
 
@@ -1410,7 +1447,7 @@ static __init void event_trace_self_tests(void)
 		 * If an event is already enabled, someone is using
 		 * it and the self test should not be on.
 		 */
-		if (call->enabled) {
+		if (call->flags & TRACE_EVENT_FL_ENABLED) {
 			pr_warning("Enabled event during self test!\n");
 			WARN_ON_ONCE(1);
 			continue;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 58092d8..57bb1bb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -500,8 +500,10 @@ static struct ftrace_event_field *
 find_event_field(struct ftrace_event_call *call, char *name)
 {
 	struct ftrace_event_field *field;
+	struct list_head *head;
 
-	list_for_each_entry(field, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry(field, head, link) {
 		if (!strcmp(field->name, name))
 			return field;
 	}
@@ -545,7 +547,7 @@ static void filter_disable_preds(struct ftrace_event_call *call)
 	struct event_filter *filter = call->filter;
 	int i;
 
-	call->filter_active = 0;
+	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 	filter->n_preds = 0;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++)
@@ -572,7 +574,7 @@ void destroy_preds(struct ftrace_event_call *call)
 {
 	__free_preds(call->filter);
 	call->filter = NULL;
-	call->filter_active = 0;
+	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
 
 static struct event_filter *__alloc_preds(void)
@@ -611,7 +613,7 @@ static int init_preds(struct ftrace_event_call *call)
 	if (call->filter)
 		return 0;
 
-	call->filter_active = 0;
+	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 	call->filter = __alloc_preds();
 	if (IS_ERR(call->filter))
 		return PTR_ERR(call->filter);
@@ -625,10 +627,10 @@ static int init_subsystem_preds(struct event_subsystem *system)
 	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
-		if (strcmp(call->system, system->name) != 0)
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		err = init_preds(call);
@@ -644,10 +646,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 	struct ftrace_event_call *call;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
-		if (strcmp(call->system, system->name) != 0)
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		filter_disable_preds(call);
@@ -1249,10 +1251,10 @@ static int replace_system_preds(struct event_subsystem *system,
 	list_for_each_entry(call, &ftrace_events, list) {
 		struct event_filter *filter = call->filter;
 
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
-		if (strcmp(call->system, system->name) != 0)
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		/* try to see if the filter can be applied */
@@ -1266,7 +1268,7 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (err)
 			filter_disable_preds(call);
 		else {
-			call->filter_active = 1;
+			call->flags |= TRACE_EVENT_FL_FILTERED;
 			replace_filter_string(filter, filter_string);
 		}
 		fail = false;
@@ -1315,7 +1317,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 	if (err)
 		append_filter_err(ps, call->filter);
 	else
-		call->filter_active = 1;
+		call->flags |= TRACE_EVENT_FL_FILTERED;
 out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
@@ -1393,7 +1395,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	mutex_lock(&event_mutex);
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->id == event_id)
+		if (call->event.type == event_id)
 			break;
 	}
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e091f64..8536e2a 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -127,7 +127,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 
 static int ftrace_raw_init_event(struct ftrace_event_call *call)
 {
-	INIT_LIST_HEAD(&call->fields);
+	INIT_LIST_HEAD(&call->class->fields);
 	return 0;
 }
 
@@ -153,17 +153,21 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
+#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+									\
+struct ftrace_event_class event_class_ftrace_##call = {			\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.define_fields		= ftrace_define_fields_##call,		\
+	.raw_init		= ftrace_raw_init_event,		\
+};									\
 									\
 struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.id			= type,					\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_raw_init_event,		\
+	.event.type		= etype,				\
+	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
-	.define_fields		= ftrace_define_fields_##call,		\
 };									\
 
 #include "trace_entries.h"
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index dd11c83..79f4bac 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1025,7 +1025,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		if (!event)
 			return TRACE_TYPE_UNHANDLED;
 
-		ret = event->trace(iter, sym_flags);
+		ret = event->funcs->trace(iter, sym_flags, event);
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
 	}
@@ -1112,7 +1112,8 @@ print_graph_function(struct trace_iterator *iter)
 }
 
 static enum print_line_t
-print_graph_function_event(struct trace_iterator *iter, int flags)
+print_graph_function_event(struct trace_iterator *iter, int flags,
+			   struct trace_event *event)
 {
 	return print_graph_function(iter);
 }
@@ -1225,14 +1226,18 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static struct trace_event_functions graph_functions = {
+	.trace		= print_graph_function_event,
+};
+
 static struct trace_event graph_trace_entry_event = {
 	.type		= TRACE_GRAPH_ENT,
-	.trace		= print_graph_function_event,
+	.funcs		= &graph_functions,
 };
 
 static struct trace_event graph_trace_ret_event = {
 	.type		= TRACE_GRAPH_RET,
-	.trace		= print_graph_function_event,
+	.funcs		= &graph_functions
 };
 
 static struct tracer graph_trace __read_mostly = {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a751432..faf7cef 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -324,8 +324,8 @@ struct trace_probe {
 	unsigned long 		nhit;
 	unsigned int		flags;	/* For TP_FLAG_* */
 	const char		*symbol;	/* symbol name */
+	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	struct trace_event		event;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
@@ -404,6 +404,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
+	tp->call.class = &tp->class;
 	tp->call.name = kstrdup(event, GFP_KERNEL);
 	if (!tp->call.name)
 		goto error;
@@ -413,8 +414,8 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->call.system = kstrdup(group, GFP_KERNEL);
-	if (!tp->call.system)
+	tp->class.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->class.system)
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
@@ -443,7 +444,7 @@ static void free_trace_probe(struct trace_probe *tp)
 	for (i = 0; i < tp->nr_args; i++)
 		free_probe_arg(&tp->args[i]);
 
-	kfree(tp->call.system);
+	kfree(tp->call.class->system);
 	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
@@ -456,7 +457,7 @@ static struct trace_probe *find_probe_event(const char *event,
 
 	list_for_each_entry(tp, &probe_list, list)
 		if (strcmp(tp->call.name, event) == 0 &&
-		    strcmp(tp->call.system, group) == 0)
+		    strcmp(tp->call.class->system, group) == 0)
 			return tp;
 	return NULL;
 }
@@ -481,7 +482,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	mutex_lock(&probe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tp->call.name, tp->call.system);
+	old_tp = find_probe_event(tp->call.name, tp->call.class->system);
 	if (old_tp) {
 		/* delete old event */
 		unregister_trace_probe(old_tp);
@@ -904,7 +905,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	int i;
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
-	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
+	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
 
 	if (!tp->symbol)
 		seq_printf(m, " 0x%p", tp->rp.kp.addr);
@@ -1061,8 +1062,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	size = sizeof(*entry) + tp->size;
 
-	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
-						  irq_flags, pc);
+	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
+						  size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -1094,8 +1095,8 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 
 	size = sizeof(*entry) + tp->size;
 
-	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
-						  irq_flags, pc);
+	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
+						  size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -1112,18 +1113,17 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 
 /* Event entry printers */
 enum print_line_t
-print_kprobe_event(struct trace_iterator *iter, int flags)
+print_kprobe_event(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
 {
 	struct kprobe_trace_entry_head *field;
 	struct trace_seq *s = &iter->seq;
-	struct trace_event *event;
 	struct trace_probe *tp;
 	u8 *data;
 	int i;
 
 	field = (struct kprobe_trace_entry_head *)iter->ent;
-	event = ftrace_find_event(field->ent.type);
-	tp = container_of(event, struct trace_probe, event);
+	tp = container_of(event, struct trace_probe, call.event);
 
 	if (!trace_seq_printf(s, "%s: (", tp->call.name))
 		goto partial;
@@ -1149,18 +1149,17 @@ partial:
 }
 
 enum print_line_t
-print_kretprobe_event(struct trace_iterator *iter, int flags)
+print_kretprobe_event(struct trace_iterator *iter, int flags,
+		      struct trace_event *event)
 {
 	struct kretprobe_trace_entry_head *field;
 	struct trace_seq *s = &iter->seq;
-	struct trace_event *event;
 	struct trace_probe *tp;
 	u8 *data;
 	int i;
 
 	field = (struct kretprobe_trace_entry_head *)iter->ent;
-	event = ftrace_find_event(field->ent.type);
-	tp = container_of(event, struct trace_probe, event);
+	tp = container_of(event, struct trace_probe, call.event);
 
 	if (!trace_seq_printf(s, "%s: (", tp->call.name))
 		goto partial;
@@ -1217,8 +1216,6 @@ static void probe_event_disable(struct ftrace_event_call *call)
 
 static int probe_event_raw_init(struct ftrace_event_call *event_call)
 {
-	INIT_LIST_HEAD(&event_call->fields);
-
 	return 0;
 }
 
@@ -1341,9 +1338,9 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry_head *entry;
+	struct hlist_head *head;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1353,7 +1350,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1362,7 +1359,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
+	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
 }
 
 /* Kretprobe profile handler */
@@ -1372,9 +1370,9 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry_head *entry;
+	struct hlist_head *head;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1384,7 +1382,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1394,8 +1392,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			       irq_flags, regs);
+	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
@@ -1425,6 +1423,26 @@ static void probe_perf_disable(struct ftrace_event_call *call)
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
+static __kprobes
+int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return probe_event_enable(event);
+	case TRACE_REG_UNREGISTER:
+		probe_event_disable(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return probe_perf_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		probe_perf_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
 
 static __kprobes
 int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
@@ -1454,6 +1472,14 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
 
+static struct trace_event_functions kretprobe_funcs = {
+	.trace		= print_kretprobe_event
+};
+
+static struct trace_event_functions kprobe_funcs = {
+	.trace		= print_kprobe_event
+};
+
 static int register_probe_event(struct trace_probe *tp)
 {
 	struct ftrace_event_call *call = &tp->call;
@@ -1461,36 +1487,31 @@ static int register_probe_event(struct trace_probe *tp)
 
 	/* Initialize ftrace_event_call */
 	if (probe_is_return(tp)) {
-		tp->event.trace = print_kretprobe_event;
-		call->raw_init = probe_event_raw_init;
-		call->define_fields = kretprobe_event_define_fields;
+		INIT_LIST_HEAD(&call->class->fields);
+		call->event.funcs = &kretprobe_funcs;
+		call->class->raw_init = probe_event_raw_init;
+		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
-		tp->event.trace = print_kprobe_event;
-		call->raw_init = probe_event_raw_init;
-		call->define_fields = kprobe_event_define_fields;
+		INIT_LIST_HEAD(&call->class->fields);
+		call->event.funcs = &kprobe_funcs;
+		call->class->raw_init = probe_event_raw_init;
+		call->class->define_fields = kprobe_event_define_fields;
 	}
 	if (set_print_fmt(tp) < 0)
 		return -ENOMEM;
-	call->event = &tp->event;
-	call->id = register_ftrace_event(&tp->event);
-	if (!call->id) {
+	ret = register_ftrace_event(&call->event);
+	if (!ret) {
 		kfree(call->print_fmt);
 		return -ENODEV;
 	}
-	call->enabled = 0;
-	call->regfunc = probe_event_enable;
-	call->unregfunc = probe_event_disable;
-
-#ifdef CONFIG_PERF_EVENTS
-	call->perf_event_enable = probe_perf_enable;
-	call->perf_event_disable = probe_perf_disable;
-#endif
+	call->flags = 0;
+	call->class->reg = kprobe_register;
 	call->data = tp;
 	ret = trace_add_event_call(call);
 	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
 		kfree(call->print_fmt);
-		unregister_ftrace_event(&tp->event);
+		unregister_ftrace_event(&call->event);
 	}
 	return ret;
 }
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 2404c12..fc9d4db 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -726,6 +726,9 @@ int register_ftrace_event(struct trace_event *event)
 	if (WARN_ON(!event))
 		goto out;
 
+	if (WARN_ON(!event->funcs))
+		goto out;
+
 	INIT_LIST_HEAD(&event->list);
 
 	if (!event->type) {
@@ -758,14 +761,14 @@ int register_ftrace_event(struct trace_event *event)
 			goto out;
 	}
 
-	if (event->trace == NULL)
-		event->trace = trace_nop_print;
-	if (event->raw == NULL)
-		event->raw = trace_nop_print;
-	if (event->hex == NULL)
-		event->hex = trace_nop_print;
-	if (event->binary == NULL)
-		event->binary = trace_nop_print;
+	if (event->funcs->trace == NULL)
+		event->funcs->trace = trace_nop_print;
+	if (event->funcs->raw == NULL)
+		event->funcs->raw = trace_nop_print;
+	if (event->funcs->hex == NULL)
+		event->funcs->hex = trace_nop_print;
+	if (event->funcs->binary == NULL)
+		event->funcs->binary = trace_nop_print;
 
 	key = event->type & (EVENT_HASHSIZE - 1);
 
@@ -807,13 +810,15 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
  * Standard events
  */
 
-enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags)
+enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
+				  struct trace_event *event)
 {
 	return TRACE_TYPE_HANDLED;
 }
 
 /* TRACE_FN */
-static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags,
+					struct trace_event *event)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -840,7 +845,8 @@ static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags,
+				      struct trace_event *event)
 {
 	struct ftrace_entry *field;
 
@@ -854,7 +860,8 @@ static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags,
+				      struct trace_event *event)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -867,7 +874,8 @@ static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags,
+				      struct trace_event *event)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -880,14 +888,18 @@ static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static struct trace_event trace_fn_event = {
-	.type		= TRACE_FN,
+static struct trace_event_functions trace_fn_funcs = {
 	.trace		= trace_fn_trace,
 	.raw		= trace_fn_raw,
 	.hex		= trace_fn_hex,
 	.binary		= trace_fn_bin,
 };
 
+static struct trace_event trace_fn_event = {
+	.type		= TRACE_FN,
+	.funcs		= &trace_fn_funcs,
+};
+
 /* TRACE_CTX an TRACE_WAKE */
 static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 					     char *delim)
@@ -916,13 +928,14 @@ static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags,
+					 struct trace_event *event)
 {
 	return trace_ctxwake_print(iter, "==>");
 }
 
 static enum print_line_t trace_wake_print(struct trace_iterator *iter,
-					  int flags)
+					  int flags, struct trace_event *event)
 {
 	return trace_ctxwake_print(iter, "  +");
 }
@@ -950,12 +963,14 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags,
+				       struct trace_event *event)
 {
 	return trace_ctxwake_raw(iter, 0);
 }
 
-static enum print_line_t trace_wake_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_raw(struct trace_iterator *iter, int flags,
+					struct trace_event *event)
 {
 	return trace_ctxwake_raw(iter, '+');
 }
@@ -984,18 +999,20 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags,
+				       struct trace_event *event)
 {
 	return trace_ctxwake_hex(iter, 0);
 }
 
-static enum print_line_t trace_wake_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_hex(struct trace_iterator *iter, int flags,
+					struct trace_event *event)
 {
 	return trace_ctxwake_hex(iter, '+');
 }
 
 static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct ctx_switch_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1012,25 +1029,33 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-static struct trace_event trace_ctx_event = {
-	.type		= TRACE_CTX,
+static struct trace_event_functions trace_ctx_funcs = {
 	.trace		= trace_ctx_print,
 	.raw		= trace_ctx_raw,
 	.hex		= trace_ctx_hex,
 	.binary		= trace_ctxwake_bin,
 };
 
-static struct trace_event trace_wake_event = {
-	.type		= TRACE_WAKE,
+static struct trace_event trace_ctx_event = {
+	.type		= TRACE_CTX,
+	.funcs		= &trace_ctx_funcs,
+};
+
+static struct trace_event_functions trace_wake_funcs = {
 	.trace		= trace_wake_print,
 	.raw		= trace_wake_raw,
 	.hex		= trace_wake_hex,
 	.binary		= trace_ctxwake_bin,
 };
 
+static struct trace_event trace_wake_event = {
+	.type		= TRACE_WAKE,
+	.funcs		= &trace_wake_funcs,
+};
+
 /* TRACE_SPECIAL */
 static enum print_line_t trace_special_print(struct trace_iterator *iter,
-					     int flags)
+					     int flags, struct trace_event *event)
 {
 	struct special_entry *field;
 
@@ -1046,7 +1071,7 @@ static enum print_line_t trace_special_print(struct trace_iterator *iter,
 }
 
 static enum print_line_t trace_special_hex(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct special_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1061,7 +1086,7 @@ static enum print_line_t trace_special_hex(struct trace_iterator *iter,
 }
 
 static enum print_line_t trace_special_bin(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct special_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1075,18 +1100,22 @@ static enum print_line_t trace_special_bin(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-static struct trace_event trace_special_event = {
-	.type		= TRACE_SPECIAL,
+static struct trace_event_functions trace_special_funcs = {
 	.trace		= trace_special_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
 };
 
+static struct trace_event trace_special_event = {
+	.type		= TRACE_SPECIAL,
+	.funcs		= &trace_special_funcs,
+};
+
 /* TRACE_STACK */
 
 static enum print_line_t trace_stack_print(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct stack_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1114,17 +1143,21 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_stack_event = {
-	.type		= TRACE_STACK,
+static struct trace_event_functions trace_stack_funcs = {
 	.trace		= trace_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
 };
 
+static struct trace_event trace_stack_event = {
+	.type		= TRACE_STACK,
+	.funcs		= &trace_stack_funcs,
+};
+
 /* TRACE_USER_STACK */
 static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
-						int flags)
+						int flags, struct trace_event *event)
 {
 	struct userstack_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1143,17 +1176,22 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_user_stack_event = {
-	.type		= TRACE_USER_STACK,
+static struct trace_event_functions trace_user_stack_funcs = {
 	.trace		= trace_user_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
 };
 
+static struct trace_event trace_user_stack_event = {
+	.type		= TRACE_USER_STACK,
+	.funcs		= &trace_user_stack_funcs,
+};
+
 /* TRACE_BPRINT */
 static enum print_line_t
-trace_bprint_print(struct trace_iterator *iter, int flags)
+trace_bprint_print(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
@@ -1178,7 +1216,8 @@ trace_bprint_print(struct trace_iterator *iter, int flags)
 
 
 static enum print_line_t
-trace_bprint_raw(struct trace_iterator *iter, int flags)
+trace_bprint_raw(struct trace_iterator *iter, int flags,
+		 struct trace_event *event)
 {
 	struct bprint_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1197,16 +1236,19 @@ trace_bprint_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
+static struct trace_event_functions trace_bprint_funcs = {
+	.trace		= trace_bprint_print,
+	.raw		= trace_bprint_raw,
+};
 
 static struct trace_event trace_bprint_event = {
 	.type		= TRACE_BPRINT,
-	.trace		= trace_bprint_print,
-	.raw		= trace_bprint_raw,
+	.funcs		= &trace_bprint_funcs,
 };
 
 /* TRACE_PRINT */
 static enum print_line_t trace_print_print(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1225,7 +1267,8 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
+					 struct trace_event *event)
 {
 	struct print_entry *field;
 
@@ -1240,12 +1283,16 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_print_event = {
-	.type	 	= TRACE_PRINT,
+static struct trace_event_functions trace_print_funcs = {
 	.trace		= trace_print_print,
 	.raw		= trace_print_raw,
 };
 
+static struct trace_event trace_print_event = {
+	.type	 	= TRACE_PRINT,
+	.funcs		= &trace_print_funcs,
+};
+
 
 static struct trace_event *events[] __initdata = {
 	&trace_fn_event,
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 9d91c72..c038eba 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -25,7 +25,7 @@ extern void trace_event_read_unlock(void);
 extern struct trace_event *ftrace_find_event(int type);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
-					 int flags);
+					 int flags, struct trace_event *event);
 extern int
 trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index a55fccf..8f758d0 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -50,7 +50,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_switch(struct task_struct *prev, struct task_struct *next)
+probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
@@ -108,7 +108,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_wakeup(struct task_struct *wakee, int success)
+probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
@@ -138,21 +138,21 @@ static int tracing_sched_register(void)
 {
 	int ret;
 
-	ret = register_trace_sched_wakeup(probe_sched_wakeup);
+	ret = register_trace_sched_wakeup(probe_sched_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return ret;
 	}
 
-	ret = register_trace_sched_wakeup_new(probe_sched_wakeup);
+	ret = register_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = register_trace_sched_switch(probe_sched_switch);
+	ret = register_trace_sched_switch(probe_sched_switch, NULL);
 	if (ret) {
 		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_switch\n");
@@ -161,17 +161,17 @@ static int tracing_sched_register(void)
 
 	return ret;
 fail_deprobe_wake_new:
-	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
 fail_deprobe:
-	unregister_trace_sched_wakeup(probe_sched_wakeup);
+	unregister_trace_sched_wakeup(probe_sched_wakeup, NULL);
 	return ret;
 }
 
 static void tracing_sched_unregister(void)
 {
-	unregister_trace_sched_switch(probe_sched_switch);
-	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
-	unregister_trace_sched_wakeup(probe_sched_wakeup);
+	unregister_trace_sched_switch(probe_sched_switch, NULL);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
+	unregister_trace_sched_wakeup(probe_sched_wakeup, NULL);
 }
 
 static void tracing_start_sched_switch(void)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 8052446..0e73bc2 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -98,7 +98,8 @@ static int report_latency(cycle_t delta)
 	return 1;
 }
 
-static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
+static void
+probe_wakeup_migrate_task(void *ignore, struct task_struct *task, int cpu)
 {
 	if (task != wakeup_task)
 		return;
@@ -107,7 +108,8 @@ static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
 }
 
 static void notrace
-probe_wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
+probe_wakeup_sched_switch(void *ignore,
+			  struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
@@ -199,7 +201,7 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-probe_wakeup(struct task_struct *p, int success)
+probe_wakeup(void *ignore, struct task_struct *p, int success)
 {
 	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();
@@ -263,28 +265,28 @@ static void start_wakeup_tracer(struct trace_array *tr)
 {
 	int ret;
 
-	ret = register_trace_sched_wakeup(probe_wakeup);
+	ret = register_trace_sched_wakeup(probe_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return;
 	}
 
-	ret = register_trace_sched_wakeup_new(probe_wakeup);
+	ret = register_trace_sched_wakeup_new(probe_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = register_trace_sched_switch(probe_wakeup_sched_switch);
+	ret = register_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 	if (ret) {
 		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_switch\n");
 		goto fail_deprobe_wake_new;
 	}
 
-	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task);
+	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_migrate_task\n");
@@ -311,19 +313,19 @@ static void start_wakeup_tracer(struct trace_array *tr)
 
 	return;
 fail_deprobe_wake_new:
-	unregister_trace_sched_wakeup_new(probe_wakeup);
+	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 fail_deprobe:
-	unregister_trace_sched_wakeup(probe_wakeup);
+	unregister_trace_sched_wakeup(probe_wakeup, NULL);
 }
 
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
-	unregister_trace_sched_switch(probe_wakeup_sched_switch);
-	unregister_trace_sched_wakeup_new(probe_wakeup);
-	unregister_trace_sched_wakeup(probe_wakeup);
-	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task);
+	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
+	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
+	unregister_trace_sched_wakeup(probe_wakeup, NULL);
+	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task, NULL);
 }
 
 static int __wakeup_tracer_init(struct trace_array *tr)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4d6d711..d2c859c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -15,6 +15,54 @@ static int sys_refcount_exit;
 static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
+static int syscall_enter_register(struct ftrace_event_call *event,
+				 enum trace_reg type);
+static int syscall_exit_register(struct ftrace_event_call *event,
+				 enum trace_reg type);
+
+static int syscall_enter_define_fields(struct ftrace_event_call *call);
+static int syscall_exit_define_fields(struct ftrace_event_call *call);
+
+static struct list_head *
+syscall_get_enter_fields(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	return &entry->enter_fields;
+}
+
+static struct list_head *
+syscall_get_exit_fields(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	return &entry->exit_fields;
+}
+
+struct trace_event_functions enter_syscall_print_funcs = {
+	.trace                  = print_syscall_enter,
+};
+
+struct trace_event_functions exit_syscall_print_funcs = {
+	.trace                  = print_syscall_exit,
+};
+
+struct ftrace_event_class event_class_syscall_enter = {
+	.system			= "syscalls",
+	.reg			= syscall_enter_register,
+	.define_fields		= syscall_enter_define_fields,
+	.get_fields		= syscall_get_enter_fields,
+	.raw_init		= init_syscall_trace,
+};
+
+struct ftrace_event_class event_class_syscall_exit = {
+	.system			= "syscalls",
+	.reg			= syscall_exit_register,
+	.define_fields		= syscall_exit_define_fields,
+	.get_fields		= syscall_get_exit_fields,
+	.raw_init		= init_syscall_trace,
+};
+
 extern unsigned long __start_syscalls_metadata[];
 extern unsigned long __stop_syscalls_metadata[];
 
@@ -53,7 +101,8 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 }
 
 enum print_line_t
-print_syscall_enter(struct trace_iterator *iter, int flags)
+print_syscall_enter(struct trace_iterator *iter, int flags,
+		    struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
@@ -68,7 +117,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 	if (!entry)
 		goto end;
 
-	if (entry->enter_event->id != ent->type) {
+	if (entry->enter_event->event.type != ent->type) {
 		WARN_ON_ONCE(1);
 		goto end;
 	}
@@ -105,7 +154,8 @@ end:
 }
 
 enum print_line_t
-print_syscall_exit(struct trace_iterator *iter, int flags)
+print_syscall_exit(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
@@ -123,7 +173,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 		return TRACE_TYPE_HANDLED;
 	}
 
-	if (entry->exit_event->id != ent->type) {
+	if (entry->exit_event->event.type != ent->type) {
 		WARN_ON_ONCE(1);
 		return TRACE_TYPE_UNHANDLED;
 	}
@@ -205,7 +255,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
 		kfree(call->print_fmt);
 }
 
-int syscall_enter_define_fields(struct ftrace_event_call *call)
+static int syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
 	struct syscall_metadata *meta = call->data;
@@ -228,7 +278,7 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-int syscall_exit_define_fields(struct ftrace_event_call *call)
+static int syscall_exit_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_exit trace;
 	int ret;
@@ -243,7 +293,7 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-void ftrace_syscall_enter(struct pt_regs *regs, long id)
+void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
@@ -265,7 +315,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->enter_event->id, size, 0, 0);
+			sys_data->enter_event->event.type, size, 0, 0);
 	if (!event)
 		return;
 
@@ -278,7 +328,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-void ftrace_syscall_exit(struct pt_regs *regs, long ret)
+void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 {
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
@@ -297,7 +347,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 		return;
 
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->exit_event->id, sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
 	if (!event)
 		return;
 
@@ -320,7 +370,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
-		ret = register_trace_sys_enter(ftrace_syscall_enter);
+		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
 	if (!ret) {
 		set_bit(num, enabled_enter_syscalls);
 		sys_refcount_enter++;
@@ -340,7 +390,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	sys_refcount_enter--;
 	clear_bit(num, enabled_enter_syscalls);
 	if (!sys_refcount_enter)
-		unregister_trace_sys_enter(ftrace_syscall_enter);
+		unregister_trace_sys_enter(ftrace_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -354,7 +404,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
-		ret = register_trace_sys_exit(ftrace_syscall_exit);
+		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
 	if (!ret) {
 		set_bit(num, enabled_exit_syscalls);
 		sys_refcount_exit++;
@@ -374,7 +424,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	sys_refcount_exit--;
 	clear_bit(num, enabled_exit_syscalls);
 	if (!sys_refcount_exit)
-		unregister_trace_sys_exit(ftrace_syscall_exit);
+		unregister_trace_sys_exit(ftrace_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -434,11 +484,11 @@ static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
 static int sys_perf_refcount_enter;
 static int sys_perf_refcount_exit;
 
-static void perf_syscall_enter(struct pt_regs *regs, long id)
+static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
-	unsigned long flags;
+	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -461,14 +511,16 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 		return;
 
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
-				sys_data->enter_event->id, &rctx, &flags);
+				sys_data->enter_event->event.type, regs, &rctx);
 	if (!rec)
 		return;
 
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+
+	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -480,7 +532,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_perf_refcount_enter)
-		ret = register_trace_sys_enter(perf_syscall_enter);
+		ret = register_trace_sys_enter(perf_syscall_enter, NULL);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
@@ -502,15 +554,15 @@ void perf_sysenter_disable(struct ftrace_event_call *call)
 	sys_perf_refcount_enter--;
 	clear_bit(num, enabled_perf_enter_syscalls);
 	if (!sys_perf_refcount_enter)
-		unregister_trace_sys_enter(perf_syscall_enter);
+		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static void perf_syscall_exit(struct pt_regs *regs, long ret)
+static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
-	unsigned long flags;
+	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -536,14 +588,15 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 		return;
 
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
-				sys_data->exit_event->id, &rctx, &flags);
+				sys_data->exit_event->event.type, regs, &rctx);
 	if (!rec)
 		return;
 
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)
@@ -555,7 +608,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_perf_refcount_exit)
-		ret = register_trace_sys_exit(perf_syscall_exit);
+		ret = register_trace_sys_exit(perf_syscall_exit, NULL);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
@@ -577,9 +630,50 @@ void perf_sysexit_disable(struct ftrace_event_call *call)
 	sys_perf_refcount_exit--;
 	clear_bit(num, enabled_perf_exit_syscalls);
 	if (!sys_perf_refcount_exit)
-		unregister_trace_sys_exit(perf_syscall_exit);
+		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
 #endif /* CONFIG_PERF_EVENTS */
 
+static int syscall_enter_register(struct ftrace_event_call *event,
+				 enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return reg_event_syscall_enter(event);
+	case TRACE_REG_UNREGISTER:
+		unreg_event_syscall_enter(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return perf_sysenter_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		perf_sysenter_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
+
+static int syscall_exit_register(struct ftrace_event_call *event,
+				 enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return reg_event_syscall_exit(event);
+	case TRACE_REG_UNREGISTER:
+		unreg_event_syscall_exit(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return perf_sysexit_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		perf_sysexit_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index cc2d2fa..a7cc379 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -49,7 +49,8 @@ static void cpu_workqueue_stat_free(struct kref *kref)
 
 /* Insertion of a work */
 static void
-probe_workqueue_insertion(struct task_struct *wq_thread,
+probe_workqueue_insertion(void *ignore,
+			  struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -70,7 +71,8 @@ found:
 
 /* Execution of a work */
 static void
-probe_workqueue_execution(struct task_struct *wq_thread,
+probe_workqueue_execution(void *ignore,
+			  struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -90,7 +92,8 @@ found:
 }
 
 /* Creation of a cpu workqueue thread */
-static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
+static void probe_workqueue_creation(void *ignore,
+				     struct task_struct *wq_thread, int cpu)
 {
 	struct cpu_workqueue_stats *cws;
 	unsigned long flags;
@@ -114,7 +117,8 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 }
 
 /* Destruction of a cpu workqueue thread */
-static void probe_workqueue_destruction(struct task_struct *wq_thread)
+static void
+probe_workqueue_destruction(void *ignore, struct task_struct *wq_thread)
 {
 	/* Workqueue only execute on one cpu */
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -259,19 +263,19 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-	ret = register_trace_workqueue_insertion(probe_workqueue_insertion);
+	ret = register_trace_workqueue_insertion(probe_workqueue_insertion, NULL);
 	if (ret)
 		goto out;
 
-	ret = register_trace_workqueue_execution(probe_workqueue_execution);
+	ret = register_trace_workqueue_execution(probe_workqueue_execution, NULL);
 	if (ret)
 		goto no_insertion;
 
-	ret = register_trace_workqueue_creation(probe_workqueue_creation);
+	ret = register_trace_workqueue_creation(probe_workqueue_creation, NULL);
 	if (ret)
 		goto no_execution;
 
-	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
+	ret = register_trace_workqueue_destruction(probe_workqueue_destruction, NULL);
 	if (ret)
 		goto no_creation;
 
@@ -283,11 +287,11 @@ int __init trace_workqueue_early_init(void)
 	return 0;
 
 no_creation:
-	unregister_trace_workqueue_creation(probe_workqueue_creation);
+	unregister_trace_workqueue_creation(probe_workqueue_creation, NULL);
 no_execution:
-	unregister_trace_workqueue_execution(probe_workqueue_execution);
+	unregister_trace_workqueue_execution(probe_workqueue_execution, NULL);
 no_insertion:
-	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
+	unregister_trace_workqueue_insertion(probe_workqueue_insertion, NULL);
 out:
 	pr_warning("trace_workqueue: unable to trace workqueues\n");
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index cc89be5..c77f3ec 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -54,7 +54,7 @@ static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
  */
 struct tracepoint_entry {
 	struct hlist_node hlist;
-	void **funcs;
+	struct tracepoint_func *funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	char name[0];
 };
@@ -64,12 +64,12 @@ struct tp_probes {
 		struct rcu_head rcu;
 		struct list_head list;
 	} u;
-	void *probes[0];
+	struct tracepoint_func probes[0];
 };
 
 static inline void *allocate_probes(int count)
 {
-	struct tp_probes *p  = kmalloc(count * sizeof(void *)
+	struct tp_probes *p  = kmalloc(count * sizeof(struct tracepoint_func)
 			+ sizeof(struct tp_probes), GFP_KERNEL);
 	return p == NULL ? NULL : p->probes;
 }
@@ -79,7 +79,7 @@ static void rcu_free_old_probes(struct rcu_head *head)
 	kfree(container_of(head, struct tp_probes, u.rcu));
 }
 
-static inline void release_probes(void *old)
+static inline void release_probes(struct tracepoint_func *old)
 {
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
@@ -95,15 +95,16 @@ static void debug_print_probes(struct tracepoint_entry *entry)
 	if (!tracepoint_debug || !entry->funcs)
 		return;
 
-	for (i = 0; entry->funcs[i]; i++)
-		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i]);
+	for (i = 0; entry->funcs[i].func; i++)
+		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i].func);
 }
 
-static void *
-tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
+static struct tracepoint_func *
+tracepoint_entry_add_probe(struct tracepoint_entry *entry,
+			   void *probe, void *data)
 {
 	int nr_probes = 0;
-	void **old, **new;
+	struct tracepoint_func *old, *new;
 
 	WARN_ON(!probe);
 
@@ -111,8 +112,9 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 	old = entry->funcs;
 	if (old) {
 		/* (N -> N+1), (N != 0, 1) probes */
-		for (nr_probes = 0; old[nr_probes]; nr_probes++)
-			if (old[nr_probes] == probe)
+		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
+			if (old[nr_probes].func == probe &&
+			    old[nr_probes].data == data)
 				return ERR_PTR(-EEXIST);
 	}
 	/* + 2 : one for new probe, one for NULL func */
@@ -120,9 +122,10 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old)
-		memcpy(new, old, nr_probes * sizeof(void *));
-	new[nr_probes] = probe;
-	new[nr_probes + 1] = NULL;
+		memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
+	new[nr_probes].func = probe;
+	new[nr_probes].data = data;
+	new[nr_probes + 1].func = NULL;
 	entry->refcount = nr_probes + 1;
 	entry->funcs = new;
 	debug_print_probes(entry);
@@ -130,10 +133,11 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 }
 
 static void *
-tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
+tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
+			      void *probe, void *data)
 {
 	int nr_probes = 0, nr_del = 0, i;
-	void **old, **new;
+	struct tracepoint_func *old, *new;
 
 	old = entry->funcs;
 
@@ -142,8 +146,10 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
-	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
-		if ((!probe || old[nr_probes] == probe))
+	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+		if (!probe ||
+		    (old[nr_probes].func == probe &&
+		     old[nr_probes].data == data))
 			nr_del++;
 	}
 
@@ -160,10 +166,11 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 		new = allocate_probes(nr_probes - nr_del + 1);
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
-		for (i = 0; old[i]; i++)
-			if ((probe && old[i] != probe))
+		for (i = 0; old[i].func; i++)
+			if (probe &&
+			    (old[i].func != probe || old[i].data != data))
 				new[j++] = old[i];
-		new[nr_probes - nr_del] = NULL;
+		new[nr_probes - nr_del].func = NULL;
 		entry->refcount = nr_probes - nr_del;
 		entry->funcs = new;
 	}
@@ -315,18 +322,19 @@ static void tracepoint_update_probes(void)
 	module_update_tracepoints();
 }
 
-static void *tracepoint_add_probe(const char *name, void *probe)
+static struct tracepoint_func *
+tracepoint_add_probe(const char *name, void *probe, void *data)
 {
 	struct tracepoint_entry *entry;
-	void *old;
+	struct tracepoint_func *old;
 
 	entry = get_tracepoint(name);
 	if (!entry) {
 		entry = add_tracepoint(name);
 		if (IS_ERR(entry))
-			return entry;
+			return (struct tracepoint_func *)entry;
 	}
-	old = tracepoint_entry_add_probe(entry, probe);
+	old = tracepoint_entry_add_probe(entry, probe, data);
 	if (IS_ERR(old) && !entry->refcount)
 		remove_tracepoint(entry);
 	return old;
@@ -340,12 +348,12 @@ static void *tracepoint_add_probe(const char *name, void *probe)
  * Returns 0 if ok, error value on error.
  * The probe address must at least be aligned on the architecture pointer size.
  */
-int tracepoint_probe_register(const char *name, void *probe)
+int tracepoint_probe_register(const char *name, void *probe, void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe);
+	old = tracepoint_add_probe(name, probe, data);
 	mutex_unlock(&tracepoints_mutex);
 	if (IS_ERR(old))
 		return PTR_ERR(old);
@@ -356,15 +364,16 @@ int tracepoint_probe_register(const char *name, void *probe)
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_register);
 
-static void *tracepoint_remove_probe(const char *name, void *probe)
+static struct tracepoint_func *
+tracepoint_remove_probe(const char *name, void *probe, void *data)
 {
 	struct tracepoint_entry *entry;
-	void *old;
+	struct tracepoint_func *old;
 
 	entry = get_tracepoint(name);
 	if (!entry)
 		return ERR_PTR(-ENOENT);
-	old = tracepoint_entry_remove_probe(entry, probe);
+	old = tracepoint_entry_remove_probe(entry, probe, data);
 	if (IS_ERR(old))
 		return old;
 	if (!entry->refcount)
@@ -382,12 +391,12 @@ static void *tracepoint_remove_probe(const char *name, void *probe)
  * itself uses stop_machine(), which insures that every preempt disabled section
  * have finished.
  */
-int tracepoint_probe_unregister(const char *name, void *probe)
+int tracepoint_probe_unregister(const char *name, void *probe, void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe);
+	old = tracepoint_remove_probe(name, probe, data);
 	mutex_unlock(&tracepoints_mutex);
 	if (IS_ERR(old))
 		return PTR_ERR(old);
@@ -418,12 +427,13 @@ static void tracepoint_add_old_probes(void *old)
  *
  * caller must call tracepoint_probe_update_all()
  */
-int tracepoint_probe_register_noupdate(const char *name, void *probe)
+int tracepoint_probe_register_noupdate(const char *name, void *probe,
+				       void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe);
+	old = tracepoint_add_probe(name, probe, data);
 	if (IS_ERR(old)) {
 		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
@@ -441,12 +451,13 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register_noupdate);
  *
  * caller must call tracepoint_probe_update_all()
  */
-int tracepoint_probe_unregister_noupdate(const char *name, void *probe)
+int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
+					 void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe);
+	old = tracepoint_remove_probe(name, probe, data);
 	if (IS_ERR(old)) {
 		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index cf208d8..ad41529 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -172,12 +172,12 @@ out:
 	return;
 }
 
-static void trace_kfree_skb_hit(struct sk_buff *skb, void *location)
+static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
 {
 	trace_drop_common(skb, location);
 }
 
-static void trace_napi_poll_hit(struct napi_struct *napi)
+static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi)
 {
 	struct dm_hw_stat_delta *new_stat;
 
@@ -225,12 +225,12 @@ static int set_all_monitor_traces(int state)
 
 	switch (state) {
 	case TRACE_ON:
-		rc |= register_trace_kfree_skb(trace_kfree_skb_hit);
-		rc |= register_trace_napi_poll(trace_napi_poll_hit);
+		rc |= register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+		rc |= register_trace_napi_poll(trace_napi_poll_hit, NULL);
 		break;
 	case TRACE_OFF:
-		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit);
-		rc |= unregister_trace_napi_poll(trace_napi_poll_hit);
+		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+		rc |= unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
 
 		tracepoint_synchronize_unregister();
 
diff --git a/samples/tracepoints/tp-samples-trace.h b/samples/tracepoints/tp-samples-trace.h
index dffdc49..4d46be9 100644
--- a/samples/tracepoints/tp-samples-trace.h
+++ b/samples/tracepoints/tp-samples-trace.h
@@ -7,7 +7,5 @@
 DECLARE_TRACE(subsys_event,
 	TP_PROTO(struct inode *inode, struct file *file),
 	TP_ARGS(inode, file));
-DECLARE_TRACE(subsys_eventb,
-	TP_PROTO(void),
-	TP_ARGS());
+DECLARE_TRACE_NOARGS(subsys_eventb);
 #endif
diff --git a/samples/tracepoints/tracepoint-probe-sample.c b/samples/tracepoints/tracepoint-probe-sample.c
index 9e60eb6..744c0b9 100644
--- a/samples/tracepoints/tracepoint-probe-sample.c
+++ b/samples/tracepoints/tracepoint-probe-sample.c
@@ -13,7 +13,8 @@
  * Here the caller only guarantees locking for struct file and struct inode.
  * Locking must therefore be done in the probe to use the dentry.
  */
-static void probe_subsys_event(struct inode *inode, struct file *file)
+static void probe_subsys_event(void *ignore,
+			       struct inode *inode, struct file *file)
 {
 	path_get(&file->f_path);
 	dget(file->f_path.dentry);
@@ -23,7 +24,7 @@ static void probe_subsys_event(struct inode *inode, struct file *file)
 	path_put(&file->f_path);
 }
 
-static void probe_subsys_eventb(void)
+static void probe_subsys_eventb(void *ignore)
 {
 	printk(KERN_INFO "Event B is encountered\n");
 }
@@ -32,9 +33,9 @@ static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
-	ret = register_trace_subsys_event(probe_subsys_event);
+	ret = register_trace_subsys_event(probe_subsys_event, NULL);
 	WARN_ON(ret);
-	ret = register_trace_subsys_eventb(probe_subsys_eventb);
+	ret = register_trace_subsys_eventb(probe_subsys_eventb, NULL);
 	WARN_ON(ret);
 
 	return 0;
@@ -44,8 +45,8 @@ module_init(tp_sample_trace_init);
 
 static void __exit tp_sample_trace_exit(void)
 {
-	unregister_trace_subsys_eventb(probe_subsys_eventb);
-	unregister_trace_subsys_event(probe_subsys_event);
+	unregister_trace_subsys_eventb(probe_subsys_eventb, NULL);
+	unregister_trace_subsys_event(probe_subsys_event, NULL);
 	tracepoint_synchronize_unregister();
 }
 
diff --git a/samples/tracepoints/tracepoint-probe-sample2.c b/samples/tracepoints/tracepoint-probe-sample2.c
index be2a960..9fcf990 100644
--- a/samples/tracepoints/tracepoint-probe-sample2.c
+++ b/samples/tracepoints/tracepoint-probe-sample2.c
@@ -12,7 +12,8 @@
  * Here the caller only guarantees locking for struct file and struct inode.
  * Locking must therefore be done in the probe to use the dentry.
  */
-static void probe_subsys_event(struct inode *inode, struct file *file)
+static void probe_subsys_event(void *ignore,
+			       struct inode *inode, struct file *file)
 {
 	printk(KERN_INFO "Event is encountered with inode number %lu\n",
 		inode->i_ino);
@@ -22,7 +23,7 @@ static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
-	ret = register_trace_subsys_event(probe_subsys_event);
+	ret = register_trace_subsys_event(probe_subsys_event, NULL);
 	WARN_ON(ret);
 
 	return 0;
@@ -32,7 +33,7 @@ module_init(tp_sample_trace_init);
 
 static void __exit tp_sample_trace_exit(void)
 {
-	unregister_trace_subsys_event(probe_subsys_event);
+	unregister_trace_subsys_event(probe_subsys_event, NULL);
 	tracepoint_synchronize_unregister();
 }
 
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2cab8e8..909fa76 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -43,6 +43,9 @@ OPTIONS
 -c::
         scale counter values
 
+-B::
+        print large numbers with thousands' separators according to locale
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 77bcc9b..08278ed 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -277,7 +277,7 @@ static void hist_entry__print_hits(struct hist_entry *self)
 	printf("%*s: %Lu\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-static void annotate_sym(struct hist_entry *he)
+static int hist_entry__tty_annotate(struct hist_entry *he)
 {
 	struct map *map = he->ms.map;
 	struct dso *dso = map->dso;
@@ -288,7 +288,7 @@ static void annotate_sym(struct hist_entry *he)
 	struct objdump_line *pos, *n;
 
 	if (hist_entry__annotate(he, &head) < 0)
-		return;
+		return -1;
 
 	if (full_paths)
 		d_filename = filename;
@@ -317,30 +317,59 @@ static void annotate_sym(struct hist_entry *he)
 
 	if (print_line)
 		free_source_line(he, len);
+
+	return 0;
 }
 
 static void hists__find_annotations(struct hists *self)
 {
-	struct rb_node *nd;
+	struct rb_node *first = rb_first(&self->entries), *nd = first;
+	int key = KEY_RIGHT;
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	while (nd) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
-		if (he->ms.sym == NULL)
-			continue;
+		if (he->ms.sym == NULL || he->ms.map->dso->annotate_warned)
+			goto find_next;
 
 		priv = symbol__priv(he->ms.sym);
-		if (priv->hist == NULL)
+		if (priv->hist == NULL) {
+find_next:
+			if (key == KEY_LEFT)
+				nd = rb_prev(nd);
+			else
+				nd = rb_next(nd);
 			continue;
+		}
 
-		annotate_sym(he);
-		/*
-		 * Since we have a hist_entry per IP for the same symbol, free
-		 * he->ms.sym->hist to signal we already processed this symbol.
-		 */
-		free(priv->hist);
-		priv->hist = NULL;
+		if (use_browser) {
+			key = hist_entry__tui_annotate(he);
+			if (is_exit_key(key))
+				break;
+			switch (key) {
+			case KEY_RIGHT:
+			case '\t':
+				nd = rb_next(nd);
+				break;
+			case KEY_LEFT:
+				if (nd == first)
+					continue;
+				nd = rb_prev(nd);
+			default:
+				break;
+			}
+		} else {
+			hist_entry__tty_annotate(he);
+			nd = rb_next(nd);
+			/*
+			 * Since we have a hist_entry per IP for the same
+			 * symbol, free he->ms.sym->hist to signal we already
+			 * processed this symbol.
+			 */
+			free(priv->hist);
+			priv->hist = NULL;
+		}
 	}
 }
 
@@ -416,6 +445,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
+	setup_browser();
+
 	symbol_conf.priv_size = sizeof(struct sym_priv);
 	symbol_conf.try_vmlinux_path = true;
 
@@ -435,8 +466,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		sym_hist_filter = argv[0];
 	}
 
-	setup_pager();
-
 	if (field_sep && *field_sep == '.') {
 		pr_err("'.' is the only non valid --field-separator argument\n");
 		return -1;
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 61c6d70..e4a4da3 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -65,8 +65,10 @@ static int parse_probe_event(const char *str)
 	int ret;
 
 	pr_debug("probe-definition(%d): %s\n", params.nevents, str);
-	if (++params.nevents == MAX_PROBES)
-		die("Too many probes (> %d) are specified.", MAX_PROBES);
+	if (++params.nevents == MAX_PROBES) {
+		pr_err("Too many probes (> %d) were specified.", MAX_PROBES);
+		return -1;
+	}
 
 	/* Parse a perf-probe command into event */
 	ret = parse_perf_probe_command(str, pev);
@@ -84,7 +86,9 @@ static int parse_probe_event_argv(int argc, const char **argv)
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += strlen(argv[i]) + 1;
-	buf = xzalloc(len + 1);
+	buf = zalloc(len + 1);
+	if (buf == NULL)
+		return -ENOMEM;
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += sprintf(&buf[len], "%s ", argv[i]);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cb46c7d..9bc8905 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -25,6 +25,7 @@
 
 #include <unistd.h>
 #include <sched.h>
+#include <sys/mman.h>
 
 enum write_mode_t {
 	WRITE_FORCE,
@@ -60,13 +61,8 @@ static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
-static bool			multiplex			=  false;
-static int			multiplex_fd			=     -1;
 
 static long			samples				=      0;
-static struct timeval		last_read;
-static struct timeval		this_read;
-
 static u64			bytes_written			=      0;
 
 static struct pollfd		*event_array;
@@ -86,7 +82,7 @@ struct mmap_data {
 	unsigned int		prev;
 };
 
-static struct mmap_data		*mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct mmap_data		mmap_array[MAX_NR_CPUS];
 
 static unsigned long mmap_read_head(struct mmap_data *md)
 {
@@ -146,8 +142,6 @@ static void mmap_read(struct mmap_data *md)
 	void *buf;
 	int diff;
 
-	gettimeofday(&this_read, NULL);
-
 	/*
 	 * If we're further behind than half the buffer, there's a chance
 	 * the writer will bite our tail and mess up the samples under us.
@@ -158,23 +152,13 @@ static void mmap_read(struct mmap_data *md)
 	 */
 	diff = head - old;
 	if (diff < 0) {
-		struct timeval iv;
-		unsigned long msecs;
-
-		timersub(&this_read, &last_read, &iv);
-		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
-
-		fprintf(stderr, "WARNING: failed to keep up with mmap data."
-				"  Last read %lu msecs ago.\n", msecs);
-
+		fprintf(stderr, "WARNING: failed to keep up with mmap data\n");
 		/*
 		 * head points to a known good entry, start there.
 		 */
 		old = head;
 	}
 
-	last_read = this_read;
-
 	if (old != head)
 		samples++;
 
@@ -380,27 +364,30 @@ try_again:
 		 */
 		if (group && group_fd == -1)
 			group_fd = fd[nr_cpu][counter][thread_index];
-		if (multiplex && multiplex_fd == -1)
-			multiplex_fd = fd[nr_cpu][counter][thread_index];
 
-		if (multiplex && fd[nr_cpu][counter][thread_index] != multiplex_fd) {
-
-			ret = ioctl(fd[nr_cpu][counter][thread_index], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
-			assert(ret != -1);
+		if (counter || thread_index) {
+			ret = ioctl(fd[nr_cpu][counter][thread_index],
+					PERF_EVENT_IOC_SET_OUTPUT,
+					fd[nr_cpu][0][0]);
+			if (ret) {
+				error("failed to set output: %d (%s)\n", errno,
+						strerror(errno));
+				exit(-1);
+			}
 		} else {
-			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
-			event_array[nr_poll].events = POLLIN;
-			nr_poll++;
-
-			mmap_array[nr_cpu][counter][thread_index].counter = counter;
-			mmap_array[nr_cpu][counter][thread_index].prev = 0;
-			mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
-			mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
+			mmap_array[nr_cpu].counter = counter;
+			mmap_array[nr_cpu].prev = 0;
+			mmap_array[nr_cpu].mask = mmap_pages*page_size - 1;
+			mmap_array[nr_cpu].base = mmap(NULL, (mmap_pages+1)*page_size,
 				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
-			if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
+			if (mmap_array[nr_cpu].base == MAP_FAILED) {
 				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
 				exit(-1);
 			}
+
+			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
+			event_array[nr_poll].events = POLLIN;
+			nr_poll++;
 		}
 
 		if (filter != NULL) {
@@ -501,16 +488,11 @@ static struct perf_event_header finished_round_event = {
 
 static void mmap_read_all(void)
 {
-	int i, counter, thread;
+	int i;
 
 	for (i = 0; i < nr_cpu; i++) {
-		for (counter = 0; counter < nr_counters; counter++) {
-			for (thread = 0; thread < thread_num; thread++) {
-				if (mmap_array[i][counter][thread].base)
-					mmap_read(&mmap_array[i][counter][thread]);
-			}
-
-		}
+		if (mmap_array[i].base)
+			mmap_read(&mmap_array[i]);
 	}
 
 	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
@@ -834,8 +816,6 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
-	OPT_BOOLEAN('M', "multiplex", &multiplex,
-		    "multiplex counter output in a single channel"),
 	OPT_END()
 };
 
@@ -887,9 +867,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	for (i = 0; i < MAX_NR_CPUS; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = zalloc(
-				sizeof(struct mmap_data)*thread_num);
-			if (!fd[i][j] || !mmap_array[i][j])
+			if (!fd[i][j])
 				return -ENOMEM;
 		}
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1d3c100..3592057 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -116,7 +116,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (use_browser)
+	if (use_browser > 0)
 		err = hist_entry__inc_addr_samples(he, al->addr);
 out_free_syms:
 	free(syms);
@@ -288,6 +288,38 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	return ret + fprintf(fp, "\n#\n");
 }
 
+static int hists__tty_browse_tree(struct rb_root *tree, const char *help)
+{
+	struct rb_node *next = rb_first(tree);
+
+	while (next) {
+		struct hists *hists = rb_entry(next, struct hists, rb_node);
+		const char *evname = NULL;
+
+		if (rb_first(&hists->entries) != rb_last(&hists->entries))
+			evname = __event_name(hists->type, hists->config);
+
+		hists__fprintf_nr_sample_events(hists, evname, stdout);
+		hists__fprintf(hists, NULL, false, stdout);
+		fprintf(stdout, "\n\n");
+		next = rb_next(&hists->rb_node);
+	}
+
+	if (sort_order == default_sort_order &&
+	    parent_pattern == default_parent_pattern) {
+		fprintf(stdout, "#\n# (%s)\n#\n", help);
+
+		if (show_threads) {
+			bool style = !strcmp(pretty_printing_style, "raw");
+			perf_read_values_display(stdout, &show_threads_values,
+						 style);
+			perf_read_values_destroy(&show_threads_values);
+		}
+	}
+
+	return 0;
+}
+
 static int __cmd_report(void)
 {
 	int ret = -EINVAL;
@@ -330,34 +362,14 @@ static int __cmd_report(void)
 		hists = rb_entry(next, struct hists, rb_node);
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
-		if (use_browser)
-			hists__browse(hists, help, input_name);
-		else {
-			const char *evname = NULL;
-			if (rb_first(&session->hists.entries) !=
-			    rb_last(&session->hists.entries))
-				evname = __event_name(hists->type, hists->config);
-
-			hists__fprintf_nr_sample_events(hists, evname, stdout);
-
-			hists__fprintf(hists, NULL, false, stdout);
-			fprintf(stdout, "\n\n");
-		}
-
 		next = rb_next(&hists->rb_node);
 	}
 
-	if (!use_browser && sort_order == default_sort_order &&
-	    parent_pattern == default_parent_pattern) {
-		fprintf(stdout, "#\n# (%s)\n#\n", help);
+	if (use_browser > 0)
+		hists__tui_browse_tree(&session->hists_tree, help);
+	else
+		hists__tty_browse_tree(&session->hists_tree, help);
 
-		if (show_threads) {
-			bool style = !strcmp(pretty_printing_style, "raw");
-			perf_read_values_display(stdout, &show_threads_values,
-						 style);
-			perf_read_values_destroy(&show_threads_values);
-		}
-	}
 out_delete:
 	perf_session__delete(session);
 	return ret;
@@ -491,7 +503,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser)
+	if (use_browser > 0)
 		symbol_conf.priv_size = sizeof(struct sym_priv);
 
 	if (symbol__init() < 0)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ff8c413..9a39ca3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -50,6 +50,7 @@
 
 #include <sys/prctl.h>
 #include <math.h>
+#include <locale.h>
 
 static struct perf_event_attr default_attrs[] = {
 
@@ -80,6 +81,8 @@ static pid_t			*all_tids			=  NULL;
 static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
+static bool			big_num				=  false;
+
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
@@ -377,7 +380,7 @@ static void nsec_printout(int counter, double avg)
 {
 	double msecs = avg / 1e6;
 
-	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
+	fprintf(stderr, " %18.6f  %-24s", msecs, event_name(counter));
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		fprintf(stderr, " # %10.3f CPUs ",
@@ -389,7 +392,10 @@ static void abs_printout(int counter, double avg)
 {
 	double total, ratio = 0.0;
 
-	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
+	if (big_num)
+		fprintf(stderr, " %'18.0f  %-24s", avg, event_name(counter));
+	else
+		fprintf(stderr, " %18.0f  %-24s", avg, event_name(counter));
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		total = avg_stats(&runtime_cycles_stats);
@@ -426,7 +432,7 @@ static void print_counter(int counter)
 	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %14s  %-24s\n",
+		fprintf(stderr, " %18s  %-24s\n",
 			"<not counted>", event_name(counter));
 		return;
 	}
@@ -477,7 +483,7 @@ static void print_stat(int argc, const char **argv)
 		print_counter(counter);
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " %14.9f  seconds time elapsed",
+	fprintf(stderr, " %18.9f  seconds time elapsed",
 			avg_stats(&walltime_nsecs_stats)/1e9);
 	if (run_count > 1) {
 		fprintf(stderr, "   ( +- %7.3f%% )",
@@ -534,6 +540,8 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
+	OPT_BOOLEAN('B', "big-num", &big_num,
+		    "print large numbers with thousands\' separators"),
 	OPT_END()
 };
 
@@ -542,6 +550,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	int status;
 	int i,j;
 
+	setlocale(LC_ALL, "");
+
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && target_tid == -1)
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 08e0e5d..6e48711 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -15,15 +15,15 @@
 #include "util/parse-events.h"
 #include "util/debugfs.h"
 
-bool use_browser;
-
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
 
+int use_browser = -1;
 static int use_pager = -1;
+
 struct pager_config {
 	const char *cmd;
 	int val;
@@ -49,6 +49,24 @@ int check_pager_config(const char *cmd)
 	return c.val;
 }
 
+static int tui_command_config(const char *var, const char *value, void *data)
+{
+	struct pager_config *c = data;
+	if (!prefixcmp(var, "tui.") && !strcmp(var + 4, c->cmd))
+		c->val = perf_config_bool(var, value);
+	return 0;
+}
+
+/* returns 0 for "no tui", 1 for "use tui", and -1 for "not specified" */
+static int check_tui_config(const char *cmd)
+{
+	struct pager_config c;
+	c.cmd = cmd;
+	c.val = -1;
+	perf_config(tui_command_config, &c);
+	return c.val;
+}
+
 static void commit_pager_choice(void)
 {
 	switch (use_pager) {
@@ -255,6 +273,9 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	if (p->option & RUN_SETUP)
 		prefix = NULL; /* setup_perf_directory(); */
 
+	if (use_browser == -1)
+		use_browser = check_tui_config(p->cmd);
+
 	if (use_pager == -1 && p->option & RUN_SETUP)
 		use_pager = check_pager_config(p->cmd);
 	if (use_pager == -1 && p->option & USE_PAGER)
diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
index a791dd4..0e76aff 100644
--- a/tools/perf/util/abspath.c
+++ b/tools/perf/util/abspath.c
@@ -1,86 +1,5 @@
 #include "cache.h"
 
-/*
- * Do not use this for inspecting *tracked* content.  When path is a
- * symlink to a directory, we do not want to say it is a directory when
- * dealing with tracked content in the working tree.
- */
-static int is_directory(const char *path)
-{
-	struct stat st;
-	return (!stat(path, &st) && S_ISDIR(st.st_mode));
-}
-
-/* We allow "recursive" symbolic links. Only within reason, though. */
-#define MAXDEPTH 5
-
-const char *make_absolute_path(const char *path)
-{
-	static char bufs[2][PATH_MAX + 1], *buf = bufs[0], *next_buf = bufs[1];
-	char cwd[1024] = "";
-	int buf_index = 1, len;
-
-	int depth = MAXDEPTH;
-	char *last_elem = NULL;
-	struct stat st;
-
-	if (strlcpy(buf, path, PATH_MAX) >= PATH_MAX)
-		die ("Too long path: %.*s", 60, path);
-
-	while (depth--) {
-		if (!is_directory(buf)) {
-			char *last_slash = strrchr(buf, '/');
-			if (last_slash) {
-				*last_slash = '\0';
-				last_elem = xstrdup(last_slash + 1);
-			} else {
-				last_elem = xstrdup(buf);
-				*buf = '\0';
-			}
-		}
-
-		if (*buf) {
-			if (!*cwd && !getcwd(cwd, sizeof(cwd)))
-				die ("Could not get current working directory");
-
-			if (chdir(buf))
-				die ("Could not switch to '%s'", buf);
-		}
-		if (!getcwd(buf, PATH_MAX))
-			die ("Could not get current working directory");
-
-		if (last_elem) {
-			len = strlen(buf);
-
-			if (len + strlen(last_elem) + 2 > PATH_MAX)
-				die ("Too long path name: '%s/%s'",
-						buf, last_elem);
-			buf[len] = '/';
-			strcpy(buf + len + 1, last_elem);
-			free(last_elem);
-			last_elem = NULL;
-		}
-
-		if (!lstat(buf, &st) && S_ISLNK(st.st_mode)) {
-			len = readlink(buf, next_buf, PATH_MAX);
-			if (len < 0)
-				die ("Invalid symlink: %s", buf);
-			if (PATH_MAX <= len)
-				die("symbolic link too long: %s", buf);
-			next_buf[len] = '\0';
-			buf = next_buf;
-			buf_index = 1 - buf_index;
-			next_buf = bufs[buf_index];
-		} else
-			break;
-	}
-
-	if (*cwd && chdir(cwd))
-		die ("Could not change back to '%s'", cwd);
-
-	return buf;
-}
-
 static const char *get_pwd_cwd(void)
 {
 	static char cwd[PATH_MAX + 1];
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 0f60a39..70c5cf8 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2009, 2010 Red Hat Inc.
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
+#include "util.h"
+#include <stdio.h>
 #include "build-id.h"
 #include "event.h"
 #include "symbol.h"
@@ -37,3 +39,23 @@ struct perf_event_ops build_id__mark_dso_hit_ops = {
 	.mmap	= event__process_mmap,
 	.fork	= event__process_task,
 };
+
+char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
+{
+	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+	const char *home;
+
+	if (!self->has_build_id)
+		return NULL;
+
+	build_id__sprintf(self->build_id, sizeof(self->build_id), build_id_hex);
+	home = getenv("HOME");
+	if (bf == NULL) {
+		if (asprintf(&bf, "%s/%s/.build-id/%.2s/%s", home,
+			     DEBUG_CACHE_DIR, build_id_hex, build_id_hex + 2) < 0)
+			return NULL;
+	} else
+		snprintf(bf, size, "%s/%s/.build-id/%.2s/%s", home,
+			 DEBUG_CACHE_DIR, build_id_hex, build_id_hex + 2);
+	return bf;
+}
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 1d981d6..5dafb00 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -5,4 +5,6 @@
 
 extern struct perf_event_ops build_id__mark_dso_hit_ops;
 
+char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
+
 #endif
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 4b9aab7..65fe664 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -13,56 +13,16 @@
 
 #define PERF_DIR_ENVIRONMENT "PERF_DIR"
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
-#define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
-#define DB_ENVIRONMENT "PERF_OBJECT_DIRECTORY"
-#define INDEX_ENVIRONMENT "PERF_INDEX_FILE"
-#define GRAFT_ENVIRONMENT "PERF_GRAFT_FILE"
-#define TEMPLATE_DIR_ENVIRONMENT "PERF_TEMPLATE_DIR"
-#define CONFIG_ENVIRONMENT "PERF_CONFIG"
 #define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
-#define CEILING_DIRECTORIES_ENVIRONMENT "PERF_CEILING_DIRECTORIES"
-#define PERFATTRIBUTES_FILE ".perfattributes"
-#define INFOATTRIBUTES_FILE "info/attributes"
-#define ATTRIBUTE_MACRO_PREFIX "[attr]"
+#define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
 #define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
-extern int perf_config_from_file(config_fn_t fn, const char *, void *);
 extern int perf_config(config_fn_t fn, void *);
-extern int perf_parse_ulong(const char *, unsigned long *);
 extern int perf_config_int(const char *, const char *);
-extern unsigned long perf_config_ulong(const char *, const char *);
-extern int perf_config_bool_or_int(const char *, const char *, int *);
 extern int perf_config_bool(const char *, const char *);
-extern int perf_config_string(const char **, const char *, const char *);
-extern int perf_config_set(const char *, const char *);
-extern int perf_config_set_multivar(const char *, const char *, const char *, int);
-extern int perf_config_rename_section(const char *, const char *);
-extern const char *perf_etc_perfconfig(void);
-extern int check_repository_format_version(const char *var, const char *value, void *cb);
-extern int perf_config_system(void);
-extern int perf_config_global(void);
 extern int config_error_nonbool(const char *);
-extern const char *config_exclusive_filename;
-
-#define MAX_PERFNAME (1000)
-extern char perf_default_email[MAX_PERFNAME];
-extern char perf_default_name[MAX_PERFNAME];
-extern int user_ident_explicitly_given;
-
-extern const char *perf_log_output_encoding;
-extern const char *perf_mailmap_file;
-
-/* IO helper functions */
-extern void maybe_flush_or_die(FILE *, const char *);
-extern int copy_fd(int ifd, int ofd);
-extern int copy_file(const char *dst, const char *src, int mode);
-extern ssize_t write_in_full(int fd, const void *buf, size_t count);
-extern void write_or_die(int fd, const void *buf, size_t count);
-extern int write_or_whine(int fd, const void *buf, size_t count, const char *msg);
-extern int write_or_whine_pipe(int fd, const void *buf, size_t count, const char *msg);
-extern void fsync_or_die(int fd, const char *);
 
 /* pager.c */
 extern void setup_pager(void);
@@ -70,7 +30,7 @@ extern const char *pager_program;
 extern int pager_in_use(void);
 extern int pager_use_color;
 
-extern bool use_browser;
+extern int use_browser;
 
 #ifdef NO_NEWT_SUPPORT
 static inline void setup_browser(void)
@@ -83,9 +43,6 @@ void setup_browser(void);
 void exit_browser(bool wait_for_ok);
 #endif
 
-extern const char *editor_program;
-extern const char *excludes_file;
-
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
 
@@ -115,22 +72,12 @@ static inline int is_absolute_path(const char *path)
 	return path[0] == '/';
 }
 
-const char *make_absolute_path(const char *path);
 const char *make_nonrelative_path(const char *path);
-const char *make_relative_path(const char *abs, const char *base);
-int normalize_path_copy(char *dst, const char *src);
-int longest_ancestor_length(const char *path, const char *prefix_list);
 char *strip_path_suffix(const char *path, const char *suffix);
 
 extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
 extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
-/* perf_mkstemp() - create tmp file honoring TMPDIR variable */
-extern int perf_mkstemp(char *path, size_t len, const char *template);
 
-extern char *mksnpath(char *buf, size_t n, const char *fmt, ...)
-	__attribute__((format (printf, 3, 4)));
-extern char *perf_snpath(char *buf, size_t n, const char *fmt, ...)
-	__attribute__((format (printf, 3, 4)));
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 21a52e0..62b69ad 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <math.h>
 
+#include "util.h"
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain, event_t *event)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1cba1f5..1ca73e4 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -5,7 +5,6 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include "event.h"
-#include "util.h"
 #include "symbol.h"
 
 enum chain_mode {
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 8784649..dabe892 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -16,7 +16,7 @@ static const char *config_file_name;
 static int config_linenr;
 static int config_file_eof;
 
-const char *config_exclusive_filename = NULL;
+static const char *config_exclusive_filename;
 
 static int get_next_char(void)
 {
@@ -291,19 +291,6 @@ static int perf_parse_long(const char *value, long *ret)
 	return 0;
 }
 
-int perf_parse_ulong(const char *value, unsigned long *ret)
-{
-	if (value && *value) {
-		char *end;
-		unsigned long val = strtoul(value, &end, 0);
-		if (!parse_unit_factor(end, &val))
-			return 0;
-		*ret = val;
-		return 1;
-	}
-	return 0;
-}
-
 static void die_bad_config(const char *name)
 {
 	if (config_file_name)
@@ -319,15 +306,7 @@ int perf_config_int(const char *name, const char *value)
 	return ret;
 }
 
-unsigned long perf_config_ulong(const char *name, const char *value)
-{
-	unsigned long ret;
-	if (!perf_parse_ulong(value, &ret))
-		die_bad_config(name);
-	return ret;
-}
-
-int perf_config_bool_or_int(const char *name, const char *value, int *is_bool)
+static int perf_config_bool_or_int(const char *name, const char *value, int *is_bool)
 {
 	*is_bool = 1;
 	if (!value)
@@ -348,14 +327,6 @@ int perf_config_bool(const char *name, const char *value)
 	return !!perf_config_bool_or_int(name, value, &discard);
 }
 
-int perf_config_string(const char **dest, const char *var, const char *value)
-{
-	if (!value)
-		return config_error_nonbool(var);
-	*dest = strdup(value);
-	return 0;
-}
-
 static int perf_default_core_config(const char *var __used, const char *value __used)
 {
 	/* Add other config variables here and to Documentation/config.txt. */
@@ -371,7 +342,7 @@ int perf_default_config(const char *var, const char *value, void *dummy __used)
 	return 0;
 }
 
-int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
+static int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
 {
 	int ret;
 	FILE *f = fopen(filename, "r");
@@ -389,7 +360,7 @@ int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
 	return ret;
 }
 
-const char *perf_etc_perfconfig(void)
+static const char *perf_etc_perfconfig(void)
 {
 	static const char *system_wide;
 	if (!system_wide)
@@ -403,12 +374,12 @@ static int perf_env_bool(const char *k, int def)
 	return v ? perf_config_bool(k, v) : def;
 }
 
-int perf_config_system(void)
+static int perf_config_system(void)
 {
 	return !perf_env_bool("PERF_CONFIG_NOSYSTEM", 0);
 }
 
-int perf_config_global(void)
+static int perf_config_global(void)
 {
 	return !perf_env_bool("PERF_CONFIG_NOGLOBAL", 0);
 }
@@ -450,426 +421,6 @@ int perf_config(config_fn_t fn, void *data)
 }
 
 /*
- * Find all the stuff for perf_config_set() below.
- */
-
-#define MAX_MATCHES 512
-
-static struct {
-	int baselen;
-	char* key;
-	int do_not_match;
-	regex_t* value_regex;
-	int multi_replace;
-	size_t offset[MAX_MATCHES];
-	enum { START, SECTION_SEEN, SECTION_END_SEEN, KEY_SEEN } state;
-	int seen;
-} store;
-
-static int matches(const char* key, const char* value)
-{
-	return !strcmp(key, store.key) &&
-		(store.value_regex == NULL ||
-		 (store.do_not_match ^
-		  !regexec(store.value_regex, value, 0, NULL, 0)));
-}
-
-static int store_aux(const char* key, const char* value, void *cb __used)
-{
-	int section_len;
-	const char *ep;
-
-	switch (store.state) {
-	case KEY_SEEN:
-		if (matches(key, value)) {
-			if (store.seen == 1 && store.multi_replace == 0) {
-				warning("%s has multiple values", key);
-			} else if (store.seen >= MAX_MATCHES) {
-				error("too many matches for %s", key);
-				return 1;
-			}
-
-			store.offset[store.seen] = ftell(config_file);
-			store.seen++;
-		}
-		break;
-	case SECTION_SEEN:
-		/*
-		 * What we are looking for is in store.key (both
-		 * section and var), and its section part is baselen
-		 * long.  We found key (again, both section and var).
-		 * We would want to know if this key is in the same
-		 * section as what we are looking for.  We already
-		 * know we are in the same section as what should
-		 * hold store.key.
-		 */
-		ep = strrchr(key, '.');
-		section_len = ep - key;
-
-		if ((section_len != store.baselen) ||
-		    memcmp(key, store.key, section_len+1)) {
-			store.state = SECTION_END_SEEN;
-			break;
-		}
-
-		/*
-		 * Do not increment matches: this is no match, but we
-		 * just made sure we are in the desired section.
-		 */
-		store.offset[store.seen] = ftell(config_file);
-		/* fallthru */
-	case SECTION_END_SEEN:
-	case START:
-		if (matches(key, value)) {
-			store.offset[store.seen] = ftell(config_file);
-			store.state = KEY_SEEN;
-			store.seen++;
-		} else {
-			if (strrchr(key, '.') - key == store.baselen &&
-			      !strncmp(key, store.key, store.baselen)) {
-					store.state = SECTION_SEEN;
-					store.offset[store.seen] = ftell(config_file);
-			}
-		}
-	default:
-		break;
-	}
-	return 0;
-}
-
-static int store_write_section(int fd, const char* key)
-{
-	const char *dot;
-	int i, success;
-	struct strbuf sb = STRBUF_INIT;
-
-	dot = memchr(key, '.', store.baselen);
-	if (dot) {
-		strbuf_addf(&sb, "[%.*s \"", (int)(dot - key), key);
-		for (i = dot - key + 1; i < store.baselen; i++) {
-			if (key[i] == '"' || key[i] == '\\')
-				strbuf_addch(&sb, '\\');
-			strbuf_addch(&sb, key[i]);
-		}
-		strbuf_addstr(&sb, "\"]\n");
-	} else {
-		strbuf_addf(&sb, "[%.*s]\n", store.baselen, key);
-	}
-
-	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
-	strbuf_release(&sb);
-
-	return success;
-}
-
-static int store_write_pair(int fd, const char* key, const char* value)
-{
-	int i, success;
-	int length = strlen(key + store.baselen + 1);
-	const char *quote = "";
-	struct strbuf sb = STRBUF_INIT;
-
-	/*
-	 * Check to see if the value needs to be surrounded with a dq pair.
-	 * Note that problematic characters are always backslash-quoted; this
-	 * check is about not losing leading or trailing SP and strings that
-	 * follow beginning-of-comment characters (i.e. ';' and '#') by the
-	 * configuration parser.
-	 */
-	if (value[0] == ' ')
-		quote = "\"";
-	for (i = 0; value[i]; i++)
-		if (value[i] == ';' || value[i] == '#')
-			quote = "\"";
-	if (i && value[i - 1] == ' ')
-		quote = "\"";
-
-	strbuf_addf(&sb, "\t%.*s = %s",
-		    length, key + store.baselen + 1, quote);
-
-	for (i = 0; value[i]; i++)
-		switch (value[i]) {
-		case '\n':
-			strbuf_addstr(&sb, "\\n");
-			break;
-		case '\t':
-			strbuf_addstr(&sb, "\\t");
-			break;
-		case '"':
-		case '\\':
-			strbuf_addch(&sb, '\\');
-		default:
-			strbuf_addch(&sb, value[i]);
-			break;
-		}
-	strbuf_addf(&sb, "%s\n", quote);
-
-	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
-	strbuf_release(&sb);
-
-	return success;
-}
-
-static ssize_t find_beginning_of_line(const char* contents, size_t size,
-	size_t offset_, int* found_bracket)
-{
-	size_t equal_offset = size, bracket_offset = size;
-	ssize_t offset;
-
-contline:
-	for (offset = offset_-2; offset > 0
-			&& contents[offset] != '\n'; offset--)
-		switch (contents[offset]) {
-			case '=': equal_offset = offset; break;
-			case ']': bracket_offset = offset; break;
-			default: break;
-		}
-	if (offset > 0 && contents[offset-1] == '\\') {
-		offset_ = offset;
-		goto contline;
-	}
-	if (bracket_offset < equal_offset) {
-		*found_bracket = 1;
-		offset = bracket_offset+1;
-	} else
-		offset++;
-
-	return offset;
-}
-
-int perf_config_set(const char* key, const char* value)
-{
-	return perf_config_set_multivar(key, value, NULL, 0);
-}
-
-/*
- * If value==NULL, unset in (remove from) config,
- * if value_regex!=NULL, disregard key/value pairs where value does not match.
- * if multi_replace==0, nothing, or only one matching key/value is replaced,
- *     else all matching key/values (regardless how many) are removed,
- *     before the new pair is written.
- *
- * Returns 0 on success.
- *
- * This function does this:
- *
- * - it locks the config file by creating ".perf/config.lock"
- *
- * - it then parses the config using store_aux() as validator to find
- *   the position on the key/value pair to replace. If it is to be unset,
- *   it must be found exactly once.
- *
- * - the config file is mmap()ed and the part before the match (if any) is
- *   written to the lock file, then the changed part and the rest.
- *
- * - the config file is removed and the lock file rename()d to it.
- *
- */
-int perf_config_set_multivar(const char* key, const char* value,
-	const char* value_regex, int multi_replace)
-{
-	int i, dot;
-	int fd = -1, in_fd;
-	int ret = 0;
-	char* config_filename;
-	const char* last_dot = strrchr(key, '.');
-
-	if (config_exclusive_filename)
-		config_filename = strdup(config_exclusive_filename);
-	else
-		config_filename = perf_pathdup("config");
-
-	/*
-	 * Since "key" actually contains the section name and the real
-	 * key name separated by a dot, we have to know where the dot is.
-	 */
-
-	if (last_dot == NULL) {
-		error("key does not contain a section: %s", key);
-		ret = 2;
-		goto out_free;
-	}
-	store.baselen = last_dot - key;
-
-	store.multi_replace = multi_replace;
-
-	/*
-	 * Validate the key and while at it, lower case it for matching.
-	 */
-	store.key = malloc(strlen(key) + 1);
-	dot = 0;
-	for (i = 0; key[i]; i++) {
-		unsigned char c = key[i];
-		if (c == '.')
-			dot = 1;
-		/* Leave the extended basename untouched.. */
-		if (!dot || i > store.baselen) {
-			if (!iskeychar(c) || (i == store.baselen+1 && !isalpha(c))) {
-				error("invalid key: %s", key);
-				free(store.key);
-				ret = 1;
-				goto out_free;
-			}
-			c = tolower(c);
-		} else if (c == '\n') {
-			error("invalid key (newline): %s", key);
-			free(store.key);
-			ret = 1;
-			goto out_free;
-		}
-		store.key[i] = c;
-	}
-	store.key[i] = 0;
-
-	/*
-	 * If .perf/config does not exist yet, write a minimal version.
-	 */
-	in_fd = open(config_filename, O_RDONLY);
-	if ( in_fd < 0 ) {
-		free(store.key);
-
-		if ( ENOENT != errno ) {
-			error("opening %s: %s", config_filename,
-			      strerror(errno));
-			ret = 3; /* same as "invalid config file" */
-			goto out_free;
-		}
-		/* if nothing to unset, error out */
-		if (value == NULL) {
-			ret = 5;
-			goto out_free;
-		}
-
-		store.key = (char*)key;
-		if (!store_write_section(fd, key) ||
-		    !store_write_pair(fd, key, value))
-			goto write_err_out;
-	} else {
-		struct stat st;
-		char *contents;
-		ssize_t contents_sz, copy_begin, copy_end;
-		int new_line = 0;
-
-		if (value_regex == NULL)
-			store.value_regex = NULL;
-		else {
-			if (value_regex[0] == '!') {
-				store.do_not_match = 1;
-				value_regex++;
-			} else
-				store.do_not_match = 0;
-
-			store.value_regex = (regex_t*)malloc(sizeof(regex_t));
-			if (regcomp(store.value_regex, value_regex,
-					REG_EXTENDED)) {
-				error("invalid pattern: %s", value_regex);
-				free(store.value_regex);
-				ret = 6;
-				goto out_free;
-			}
-		}
-
-		store.offset[0] = 0;
-		store.state = START;
-		store.seen = 0;
-
-		/*
-		 * After this, store.offset will contain the *end* offset
-		 * of the last match, or remain at 0 if no match was found.
-		 * As a side effect, we make sure to transform only a valid
-		 * existing config file.
-		 */
-		if (perf_config_from_file(store_aux, config_filename, NULL)) {
-			error("invalid config file %s", config_filename);
-			free(store.key);
-			if (store.value_regex != NULL) {
-				regfree(store.value_regex);
-				free(store.value_regex);
-			}
-			ret = 3;
-			goto out_free;
-		}
-
-		free(store.key);
-		if (store.value_regex != NULL) {
-			regfree(store.value_regex);
-			free(store.value_regex);
-		}
-
-		/* if nothing to unset, or too many matches, error out */
-		if ((store.seen == 0 && value == NULL) ||
-				(store.seen > 1 && multi_replace == 0)) {
-			ret = 5;
-			goto out_free;
-		}
-
-		fstat(in_fd, &st);
-		contents_sz = xsize_t(st.st_size);
-		contents = mmap(NULL, contents_sz, PROT_READ,
-			MAP_PRIVATE, in_fd, 0);
-		close(in_fd);
-
-		if (store.seen == 0)
-			store.seen = 1;
-
-		for (i = 0, copy_begin = 0; i < store.seen; i++) {
-			if (store.offset[i] == 0) {
-				store.offset[i] = copy_end = contents_sz;
-			} else if (store.state != KEY_SEEN) {
-				copy_end = store.offset[i];
-			} else
-				copy_end = find_beginning_of_line(
-					contents, contents_sz,
-					store.offset[i]-2, &new_line);
-
-			if (copy_end > 0 && contents[copy_end-1] != '\n')
-				new_line = 1;
-
-			/* write the first part of the config */
-			if (copy_end > copy_begin) {
-				if (write_in_full(fd, contents + copy_begin,
-						  copy_end - copy_begin) <
-				    copy_end - copy_begin)
-					goto write_err_out;
-				if (new_line &&
-				    write_in_full(fd, "\n", 1) != 1)
-					goto write_err_out;
-			}
-			copy_begin = store.offset[i];
-		}
-
-		/* write the pair (value == NULL means unset) */
-		if (value != NULL) {
-			if (store.state == START) {
-				if (!store_write_section(fd, key))
-					goto write_err_out;
-			}
-			if (!store_write_pair(fd, key, value))
-				goto write_err_out;
-		}
-
-		/* write the rest of the config */
-		if (copy_begin < contents_sz)
-			if (write_in_full(fd, contents + copy_begin,
-					  contents_sz - copy_begin) <
-			    contents_sz - copy_begin)
-				goto write_err_out;
-
-		munmap(contents, contents_sz);
-	}
-
-	ret = 0;
-
-out_free:
-	free(config_filename);
-	return ret;
-
-write_err_out:
-	goto out_free;
-
-}
-
-/*
  * Call this to report error for your variable that should not
  * get a boolean value (i.e. "[my] var" means "true").
  */
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 2745605..67eeff5 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -53,8 +53,8 @@ const char *perf_extract_argv0_path(const char *argv0)
 		slash--;
 
 	if (slash >= argv0) {
-		argv0_path = xstrndup(argv0, slash - argv0);
-		return slash + 1;
+		argv0_path = strndup(argv0, slash - argv0);
+		return argv0_path ? slash + 1 : NULL;
 	}
 
 	return argv0;
@@ -116,7 +116,7 @@ void setup_path(void)
 	strbuf_release(&new_path);
 }
 
-const char **prepare_perf_cmd(const char **argv)
+static const char **prepare_perf_cmd(const char **argv)
 {
 	int argc;
 	const char **nargv;
diff --git a/tools/perf/util/exec_cmd.h b/tools/perf/util/exec_cmd.h
index 31647ac..bc4b915 100644
--- a/tools/perf/util/exec_cmd.h
+++ b/tools/perf/util/exec_cmd.h
@@ -5,7 +5,6 @@ extern void perf_set_argv_exec_path(const char *exec_path);
 extern const char *perf_extract_argv0_path(const char *path);
 extern const char *perf_exec_path(void);
 extern void setup_path(void);
-extern const char **prepare_perf_cmd(const char **argv);
 extern int execv_perf_cmd(const char **argv); /* NULL terminated */
 extern int execl_perf_cmd(const char *cmd, ...);
 extern const char *system_path(const char *path);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8847bec..1f62435 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -221,29 +221,38 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 	return 0;
 }
 
+static int machine__write_buildid_table(struct machine *self, int fd)
+{
+	int err;
+	u16 kmisc = PERF_RECORD_MISC_KERNEL,
+	    umisc = PERF_RECORD_MISC_USER;
+
+	if (!machine__is_host(self)) {
+		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
+		umisc = PERF_RECORD_MISC_GUEST_USER;
+	}
+
+	err = __dsos__write_buildid_table(&self->kernel_dsos, self->pid,
+					  kmisc, fd);
+	if (err == 0)
+		err = __dsos__write_buildid_table(&self->user_dsos,
+						  self->pid, umisc, fd);
+	return err;
+}
+
 static int dsos__write_buildid_table(struct perf_header *header, int fd)
 {
 	struct perf_session *session = container_of(header,
 			struct perf_session, header);
 	struct rb_node *nd;
-	int err = 0;
-	u16 kmisc, umisc;
+	int err = machine__write_buildid_table(&session->host_machine, fd);
+
+	if (err)
+		return err;
 
 	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		if (machine__is_host(pos)) {
-			kmisc = PERF_RECORD_MISC_KERNEL;
-			umisc = PERF_RECORD_MISC_USER;
-		} else {
-			kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-			umisc = PERF_RECORD_MISC_GUEST_USER;
-		}
-
-		err = __dsos__write_buildid_table(&pos->kernel_dsos, pos->pid,
-						  kmisc, fd);
-		if (err == 0)
-			err = __dsos__write_buildid_table(&pos->user_dsos,
-							  pos->pid, umisc, fd);
+		err = machine__write_buildid_table(pos, fd);
 		if (err)
 			break;
 	}
@@ -363,12 +372,17 @@ static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
 	return err;
 }
 
-static int dsos__cache_build_ids(struct perf_header *self)
+static int machine__cache_build_ids(struct machine *self, const char *debugdir)
+{
+	int ret = __dsos__cache_build_ids(&self->kernel_dsos, debugdir);
+	ret |= __dsos__cache_build_ids(&self->user_dsos, debugdir);
+	return ret;
+}
+
+static int perf_session__cache_build_ids(struct perf_session *self)
 {
-	struct perf_session *session = container_of(self,
-			struct perf_session, header);
 	struct rb_node *nd;
-	int ret = 0;
+	int ret;
 	char debugdir[PATH_MAX];
 
 	snprintf(debugdir, sizeof(debugdir), "%s/%s", getenv("HOME"),
@@ -377,25 +391,30 @@ static int dsos__cache_build_ids(struct perf_header *self)
 	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
 		return -1;
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	ret = machine__cache_build_ids(&self->host_machine, debugdir);
+
+	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= __dsos__cache_build_ids(&pos->kernel_dsos, debugdir);
-		ret |= __dsos__cache_build_ids(&pos->user_dsos, debugdir);
+		ret |= machine__cache_build_ids(pos, debugdir);
 	}
 	return ret ? -1 : 0;
 }
 
-static bool dsos__read_build_ids(struct perf_header *self, bool with_hits)
+static bool machine__read_build_ids(struct machine *self, bool with_hits)
+{
+	bool ret = __dsos__read_build_ids(&self->kernel_dsos, with_hits);
+	ret |= __dsos__read_build_ids(&self->user_dsos, with_hits);
+	return ret;
+}
+
+static bool perf_session__read_build_ids(struct perf_session *self, bool with_hits)
 {
-	bool ret = false;
-	struct perf_session *session = container_of(self,
-			struct perf_session, header);
 	struct rb_node *nd;
+	bool ret = machine__read_build_ids(&self->host_machine, with_hits);
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= __dsos__read_build_ids(&pos->kernel_dsos, with_hits);
-		ret |= __dsos__read_build_ids(&pos->user_dsos, with_hits);
+		ret |= machine__read_build_ids(pos, with_hits);
 	}
 
 	return ret;
@@ -404,12 +423,14 @@ static bool dsos__read_build_ids(struct perf_header *self, bool with_hits)
 static int perf_header__adds_write(struct perf_header *self, int fd)
 {
 	int nr_sections;
+	struct perf_session *session;
 	struct perf_file_section *feat_sec;
 	int sec_size;
 	u64 sec_start;
 	int idx = 0, err;
 
-	if (dsos__read_build_ids(self, true))
+	session = container_of(self, struct perf_session, header);
+	if (perf_session__read_build_ids(session, true))
 		perf_header__set_feat(self, HEADER_BUILD_ID);
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
@@ -450,7 +471,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		}
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
 					  buildid_sec->offset;
-		dsos__cache_build_ids(self);
+		perf_session__cache_build_ids(session);
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
@@ -490,7 +511,6 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
-
 	for (i = 0; i < self->attrs; i++) {
 		attr = self->attr[i];
 
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index fbb0097..6f2975a 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -4,28 +4,6 @@
 #include "levenshtein.h"
 #include "help.h"
 
-/* most GUI terminals set COLUMNS (although some don't export it) */
-static int term_columns(void)
-{
-	char *col_string = getenv("COLUMNS");
-	int n_cols;
-
-	if (col_string && (n_cols = atoi(col_string)) > 0)
-		return n_cols;
-
-#ifdef TIOCGWINSZ
-	{
-		struct winsize ws;
-		if (!ioctl(1, TIOCGWINSZ, &ws)) {
-			if (ws.ws_col)
-				return ws.ws_col;
-		}
-	}
-#endif
-
-	return 80;
-}
-
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
 	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
@@ -96,9 +74,13 @@ static void pretty_print_string_list(struct cmdnames *cmds, int longest)
 {
 	int cols = 1, rows;
 	int space = longest + 1; /* min 1 SP between words */
-	int max_cols = term_columns() - 1; /* don't print *on* the edge */
+	struct winsize win;
+	int max_cols;
 	int i, j;
 
+	get_term_dimensions(&win);
+	max_cols = win.ws_col - 1; /* don't print *on* the edge */
+
 	if (space < max_cols)
 		cols = max_cols / space;
 	rows = (cmds->cnt + cols - 1) / cols;
@@ -324,7 +306,7 @@ const char *help_unknown_cmd(const char *cmd)
 
 		main_cmds.names[0] = NULL;
 		clean_cmdnames(&main_cmds);
-		fprintf(stderr, "WARNING: You called a Git program named '%s', "
+		fprintf(stderr, "WARNING: You called a perf program named '%s', "
 			"which does not exist.\n"
 			"Continuing under the assumption that you meant '%s'\n",
 			cmd, assumed);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9a71c94..cbf7eae 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,4 +1,5 @@
 #include "util.h"
+#include "build-id.h"
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
@@ -988,22 +989,42 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 	struct symbol *sym = self->ms.sym;
 	struct map *map = self->ms.map;
 	struct dso *dso = map->dso;
-	const char *filename = dso->long_name;
+	char *filename = dso__build_id_filename(dso, NULL, 0);
+	bool free_filename = true;
 	char command[PATH_MAX * 2];
 	FILE *file;
+	int err = 0;
 	u64 len;
 
-	if (!filename)
-		return -1;
+	if (filename == NULL) {
+		if (dso->has_build_id) {
+			pr_err("Can't annotate %s: not enough memory\n",
+			       sym->name);
+			return -ENOMEM;
+		}
+		goto fallback;
+	} else if (readlink(filename, command, sizeof(command)) < 0 ||
+		   strstr(command, "[kernel.kallsyms]") ||
+		   access(filename, R_OK)) {
+		free(filename);
+fallback:
+		/*
+		 * If we don't have build-ids or the build-id file isn't in the
+		 * cache, or is just a kallsyms file, well, lets hope that this
+		 * DSO is the same as when 'perf record' ran.
+		 */
+		filename = dso->long_name;
+		free_filename = false;
+	}
 
 	if (dso->origin == DSO__ORIG_KERNEL) {
 		if (dso->annotate_warned)
-			return 0;
+			goto out_free_filename;
+		err = -ENOENT;
 		dso->annotate_warned = 1;
 		pr_err("Can't annotate %s: No vmlinux file was found in the "
-		       "path:\n", sym->name);
-		vmlinux_path__fprintf(stderr);
-		return -1;
+		       "path\n", sym->name);
+		goto out_free_filename;
 	}
 
 	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
@@ -1025,14 +1046,17 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 
 	file = popen(command, "r");
 	if (!file)
-		return -1;
+		goto out_free_filename;
 
 	while (!feof(file))
 		if (hist_entry__parse_objdump_line(self, file, head) < 0)
 			break;
 
 	pclose(file);
-	return 0;
+out_free_filename:
+	if (free_filename)
+		free(filename);
+	return err;
 }
 
 void hists__inc_nr_events(struct hists *self, u32 type)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 6f17dcd..83fa33a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,12 +98,32 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread);
 #ifdef NO_NEWT_SUPPORT
 static inline int hists__browse(struct hists *self __used,
 				const char *helpline __used,
-				const char *input_name __used)
+				const char *ev_name __used)
 {
 	return 0;
 }
+
+static inline int hists__tui_browse_tree(struct rb_root *self __used,
+					 const char *help __used)
+{
+	return 0;
+}
+
+static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
+{
+	return 0;
+}
+#define KEY_LEFT -1
+#define KEY_RIGHT -2
 #else
+#include <newt.h>
 int hists__browse(struct hists *self, const char *helpline,
-		  const char *input_name);
+		  const char *ev_name);
+int hist_entry__tui_annotate(struct hist_entry *self);
+
+#define KEY_LEFT NEWT_KEY_LEFT
+#define KEY_RIGHT NEWT_KEY_RIGHT
+
+int hists__tui_browse_tree(struct rb_root *self, const char *help);
 #endif
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index ccb7c5b..d54c540 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1,7 +1,15 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #undef _GNU_SOURCE
-
+/*
+ * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
+ * the build if it isn't defined. Use the equivalent one that glibc
+ * has on features.h.
+ */
+#include <features.h>
+#ifndef HAVE_LONG_LONG
+#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
+#endif
 #include <slang.h>
 #include <stdlib.h>
 #include <newt.h>
@@ -227,6 +235,15 @@ static bool dialog_yesno(const char *msg)
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
 
+static void ui__error_window(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
+	va_end(ap);
+}
+
 #define HE_COLORSET_TOP		50
 #define HE_COLORSET_MEDIUM	51
 #define HE_COLORSET_NORMAL	52
@@ -375,8 +392,11 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
 	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
 	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
+	newtFormAddHotKey(self->form, ' ');
 	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddHotKey(self->form, NEWT_KEY_TAB);
+	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
 
 	if (ui_browser__refresh_entries(self) < 0)
 		return -1;
@@ -389,6 +409,8 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 
 		if (es->reason != NEWT_EXIT_HOTKEY)
 			break;
+		if (is_exit_key(es->u.key))
+			return es->u.key;
 		switch (es->u.key) {
 		case NEWT_KEY_DOWN:
 			if (self->index == self->nr_entries - 1)
@@ -411,6 +433,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 			}
 			break;
 		case NEWT_KEY_PGDN:
+		case ' ':
 			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
 				break;
 
@@ -461,12 +484,10 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 			}
 		}
 			break;
-		case NEWT_KEY_ESCAPE:
+		case NEWT_KEY_RIGHT:
 		case NEWT_KEY_LEFT:
-		case CTRL('c'):
-		case 'Q':
-		case 'q':
-			return 0;
+		case NEWT_KEY_TAB:
+			return es->u.key;
 		default:
 			continue;
 		}
@@ -658,18 +679,24 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 	return ret;
 }
 
-static void hist_entry__annotate_browser(struct hist_entry *self)
+int hist_entry__tui_annotate(struct hist_entry *self)
 {
 	struct ui_browser browser;
 	struct newtExitStruct es;
 	struct objdump_line *pos, *n;
 	LIST_HEAD(head);
+	int ret;
 
 	if (self->ms.sym == NULL)
-		return;
+		return -1;
 
-	if (hist_entry__annotate(self, &head) < 0)
-		return;
+	if (self->ms.map->dso->annotate_warned)
+		return -1;
+
+	if (hist_entry__annotate(self, &head) < 0) {
+		ui__error_window(browser__last_msg);
+		return -1;
+	}
 
 	ui_helpline__push("Press <- or ESC to exit");
 
@@ -684,7 +711,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	}
 
 	browser.width += 18; /* Percentage */
-	ui_browser__run(&browser, self->ms.sym->name, &es);
+	ret = ui_browser__run(&browser, self->ms.sym->name, &es);
 	newtFormDestroy(browser.form);
 	newtPopWindow();
 	list_for_each_entry_safe(pos, n, &head, node) {
@@ -692,6 +719,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 		objdump_line__free(pos);
 	}
 	ui_helpline__pop();
+	return ret;
 }
 
 static const void *newt__symbol_tree_get_current(newtComponent self)
@@ -814,6 +842,8 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	newtFormAddHotKey(self->form, 'h');
 	newtFormAddHotKey(self->form, NEWT_KEY_F1);
 	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
+	newtFormAddHotKey(self->form, NEWT_KEY_TAB);
+	newtFormAddHotKey(self->form, NEWT_KEY_UNTAB);
 	newtFormAddComponents(self->form, self->tree, NULL);
 	self->selection = newt__symbol_tree_get_current(self->tree);
 
@@ -845,7 +875,7 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 	return he ? he->thread : NULL;
 }
 
-static int hist_browser__title(char *bf, size_t size, const char *input_name,
+static int hist_browser__title(char *bf, size_t size, const char *ev_name,
 			       const struct dso *dso, const struct thread *thread)
 {
 	int printed = 0;
@@ -859,18 +889,18 @@ static int hist_browser__title(char *bf, size_t size, const char *input_name,
 		printed += snprintf(bf + printed, size - printed,
 				    "%sDSO: %s", thread ? " " : "",
 				    dso->short_name);
-	return printed ?: snprintf(bf, size, "Report: %s", input_name);
+	return printed ?: snprintf(bf, size, "Event: %s", ev_name);
 }
 
-int hists__browse(struct hists *self, const char *helpline, const char *input_name)
+int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 {
 	struct hist_browser *browser = hist_browser__new();
-	struct pstack *fstack = pstack__new(2);
+	struct pstack *fstack;
 	const struct thread *thread_filter = NULL;
 	const struct dso *dso_filter = NULL;
 	struct newtExitStruct es;
 	char msg[160];
-	int err = -1;
+	int key = -1;
 
 	if (browser == NULL)
 		return -1;
@@ -881,7 +911,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 
 	ui_helpline__push(helpline);
 
-	hist_browser__title(msg, sizeof(msg), input_name,
+	hist_browser__title(msg, sizeof(msg), ev_name,
 			    dso_filter, thread_filter);
 	if (hist_browser__populate(browser, self, msg) < 0)
 		goto out_free_stack;
@@ -899,11 +929,27 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 		dso = browser->selection->map ? browser->selection->map->dso : NULL;
 
 		if (es.reason == NEWT_EXIT_HOTKEY) {
-			if (es.u.key == NEWT_KEY_F1)
+			key = es.u.key;
+
+			switch (key) {
+			case NEWT_KEY_F1:
 				goto do_help;
+			case NEWT_KEY_TAB:
+			case NEWT_KEY_UNTAB:
+				/*
+				 * Exit the browser, let hists__browser_tree
+				 * go to the next or previous
+				 */
+				goto out_free_stack;
+			default:;
+			}
 
-			switch (toupper(es.u.key)) {
+			key = toupper(key);
+			switch (key) {
 			case 'A':
+				if (browser->selection->map == NULL &&
+				    browser->selection->map->dso->annotate_warned)
+					continue;
 				goto do_annotate;
 			case 'D':
 				goto zoom_dso;
@@ -922,14 +968,14 @@ do_help:
 				continue;
 			default:;
 			}
-			if (toupper(es.u.key) == 'Q' ||
-			    es.u.key == CTRL('c'))
-				break;
-			if (es.u.key == NEWT_KEY_ESCAPE) {
-				if (dialog_yesno("Do you really want to exit?"))
+			if (is_exit_key(key)) {
+				if (key == NEWT_KEY_ESCAPE) {
+					if (dialog_yesno("Do you really want to exit?"))
+						break;
+					else
+						continue;
+				} else
 					break;
-				else
-					continue;
 			}
 
 			if (es.u.key == NEWT_KEY_LEFT) {
@@ -947,6 +993,7 @@ do_help:
 		}
 
 		if (browser->selection->sym != NULL &&
+		    !browser->selection->map->dso->annotate_warned &&
 		    asprintf(&options[nr_options], "Annotate %s",
 			     browser->selection->sym->name) > 0)
 			annotate = nr_options++;
@@ -981,6 +1028,7 @@ do_help:
 			struct hist_entry *he;
 do_annotate:
 			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
+				browser->selection->map->dso->annotate_warned = 1;
 				ui_helpline__puts("No vmlinux file found, can't "
 						 "annotate with just a "
 						 "kallsyms file");
@@ -991,7 +1039,7 @@ do_annotate:
 			if (he == NULL)
 				continue;
 
-			hist_entry__annotate_browser(he);
+			hist_entry__tui_annotate(he);
 		} else if (choice == zoom_dso) {
 zoom_dso:
 			if (dso_filter) {
@@ -1008,7 +1056,7 @@ zoom_out_dso:
 				pstack__push(fstack, &dso_filter);
 			}
 			hists__filter_by_dso(self, dso_filter);
-			hist_browser__title(msg, sizeof(msg), input_name,
+			hist_browser__title(msg, sizeof(msg), ev_name,
 					    dso_filter, thread_filter);
 			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
@@ -1027,18 +1075,49 @@ zoom_out_thread:
 				pstack__push(fstack, &thread_filter);
 			}
 			hists__filter_by_thread(self, thread_filter);
-			hist_browser__title(msg, sizeof(msg), input_name,
+			hist_browser__title(msg, sizeof(msg), ev_name,
 					    dso_filter, thread_filter);
 			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
 		}
 	}
-	err = 0;
 out_free_stack:
 	pstack__delete(fstack);
 out:
 	hist_browser__delete(browser);
-	return err;
+	return key;
+}
+
+int hists__tui_browse_tree(struct rb_root *self, const char *help)
+{
+	struct rb_node *first = rb_first(self), *nd = first, *next;
+	int key = 0;
+
+	while (nd) {
+		struct hists *hists = rb_entry(nd, struct hists, rb_node);
+		const char *ev_name = __event_name(hists->type, hists->config);
+
+		key = hists__browse(hists, help, ev_name);
+
+		if (is_exit_key(key))
+			break;
+
+		switch (key) {
+		case NEWT_KEY_TAB:
+			next = rb_next(nd);
+			if (next)
+				nd = next;
+			break;
+		case NEWT_KEY_UNTAB:
+			if (nd == first)
+				continue;
+			nd = rb_prev(nd);
+		default:
+			break;
+		}
+	}
+
+	return key;
 }
 
 static struct newtPercentTreeColors {
@@ -1058,10 +1137,13 @@ static struct newtPercentTreeColors {
 void setup_browser(void)
 {
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
-	if (!isatty(1))
+
+	if (!isatty(1) || !use_browser || dump_trace) {
+		setup_pager();
 		return;
+	}
 
-	use_browser = true;
+	use_browser = 1;
 	newtInit();
 	newtCls();
 	ui_helpline__puts(" ");
@@ -1074,7 +1156,7 @@ void setup_browser(void)
 
 void exit_browser(bool wait_for_ok)
 {
-	if (use_browser) {
+	if (use_browser > 0) {
 		if (wait_for_ok) {
 			char title[] = "Fatal Error", ok[] = "Ok";
 			newtWinMessage(title, ok, browser__last_msg);
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index fd1f2fa..58a470d 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -54,21 +54,6 @@ static char *cleanup_path(char *path)
 	return path;
 }
 
-char *mksnpath(char *buf, size_t n, const char *fmt, ...)
-{
-	va_list args;
-	unsigned len;
-
-	va_start(args, fmt);
-	len = vsnprintf(buf, n, fmt, args);
-	va_end(args);
-	if (len >= n) {
-		strlcpy(buf, bad_path, n);
-		return buf;
-	}
-	return cleanup_path(buf);
-}
-
 static char *perf_vsnpath(char *buf, size_t n, const char *fmt, va_list args)
 {
 	const char *perf_dir = get_perf_dir();
@@ -89,15 +74,6 @@ bad:
 	return buf;
 }
 
-char *perf_snpath(char *buf, size_t n, const char *fmt, ...)
-{
-	va_list args;
-	va_start(args, fmt);
-	(void)perf_vsnpath(buf, n, fmt, args);
-	va_end(args);
-	return buf;
-}
-
 char *perf_pathdup(const char *fmt, ...)
 {
 	char path[PATH_MAX];
@@ -143,184 +119,6 @@ char *perf_path(const char *fmt, ...)
 	return cleanup_path(pathname);
 }
 
-
-/* perf_mkstemp() - create tmp file honoring TMPDIR variable */
-int perf_mkstemp(char *path, size_t len, const char *template)
-{
-	const char *tmp;
-	size_t n;
-
-	tmp = getenv("TMPDIR");
-	if (!tmp)
-		tmp = "/tmp";
-	n = snprintf(path, len, "%s/%s", tmp, template);
-	if (len <= n) {
-		errno = ENAMETOOLONG;
-		return -1;
-	}
-	return mkstemp(path);
-}
-
-
-const char *make_relative_path(const char *abs_path, const char *base)
-{
-	static char buf[PATH_MAX + 1];
-	int baselen;
-
-	if (!base)
-		return abs_path;
-
-	baselen = strlen(base);
-	if (prefixcmp(abs_path, base))
-		return abs_path;
-	if (abs_path[baselen] == '/')
-		baselen++;
-	else if (base[baselen - 1] != '/')
-		return abs_path;
-
-	strcpy(buf, abs_path + baselen);
-
-	return buf;
-}
-
-/*
- * It is okay if dst == src, but they should not overlap otherwise.
- *
- * Performs the following normalizations on src, storing the result in dst:
- * - Ensures that components are separated by '/' (Windows only)
- * - Squashes sequences of '/'.
- * - Removes "." components.
- * - Removes ".." components, and the components the precede them.
- * Returns failure (non-zero) if a ".." component appears as first path
- * component anytime during the normalization. Otherwise, returns success (0).
- *
- * Note that this function is purely textual.  It does not follow symlinks,
- * verify the existence of the path, or make any system calls.
- */
-int normalize_path_copy(char *dst, const char *src)
-{
-	char *dst0;
-
-	if (has_dos_drive_prefix(src)) {
-		*dst++ = *src++;
-		*dst++ = *src++;
-	}
-	dst0 = dst;
-
-	if (is_dir_sep(*src)) {
-		*dst++ = '/';
-		while (is_dir_sep(*src))
-			src++;
-	}
-
-	for (;;) {
-		char c = *src;
-
-		/*
-		 * A path component that begins with . could be
-		 * special:
-		 * (1) "." and ends   -- ignore and terminate.
-		 * (2) "./"           -- ignore them, eat slash and continue.
-		 * (3) ".." and ends  -- strip one and terminate.
-		 * (4) "../"          -- strip one, eat slash and continue.
-		 */
-		if (c == '.') {
-			if (!src[1]) {
-				/* (1) */
-				src++;
-			} else if (is_dir_sep(src[1])) {
-				/* (2) */
-				src += 2;
-				while (is_dir_sep(*src))
-					src++;
-				continue;
-			} else if (src[1] == '.') {
-				if (!src[2]) {
-					/* (3) */
-					src += 2;
-					goto up_one;
-				} else if (is_dir_sep(src[2])) {
-					/* (4) */
-					src += 3;
-					while (is_dir_sep(*src))
-						src++;
-					goto up_one;
-				}
-			}
-		}
-
-		/* copy up to the next '/', and eat all '/' */
-		while ((c = *src++) != '\0' && !is_dir_sep(c))
-			*dst++ = c;
-		if (is_dir_sep(c)) {
-			*dst++ = '/';
-			while (is_dir_sep(c))
-				c = *src++;
-			src--;
-		} else if (!c)
-			break;
-		continue;
-
-	up_one:
-		/*
-		 * dst0..dst is prefix portion, and dst[-1] is '/';
-		 * go up one level.
-		 */
-		dst--;	/* go to trailing '/' */
-		if (dst <= dst0)
-			return -1;
-		/* Windows: dst[-1] cannot be backslash anymore */
-		while (dst0 < dst && dst[-1] != '/')
-			dst--;
-	}
-	*dst = '\0';
-	return 0;
-}
-
-/*
- * path = Canonical absolute path
- * prefix_list = Colon-separated list of absolute paths
- *
- * Determines, for each path in prefix_list, whether the "prefix" really
- * is an ancestor directory of path.  Returns the length of the longest
- * ancestor directory, excluding any trailing slashes, or -1 if no prefix
- * is an ancestor.  (Note that this means 0 is returned if prefix_list is
- * "/".) "/foo" is not considered an ancestor of "/foobar".  Directories
- * are not considered to be their own ancestors.  path must be in a
- * canonical form: empty components, or "." or ".." components are not
- * allowed.  prefix_list may be null, which is like "".
- */
-int longest_ancestor_length(const char *path, const char *prefix_list)
-{
-	char buf[PATH_MAX+1];
-	const char *ceil, *colon;
-	int len, max_len = -1;
-
-	if (prefix_list == NULL || !strcmp(path, "/"))
-		return -1;
-
-	for (colon = ceil = prefix_list; *colon; ceil = colon+1) {
-		for (colon = ceil; *colon && *colon != PATH_SEP; colon++);
-		len = colon - ceil;
-		if (len == 0 || len > PATH_MAX || !is_absolute_path(ceil))
-			continue;
-		strlcpy(buf, ceil, len+1);
-		if (normalize_path_copy(buf, buf) < 0)
-			continue;
-		len = strlen(buf);
-		if (len > 0 && buf[len-1] == '/')
-			buf[--len] = '\0';
-
-		if (!strncmp(path, buf, len) &&
-		    path[len] == '/' &&
-		    len > max_len) {
-			max_len = len;
-		}
-	}
-
-	return max_len;
-}
-
 /* strip arbitrary amount of directory separators at end of path */
 static inline int chomp_trailing_dir_sep(const char *path, int len)
 {
@@ -354,5 +152,5 @@ char *strip_path_suffix(const char *path, const char *suffix)
 
 	if (path_len && !is_dir_sep(path[path_len - 1]))
 		return NULL;
-	return xstrndup(path, chomp_trailing_dir_sep(path, path_len));
+	return strndup(path, chomp_trailing_dir_sep(path, path_len));
 }
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 562b144..d964cb1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -668,6 +668,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
 	if (ret <= 0 || nops == 0) {
 		pf->fb_ops = NULL;
+#if _ELFUTILS_PREREQ(0, 142)
 	} else if (nops == 1 && pf->fb_ops[0].atom == DW_OP_call_frame_cfa &&
 		   pf->cfi != NULL) {
 		Dwarf_Frame *frame;
@@ -677,6 +678,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 				   (uintmax_t)pf->addr);
 			return -ENOENT;
 		}
+#endif
 	}
 
 	/* Find each argument */
@@ -741,32 +743,36 @@ static int find_lazy_match_lines(struct list_head *head,
 				 const char *fname, const char *pat)
 {
 	char *fbuf, *p1, *p2;
-	int fd, ret, line, nlines = 0;
+	int fd, line, nlines = -1;
 	struct stat st;
 
 	fd = open(fname, O_RDONLY);
 	if (fd < 0) {
 		pr_warning("Failed to open %s: %s\n", fname, strerror(-fd));
-		return fd;
+		return -errno;
 	}
 
-	ret = fstat(fd, &st);
-	if (ret < 0) {
+	if (fstat(fd, &st) < 0) {
 		pr_warning("Failed to get the size of %s: %s\n",
 			   fname, strerror(errno));
-		return ret;
+		nlines = -errno;
+		goto out_close;
 	}
-	fbuf = xmalloc(st.st_size + 2);
-	ret = read(fd, fbuf, st.st_size);
-	if (ret < 0) {
+
+	nlines = -ENOMEM;
+	fbuf = malloc(st.st_size + 2);
+	if (fbuf == NULL)
+		goto out_close;
+	if (read(fd, fbuf, st.st_size) < 0) {
 		pr_warning("Failed to read %s: %s\n", fname, strerror(errno));
-		return ret;
+		nlines = -errno;
+		goto out_free_fbuf;
 	}
-	close(fd);
 	fbuf[st.st_size] = '\n';	/* Dummy line */
 	fbuf[st.st_size + 1] = '\0';
 	p1 = fbuf;
 	line = 1;
+	nlines = 0;
 	while ((p2 = strchr(p1, '\n')) != NULL) {
 		*p2 = '\0';
 		if (strlazymatch(p1, pat)) {
@@ -776,7 +782,10 @@ static int find_lazy_match_lines(struct list_head *head,
 		line++;
 		p1 = p2 + 1;
 	}
+out_free_fbuf:
 	free(fbuf);
+out_close:
+	close(fd);
 	return nlines;
 }
 
@@ -953,11 +962,15 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	if (!dbg) {
 		pr_warning("No dwarf info found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		free(pf.tevs);
+		*tevs = NULL;
 		return -EBADF;
 	}
 
+#if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
 	pf.cfi = dwarf_getcfi(dbg);
+#endif
 
 	off = 0;
 	line_list__init(&pf.lcache);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 66f1980..e1f61dc 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -29,6 +29,7 @@ extern int find_line_range(int fd, struct line_range *lr);
 
 #include <dwarf.h>
 #include <libdw.h>
+#include <version.h>
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
@@ -44,7 +45,9 @@ struct probe_finder {
 	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
+#if _ELFUTILS_PREREQ(0, 142)
 	Dwarf_CFI		*cfi;		/* Call Frame Information */
+#endif
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
 	struct kprobe_trace_arg	*tvar;		/* Current result variable */
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index 2726fe4..01f0324 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -1,8 +1,6 @@
 #include "cache.h"
 #include "quote.h"
 
-int quote_path_fully = 1;
-
 /* Help to copy the thing properly quoted for the shell safety.
  * any single quote is replaced with '\'', any exclamation point
  * is replaced with '\!', and the whole thing is enclosed in a
@@ -19,7 +17,7 @@ static inline int need_bs_quote(char c)
 	return (c == '\'' || c == '!');
 }
 
-void sq_quote_buf(struct strbuf *dst, const char *src)
+static void sq_quote_buf(struct strbuf *dst, const char *src)
 {
 	char *to_free = NULL;
 
@@ -41,23 +39,6 @@ void sq_quote_buf(struct strbuf *dst, const char *src)
 	free(to_free);
 }
 
-void sq_quote_print(FILE *stream, const char *src)
-{
-	char c;
-
-	fputc('\'', stream);
-	while ((c = *src++)) {
-		if (need_bs_quote(c)) {
-			fputs("'\\", stream);
-			fputc(c, stream);
-			fputc('\'', stream);
-		} else {
-			fputc(c, stream);
-		}
-	}
-	fputc('\'', stream);
-}
-
 void sq_quote_argv(struct strbuf *dst, const char** argv, size_t maxlen)
 {
 	int i;
@@ -71,415 +52,3 @@ void sq_quote_argv(struct strbuf *dst, const char** argv, size_t maxlen)
 			die("Too many or long arguments");
 	}
 }
-
-char *sq_dequote_step(char *arg, char **next)
-{
-	char *dst = arg;
-	char *src = arg;
-	char c;
-
-	if (*src != '\'')
-		return NULL;
-	for (;;) {
-		c = *++src;
-		if (!c)
-			return NULL;
-		if (c != '\'') {
-			*dst++ = c;
-			continue;
-		}
-		/* We stepped out of sq */
-		switch (*++src) {
-		case '\0':
-			*dst = 0;
-			if (next)
-				*next = NULL;
-			return arg;
-		case '\\':
-			c = *++src;
-			if (need_bs_quote(c) && *++src == '\'') {
-				*dst++ = c;
-				continue;
-			}
-		/* Fallthrough */
-		default:
-			if (!next || !isspace(*src))
-				return NULL;
-			do {
-				c = *++src;
-			} while (isspace(c));
-			*dst = 0;
-			*next = src;
-			return arg;
-		}
-	}
-}
-
-char *sq_dequote(char *arg)
-{
-	return sq_dequote_step(arg, NULL);
-}
-
-int sq_dequote_to_argv(char *arg, const char ***argv, int *nr, int *alloc)
-{
-	char *next = arg;
-
-	if (!*arg)
-		return 0;
-	do {
-		char *dequoted = sq_dequote_step(next, &next);
-		if (!dequoted)
-			return -1;
-		ALLOC_GROW(*argv, *nr + 1, *alloc);
-		(*argv)[(*nr)++] = dequoted;
-	} while (next);
-
-	return 0;
-}
-
-/* 1 means: quote as octal
- * 0 means: quote as octal if (quote_path_fully)
- * -1 means: never quote
- * c: quote as "\\c"
- */
-#define X8(x)   x, x, x, x, x, x, x, x
-#define X16(x)  X8(x), X8(x)
-static signed char const sq_lookup[256] = {
-	/*           0    1    2    3    4    5    6    7 */
-	/* 0x00 */   1,   1,   1,   1,   1,   1,   1, 'a',
-	/* 0x08 */ 'b', 't', 'n', 'v', 'f', 'r',   1,   1,
-	/* 0x10 */ X16(1),
-	/* 0x20 */  -1,  -1, '"',  -1,  -1,  -1,  -1,  -1,
-	/* 0x28 */ X16(-1), X16(-1), X16(-1),
-	/* 0x58 */  -1,  -1,  -1,  -1,'\\',  -1,  -1,  -1,
-	/* 0x60 */ X16(-1), X8(-1),
-	/* 0x78 */  -1,  -1,  -1,  -1,  -1,  -1,  -1,   1,
-	/* 0x80 */ /* set to 0 */
-};
-
-static inline int sq_must_quote(char c)
-{
-	return sq_lookup[(unsigned char)c] + quote_path_fully > 0;
-}
-
-/*
- * Returns the longest prefix not needing a quote up to maxlen if
- * positive.
- * This stops at the first \0 because it's marked as a character
- * needing an escape.
- */
-static ssize_t next_quote_pos(const char *s, ssize_t maxlen)
-{
-	ssize_t len;
-
-	if (maxlen < 0) {
-		for (len = 0; !sq_must_quote(s[len]); len++);
-	} else {
-		for (len = 0; len < maxlen && !sq_must_quote(s[len]); len++);
-	}
-	return len;
-}
-
-/*
- * C-style name quoting.
- *
- * (1) if sb and fp are both NULL, inspect the input name and counts the
- *     number of bytes that are needed to hold c_style quoted version of name,
- *     counting the double quotes around it but not terminating NUL, and
- *     returns it.
- *     However, if name does not need c_style quoting, it returns 0.
- *
- * (2) if sb or fp are not NULL, it emits the c_style quoted version
- *     of name, enclosed with double quotes if asked and needed only.
- *     Return value is the same as in (1).
- */
-static size_t quote_c_style_counted(const char *name, ssize_t maxlen,
-                                    struct strbuf *sb, FILE *fp, int no_dq)
-{
-#define EMIT(c)							\
-	do {							\
-		if (sb) strbuf_addch(sb, (c));			\
-		if (fp) fputc((c), fp);				\
-		count++;					\
-	} while (0)
-
-#define EMITBUF(s, l)						\
-	do {							\
-		int __ret;					\
-		if (sb) strbuf_add(sb, (s), (l));		\
-		if (fp) __ret = fwrite((s), (l), 1, fp);	\
-		count += (l);					\
-	} while (0)
-
-	ssize_t len, count = 0;
-	const char *p = name;
-
-	for (;;) {
-		int ch;
-
-		len = next_quote_pos(p, maxlen);
-		if (len == maxlen || !p[len])
-			break;
-
-		if (!no_dq && p == name)
-			EMIT('"');
-
-		EMITBUF(p, len);
-		EMIT('\\');
-		p += len;
-		ch = (unsigned char)*p++;
-		if (sq_lookup[ch] >= ' ') {
-			EMIT(sq_lookup[ch]);
-		} else {
-			EMIT(((ch >> 6) & 03) + '0');
-			EMIT(((ch >> 3) & 07) + '0');
-			EMIT(((ch >> 0) & 07) + '0');
-		}
-	}
-
-	EMITBUF(p, len);
-	if (p == name)   /* no ending quote needed */
-		return 0;
-
-	if (!no_dq)
-		EMIT('"');
-	return count;
-}
-
-size_t quote_c_style(const char *name, struct strbuf *sb, FILE *fp, int nodq)
-{
-	return quote_c_style_counted(name, -1, sb, fp, nodq);
-}
-
-void quote_two_c_style(struct strbuf *sb, const char *prefix, const char *path, int nodq)
-{
-	if (quote_c_style(prefix, NULL, NULL, 0) ||
-	    quote_c_style(path, NULL, NULL, 0)) {
-		if (!nodq)
-			strbuf_addch(sb, '"');
-		quote_c_style(prefix, sb, NULL, 1);
-		quote_c_style(path, sb, NULL, 1);
-		if (!nodq)
-			strbuf_addch(sb, '"');
-	} else {
-		strbuf_addstr(sb, prefix);
-		strbuf_addstr(sb, path);
-	}
-}
-
-void write_name_quoted(const char *name, FILE *fp, int terminator)
-{
-	if (terminator) {
-		quote_c_style(name, NULL, fp, 0);
-	} else {
-		fputs(name, fp);
-	}
-	fputc(terminator, fp);
-}
-
-void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
-			  const char *name, FILE *fp, int terminator)
-{
-	int needquote = 0;
-
-	if (terminator) {
-		needquote = next_quote_pos(pfx, pfxlen) < pfxlen
-			|| name[next_quote_pos(name, -1)];
-	}
-	if (needquote) {
-		fputc('"', fp);
-		quote_c_style_counted(pfx, pfxlen, NULL, fp, 1);
-		quote_c_style(name, NULL, fp, 1);
-		fputc('"', fp);
-	} else {
-		int ret;
-
-		ret = fwrite(pfx, pfxlen, 1, fp);
-		fputs(name, fp);
-	}
-	fputc(terminator, fp);
-}
-
-/* quote path as relative to the given prefix */
-char *quote_path_relative(const char *in, int len,
-			  struct strbuf *out, const char *prefix)
-{
-	int needquote;
-
-	if (len < 0)
-		len = strlen(in);
-
-	/* "../" prefix itself does not need quoting, but "in" might. */
-	needquote = (next_quote_pos(in, len) < len);
-	strbuf_setlen(out, 0);
-	strbuf_grow(out, len);
-
-	if (needquote)
-		strbuf_addch(out, '"');
-	if (prefix) {
-		int off = 0;
-		while (off < len && prefix[off] && prefix[off] == in[off])
-			if (prefix[off] == '/') {
-				prefix += off + 1;
-				in += off + 1;
-				len -= off + 1;
-				off = 0;
-			} else
-				off++;
-
-		for (; *prefix; prefix++)
-			if (*prefix == '/')
-				strbuf_addstr(out, "../");
-	}
-
-	quote_c_style_counted (in, len, out, NULL, 1);
-
-	if (needquote)
-		strbuf_addch(out, '"');
-	if (!out->len)
-		strbuf_addstr(out, "./");
-
-	return out->buf;
-}
-
-/*
- * C-style name unquoting.
- *
- * Quoted should point at the opening double quote.
- * + Returns 0 if it was able to unquote the string properly, and appends the
- *   result in the strbuf `sb'.
- * + Returns -1 in case of error, and doesn't touch the strbuf. Though note
- *   that this function will allocate memory in the strbuf, so calling
- *   strbuf_release is mandatory whichever result unquote_c_style returns.
- *
- * Updates endp pointer to point at one past the ending double quote if given.
- */
-int unquote_c_style(struct strbuf *sb, const char *quoted, const char **endp)
-{
-	size_t oldlen = sb->len, len;
-	int ch, ac;
-
-	if (*quoted++ != '"')
-		return -1;
-
-	for (;;) {
-		len = strcspn(quoted, "\"\\");
-		strbuf_add(sb, quoted, len);
-		quoted += len;
-
-		switch (*quoted++) {
-		  case '"':
-			if (endp)
-				*endp = quoted;
-			return 0;
-		  case '\\':
-			break;
-		  default:
-			goto error;
-		}
-
-		switch ((ch = *quoted++)) {
-		case 'a': ch = '\a'; break;
-		case 'b': ch = '\b'; break;
-		case 'f': ch = '\f'; break;
-		case 'n': ch = '\n'; break;
-		case 'r': ch = '\r'; break;
-		case 't': ch = '\t'; break;
-		case 'v': ch = '\v'; break;
-
-		case '\\': case '"':
-			break; /* verbatim */
-
-		/* octal values with first digit over 4 overflow */
-		case '0': case '1': case '2': case '3':
-					ac = ((ch - '0') << 6);
-			if ((ch = *quoted++) < '0' || '7' < ch)
-				goto error;
-					ac |= ((ch - '0') << 3);
-			if ((ch = *quoted++) < '0' || '7' < ch)
-				goto error;
-					ac |= (ch - '0');
-					ch = ac;
-					break;
-				default:
-			goto error;
-			}
-		strbuf_addch(sb, ch);
-		}
-
-  error:
-	strbuf_setlen(sb, oldlen);
-	return -1;
-}
-
-/* quoting as a string literal for other languages */
-
-void perl_quote_print(FILE *stream, const char *src)
-{
-	const char sq = '\'';
-	const char bq = '\\';
-	char c;
-
-	fputc(sq, stream);
-	while ((c = *src++)) {
-		if (c == sq || c == bq)
-			fputc(bq, stream);
-		fputc(c, stream);
-	}
-	fputc(sq, stream);
-}
-
-void python_quote_print(FILE *stream, const char *src)
-{
-	const char sq = '\'';
-	const char bq = '\\';
-	const char nl = '\n';
-	char c;
-
-	fputc(sq, stream);
-	while ((c = *src++)) {
-		if (c == nl) {
-			fputc(bq, stream);
-			fputc('n', stream);
-			continue;
-		}
-		if (c == sq || c == bq)
-			fputc(bq, stream);
-		fputc(c, stream);
-	}
-	fputc(sq, stream);
-}
-
-void tcl_quote_print(FILE *stream, const char *src)
-{
-	char c;
-
-	fputc('"', stream);
-	while ((c = *src++)) {
-		switch (c) {
-		case '[': case ']':
-		case '{': case '}':
-		case '$': case '\\': case '"':
-			fputc('\\', stream);
-		default:
-			fputc(c, stream);
-			break;
-		case '\f':
-			fputs("\\f", stream);
-			break;
-		case '\r':
-			fputs("\\r", stream);
-			break;
-		case '\n':
-			fputs("\\n", stream);
-			break;
-		case '\t':
-			fputs("\\t", stream);
-			break;
-		case '\v':
-			fputs("\\v", stream);
-			break;
-		}
-	}
-	fputc('"', stream);
-}
diff --git a/tools/perf/util/quote.h b/tools/perf/util/quote.h
index b6a0197..172889e 100644
--- a/tools/perf/util/quote.h
+++ b/tools/perf/util/quote.h
@@ -22,47 +22,8 @@
  *
  * Note that the above examples leak memory!  Remember to free result from
  * sq_quote() in a real application.
- *
- * sq_quote_buf() writes to an existing buffer of specified size; it
- * will return the number of characters that would have been written
- * excluding the final null regardless of the buffer size.
  */
 
-extern void sq_quote_print(FILE *stream, const char *src);
-
-extern void sq_quote_buf(struct strbuf *, const char *src);
 extern void sq_quote_argv(struct strbuf *, const char **argv, size_t maxlen);
 
-/* This unwraps what sq_quote() produces in place, but returns
- * NULL if the input does not look like what sq_quote would have
- * produced.
- */
-extern char *sq_dequote(char *);
-
-/*
- * Same as the above, but can be used to unwrap many arguments in the
- * same string separated by space. "next" is changed to point to the
- * next argument that should be passed as first parameter. When there
- * is no more argument to be dequoted, "next" is updated to point to NULL.
- */
-extern char *sq_dequote_step(char *arg, char **next);
-extern int sq_dequote_to_argv(char *arg, const char ***argv, int *nr, int *alloc);
-
-extern int unquote_c_style(struct strbuf *, const char *quoted, const char **endp);
-extern size_t quote_c_style(const char *name, struct strbuf *, FILE *, int no_dq);
-extern void quote_two_c_style(struct strbuf *, const char *, const char *, int);
-
-extern void write_name_quoted(const char *name, FILE *, int terminator);
-extern void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
-                                 const char *name, FILE *, int terminator);
-
-/* quote path as relative to the given prefix */
-char *quote_path_relative(const char *in, int len,
-			  struct strbuf *out, const char *prefix);
-
-/* quoting as a string literal for other languages */
-extern void perl_quote_print(FILE *stream, const char *src);
-extern void python_quote_print(FILE *stream, const char *src);
-extern void tcl_quote_print(FILE *stream, const char *src);
-
 #endif /* __PERF_QUOTE_H */
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index 2b615ac..da8e9b2 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -212,93 +212,3 @@ int run_command_v_opt(const char **argv, int opt)
 	prepare_run_command_v_opt(&cmd, argv, opt);
 	return run_command(&cmd);
 }
-
-int run_command_v_opt_cd_env(const char **argv, int opt, const char *dir, const char *const *env)
-{
-	struct child_process cmd;
-	prepare_run_command_v_opt(&cmd, argv, opt);
-	cmd.dir = dir;
-	cmd.env = env;
-	return run_command(&cmd);
-}
-
-int start_async(struct async *async)
-{
-	int pipe_out[2];
-
-	if (pipe(pipe_out) < 0)
-		return error("cannot create pipe: %s", strerror(errno));
-	async->out = pipe_out[0];
-
-	/* Flush stdio before fork() to avoid cloning buffers */
-	fflush(NULL);
-
-	async->pid = fork();
-	if (async->pid < 0) {
-		error("fork (async) failed: %s", strerror(errno));
-		close_pair(pipe_out);
-		return -1;
-	}
-	if (!async->pid) {
-		close(pipe_out[0]);
-		exit(!!async->proc(pipe_out[1], async->data));
-	}
-	close(pipe_out[1]);
-
-	return 0;
-}
-
-int finish_async(struct async *async)
-{
-	int ret = 0;
-
-	if (wait_or_whine(async->pid))
-		ret = error("waitpid (async) failed");
-
-	return ret;
-}
-
-int run_hook(const char *index_file, const char *name, ...)
-{
-	struct child_process hook;
-	const char **argv = NULL, *env[2];
-	char idx[PATH_MAX];
-	va_list args;
-	int ret;
-	size_t i = 0, alloc = 0;
-
-	if (access(perf_path("hooks/%s", name), X_OK) < 0)
-		return 0;
-
-	va_start(args, name);
-	ALLOC_GROW(argv, i + 1, alloc);
-	argv[i++] = perf_path("hooks/%s", name);
-	while (argv[i-1]) {
-		ALLOC_GROW(argv, i + 1, alloc);
-		argv[i++] = va_arg(args, const char *);
-	}
-	va_end(args);
-
-	memset(&hook, 0, sizeof(hook));
-	hook.argv = argv;
-	hook.no_stdin = 1;
-	hook.stdout_to_stderr = 1;
-	if (index_file) {
-		snprintf(idx, sizeof(idx), "PERF_INDEX_FILE=%s", index_file);
-		env[0] = idx;
-		env[1] = NULL;
-		hook.env = env;
-	}
-
-	ret = start_command(&hook);
-	free(argv);
-	if (ret) {
-		warning("Could not spawn %s", argv[0]);
-		return ret;
-	}
-	ret = finish_command(&hook);
-	if (ret == -ERR_RUN_COMMAND_WAITPID_SIGNAL)
-		warning("%s exited due to uncaught signal", argv[0]);
-
-	return ret;
-}
diff --git a/tools/perf/util/run-command.h b/tools/perf/util/run-command.h
index d790287..1ef264d 100644
--- a/tools/perf/util/run-command.h
+++ b/tools/perf/util/run-command.h
@@ -50,39 +50,9 @@ int start_command(struct child_process *);
 int finish_command(struct child_process *);
 int run_command(struct child_process *);
 
-extern int run_hook(const char *index_file, const char *name, ...);
-
 #define RUN_COMMAND_NO_STDIN 1
 #define RUN_PERF_CMD	     2	/*If this is to be perf sub-command */
 #define RUN_COMMAND_STDOUT_TO_STDERR 4
 int run_command_v_opt(const char **argv, int opt);
 
-/*
- * env (the environment) is to be formatted like environ: "VAR=VALUE".
- * To unset an environment variable use just "VAR".
- */
-int run_command_v_opt_cd_env(const char **argv, int opt, const char *dir, const char *const *env);
-
-/*
- * The purpose of the following functions is to feed a pipe by running
- * a function asynchronously and providing output that the caller reads.
- *
- * It is expected that no synchronization and mutual exclusion between
- * the caller and the feed function is necessary so that the function
- * can run in a thread without interfering with the caller.
- */
-struct async {
-	/*
-	 * proc writes to fd and closes it;
-	 * returns 0 on success, non-zero on failure
-	 */
-	int (*proc)(int fd, void *data);
-	void *data;
-	int out;	/* caller reads from here and closes it */
-	pid_t pid;
-};
-
-int start_async(struct async *async);
-int finish_async(struct async *async);
-
 #endif /* __PERF_RUN_COMMAND_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 25bfca4..8f83a18 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -5,6 +5,7 @@
 #include <byteswap.h>
 #include <unistd.h>
 #include <sys/types.h>
+#include <sys/mman.h>
 
 #include "session.h"
 #include "sort.h"
@@ -894,3 +895,10 @@ size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
 	       __dsos__fprintf(&self->host_machine.user_dsos, fp) +
 	       machines__fprintf_dsos(&self->machines, fp);
 }
+
+size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
+					  bool with_hits)
+{
+	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
+	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index e7fce48..55c6881 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -132,12 +132,8 @@ void perf_session__process_machines(struct perf_session *self,
 
 size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
 
-static inline
-size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
-					  bool with_hits)
-{
-	return machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
-}
+size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
+					  FILE *fp, bool with_hits);
 
 static inline
 size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
diff --git a/tools/perf/util/sigchain.c b/tools/perf/util/sigchain.c
index 1118b99..ba785e9 100644
--- a/tools/perf/util/sigchain.c
+++ b/tools/perf/util/sigchain.c
@@ -16,7 +16,7 @@ static void check_signum(int sig)
 		die("BUG: signal out of range: %d", sig);
 }
 
-int sigchain_push(int sig, sigchain_fun f)
+static int sigchain_push(int sig, sigchain_fun f)
 {
 	struct sigchain_signal *s = signals + sig;
 	check_signum(sig);
diff --git a/tools/perf/util/sigchain.h b/tools/perf/util/sigchain.h
index 1a53c11..959d64e 100644
--- a/tools/perf/util/sigchain.h
+++ b/tools/perf/util/sigchain.h
@@ -3,7 +3,6 @@
 
 typedef void (*sigchain_fun)(int);
 
-int sigchain_push(int sig, sigchain_fun f);
 int sigchain_pop(int sig);
 
 void sigchain_push_common(sigchain_fun f);
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 5249d5a..92e0685 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -41,16 +41,6 @@ char *strbuf_detach(struct strbuf *sb, size_t *sz)
 	return res;
 }
 
-void strbuf_attach(struct strbuf *sb, void *buf, size_t len, size_t alloc)
-{
-	strbuf_release(sb);
-	sb->buf   = buf;
-	sb->len   = len;
-	sb->alloc = alloc;
-	strbuf_grow(sb, 0);
-	sb->buf[sb->len] = '\0';
-}
-
 void strbuf_grow(struct strbuf *sb, size_t extra)
 {
 	if (sb->len + extra + 1 <= sb->len)
@@ -60,94 +50,7 @@ void strbuf_grow(struct strbuf *sb, size_t extra)
 	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
 }
 
-void strbuf_trim(struct strbuf *sb)
-{
-	char *b = sb->buf;
-	while (sb->len > 0 && isspace((unsigned char)sb->buf[sb->len - 1]))
-		sb->len--;
-	while (sb->len > 0 && isspace(*b)) {
-		b++;
-		sb->len--;
-	}
-	memmove(sb->buf, b, sb->len);
-	sb->buf[sb->len] = '\0';
-}
-void strbuf_rtrim(struct strbuf *sb)
-{
-	while (sb->len > 0 && isspace((unsigned char)sb->buf[sb->len - 1]))
-		sb->len--;
-	sb->buf[sb->len] = '\0';
-}
-
-void strbuf_ltrim(struct strbuf *sb)
-{
-	char *b = sb->buf;
-	while (sb->len > 0 && isspace(*b)) {
-		b++;
-		sb->len--;
-	}
-	memmove(sb->buf, b, sb->len);
-	sb->buf[sb->len] = '\0';
-}
-
-void strbuf_tolower(struct strbuf *sb)
-{
-	unsigned int i;
-
-	for (i = 0; i < sb->len; i++)
-		sb->buf[i] = tolower(sb->buf[i]);
-}
-
-struct strbuf **strbuf_split(const struct strbuf *sb, int delim)
-{
-	int alloc = 2, pos = 0;
-	char *n, *p;
-	struct strbuf **ret;
-	struct strbuf *t;
-
-	ret = calloc(alloc, sizeof(struct strbuf *));
-	p = n = sb->buf;
-	while (n < sb->buf + sb->len) {
-		int len;
-		n = memchr(n, delim, sb->len - (n - sb->buf));
-		if (pos + 1 >= alloc) {
-			alloc = alloc * 2;
-			ret = realloc(ret, sizeof(struct strbuf *) * alloc);
-		}
-		if (!n)
-			n = sb->buf + sb->len - 1;
-		len = n - p + 1;
-		t = malloc(sizeof(struct strbuf));
-		strbuf_init(t, len);
-		strbuf_add(t, p, len);
-		ret[pos] = t;
-		ret[++pos] = NULL;
-		p = ++n;
-	}
-	return ret;
-}
-
-void strbuf_list_free(struct strbuf **sbs)
-{
-	struct strbuf **s = sbs;
-
-	while (*s) {
-		strbuf_release(*s);
-		free(*s++);
-	}
-	free(sbs);
-}
-
-int strbuf_cmp(const struct strbuf *a, const struct strbuf *b)
-{
-	int len = a->len < b->len ? a->len: b->len;
-	int cmp = memcmp(a->buf, b->buf, len);
-	if (cmp)
-		return cmp;
-	return a->len < b->len ? -1: a->len != b->len;
-}
-
-void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
+static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
 				   const void *data, size_t dlen)
 {
 	if (pos + len < pos)
@@ -166,11 +69,6 @@ void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
 	strbuf_setlen(sb, sb->len + dlen - len);
 }
 
-void strbuf_insert(struct strbuf *sb, size_t pos, const void *data, size_t len)
-{
-	strbuf_splice(sb, pos, 0, data, len);
-}
-
 void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
 {
 	strbuf_splice(sb, pos, len, NULL, 0);
@@ -183,13 +81,6 @@ void strbuf_add(struct strbuf *sb, const void *data, size_t len)
 	strbuf_setlen(sb, sb->len + len);
 }
 
-void strbuf_adddup(struct strbuf *sb, size_t pos, size_t len)
-{
-	strbuf_grow(sb, len);
-	memcpy(sb->buf + sb->len, sb->buf + pos, len);
-	strbuf_setlen(sb, sb->len + len);
-}
-
 void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 {
 	int len;
@@ -214,57 +105,6 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	strbuf_setlen(sb, sb->len + len);
 }
 
-void strbuf_expand(struct strbuf *sb, const char *format, expand_fn_t fn,
-		   void *context)
-{
-	for (;;) {
-		const char *percent;
-		size_t consumed;
-
-		percent = strchrnul(format, '%');
-		strbuf_add(sb, format, percent - format);
-		if (!*percent)
-			break;
-		format = percent + 1;
-
-		consumed = fn(sb, format, context);
-		if (consumed)
-			format += consumed;
-		else
-			strbuf_addch(sb, '%');
-	}
-}
-
-size_t strbuf_expand_dict_cb(struct strbuf *sb, const char *placeholder,
-		void *context)
-{
-	struct strbuf_expand_dict_entry *e = context;
-	size_t len;
-
-	for (; e->placeholder && (len = strlen(e->placeholder)); e++) {
-		if (!strncmp(placeholder, e->placeholder, len)) {
-			if (e->value)
-				strbuf_addstr(sb, e->value);
-			return len;
-		}
-	}
-	return 0;
-}
-
-size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
-{
-	size_t res;
-	size_t oldalloc = sb->alloc;
-
-	strbuf_grow(sb, size);
-	res = fread(sb->buf + sb->len, 1, size, f);
-	if (res > 0)
-		strbuf_setlen(sb, sb->len + res);
-	else if (oldalloc == 0)
-		strbuf_release(sb);
-	return res;
-}
-
 ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
 {
 	size_t oldlen = sb->len;
@@ -291,70 +131,3 @@ ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
 	sb->buf[sb->len] = '\0';
 	return sb->len - oldlen;
 }
-
-#define STRBUF_MAXLINK (2*PATH_MAX)
-
-int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint)
-{
-	size_t oldalloc = sb->alloc;
-
-	if (hint < 32)
-		hint = 32;
-
-	while (hint < STRBUF_MAXLINK) {
-		ssize_t len;
-
-		strbuf_grow(sb, hint);
-		len = readlink(path, sb->buf, hint);
-		if (len < 0) {
-			if (errno != ERANGE)
-				break;
-		} else if (len < hint) {
-			strbuf_setlen(sb, len);
-			return 0;
-		}
-
-		/* .. the buffer was too small - try again */
-		hint *= 2;
-	}
-	if (oldalloc == 0)
-		strbuf_release(sb);
-	return -1;
-}
-
-int strbuf_getline(struct strbuf *sb, FILE *fp, int term)
-{
-	int ch;
-
-	strbuf_grow(sb, 0);
-	if (feof(fp))
-		return EOF;
-
-	strbuf_reset(sb);
-	while ((ch = fgetc(fp)) != EOF) {
-		if (ch == term)
-			break;
-		strbuf_grow(sb, 1);
-		sb->buf[sb->len++] = ch;
-	}
-	if (ch == EOF && sb->len == 0)
-		return EOF;
-
-	sb->buf[sb->len] = '\0';
-	return 0;
-}
-
-int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint)
-{
-	int fd, len;
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -1;
-	len = strbuf_read(sb, fd, hint);
-	close(fd);
-	if (len < 0)
-		return -1;
-
-	return len;
-}
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
index a3d121d..436ac31 100644
--- a/tools/perf/util/strbuf.h
+++ b/tools/perf/util/strbuf.h
@@ -53,12 +53,6 @@ struct strbuf {
 extern void strbuf_init(struct strbuf *buf, ssize_t hint);
 extern void strbuf_release(struct strbuf *);
 extern char *strbuf_detach(struct strbuf *, size_t *);
-extern void strbuf_attach(struct strbuf *, void *, size_t, size_t);
-static inline void strbuf_swap(struct strbuf *a, struct strbuf *b) {
-	struct strbuf tmp = *a;
-	*a = *b;
-	*b = tmp;
-}
 
 /*----- strbuf size related -----*/
 static inline ssize_t strbuf_avail(const struct strbuf *sb) {
@@ -74,17 +68,6 @@ static inline void strbuf_setlen(struct strbuf *sb, size_t len) {
 	sb->len = len;
 	sb->buf[len] = '\0';
 }
-#define strbuf_reset(sb)  strbuf_setlen(sb, 0)
-
-/*----- content related -----*/
-extern void strbuf_trim(struct strbuf *);
-extern void strbuf_rtrim(struct strbuf *);
-extern void strbuf_ltrim(struct strbuf *);
-extern int strbuf_cmp(const struct strbuf *, const struct strbuf *);
-extern void strbuf_tolower(struct strbuf *);
-
-extern struct strbuf **strbuf_split(const struct strbuf *, int delim);
-extern void strbuf_list_free(struct strbuf **);
 
 /*----- add data in your buffer -----*/
 static inline void strbuf_addch(struct strbuf *sb, int c) {
@@ -93,45 +76,17 @@ static inline void strbuf_addch(struct strbuf *sb, int c) {
 	sb->buf[sb->len] = '\0';
 }
 
-extern void strbuf_insert(struct strbuf *, size_t pos, const void *, size_t);
 extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
 
-/* splice pos..pos+len with given data */
-extern void strbuf_splice(struct strbuf *, size_t pos, size_t len,
-                          const void *, size_t);
-
 extern void strbuf_add(struct strbuf *, const void *, size_t);
 static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
 	strbuf_add(sb, s, strlen(s));
 }
-static inline void strbuf_addbuf(struct strbuf *sb, const struct strbuf *sb2) {
-	strbuf_add(sb, sb2->buf, sb2->len);
-}
-extern void strbuf_adddup(struct strbuf *sb, size_t pos, size_t len);
-
-typedef size_t (*expand_fn_t) (struct strbuf *sb, const char *placeholder, void *context);
-extern void strbuf_expand(struct strbuf *sb, const char *format, expand_fn_t fn, void *context);
-struct strbuf_expand_dict_entry {
-	const char *placeholder;
-	const char *value;
-};
-extern size_t strbuf_expand_dict_cb(struct strbuf *sb, const char *placeholder, void *context);
 
 __attribute__((format(printf,2,3)))
 extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
 
-extern size_t strbuf_fread(struct strbuf *, size_t, FILE *);
 /* XXX: if read fails, any partial read is undone */
 extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
-extern int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint);
-extern int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint);
-
-extern int strbuf_getline(struct strbuf *, FILE *, int);
-
-extern void stripspace(struct strbuf *buf, int skip_comments);
-extern int launch_editor(const char *path, struct strbuf *buffer, const char *const *env);
-
-extern int strbuf_branchname(struct strbuf *sb, const char *name);
-extern int strbuf_check_branch_ref(struct strbuf *sb, const char *name);
 
 #endif /* __PERF_STRBUF_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a06131f..aaa51ba 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -11,6 +11,7 @@
 #include <sys/param.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include "build-id.h"
 #include "symbol.h"
 #include "strlist.h"
 
@@ -1131,6 +1132,10 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
 	list_for_each_entry(pos, head, node) {
 		if (with_hits && !pos->hit)
 			continue;
+		if (pos->has_build_id) {
+			have_build_id = true;
+			continue;
+		}
 		if (filename__read_build_id(pos->long_name, pos->build_id,
 					    sizeof(pos->build_id)) > 0) {
 			have_build_id	  = true;
@@ -1289,7 +1294,6 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	int size = PATH_MAX;
 	char *name;
 	u8 build_id[BUILD_ID_SIZE];
-	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = -1;
 	int fd;
 	struct machine *machine;
@@ -1321,15 +1325,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	}
 
 	self->origin = DSO__ORIG_BUILD_ID_CACHE;
-
-	if (self->has_build_id) {
-		build_id__sprintf(self->build_id, sizeof(self->build_id),
-				  build_id_hex);
-		snprintf(name, size, "%s/%s/.build-id/%.2s/%s",
-			 getenv("HOME"), DEBUG_CACHE_DIR,
-			 build_id_hex, build_id_hex + 2);
+	if (dso__build_id_filename(self, name, size) != NULL)
 		goto open_file;
-	}
 more:
 	do {
 		self->origin++;
@@ -1345,6 +1342,7 @@ more:
 		case DSO__ORIG_BUILDID:
 			if (filename__read_build_id(self->long_name, build_id,
 						    sizeof(build_id))) {
+				char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 				build_id__sprintf(build_id, sizeof(build_id),
 						  build_id_hex);
 				snprintf(name, size,
@@ -1933,6 +1931,12 @@ static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
 	return ret;
 }
 
+size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits)
+{
+	return __dsos__fprintf_buildid(&self->kernel_dsos, fp, with_hits) +
+	       __dsos__fprintf_buildid(&self->user_dsos, fp, with_hits);
+}
+
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
 {
 	struct rb_node *nd;
@@ -1940,8 +1944,7 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_
 
 	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += __dsos__fprintf_buildid(&pos->kernel_dsos, fp, with_hits);
-		ret += __dsos__fprintf_buildid(&pos->user_dsos, fp, with_hits);
+		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
 	}
 	return ret;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 032469e..5d25b5e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -170,6 +170,7 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 
 size_t __dsos__fprintf(struct list_head *head, FILE *fp);
 
+size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits);
 size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index cb54cd0..f55cc3a 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -53,12 +53,6 @@ static unsigned long	page_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-/* If it fails, the next read will report it */
-static void skip(int size)
-{
-	lseek(input_fd, size, SEEK_CUR);
-}
-
 static int do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
@@ -98,6 +92,19 @@ static int read_or_die(void *data, int size)
 	return r;
 }
 
+/* If it fails, the next read will report it */
+static void skip(int size)
+{
+	char buf[BUFSIZ];
+	int r;
+
+	while (size) {
+		r = size > BUFSIZ ? BUFSIZ : size;
+		read_or_die(buf, r);
+		size -= r;
+	};
+}
+
 static unsigned int read4(void)
 {
 	unsigned int data;
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 406d452..b3e86b1 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -233,7 +233,12 @@ static inline unsigned long long __data2host8(unsigned long long data)
 
 #define data2host2(ptr)		__data2host2(*(unsigned short *)ptr)
 #define data2host4(ptr)		__data2host4(*(unsigned int *)ptr)
-#define data2host8(ptr)		__data2host8(*(unsigned long long *)ptr)
+#define data2host8(ptr)		({				\
+	unsigned long long __val;				\
+								\
+	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
+	__data2host8(__val);					\
+})
 
 extern int header_page_ts_offset;
 extern int header_page_ts_size;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0795bf3..4e8b6b0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -81,7 +81,7 @@
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
-
+#include <sys/ttydefaults.h>
 
 #ifndef NO_ICONV
 #include <iconv.h>
@@ -152,7 +152,6 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);
-extern time_t tm_to_time_t(const struct tm *tm);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
@@ -160,119 +159,6 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
 	return strncmp(str, prefix, len) ? NULL : str + len;
 }
 
-#if defined(NO_MMAP) || defined(USE_WIN32_MMAP)
-
-#ifndef PROT_READ
-#define PROT_READ 1
-#define PROT_WRITE 2
-#define MAP_PRIVATE 1
-#define MAP_FAILED ((void*)-1)
-#endif
-
-#define mmap git_mmap
-#define munmap git_munmap
-extern void *git_mmap(void *start, size_t length, int prot, int flags, int fd, off_t offset);
-extern int git_munmap(void *start, size_t length);
-
-#else /* NO_MMAP || USE_WIN32_MMAP */
-
-#include <sys/mman.h>
-
-#endif /* NO_MMAP || USE_WIN32_MMAP */
-
-#ifdef NO_MMAP
-
-/* This value must be multiple of (pagesize * 2) */
-#define DEFAULT_PACKED_GIT_WINDOW_SIZE (1 * 1024 * 1024)
-
-#else /* NO_MMAP */
-
-/* This value must be multiple of (pagesize * 2) */
-#define DEFAULT_PACKED_GIT_WINDOW_SIZE \
-	(sizeof(void*) >= 8 \
-		?  1 * 1024 * 1024 * 1024 \
-		: 32 * 1024 * 1024)
-
-#endif /* NO_MMAP */
-
-#ifdef NO_ST_BLOCKS_IN_STRUCT_STAT
-#define on_disk_bytes(st) ((st).st_size)
-#else
-#define on_disk_bytes(st) ((st).st_blocks * 512)
-#endif
-
-#define DEFAULT_PACKED_GIT_LIMIT \
-	((1024L * 1024L) * (sizeof(void*) >= 8 ? 8192 : 256))
-
-#ifdef NO_PREAD
-#define pread git_pread
-extern ssize_t git_pread(int fd, void *buf, size_t count, off_t offset);
-#endif
-/*
- * Forward decl that will remind us if its twin in cache.h changes.
- * This function is used in compat/pread.c.  But we can't include
- * cache.h there.
- */
-extern ssize_t read_in_full(int fd, void *buf, size_t count);
-
-#ifdef NO_SETENV
-#define setenv gitsetenv
-extern int gitsetenv(const char *, const char *, int);
-#endif
-
-#ifdef NO_MKDTEMP
-#define mkdtemp gitmkdtemp
-extern char *gitmkdtemp(char *);
-#endif
-
-#ifdef NO_UNSETENV
-#define unsetenv gitunsetenv
-extern void gitunsetenv(const char *);
-#endif
-
-#ifdef NO_STRCASESTR
-#define strcasestr gitstrcasestr
-extern char *gitstrcasestr(const char *haystack, const char *needle);
-#endif
-
-#ifdef NO_STRLCPY
-#define strlcpy gitstrlcpy
-extern size_t gitstrlcpy(char *, const char *, size_t);
-#endif
-
-#ifdef NO_STRTOUMAX
-#define strtoumax gitstrtoumax
-extern uintmax_t gitstrtoumax(const char *, char **, int);
-#endif
-
-#ifdef NO_HSTRERROR
-#define hstrerror githstrerror
-extern const char *githstrerror(int herror);
-#endif
-
-#ifdef NO_MEMMEM
-#define memmem gitmemmem
-void *gitmemmem(const void *haystack, size_t haystacklen,
-                const void *needle, size_t needlelen);
-#endif
-
-#ifdef FREAD_READS_DIRECTORIES
-#ifdef fopen
-#undef fopen
-#endif
-#define fopen(a,b) git_fopen(a,b)
-extern FILE *git_fopen(const char*, const char*);
-#endif
-
-#ifdef SNPRINTF_RETURNS_BOGUS
-#define snprintf git_snprintf
-extern int git_snprintf(char *str, size_t maxsize,
-			const char *format, ...);
-#define vsnprintf git_vsnprintf
-extern int git_vsnprintf(char *str, size_t maxsize,
-			 const char *format, va_list ap);
-#endif
-
 #ifdef __GLIBC_PREREQ
 #if __GLIBC_PREREQ(2, 1)
 #define HAVE_STRCHRNUL
@@ -293,28 +179,14 @@ static inline char *gitstrchrnul(const char *s, int c)
  * Wrappers:
  */
 extern char *xstrdup(const char *str);
-extern void *xmalloc(size_t size) __attribute__((weak));
-extern void *xmemdupz(const void *data, size_t len);
-extern char *xstrndup(const char *str, size_t len);
 extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
 
-static inline void *xzalloc(size_t size)
-{
-	void *buf = xmalloc(size);
-
-	return memset(buf, 0, size);
-}
 
 static inline void *zalloc(size_t size)
 {
 	return calloc(1, size);
 }
 
-static inline size_t xsize_t(off_t len)
-{
-	return (size_t)len;
-}
-
 static inline int has_extension(const char *filename, const char *ext)
 {
 	size_t len = strlen(filename);
@@ -351,8 +223,6 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
-#define is_glob_special(x) sane_istest(x,GIT_GLOB_SPECIAL)
-#define is_regex_special(x) sane_istest(x,GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
@@ -363,38 +233,6 @@ static inline int sane_case(int x, int high)
 	return x;
 }
 
-static inline int strtoul_ui(char const *s, int base, unsigned int *result)
-{
-	unsigned long ul;
-	char *p;
-
-	errno = 0;
-	ul = strtoul(s, &p, base);
-	if (errno || *p || p == s || (unsigned int) ul != ul)
-		return -1;
-	*result = ul;
-	return 0;
-}
-
-static inline int strtol_i(char const *s, int base, int *result)
-{
-	long ul;
-	char *p;
-
-	errno = 0;
-	ul = strtol(s, &p, base);
-	if (errno || *p || p == s || (int) ul != ul)
-		return -1;
-	*result = ul;
-	return 0;
-}
-
-#ifdef INTERNAL_QSORT
-void git_qsort(void *base, size_t nmemb, size_t size,
-	       int(*compar)(const void *, const void *));
-#define qsort git_qsort
-#endif
-
 #ifndef DIR_HAS_BSD_GROUP_SEMANTICS
 # define FORCE_DIR_SET_GID S_ISGID
 #else
@@ -425,6 +263,19 @@ bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
 unsigned long convert_unit(unsigned long value, char *unit);
 
+#ifndef ESC
+#define ESC 27
+#endif
+
+static inline bool is_exit_key(int key)
+{
+	char up;
+	if (key == CTRL('c') || key == ESC)
+		return true;
+	up = toupper(key);
+	return up == 'Q';
+}
+
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index bf44ca8..73e900e 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -23,46 +23,6 @@ char *xstrdup(const char *str)
 	return ret;
 }
 
-void *xmalloc(size_t size)
-{
-	void *ret = malloc(size);
-	if (!ret && !size)
-		ret = malloc(1);
-	if (!ret) {
-		release_pack_memory(size, -1);
-		ret = malloc(size);
-		if (!ret && !size)
-			ret = malloc(1);
-		if (!ret)
-			die("Out of memory, malloc failed");
-	}
-#ifdef XMALLOC_POISON
-	memset(ret, 0xA5, size);
-#endif
-	return ret;
-}
-
-/*
- * xmemdupz() allocates (len + 1) bytes of memory, duplicates "len" bytes of
- * "data" to the allocated memory, zero terminates the allocated memory,
- * and returns a pointer to the allocated memory. If the allocation fails,
- * the program dies.
- */
-void *xmemdupz(const void *data, size_t len)
-{
-	char *p = xmalloc(len + 1);
-	memcpy(p, data, len);
-	p[len] = '\0';
-	return p;
-}
-
-char *xstrndup(const char *str, size_t len)
-{
-	char *p = memchr(str, '\0', len);
-
-	return xmemdupz(str, p ? (size_t)(p - str) : len);
-}
-
 void *xrealloc(void *ptr, size_t size)
 {
 	void *ret = realloc(ptr, size);
@@ -78,73 +38,3 @@ void *xrealloc(void *ptr, size_t size)
 	}
 	return ret;
 }
-
-/*
- * xread() is the same a read(), but it automatically restarts read()
- * operations with a recoverable error (EAGAIN and EINTR). xread()
- * DOES NOT GUARANTEE that "len" bytes is read even if the data is available.
- */
-static ssize_t xread(int fd, void *buf, size_t len)
-{
-	ssize_t nr;
-	while (1) {
-		nr = read(fd, buf, len);
-		if ((nr < 0) && (errno == EAGAIN || errno == EINTR))
-			continue;
-		return nr;
-	}
-}
-
-/*
- * xwrite() is the same a write(), but it automatically restarts write()
- * operations with a recoverable error (EAGAIN and EINTR). xwrite() DOES NOT
- * GUARANTEE that "len" bytes is written even if the operation is successful.
- */
-static ssize_t xwrite(int fd, const void *buf, size_t len)
-{
-	ssize_t nr;
-	while (1) {
-		nr = write(fd, buf, len);
-		if ((nr < 0) && (errno == EAGAIN || errno == EINTR))
-			continue;
-		return nr;
-	}
-}
-
-ssize_t read_in_full(int fd, void *buf, size_t count)
-{
-	char *p = buf;
-	ssize_t total = 0;
-
-	while (count > 0) {
-		ssize_t loaded = xread(fd, p, count);
-		if (loaded <= 0)
-			return total ? total : loaded;
-		count -= loaded;
-		p += loaded;
-		total += loaded;
-	}
-
-	return total;
-}
-
-ssize_t write_in_full(int fd, const void *buf, size_t count)
-{
-	const char *p = buf;
-	ssize_t total = 0;
-
-	while (count > 0) {
-		ssize_t written = xwrite(fd, p, count);
-		if (written < 0)
-			return -1;
-		if (!written) {
-			errno = ENOSPC;
-			return -1;
-		}
-		count -= written;
-		p += written;
-		total += written;
-	}
-
-	return total;
-}
