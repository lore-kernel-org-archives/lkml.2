Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1AKLcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:32:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab1AKLcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:32:45 -0500
Date: Tue, 11 Jan 2011 12:32:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110111113223.GA27695@elte.hu>
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

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

A few late coming items plus fixes.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (4):
      perf sched: Fix allocation result check
      perf tools: Emit clearer message for sys_perf_event_open ENOENT return
      perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)
      perf session: Fix infinite loop in __perf_session__process_events

Cyrill Gorcunov (1):
      perf, x86: P4 PMU - Fix unflagged overflows handling

David Ahern (1):
      perf stat: better error message for unsupported events

Don Zickus (5):
      x86: Convert some devices to use DIE_NMIUNKNOWN
      x86, NMI: Add priorities to handlers
      x86, NMI: Remove DIE_NMI_IPI
      x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
      x86, NMI: Clean-up default_do_nmi()

Frederic Weisbecker (2):
      perf tools: Build with frame pointer
      x86: Save rbp in pt_regs on irq entry

Han Pingtian (1):
      perf tools: Fix buffer overflow error when specifying all tracepoints

Huang Ying (1):
      x86, NMI: Add NMI symbol constants and rename memory parity to PCI SERR

Jason Baron (1):
      dynamic debug: Fix build issue with older gcc

Jiri Pirko (1):
      perf sched: Use PTHREAD_STACK_MIN to avoid pthread_attr_setstacksize() fail

Lai Jiangshan (1):
      tracepoint: Add __rcu annotation

Li Zefan (1):
      tracing: Fix preempt count leak

Lin Ming (1):
      perf tools: Pass whole attr to event selectors

Mathieu Desnoyers (3):
      tracing/trivial: Add missing comma in TRACE_EVENT comment
      tracing: remove duplicate null-pointer check in skb tracepoint
      tracing: Fix TRACE_EVENT power tracepoint creation

Rakib Mullick (1):
      x86, dumpstack: Fix unused variable warning

Stephane Eranian (3):
      perf_events: Move code around to prepare for cgroup
      perf_events: Generalize use of event_filter_match()
      perf_events: Add perf_event_time()

Steven Rostedt (1):
      tracing: Include module.h in define_trace.h


 arch/x86/include/asm/kdebug.h           |    1 -
 arch/x86/include/asm/mach_traps.h       |   12 +++-
 arch/x86/include/asm/nmi.h              |   20 +++++
 arch/x86/include/asm/perf_event_p4.h    |    3 +
 arch/x86/kernel/apic/hw_nmi.c           |    3 +-
 arch/x86/kernel/apic/x2apic_uv_x.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    5 +-
 arch/x86/kernel/cpu/perf_event.c        |    3 +-
 arch/x86/kernel/cpu/perf_event_p4.c     |   28 ++++----
 arch/x86/kernel/dumpstack.c             |    6 --
 arch/x86/kernel/entry_64.S              |   36 ++++++----
 arch/x86/kernel/kgdb.c                  |    7 +--
 arch/x86/kernel/reboot.c                |    5 +-
 arch/x86/kernel/traps.c                 |  102 ++++++++++++++--------------
 arch/x86/oprofile/nmi_int.c             |    3 +-
 arch/x86/oprofile/nmi_timer_int.c       |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c       |    2 +-
 drivers/watchdog/hpwdt.c                |    2 +-
 include/linux/dynamic_debug.h           |   18 +----
 include/linux/tracepoint.h              |    4 +-
 include/trace/define_trace.h            |   10 +++
 include/trace/events/skb.h              |    4 +-
 kernel/Makefile                         |    1 +
 kernel/exit.c                           |   14 +++--
 kernel/perf_event.c                     |   82 +++++++++++++---------
 kernel/trace/Makefile                   |    2 +-
 kernel/trace/trace.c                    |    6 +-
 lib/dynamic_debug.c                     |    9 +--
 tools/perf/Makefile                     |    2 +-
 tools/perf/builtin-record.c             |    3 +
 tools/perf/builtin-sched.c              |    5 +-
 tools/perf/builtin-stat.c               |    5 +-
 tools/perf/builtin-test.c               |  116 ++++++++++++++++++++++++++++++-
 tools/perf/builtin-top.c                |    2 +
 tools/perf/util/evsel.c                 |   87 ++++++++++++++----------
 tools/perf/util/evsel.h                 |    2 +-
 tools/perf/util/parse-events.c          |   74 +++++++++++---------
 tools/perf/util/session.c               |    2 +-
 38 files changed, 442 insertions(+), 248 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index f23eb25..ca242d3 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -18,7 +18,6 @@ enum die_val {
 	DIE_TRAP,
 	DIE_GPF,
 	DIE_CALL,
-	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
 	DIE_NMIUNKNOWN,
 };
diff --git a/arch/x86/include/asm/mach_traps.h b/arch/x86/include/asm/mach_traps.h
index f792060..72a8b52 100644
--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -7,9 +7,19 @@
 
 #include <asm/mc146818rtc.h>
 
+#define NMI_REASON_PORT		0x61
+
+#define NMI_REASON_SERR		0x80
+#define NMI_REASON_IOCHK	0x40
+#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
+
+#define NMI_REASON_CLEAR_SERR	0x04
+#define NMI_REASON_CLEAR_IOCHK	0x08
+#define NMI_REASON_CLEAR_MASK	0x0f
+
 static inline unsigned char get_nmi_reason(void)
 {
-	return inb(0x61);
+	return inb(NMI_REASON_PORT);
 }
 
 static inline void reassert_nmi(void)
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c4021b9..c76f5b9 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -23,6 +23,26 @@ void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
+/*
+ * Define some priorities for the nmi notifier call chain.
+ *
+ * Create a local nmi bit that has a higher priority than
+ * external nmis, because the local ones are more frequent.
+ *
+ * Also setup some default high/normal/low settings for
+ * subsystems to registers with.  Using 4 bits to seperate
+ * the priorities.  This can go alot higher if needed be.
+ */
+
+#define NMI_LOCAL_SHIFT		16	/* randomly picked */
+#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
+#define NMI_HIGH_PRIOR		(1ULL << 8)
+#define NMI_NORMAL_PRIOR	(1ULL << 4)
+#define NMI_LOW_PRIOR		(1ULL << 0)
+#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
+#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
+#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
+
 void stop_nmi(void);
 void restart_nmi(void);
 
diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 295e2ff..e2f6a99 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -20,6 +20,9 @@
 #define ARCH_P4_MAX_ESCR	(ARCH_P4_TOTAL_ESCR - ARCH_P4_RESERVED_ESCR)
 #define ARCH_P4_MAX_CCCR	(18)
 
+#define ARCH_P4_CNTRVAL_BITS	(40)
+#define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
+
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
 #define P4_ESCR_EVENTMASK_MASK	0x01fffe00U
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 72ec29e..79fd43c 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -68,7 +68,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 
 	default:
@@ -96,7 +95,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block backtrace_notifier = {
 	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
 	.next                   = NULL,
-	.priority               = 1
+	.priority               = NMI_LOCAL_LOW_PRIOR,
 };
 
 static int __init register_trigger_all_cpu_backtrace(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2a3f2a7..936613e 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -641,7 +641,7 @@ void __cpuinit uv_cpu_init(void)
  */
 int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
-	if (reason != DIE_NMI_IPI)
+	if (reason != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	if (in_crash_kexec)
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e7dbde7..a779719 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -25,6 +25,7 @@
 #include <linux/gfp.h>
 #include <asm/mce.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
@@ -83,7 +84,7 @@ static int mce_raise_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI_IPI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
+	if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
@@ -95,7 +96,7 @@ static int mce_raise_notify(struct notifier_block *self,
 
 static struct notifier_block mce_raise_nb = {
 	.notifier_call = mce_raise_notify,
-	.priority = 1000,
+	.priority = NMI_LOCAL_NORMAL_PRIOR,
 };
 
 /* Inject mce on current CPU */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0a360d1..c71bae4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1268,7 +1268,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
@@ -1318,7 +1317,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.notifier_call		= perf_event_nmi_handler,
 	.next			= NULL,
-	.priority		= 1
+	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
 static struct event_constraint unconstrained;
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 81400b9..e56b9bf 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -753,19 +753,21 @@ out:
 
 static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 {
-	int overflow = 0;
-	u32 low, high;
+	u64 v;
 
-	rdmsr(hwc->config_base + hwc->idx, low, high);
-
-	/* we need to check high bit for unflagged overflows */
-	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
-		overflow = 1;
-		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
-			((u64)low) & ~P4_CCCR_OVF);
+	/* an official way for overflow indication */
+	rdmsrl(hwc->config_base + hwc->idx, v);
+	if (v & P4_CCCR_OVF) {
+		wrmsrl(hwc->config_base + hwc->idx, v & ~P4_CCCR_OVF);
+		return 1;
 	}
 
-	return overflow;
+	/* it might be unflagged overflow */
+	rdmsrl(hwc->event_base + hwc->idx, v);
+	if (!(v & ARCH_P4_CNTRVAL_MASK))
+		return 1;
+
+	return 0;
 }
 
 static void p4_pmu_disable_pebs(void)
@@ -1152,9 +1154,9 @@ static __initconst const struct x86_pmu p4_pmu = {
 	 */
 	.num_counters		= ARCH_P4_MAX_CCCR,
 	.apic			= 1,
-	.cntval_bits		= 40,
-	.cntval_mask		= (1ULL << 40) - 1,
-	.max_period		= (1ULL << 39) - 1,
+	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
+	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
+	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 8474c99..d6fb146 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -197,14 +197,8 @@ void show_stack(struct task_struct *task, unsigned long *sp)
  */
 void dump_stack(void)
 {
-	unsigned long bp = 0;
 	unsigned long stack;
 
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		get_bp(bp);
-#endif
-
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e3ba417..d3b895f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -299,17 +299,21 @@ ENDPROC(native_usergs_sysret64)
 ENTRY(save_args)
 	XCPT_FRAME
 	cld
-	movq_cfi rdi, RDI+16-ARGOFFSET
-	movq_cfi rsi, RSI+16-ARGOFFSET
-	movq_cfi rdx, RDX+16-ARGOFFSET
-	movq_cfi rcx, RCX+16-ARGOFFSET
-	movq_cfi rax, RAX+16-ARGOFFSET
-	movq_cfi  r8,  R8+16-ARGOFFSET
-	movq_cfi  r9,  R9+16-ARGOFFSET
-	movq_cfi r10, R10+16-ARGOFFSET
-	movq_cfi r11, R11+16-ARGOFFSET
-
-	leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */
+	/*
+	 * start from rbp in pt_regs and jump over
+	 * return address.
+	 */
+	movq_cfi rdi, RDI+8-RBP
+	movq_cfi rsi, RSI+8-RBP
+	movq_cfi rdx, RDX+8-RBP
+	movq_cfi rcx, RCX+8-RBP
+	movq_cfi rax, RAX+8-RBP
+	movq_cfi  r8,  R8+8-RBP
+	movq_cfi  r9,  R9+8-RBP
+	movq_cfi r10, R10+8-RBP
+	movq_cfi r11, R11+8-RBP
+
+	leaq -RBP+8(%rsp),%rdi	/* arg1 for handler */
 	movq_cfi rbp, 8		/* push %rbp */
 	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
 	testl $3, CS(%rdi)
@@ -782,8 +786,9 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	subq $ORIG_RAX-ARGOFFSET+8, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
+	/* reserve pt_regs for scratch regs and rbp */
+	subq $ORIG_RAX-RBP, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
 	call save_args
 	PARTIAL_FRAME 0
 	call \func
@@ -808,9 +813,14 @@ ret_from_intr:
 	TRACE_IRQS_OFF
 	decl PER_CPU_VAR(irq_count)
 	leaveq
+
 	CFI_RESTORE		rbp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
+
+	/* we did not save rbx, restore only from ARGOFFSET */
+	addq $8, %rsp
+	CFI_ADJUST_CFA_OFFSET	-8
 exit_intr:
 	GET_THREAD_INFO(%rcx)
 	testl $3,CS-ARGOFFSET(%rsp)
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index cd21b65..a413000 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -48,6 +48,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
@@ -525,10 +526,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		}
 		return NOTIFY_DONE;
 
-	case DIE_NMI_IPI:
-		/* Just ignore, we will handle the roundup on DIE_NMI. */
-		return NOTIFY_DONE;
-
 	case DIE_NMIUNKNOWN:
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
@@ -606,7 +603,7 @@ static struct notifier_block kgdb_notifier = {
 	/*
 	 * Lowest-prio notifier priority, we want to be notified last:
 	 */
-	.priority	= -INT_MAX,
+	.priority	= NMI_LOCAL_LOW_PRIOR,
 };
 
 /**
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c495aa8..fc7aae1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -18,6 +18,7 @@
 #include <asm/pci_x86.h>
 #include <asm/virtext.h>
 #include <asm/cpu.h>
+#include <asm/nmi.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/ctype.h>
@@ -747,7 +748,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 {
 	int cpu;
 
-	if (val != DIE_NMI_IPI)
+	if (val != DIE_NMI)
 		return NOTIFY_OK;
 
 	cpu = raw_smp_processor_id();
@@ -778,6 +779,8 @@ static void smp_send_nmi_allbutself(void)
 
 static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
+	/* we want to be the first one called */
+	.priority = NMI_LOCAL_HIGH_PRIOR+1,
 };
 
 /* Halt all other CPUs, calling the specified function on each of them
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c76aaca..b9b6716 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -84,6 +84,11 @@ EXPORT_SYMBOL_GPL(used_vectors);
 static int ignore_nmis;
 
 int unknown_nmi_panic;
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
 
 static inline void conditional_sti(struct pt_regs *regs)
 {
@@ -310,15 +315,15 @@ static int __init setup_unknown_nmi_panic(char *str)
 __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
 static notrace __kprobes void
-mem_parity_error(unsigned char reason, struct pt_regs *regs)
+pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
-	printk(KERN_EMERG
-		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-			reason, smp_processor_id());
-
-	printk(KERN_EMERG
-		"You have some hardware problem, likely on the PCI bus.\n");
+	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
 
+	/*
+	 * On some machines, PCI SERR line is used to report memory
+	 * errors. EDAC makes use of it.
+	 */
 #if defined(CONFIG_EDAC)
 	if (edac_handler_set()) {
 		edac_atomic_assert_error();
@@ -329,11 +334,11 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
+	pr_emerg("Dazed and confused, but trying to continue\n");
 
-	/* Clear and disable the memory parity error line. */
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
+	/* Clear and disable the PCI SERR error line. */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
+	outb(reason, NMI_REASON_PORT);
 }
 
 static notrace __kprobes void
@@ -341,15 +346,17 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
 
-	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
+	pr_emerg(
+	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
 	show_registers(regs);
 
 	if (panic_on_io_nmi)
 		panic("NMI IOCK error: Not continuing");
 
 	/* Re-enable the IOCK line, wait for a few seconds */
-	reason = (reason & 0xf) | 8;
-	outb(reason, 0x61);
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
 
 	i = 20000;
 	while (--i) {
@@ -357,8 +364,8 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 		udelay(100);
 	}
 
-	reason &= ~8;
-	outb(reason, 0x61);
+	reason &= ~NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
 }
 
 static notrace __kprobes void
@@ -377,57 +384,50 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 		return;
 	}
 #endif
-	printk(KERN_EMERG
-		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-			reason, smp_processor_id());
+	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
 
-	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
+	pr_emerg("Do you have a strange power saving mode enabled?\n");
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
+	pr_emerg("Dazed and confused, but trying to continue\n");
 }
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-	int cpu;
 
-	cpu = smp_processor_id();
-
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
-		reason = get_nmi_reason();
+	/*
+	 * CPU-specific NMI must be processed before non-CPU-specific
+	 * NMI, otherwise we may lose it, because the CPU-specific
+	 * NMI can not be detected/processed on other CPUs.
+	 */
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
 
-	if (!(reason & 0xc0)) {
-		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-								== NOTIFY_STOP)
-			return;
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
 
-#ifdef CONFIG_X86_LOCAL_APIC
-		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-							== NOTIFY_STOP)
-			return;
+	if (reason & NMI_REASON_MASK) {
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+		/*
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
+		 */
+		reassert_nmi();
 #endif
-		unknown_nmi_error(reason, regs);
-
+		raw_spin_unlock(&nmi_reason_lock);
 		return;
 	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return;
+	raw_spin_unlock(&nmi_reason_lock);
 
-	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & 0x80)
-		mem_parity_error(reason, regs);
-	if (reason & 0x40)
-		io_check_error(reason, regs);
-#ifdef CONFIG_X86_32
-	/*
-	 * Reassert NMI in case it became active meanwhile
-	 * as it's edge-triggered:
-	 */
-	reassert_nmi();
-#endif
+	unknown_nmi_error(reason, regs);
 }
 
 dotraplinkage notrace __kprobes void
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 358c8b9..e77ea0b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -65,7 +65,6 @@ static int profile_exceptions_notify(struct notifier_block *self,
 
 	switch (val) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
 		else if (!nmi_enabled)
@@ -361,7 +360,7 @@ static void nmi_cpu_setup(void *dummy)
 static struct notifier_block profile_exceptions_nb = {
 	.notifier_call = profile_exceptions_notify,
 	.next = NULL,
-	.priority = 2
+	.priority = NMI_LOCAL_LOW_PRIOR,
 };
 
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index 0636dd9..720bf5a 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -38,7 +38,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
 static struct notifier_block profile_timer_exceptions_nb = {
 	.notifier_call = profile_timer_exceptions_notify,
 	.next = NULL,
-	.priority = 0
+	.priority = NMI_LOW_PRIOR,
 };
 
 static int timer_start(void)
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index f4d334f..320668f 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1081,7 +1081,7 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct die_args *args = data;
 
-	if (val != DIE_NMI)
+	if (val != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	/* Hack, if it's a memory or I/O error, ignore it. */
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index dea7b5b..24b966d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -469,7 +469,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+	if (ulReason != DIE_NMIUNKNOWN)
 		goto out;
 
 	if (!hpwdt_nmi_decoding)
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a90b389..1c70028 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -44,34 +44,24 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 extern int ddebug_remove_module(const char *mod_name);
 
 #define dynamic_pr_debug(fmt, ...) do {					\
-	__label__ do_printk;						\
-	__label__ out;							\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
 		_DPRINTK_FLAGS_DEFAULT };				\
-	JUMP_LABEL(&descriptor.enabled, do_printk);			\
-	goto out;							\
-do_printk:								\
-	printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);			\
-out:	;								\
+	if (unlikely(descriptor.enabled))				\
+		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
 	} while (0)
 
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	__label__ do_printk;						\
-	__label__ out;							\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
 		_DPRINTK_FLAGS_DEFAULT };				\
-	JUMP_LABEL(&descriptor.enabled, do_printk);			\
-	goto out;							\
-do_printk:								\
-	dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);		\
-out:	;								\
+	if (unlikely(descriptor.enabled))				\
+		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
 #else
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d3e4f87..c681461 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -32,7 +32,7 @@ struct tracepoint {
 	int state;			/* State. */
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
-	struct tracepoint_func *funcs;
+	struct tracepoint_func __rcu *funcs;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
 					 * globally visible and gcc happily
@@ -326,7 +326,7 @@ do_trace:								\
  *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
- *	)
+ *	),
  *
  *	*
  *	* Formatted output of a trace record via TP_printk().
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index b0b4eb2..da39b22 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -21,6 +21,16 @@
 #undef CREATE_TRACE_POINTS
 
 #include <linux/stringify.h>
+/*
+ * module.h includes tracepoints, and because ftrace.h
+ * pulls in module.h:
+ *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
+ *  linux/ftrace.h -> linux/module.h
+ * we must include module.h here before we play with any of
+ * the TRACE_EVENT() macros, otherwise the tracepoints included
+ * by module.h may break the build.
+ */
+#include <linux/module.h>
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 75ce9d5..f10293c 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
-		if (skb) {
-			__entry->protocol = ntohs(skb->protocol);
-		}
+		__entry->protocol = ntohs(skb->protocol);
 		__entry->location = location;
 	),
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..e0f2831 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
+obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
diff --git a/kernel/exit.c b/kernel/exit.c
index 676149a..8cb8904 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -994,6 +994,15 @@ NORET_TYPE void do_exit(long code)
 	exit_fs(tsk);
 	check_stack_usage();
 	exit_thread();
+
+	/*
+	 * Flush inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 *
+	 * because of cgroup mode, must be called before cgroup_exit()
+	 */
+	perf_event_exit_task(tsk);
+
 	cgroup_exit(tsk, 1);
 
 	if (group_dead)
@@ -1007,11 +1016,6 @@ NORET_TYPE void do_exit(long code)
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
 	flush_ptrace_hw_breakpoint(tsk);
-	/*
-	 * Flush inherited counters to the parent - before the parent
-	 * gets woken up by child-exit notifications.
-	 */
-	perf_event_exit_task(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 11847bf..b782b7a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -38,6 +38,12 @@
 
 #include <asm/irq_regs.h>
 
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
 atomic_t perf_task_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -65,6 +71,12 @@ int sysctl_perf_event_sample_rate __read_mostly = 100000;
 
 static atomic64_t perf_event_id;
 
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type);
+
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -72,6 +84,11 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
+static inline u64 perf_clock(void)
+{
+	return local_clock();
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -240,11 +257,6 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 	put_ctx(ctx);
 }
 
-static inline u64 perf_clock(void)
-{
-	return local_clock();
-}
-
 /*
  * Update the record of the current time in a context.
  */
@@ -256,6 +268,12 @@ static void update_context_time(struct perf_event_context *ctx)
 	ctx->timestamp = now;
 }
 
+static u64 perf_event_time(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	return ctx ? ctx->time : 0;
+}
+
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
  */
@@ -269,7 +287,7 @@ static void update_event_times(struct perf_event *event)
 		return;
 
 	if (ctx->is_active)
-		run_end = ctx->time;
+		run_end = perf_event_time(event);
 	else
 		run_end = event->tstamp_stopped;
 
@@ -278,7 +296,7 @@ static void update_event_times(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_INACTIVE)
 		run_end = event->tstamp_stopped;
 	else
-		run_end = ctx->time;
+		run_end = perf_event_time(event);
 
 	event->total_time_running = run_end - event->tstamp_running;
 }
@@ -534,6 +552,7 @@ event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
 	u64 delta;
 	/*
 	 * An event which could not be activated because of
@@ -545,7 +564,7 @@ event_sched_out(struct perf_event *event,
 	    && !event_filter_match(event)) {
 		delta = ctx->time - event->tstamp_stopped;
 		event->tstamp_running += delta;
-		event->tstamp_stopped = ctx->time;
+		event->tstamp_stopped = tstamp;
 	}
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -556,7 +575,7 @@ event_sched_out(struct perf_event *event,
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_stopped = tstamp;
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
@@ -768,6 +787,8 @@ event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -784,9 +805,9 @@ event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
+	event->tstamp_running += tstamp - event->tstamp_stopped;
 
-	event->shadow_ctx_time = ctx->time - ctx->timestamp;
+	event->shadow_ctx_time = tstamp - ctx->timestamp;
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -898,11 +919,13 @@ static int group_can_go_on(struct perf_event *event,
 static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
+
 	list_add_event(event, ctx);
 	perf_group_attach(event);
-	event->tstamp_enabled = ctx->time;
-	event->tstamp_running = ctx->time;
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_enabled = tstamp;
+	event->tstamp_running = tstamp;
+	event->tstamp_stopped = tstamp;
 }
 
 /*
@@ -937,7 +960,7 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		goto unlock;
 
 	/*
@@ -1042,14 +1065,13 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->tstamp_enabled = ctx->time - event->total_time_enabled;
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
 	list_for_each_entry(sub, &event->sibling_list, group_entry) {
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
-			sub->tstamp_enabled =
-				ctx->time - sub->total_time_enabled;
-		}
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 	}
 }
 
@@ -1082,7 +1104,7 @@ static void __perf_event_enable(void *info)
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		goto unlock;
 
 	/*
@@ -1193,12 +1215,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-enum event_type_t {
-	EVENT_FLEXIBLE = 0x1,
-	EVENT_PINNED = 0x2,
-	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
-};
-
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,
 			  enum event_type_t event_type)
@@ -1435,7 +1451,7 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, 1))
@@ -1467,7 +1483,7 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
@@ -1694,7 +1710,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		hwc = &event->hw;
@@ -3893,7 +3909,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -4030,7 +4046,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm)
@@ -4178,7 +4194,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53f3381..761c510 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
-obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f8cf959..dc53ecb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1313,12 +1313,10 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 
 	__this_cpu_inc(user_stack_count);
 
-
-
 	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
-		return;
+		goto out_drop_count;
 	entry	= ring_buffer_event_data(event);
 
 	entry->tgid		= current->tgid;
@@ -1333,8 +1331,8 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
 
+ out_drop_count:
 	__this_cpu_dec(user_stack_count);
-
  out:
 	preempt_enable();
 }
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 3094318..b335acb 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -141,11 +141,10 @@ static void ddebug_change(const struct ddebug_query *query,
 			else if (!dp->flags)
 				dt->num_enabled++;
 			dp->flags = newflags;
-			if (newflags) {
-				jump_label_enable(&dp->enabled);
-			} else {
-				jump_label_disable(&dp->enabled);
-			}
+			if (newflags)
+				dp->enabled = 1;
+			else
+				dp->enabled = 0;
 			if (verbose)
 				printk(KERN_INFO
 					"ddebug: changed %s:%d [%s]%s %s\n",
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1b9b13e..2b5387d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -227,7 +227,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7bc0490..7069bd3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -331,6 +331,9 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
+			} else if (err == ENOENT) {
+				die("%s event is not supported. ",
+				     event_name(evsel));
 			} else if (err == EINVAL && sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7a4ebeb..abd4b84 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -489,7 +489,8 @@ static void create_tasks(void)
 
 	err = pthread_attr_init(&attr);
 	BUG_ON(err);
-	err = pthread_attr_setstacksize(&attr, (size_t)(16*1024));
+	err = pthread_attr_setstacksize(&attr,
+			(size_t) max(16 * 1024, PTHREAD_STACK_MIN));
 	BUG_ON(err);
 	err = pthread_mutex_lock(&start_work_mutex);
 	BUG_ON(err);
@@ -1861,7 +1862,7 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
-	if (rec_argv)
+	if (rec_argv == NULL)
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 02b2d80..c385a63 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -316,6 +316,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
+			} else if (errno == ENOENT) {
+				error("%s event is not supported. ", event_name(counter));
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
@@ -683,8 +685,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		nr_counters = ARRAY_SIZE(default_attrs);
 
 		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
-			pos = perf_evsel__new(default_attrs[c].type,
-					      default_attrs[c].config,
+			pos = perf_evsel__new(&default_attrs[c],
 					      nr_counters);
 			if (pos == NULL)
 				goto out;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c98434..ed56961 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -234,6 +234,7 @@ out:
 	return err;
 }
 
+#include "util/cpumap.h"
 #include "util/evsel.h"
 #include <sys/types.h>
 
@@ -264,6 +265,7 @@ static int test__open_syscall_event(void)
 	int err = -1, fd;
 	struct thread_map *threads;
 	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
 	int id = trace_event__id("sys_enter_open");
 
@@ -278,7 +280,10 @@ static int test__open_syscall_event(void)
 		return -1;
 	}
 
-	evsel = perf_evsel__new(PERF_TYPE_TRACEPOINT, id, 0);
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
 		goto out_thread_map_delete;
@@ -317,6 +322,111 @@ out_thread_map_delete:
 	return err;
 }
 
+#include <sched.h>
+
+static int test__open_syscall_event_on_all_cpus(void)
+{
+	int err = -1, fd, cpu;
+	struct thread_map *threads;
+	struct cpu_map *cpus;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	unsigned int nr_open_calls = 111, i;
+	cpu_set_t *cpu_set;
+	size_t cpu_set_size;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		return -1;
+	}
+
+	threads = thread_map__new(-1, getpid());
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpu_set = CPU_ALLOC(cpus->nr);
+
+	if (cpu_set == NULL)
+		goto out_thread_map_delete;
+
+	cpu_set_size = CPU_ALLOC_SIZE(cpus->nr);
+	CPU_ZERO_S(cpu_set_size, cpu_set);
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_cpu_free;
+	}
+
+	if (perf_evsel__open(evsel, cpus, threads) < 0) {
+		pr_debug("failed to open counter: %s, "
+			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+			 strerror(errno));
+		goto out_evsel_delete;
+	}
+
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int ncalls = nr_open_calls + cpu;
+
+		CPU_SET(cpu, cpu_set);
+		sched_setaffinity(0, cpu_set_size, cpu_set);
+		for (i = 0; i < ncalls; ++i) {
+			fd = open("/etc/passwd", O_RDONLY);
+			close(fd);
+		}
+		CPU_CLR(cpu, cpu_set);
+	}
+
+	/*
+	 * Here we need to explicitely preallocate the counts, as if
+	 * we use the auto allocation it will allocate just for 1 cpu,
+	 * as we start by cpu 0.
+	 */
+	if (perf_evsel__alloc_counts(evsel, cpus->nr) < 0) {
+		pr_debug("perf_evsel__alloc_counts(ncpus=%d)\n", cpus->nr);
+		goto out_close_fd;
+	}
+
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int expected;
+
+		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
+			pr_debug("perf_evsel__open_read_on_cpu\n");
+			goto out_close_fd;
+		}
+
+		expected = nr_open_calls + cpu;
+		if (evsel->counts->cpu[cpu].val != expected) {
+			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %Ld\n",
+				 expected, cpu, evsel->counts->cpu[cpu].val);
+			goto out_close_fd;
+		}
+	}
+
+	err = 0;
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_cpu_free:
+	CPU_FREE(cpu_set);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -330,6 +440,10 @@ static struct test {
 		.func = test__open_syscall_event,
 	},
 	{
+		.desc = "detect open syscall event on all cpus",
+		.func = test__open_syscall_event_on_all_cpus,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1e67ab9..6ce4042 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1247,6 +1247,8 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
+			if (err == ENOENT)
+				die("%s event is not supported. ", event_name(evsel));
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c95267e..f5cfed6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -6,14 +6,13 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
-struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx)
+struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
 	if (evsel != NULL) {
 		evsel->idx	   = idx;
-		evsel->attr.type   = type;
-		evsel->attr.config = config;
+		evsel->attr	   = *attr;
 		INIT_LIST_HEAD(&evsel->node);
 	}
 
@@ -128,59 +127,75 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
+static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
+			      struct thread_map *threads)
 {
-	int cpu;
+	int cpu, thread;
 
-	if (evsel->fd == NULL && perf_evsel__alloc_fd(evsel, cpus->nr, 1) < 0)
+	if (evsel->fd == NULL &&
+	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
 		return -1;
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		FD(evsel, cpu, 0) = sys_perf_event_open(&evsel->attr, -1,
-							cpus->map[cpu], -1, 0);
-		if (FD(evsel, cpu, 0) < 0)
-			goto out_close;
+		for (thread = 0; thread < threads->nr; thread++) {
+			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
+								     threads->map[thread],
+								     cpus->map[cpu], -1, 0);
+			if (FD(evsel, cpu, thread) < 0)
+				goto out_close;
+		}
 	}
 
 	return 0;
 
 out_close:
-	while (--cpu >= 0) {
-		close(FD(evsel, cpu, 0));
-		FD(evsel, cpu, 0) = -1;
-	}
+	do {
+		while (--thread >= 0) {
+			close(FD(evsel, cpu, thread));
+			FD(evsel, cpu, thread) = -1;
+		}
+		thread = threads->nr;
+	} while (--cpu >= 0);
 	return -1;
 }
 
-int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads)
+static struct {
+	struct cpu_map map;
+	int cpus[1];
+} empty_cpu_map = {
+	.map.nr	= 1,
+	.cpus	= { -1, },
+};
+
+static struct {
+	struct thread_map map;
+	int threads[1];
+} empty_thread_map = {
+	.map.nr	 = 1,
+	.threads = { -1, },
+};
+
+int perf_evsel__open(struct perf_evsel *evsel,
+		     struct cpu_map *cpus, struct thread_map *threads)
 {
-	int thread;
-
-	if (evsel->fd == NULL && perf_evsel__alloc_fd(evsel, 1, threads->nr))
-		return -1;
 
-	for (thread = 0; thread < threads->nr; thread++) {
-		FD(evsel, 0, thread) = sys_perf_event_open(&evsel->attr,
-							   threads->map[thread], -1, -1, 0);
-		if (FD(evsel, 0, thread) < 0)
-			goto out_close;
+	if (cpus == NULL) {
+		/* Work around old compiler warnings about strict aliasing */
+		cpus = &empty_cpu_map.map;
 	}
 
-	return 0;
+	if (threads == NULL)
+		threads = &empty_thread_map.map;
 
-out_close:
-	while (--thread >= 0) {
-		close(FD(evsel, 0, thread));
-		FD(evsel, 0, thread) = -1;
-	}
-	return -1;
+	return __perf_evsel__open(evsel, cpus, threads);
 }
 
-int perf_evsel__open(struct perf_evsel *evsel, 
-		     struct cpu_map *cpus, struct thread_map *threads)
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
 {
-	if (threads == NULL)
-		return perf_evsel__open_per_cpu(evsel, cpus);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
+}
 
-	return perf_evsel__open_per_thread(evsel, threads);
+int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads)
+{
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads);
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a0ccd69..b2d755f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -37,7 +37,7 @@ struct perf_evsel {
 struct cpu_map;
 struct thread_map;
 
-struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx);
+struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 649083f..5cb6f4b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,6 +490,31 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 	return EVT_HANDLED_ALL;
 }
 
+static int store_event_type(const char *orgname)
+{
+	char filename[PATH_MAX], *c;
+	FILE *file;
+	int id, n;
+
+	sprintf(filename, "%s/", debugfs_path);
+	strncat(filename, orgname, strlen(orgname));
+	strcat(filename, "/id");
+
+	c = strchr(filename, ':');
+	if (c)
+		*c = '/';
+
+	file = fopen(filename, "r");
+	if (!file)
+		return 0;
+	n = fscanf(file, "%i", &id);
+	fclose(file);
+	if (n < 1) {
+		pr_err("cannot store event ID\n");
+		return -EINVAL;
+	}
+	return perf_header__push_event(id, orgname);
+}
 
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
@@ -533,9 +558,13 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		*strp += strlen(sys_name) + evt_length;
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
-	} else
+	} else {
+		if (store_event_type(evt_name) < 0)
+			return EVT_FAILED;
+
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
+	}
 }
 
 static enum event_result
@@ -778,41 +807,11 @@ modifier:
 	return ret;
 }
 
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_event_attr attr;
 	enum event_result ret;
 
-	if (strchr(str, ':'))
-		if (store_event_type(str) < 0)
-			return -1;
-
 	for (;;) {
 		memset(&attr, 0, sizeof(attr));
 		ret = parse_event_symbols(&str, &attr);
@@ -824,7 +823,7 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 
 		if (ret != EVT_HANDLED_ALL) {
 			struct perf_evsel *evsel;
-			evsel = perf_evsel__new(attr.type, attr.config,
+			evsel = perf_evsel__new(&attr,
 						nr_counters);
 			if (evsel == NULL)
 				return -1;
@@ -1014,8 +1013,15 @@ void print_events(void)
 
 int perf_evsel_list__create_default(void)
 {
-	struct perf_evsel *evsel = perf_evsel__new(PERF_TYPE_HARDWARE,
-						   PERF_COUNT_HW_CPU_CYCLES, 0);
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_HARDWARE;
+	attr.config = PERF_COUNT_HW_CPU_CYCLES;
+
+	evsel = perf_evsel__new(&attr, 0);
+
 	if (evsel == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6fb4694..313dac2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1007,7 +1007,7 @@ more:
 	if (size == 0)
 		size = 8;
 
-	if (head + event->header.size >= mmap_size) {
+	if (head + event->header.size > mmap_size) {
 		if (mmaps[map_idx]) {
 			munmap(mmaps[map_idx], mmap_size);
 			mmaps[map_idx] = NULL;
