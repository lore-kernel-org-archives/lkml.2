Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1E1QfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:35:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1E1Qe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:34:56 -0400
Date: Sat, 28 May 2011 18:34:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110528163435.GA9145@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      oprofile: Use linux/mutex.h

Arnaldo Carvalho de Melo (6):
      perf symbols: Handle /proc/sys/kernel/kptr_restrict
      perf tools: Fix build on older systems
      perf tools: Make sure kptr_restrict warnings fit 80 col terms
      perf top: Remove unused macro
      perf top: Handle kptr_restrict
      perf top: Don't stop if no kernel symtab is found

David Ahern (1):
      perf events: initialize fd array to -1 instead of 0

Eric B Munson (1):
      oprofile, powerpc: Handle events that raise an exception without overflowing

Ingo Molnar (1):
      watchdog: Fix non-standard prototype of get_softlockup_thresh()

Jesper Juhl (1):
      perf: Remove duplicate headers

Jiri Olsa (1):
      jump_label: Check entries limit in __jump_label_update

Peter Zijlstra (1):
      perf: Fix SIGIO handling

Rabin Vincent (1):
      ftrace/recordmcount: Avoid STT_FUNC symbols as base on ARM

Rakib Mullick (1):
      x86/ftrace: Fix compiler warning in ftrace.c

Robert Richter (1):
      oprofile, x86: Enable preemption during pci device setup in IBS init

Steven Rostedt (7):
      maccess,probe_kernel: Make write/read src const void *
      scripts/tags.sh: Fix ctags for DEFINE_EVENT()
      scripts/tags.sh: Add magic for trace-events for etags too
      ftrace: Have ftrace_startup() return failure code
      tracing: Have event with function tracer check error return
      ftrace: Set ops->flag to enabled even on static function tracing
      ftrace: Add internal recursive checks

liubo (2):
      tracing: Add __print_symbolic_u64 to avoid warnings on 32bit machine
      tracing: Update btrfs's tracepoints to use u64 interface


 arch/blackfin/mm/maccess.c              |    4 +-
 arch/powerpc/oprofile/op_model_power4.c |   24 ++++++++-
 arch/s390/mm/maccess.c                  |    4 +-
 arch/x86/kernel/ftrace.c                |   12 ++--
 arch/x86/oprofile/op_model_amd.c        |   95 +++++++++++++++++-------------
 drivers/oprofile/event_buffer.h         |    2 +-
 drivers/oprofile/oprof.c                |    2 +-
 include/linux/ftrace_event.h            |   12 ++++
 include/linux/sched.h                   |    2 +-
 include/linux/uaccess.h                 |    8 +-
 include/trace/events/btrfs.h            |    4 +-
 include/trace/ftrace.h                  |   13 ++++
 kernel/events/core.c                    |    8 +++
 kernel/jump_label.c                     |   18 ++++--
 kernel/trace/ftrace.c                   |   31 ++++++++--
 kernel/trace/ring_buffer.c              |   10 ++--
 kernel/trace/trace.h                    |   15 +++++
 kernel/trace/trace_events.c             |    7 ++-
 kernel/trace/trace_output.c             |   27 +++++++++
 kernel/watchdog.c                       |    9 +--
 mm/maccess.c                            |    8 +-
 scripts/recordmcount.h                  |    8 +++
 scripts/tags.sh                         |    6 +-
 tools/perf/Makefile                     |    2 +
 tools/perf/builtin-annotate.c           |    2 -
 tools/perf/builtin-record.c             |   10 +++
 tools/perf/builtin-report.c             |   23 ++++++++
 tools/perf/builtin-script.c             |    1 -
 tools/perf/builtin-top.c                |   37 ++++++++++--
 tools/perf/util/event.c                 |   15 ++++-
 tools/perf/util/evsel.c                 |   10 +++
 tools/perf/util/header.c                |    8 ++-
 tools/perf/util/include/linux/const.h   |    1 +
 tools/perf/util/symbol.c                |   48 ++++++++++++++++
 tools/perf/util/symbol.h                |    3 +-
 35 files changed, 382 insertions(+), 107 deletions(-)
 create mode 100644 tools/perf/util/include/linux/const.h

diff --git a/arch/blackfin/mm/maccess.c b/arch/blackfin/mm/maccess.c
index b71cebc..e253211 100644
--- a/arch/blackfin/mm/maccess.c
+++ b/arch/blackfin/mm/maccess.c
@@ -16,7 +16,7 @@ static int validate_memory_access_address(unsigned long addr, int size)
 	return bfin_mem_access_type(addr, size);
 }
 
-long probe_kernel_read(void *dst, void *src, size_t size)
+long probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	unsigned long lsrc = (unsigned long)src;
 	int mem_type;
@@ -55,7 +55,7 @@ long probe_kernel_read(void *dst, void *src, size_t size)
 	return -EFAULT;
 }
 
-long probe_kernel_write(void *dst, void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	unsigned long ldst = (unsigned long)dst;
 	int mem_type;
diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
index 8ee51a2..e6bec74 100644
--- a/arch/powerpc/oprofile/op_model_power4.c
+++ b/arch/powerpc/oprofile/op_model_power4.c
@@ -261,6 +261,28 @@ static int get_kernel(unsigned long pc, unsigned long mmcra)
 	return is_kernel;
 }
 
+static bool pmc_overflow(unsigned long val)
+{
+	if ((int)val < 0)
+		return true;
+
+	/*
+	 * Events on POWER7 can roll back if a speculative event doesn't
+	 * eventually complete. Unfortunately in some rare cases they will
+	 * raise a performance monitor exception. We need to catch this to
+	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
+	 * cycles from overflow.
+	 *
+	 * We only do this if the first pass fails to find any overflowing
+	 * PMCs because a user might set a period of less than 256 and we
+	 * don't want to mistakenly reset them.
+	 */
+	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
+		return true;
+
+	return false;
+}
+
 static void power4_handle_interrupt(struct pt_regs *regs,
 				    struct op_counter_config *ctr)
 {
@@ -281,7 +303,7 @@ static void power4_handle_interrupt(struct pt_regs *regs,
 
 	for (i = 0; i < cur_cpu_spec->num_pmcs; ++i) {
 		val = classic_ctr_read(i);
-		if (val < 0) {
+		if (pmc_overflow(val)) {
 			if (oprofile_running && ctr[i].enabled) {
 				oprofile_add_ext_sample(pc, regs, i, is_kernel);
 				classic_ctr_write(i, reset_value[i]);
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 71a4b0d..51e5cd9 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -19,7 +19,7 @@
  * using the stura instruction.
  * Returns the number of bytes copied or -EFAULT.
  */
-static long probe_kernel_write_odd(void *dst, void *src, size_t size)
+static long probe_kernel_write_odd(void *dst, const void *src, size_t size)
 {
 	unsigned long count, aligned;
 	int offset, mask;
@@ -45,7 +45,7 @@ static long probe_kernel_write_odd(void *dst, void *src, size_t size)
 	return rc ? rc : count;
 }
 
-long probe_kernel_write(void *dst, void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	long copied = 0;
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0ba15a6..c9a281f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -123,7 +123,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
 static void *mod_code_ip;		/* holds the IP to write to */
-static void *mod_code_newcode;		/* holds the text to write to the IP */
+static const void *mod_code_newcode;	/* holds the text to write to the IP */
 
 static unsigned nmi_wait_count;
 static atomic_t nmi_update_count = ATOMIC_INIT(0);
@@ -225,7 +225,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 }
 
 static int
-do_ftrace_mod_code(unsigned long ip, void *new_code)
+do_ftrace_mod_code(unsigned long ip, const void *new_code)
 {
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
@@ -266,8 +266,8 @@ static const unsigned char *ftrace_nop_replace(void)
 }
 
 static int
-ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-		   unsigned char *new_code)
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
 
@@ -301,7 +301,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *new, *old;
+	unsigned const char *new, *old;
 	unsigned long ip = rec->ip;
 
 	old = ftrace_call_replace(ip, addr);
@@ -312,7 +312,7 @@ int ftrace_make_nop(struct module *mod,
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *new, *old;
+	unsigned const char *new, *old;
 	unsigned long ip = rec->ip;
 
 	old = ftrace_nop_replace();
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index c3b8e24..9fd8a56 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -316,16 +316,23 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
-static inline int eilvt_is_available(int offset)
+static inline int get_eilvt(int offset)
 {
-	/* check if we may assign a vector */
 	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
 }
 
+static inline int put_eilvt(int offset)
+{
+	return !setup_APIC_eilvt(offset, 0, 0, 1);
+}
+
 static inline int ibs_eilvt_valid(void)
 {
 	int offset;
 	u64 val;
+	int valid = 0;
+
+	preempt_disable();
 
 	rdmsrl(MSR_AMD64_IBSCTL, val);
 	offset = val & IBSCTL_LVT_OFFSET_MASK;
@@ -333,16 +340,20 @@ static inline int ibs_eilvt_valid(void)
 	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
 		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
 		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		return 0;
+		goto out;
 	}
 
-	if (!eilvt_is_available(offset)) {
+	if (!get_eilvt(offset)) {
 		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
 		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		return 0;
+		goto out;
 	}
 
-	return 1;
+	valid = 1;
+out:
+	preempt_enable();
+
+	return valid;
 }
 
 static inline int get_ibs_offset(void)
@@ -600,67 +611,69 @@ static int setup_ibs_ctl(int ibs_eilvt_off)
 
 static int force_ibs_eilvt_setup(void)
 {
-	int i;
+	int offset;
 	int ret;
 
-	/* find the next free available EILVT entry */
-	for (i = 1; i < 4; i++) {
-		if (!eilvt_is_available(i))
-			continue;
-		ret = setup_ibs_ctl(i);
-		if (ret)
-			return ret;
-		pr_err(FW_BUG "using offset %d for IBS interrupts\n", i);
-		return 0;
+	/*
+	 * find the next free available EILVT entry, skip offset 0,
+	 * pin search to this cpu
+	 */
+	preempt_disable();
+	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
+		if (get_eilvt(offset))
+			break;
 	}
+	preempt_enable();
 
-	printk(KERN_DEBUG "No EILVT entry available\n");
-
-	return -EBUSY;
-}
-
-static int __init_ibs_nmi(void)
-{
-	int ret;
-
-	if (ibs_eilvt_valid())
-		return 0;
+	if (offset == APIC_EILVT_NR_MAX) {
+		printk(KERN_DEBUG "No EILVT entry available\n");
+		return -EBUSY;
+	}
 
-	ret = force_ibs_eilvt_setup();
+	ret = setup_ibs_ctl(offset);
 	if (ret)
-		return ret;
+		goto out;
 
-	if (!ibs_eilvt_valid())
-		return -EFAULT;
+	if (!ibs_eilvt_valid()) {
+		ret = -EFAULT;
+		goto out;
+	}
 
+	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
 	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
 
 	return 0;
+out:
+	preempt_disable();
+	put_eilvt(offset);
+	preempt_enable();
+	return ret;
 }
 
 /*
  * check and reserve APIC extended interrupt LVT offset for IBS if
  * available
- *
- * init_ibs() preforms implicitly cpu-local operations, so pin this
- * thread to its current CPU
  */
 
 static void init_ibs(void)
 {
-	preempt_disable();
-
 	ibs_caps = get_ibs_caps();
+
 	if (!ibs_caps)
+		return;
+
+	if (ibs_eilvt_valid())
 		goto out;
 
-	if (__init_ibs_nmi() < 0)
-		ibs_caps = 0;
-	else
-		printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
+	if (!force_ibs_eilvt_setup())
+		goto out;
+
+	/* Failed to setup ibs */
+	ibs_caps = 0;
+	return;
 
 out:
-	preempt_enable();
+	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
diff --git a/drivers/oprofile/event_buffer.h b/drivers/oprofile/event_buffer.h
index 4e70749..a8d5bb3 100644
--- a/drivers/oprofile/event_buffer.h
+++ b/drivers/oprofile/event_buffer.h
@@ -11,7 +11,7 @@
 #define EVENT_BUFFER_H
 
 #include <linux/types.h>
-#include <asm/mutex.h>
+#include <linux/mutex.h>
 
 int alloc_event_buffer(void);
 
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index f9bda64..dccd863 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -14,7 +14,7 @@
 #include <linux/moduleparam.h>
 #include <linux/workqueue.h>
 #include <linux/time.h>
-#include <asm/mutex.h>
+#include <linux/mutex.h>
 
 #include "oprof.h"
 #include "event_buffer.h"
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index b5a550a..59d3ef1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -16,6 +16,11 @@ struct trace_print_flags {
 	const char		*name;
 };
 
+struct trace_print_flags_u64 {
+	unsigned long long	mask;
+	const char		*name;
+};
+
 const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 				   unsigned long flags,
 				   const struct trace_print_flags *flag_array);
@@ -23,6 +28,13 @@ const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 				     const struct trace_print_flags *symbol_array);
 
+#if BITS_PER_LONG == 32
+const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
+					 unsigned long long val,
+					 const struct trace_print_flags_u64
+								 *symbol_array);
+#endif
+
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f18300e..106bd8a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1535,7 +1535,7 @@ struct task_struct {
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
 	unsigned long trace;
-	/* bitmask of trace recursion */
+	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index d512d98..5ca0951 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -93,8 +93,8 @@ static inline unsigned long __copy_from_user_nocache(void *to,
  * Safely read from address @src to the buffer at @dst.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long probe_kernel_read(void *dst, void *src, size_t size);
-extern long __probe_kernel_read(void *dst, void *src, size_t size);
+extern long probe_kernel_read(void *dst, const void *src, size_t size);
+extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 
 /*
  * probe_kernel_write(): safely attempt to write to a location
@@ -105,7 +105,7 @@ extern long __probe_kernel_read(void *dst, void *src, size_t size);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long notrace probe_kernel_write(void *dst, void *src, size_t size);
-extern long notrace __probe_kernel_write(void *dst, void *src, size_t size);
+extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
+extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f445cff..4114129 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -28,7 +28,7 @@ struct extent_buffer;
 		{ BTRFS_SHARED_DATA_REF_KEY, 	"SHARED_DATA_REF" })
 
 #define __show_root_type(obj)						\
-	__print_symbolic(obj,						\
+	__print_symbolic_u64(obj,					\
 		{ BTRFS_ROOT_TREE_OBJECTID, 	"ROOT_TREE"	},	\
 		{ BTRFS_EXTENT_TREE_OBJECTID, 	"EXTENT_TREE"	},	\
 		{ BTRFS_CHUNK_TREE_OBJECTID, 	"CHUNK_TREE"	},	\
@@ -125,7 +125,7 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 );
 
 #define __show_map_type(type)						\
-	__print_symbolic(type,						\
+	__print_symbolic_u64(type,					\
 		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
 		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
 		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3e68366..533c49f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -205,6 +205,19 @@
 		ftrace_print_symbols_seq(p, value, symbols);		\
 	})
 
+#undef __print_symbolic_u64
+#if BITS_PER_LONG == 32
+#define __print_symbolic_u64(value, symbol_array...)			\
+	({								\
+		static const struct trace_print_flags_u64 symbols[] =	\
+			{ symbol_array, { -1, NULL } };			\
+		ftrace_print_symbols_seq_u64(p, value, symbols);	\
+	})
+#else
+#define __print_symbolic_u64(value, symbol_array...)			\
+			__print_symbolic(value, symbol_array)
+#endif
+
 #undef __print_hex
 #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c09767f..d863b3c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5028,6 +5028,14 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	else
 		perf_event_output(event, nmi, data, regs);
 
+	if (event->fasync && event->pending_kill) {
+		if (nmi) {
+			event->pending_wakeup = 1;
+			irq_work_queue(&event->pending);
+		} else
+			perf_event_wakeup(event);
+	}
+
 	return ret;
 }
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 74d1c09..fa27e75 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -105,9 +105,12 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
 }
 
 static void __jump_label_update(struct jump_label_key *key,
-		struct jump_entry *entry, int enable)
+				struct jump_entry *entry,
+				struct jump_entry *stop, int enable)
 {
-	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
+	for (; (entry < stop) &&
+	      (entry->key == (jump_label_t)(unsigned long)key);
+	      entry++) {
 		/*
 		 * entry->code set to 0 invalidates module init text sections
 		 * kernel_text_address() verifies we are not in core kernel
@@ -181,7 +184,11 @@ static void __jump_label_mod_update(struct jump_label_key *key, int enable)
 	struct jump_label_mod *mod = key->next;
 
 	while (mod) {
-		__jump_label_update(key, mod->entries, enable);
+		struct module *m = mod->mod;
+
+		__jump_label_update(key, mod->entries,
+				    m->jump_entries + m->num_jump_entries,
+				    enable);
 		mod = mod->next;
 	}
 }
@@ -245,7 +252,8 @@ static int jump_label_add_module(struct module *mod)
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop,
+					    JUMP_LABEL_ENABLE);
 	}
 
 	return 0;
@@ -371,7 +379,7 @@ static void jump_label_update(struct jump_label_key *key, int enable)
 
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, enable);
+		__jump_label_update(key, entry, __stop___jump_table, enable);
 
 #ifdef CONFIG_MODULES
 	__jump_label_mod_update(key, enable);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d017c2c..1ee417f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -109,12 +109,18 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
 static void ftrace_global_list_func(unsigned long ip,
 				    unsigned long parent_ip)
 {
-	struct ftrace_ops *op = rcu_dereference_raw(ftrace_global_list); /*see above*/
+	struct ftrace_ops *op;
+
+	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
+		return;
 
+	trace_recursion_set(TRACE_GLOBAL_BIT);
+	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 	while (op != &ftrace_list_end) {
 		op->func(ip, parent_ip);
 		op = rcu_dereference_raw(op->next); /*see above*/
 	};
+	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
@@ -1638,12 +1644,12 @@ static void ftrace_startup_enable(int command)
 	ftrace_run_update_code(command);
 }
 
-static void ftrace_startup(struct ftrace_ops *ops, int command)
+static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
 	bool hash_enable = true;
 
 	if (unlikely(ftrace_disabled))
-		return;
+		return -ENODEV;
 
 	ftrace_start_up++;
 	command |= FTRACE_ENABLE_CALLS;
@@ -1662,6 +1668,8 @@ static void ftrace_startup(struct ftrace_ops *ops, int command)
 		ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
+
+	return 0;
 }
 
 static void ftrace_shutdown(struct ftrace_ops *ops, int command)
@@ -2501,7 +2509,7 @@ static void __enable_ftrace_function_probe(void)
 
 	ret = __register_ftrace_function(&trace_probe_ops);
 	if (!ret)
-		ftrace_startup(&trace_probe_ops, 0);
+		ret = ftrace_startup(&trace_probe_ops, 0);
 
 	ftrace_probe_registered = 1;
 }
@@ -3466,7 +3474,11 @@ device_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(ops, command)	do { } while (0)
+# define ftrace_startup(ops, command)			\
+	({						\
+		(ops)->flags |= FTRACE_OPS_FL_ENABLED;	\
+		0;					\
+	})
 # define ftrace_shutdown(ops, command)	do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
@@ -3484,6 +3496,10 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op;
 
+	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
+		return;
+
+	trace_recursion_set(TRACE_INTERNAL_BIT);
 	/*
 	 * Some of the ops may be dynamically allocated,
 	 * they must be freed after a synchronize_sched().
@@ -3496,6 +3512,7 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();
+	trace_recursion_clear(TRACE_INTERNAL_BIT);
 }
 
 static void clear_ftrace_swapper(void)
@@ -3799,7 +3816,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	ret = __register_ftrace_function(ops);
 	if (!ret)
-		ftrace_startup(ops, 0);
+		ret = ftrace_startup(ops, 0);
 
 
  out_unlock:
@@ -4045,7 +4062,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-	ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
+	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0ef7b4b..b0c7aa4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2216,7 +2216,7 @@ static noinline void trace_recursive_fail(void)
 
 	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
 		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
-		    current->trace_recursion,
+		    trace_recursion_buffer(),
 		    hardirq_count() >> HARDIRQ_SHIFT,
 		    softirq_count() >> SOFTIRQ_SHIFT,
 		    in_nmi());
@@ -2226,9 +2226,9 @@ static noinline void trace_recursive_fail(void)
 
 static inline int trace_recursive_lock(void)
 {
-	current->trace_recursion++;
+	trace_recursion_inc();
 
-	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
+	if (likely(trace_recursion_buffer() < TRACE_RECURSIVE_DEPTH))
 		return 0;
 
 	trace_recursive_fail();
@@ -2238,9 +2238,9 @@ static inline int trace_recursive_lock(void)
 
 static inline void trace_recursive_unlock(void)
 {
-	WARN_ON_ONCE(!current->trace_recursion);
+	WARN_ON_ONCE(!trace_recursion_buffer());
 
-	current->trace_recursion--;
+	trace_recursion_dec();
 }
 
 #else
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6b69c4b..229f859 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -784,4 +784,19 @@ extern const char *__stop___trace_bprintk_fmt[];
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
 #include "trace_entries.h"
 
+/* Only current can touch trace_recursion */
+#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
+#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
+
+/* Ring buffer has the 10 LSB bits to count */
+#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
+
+/* for function tracing recursion */
+#define TRACE_INTERNAL_BIT		(1<<11)
+#define TRACE_GLOBAL_BIT		(1<<12)
+
+#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
+#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
+#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2fe1103..686ec39 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1657,7 +1657,12 @@ static struct ftrace_ops trace_ops __initdata  =
 
 static __init void event_trace_self_test_with_function(void)
 {
-	register_ftrace_function(&trace_ops);
+	int ret;
+	ret = register_ftrace_function(&trace_ops);
+	if (WARN_ON(ret < 0)) {
+		pr_info("Failed to enable function tracer for event tests\n");
+		return;
+	}
 	pr_info("Running tests again, along with the function tracer\n");
 	event_trace_self_tests();
 	unregister_ftrace_function(&trace_ops);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cf535cc..e37de49 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -353,6 +353,33 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 }
 EXPORT_SYMBOL(ftrace_print_symbols_seq);
 
+#if BITS_PER_LONG == 32
+const char *
+ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
+			 const struct trace_print_flags_u64 *symbol_array)
+{
+	int i;
+	const char *ret = p->buffer + p->len;
+
+	for (i = 0;  symbol_array[i].name; i++) {
+
+		if (val != symbol_array[i].mask)
+			continue;
+
+		trace_seq_puts(p, symbol_array[i].name);
+		break;
+	}
+
+	if (!p->len)
+		trace_seq_printf(p, "0x%llx", val);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_symbols_seq_u64);
+#endif
+
 const char *
 ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 {
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7daa4b0..3d0c56a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -415,15 +415,13 @@ static void watchdog_nmi_disable(int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* prepare/enable/disable routines */
-static int watchdog_prepare_cpu(int cpu)
+static void watchdog_prepare_cpu(int cpu)
 {
 	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
 
 	WARN_ON(per_cpu(softlockup_watchdog, cpu));
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = watchdog_timer_fn;
-
-	return 0;
 }
 
 static int watchdog_enable(int cpu)
@@ -542,17 +540,16 @@ static int __cpuinit
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
-	int err = 0;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		err = watchdog_prepare_cpu(hotcpu);
+		watchdog_prepare_cpu(hotcpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		if (watchdog_enabled)
-			err = watchdog_enable(hotcpu);
+			watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
diff --git a/mm/maccess.c b/mm/maccess.c
index e2b6f56..4cee182 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -15,10 +15,10 @@
  * happens, handle that and return -EFAULT.
  */
 
-long __weak probe_kernel_read(void *dst, void *src, size_t size)
+long __weak probe_kernel_read(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
-long __probe_kernel_read(void *dst, void *src, size_t size)
+long __probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
@@ -43,10 +43,10 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long __weak probe_kernel_write(void *dst, void *src, size_t size)
+long __weak probe_kernel_write(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_write")));
 
-long __probe_kernel_write(void *dst, void *src, size_t size)
+long __probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 4be6036..f40a6af6 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -43,6 +43,7 @@
 #undef ELF_R_INFO
 #undef Elf_r_info
 #undef ELF_ST_BIND
+#undef ELF_ST_TYPE
 #undef fn_ELF_R_SYM
 #undef fn_ELF_R_INFO
 #undef uint_t
@@ -76,6 +77,7 @@
 # define ELF_R_INFO		ELF64_R_INFO
 # define Elf_r_info		Elf64_r_info
 # define ELF_ST_BIND		ELF64_ST_BIND
+# define ELF_ST_TYPE		ELF64_ST_TYPE
 # define fn_ELF_R_SYM		fn_ELF64_R_SYM
 # define fn_ELF_R_INFO		fn_ELF64_R_INFO
 # define uint_t			uint64_t
@@ -108,6 +110,7 @@
 # define ELF_R_INFO		ELF32_R_INFO
 # define Elf_r_info		Elf32_r_info
 # define ELF_ST_BIND		ELF32_ST_BIND
+# define ELF_ST_TYPE		ELF32_ST_TYPE
 # define fn_ELF_R_SYM		fn_ELF32_R_SYM
 # define fn_ELF_R_INFO		fn_ELF32_R_INFO
 # define uint_t			uint32_t
@@ -427,6 +430,11 @@ static unsigned find_secsym_ndx(unsigned const txtndx,
 		if (txtndx == w2(symp->st_shndx)
 			/* avoid STB_WEAK */
 		    && (STB_LOCAL == st_bind || STB_GLOBAL == st_bind)) {
+			/* function symbols on ARM have quirks, avoid them */
+			if (w2(ehdr->e_machine) == EM_ARM
+			    && ELF_ST_TYPE(symp->st_info) == STT_FUNC)
+				continue;
+
 			*recvalp = _w(symp->st_value);
 			return symp - sym0;
 		}
diff --git a/scripts/tags.sh b/scripts/tags.sh
index bd6185d..75c5d24 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -132,7 +132,7 @@ exuberant()
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
-	--regex-c++='/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'
+	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -152,7 +152,9 @@ emacs()
 {
 	all_sources | xargs $1 -a                               \
 	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
-	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'
+	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
+	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
+	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1455413..032ba63 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -215,11 +215,13 @@ LIB_FILE=$(OUTPUT)libperf.a
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
+LIB_H += ../../include/linux/const.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += util/include/linux/compiler.h
+LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e18eb7e..7b139e1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -8,8 +8,6 @@
 #include "builtin.h"
 
 #include "util/util.h"
-
-#include "util/util.h"
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0974f95..8e2c857 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -823,6 +823,16 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	symbol__init();
 
+	if (symbol_conf.kptr_restrict)
+		pr_warning(
+"WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted,\n"
+"check /proc/sys/kernel/kptr_restrict.\n\n"
+"Samples in kernel functions may not be resolved if a suitable vmlinux\n"
+"file is not found in the buildid cache or in the vmlinux path.\n\n"
+"Samples in kernel modules won't be resolved at all.\n\n"
+"If some relocation was applied (e.g. kexec) symbols may be misresolved\n"
+"even with a suitable vmlinux or kallsyms file.\n\n");
+
 	if (no_buildid_cache || no_buildid)
 		disable_buildid_cache();
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 498c6f7..287a173 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -116,6 +116,9 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
 	if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
@@ -249,6 +252,8 @@ static int __cmd_report(void)
 	u64 nr_samples;
 	struct perf_session *session;
 	struct perf_evsel *pos;
+	struct map *kernel_map;
+	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	signal(SIGINT, sig_handler);
@@ -268,6 +273,24 @@ static int __cmd_report(void)
 	if (ret)
 		goto out_delete;
 
+	kernel_map = session->host_machine.vmlinux_maps[MAP__FUNCTION];
+	kernel_kmap = map__kmap(kernel_map);
+	if (kernel_map == NULL ||
+	    (kernel_map->dso->hit &&
+	     (kernel_kmap->ref_reloc_sym == NULL ||
+	      kernel_kmap->ref_reloc_sym->addr == 0))) {
+		const struct dso *kdso = kernel_map->dso;
+
+		ui__warning(
+"Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
+"Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
+"Samples in kernel modules can't be resolved as well.\n\n",
+			    RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION]) ?
+"As no suitable kallsyms nor vmlinux was found, kernel samples\n"
+"can't be resolved." :
+"If some relocation was applied (e.g. kexec) symbols may be misresolved.");
+	}
+
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
 		goto out_delete;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 974f6d3..22747de 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -10,7 +10,6 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
-#include "util/parse-options.h"
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2d7934e..f2f3f49 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -62,8 +62,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 static struct perf_top top = {
 	.count_filter		= 5,
 	.delay_secs		= 2,
@@ -82,6 +80,8 @@ static bool			use_tui, use_stdio;
 
 static int			default_interval		=      0;
 
+static bool			kptr_restrict_warned;
+static bool			vmlinux_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
@@ -740,7 +740,22 @@ static void perf_event__process_sample(const union perf_event *event,
 	    al.filtered)
 		return;
 
+	if (!kptr_restrict_warned &&
+	    symbol_conf.kptr_restrict &&
+	    al.cpumode == PERF_RECORD_MISC_KERNEL) {
+		ui__warning(
+"Kernel address maps (/proc/{kallsyms,modules}) are restricted.\n\n"
+"Check /proc/sys/kernel/kptr_restrict.\n\n"
+"Kernel%s samples will not be resolved.\n",
+			  !RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION]) ?
+			  " modules" : "");
+		if (use_browser <= 0)
+			sleep(5);
+		kptr_restrict_warned = true;
+	}
+
 	if (al.sym == NULL) {
+		const char *msg = "Kernel samples will not be resolved.\n";
 		/*
 		 * As we do lazy loading of symtabs we only will know if the
 		 * specified vmlinux file is invalid when we actually have a
@@ -752,12 +767,20 @@ static void perf_event__process_sample(const union perf_event *event,
 		 * --hide-kernel-symbols, even if the user specifies an
 		 * invalid --vmlinux ;-)
 		 */
-		if (al.map == machine->vmlinux_maps[MAP__FUNCTION] &&
+		if (!kptr_restrict_warned && !vmlinux_warned &&
+		    al.map == machine->vmlinux_maps[MAP__FUNCTION] &&
 		    RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION])) {
-			ui__warning("The %s file can't be used\n",
-				    symbol_conf.vmlinux_name);
-			exit_browser(0);
-			exit(1);
+			if (symbol_conf.vmlinux_name) {
+				ui__warning("The %s file can't be used.\n%s",
+					    symbol_conf.vmlinux_name, msg);
+			} else {
+				ui__warning("A vmlinux file was not found.\n%s",
+					    msg);
+			}
+
+			if (use_browser <= 0)
+				sleep(5);
+			vmlinux_warned = true;
 		}
 
 		return;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6635fcd..0fe9adf 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -553,9 +553,18 @@ static int perf_event__process_kernel_mmap(union perf_event *event,
 			goto out_problem;
 
 		perf_event__set_kernel_mmap_len(event, machine->vmlinux_maps);
-		perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
-							 symbol_name,
-							 event->mmap.pgoff);
+
+		/*
+		 * Avoid using a zero address (kptr_restrict) for the ref reloc
+		 * symbol. Effectively having zero here means that at record
+		 * time /proc/sys/kernel/kptr_restrict was non zero.
+		 */
+		if (event->mmap.pgoff != 0) {
+			perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
+								 symbol_name,
+								 event->mmap.pgoff);
+		}
+
 		if (machine__is_default_guest(machine)) {
 			/*
 			 * preload dso of guest kernel and modules
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ee0fe0d..cca29ed 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -35,7 +35,17 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
+	int cpu, thread;
 	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
+
+	if (evsel->fd) {
+		for (cpu = 0; cpu < ncpus; cpu++) {
+			for (thread = 0; thread < nthreads; thread++) {
+				FD(evsel, cpu, thread) = -1;
+			}
+		}
+	}
+
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0717beb..afb0849 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -193,9 +193,13 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
 
-	if (is_kallsyms)
+	if (is_kallsyms) {
+		if (symbol_conf.kptr_restrict) {
+			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
+			return 0;
+		}
 		realname = (char *)name;
-	else
+	} else
 		realname = realpath(name, NULL);
 
 	if (realname == NULL || filename == NULL || linkname == NULL)
diff --git a/tools/perf/util/include/linux/const.h b/tools/perf/util/include/linux/const.h
new file mode 100644
index 0000000..1b476c9
--- /dev/null
+++ b/tools/perf/util/include/linux/const.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/const.h"
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 516876d..eec1963 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -676,9 +676,30 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	return count + moved;
 }
 
+static bool symbol__restricted_filename(const char *filename,
+					const char *restricted_filename)
+{
+	bool restricted = false;
+
+	if (symbol_conf.kptr_restrict) {
+		char *r = realpath(filename, NULL);
+
+		if (r != NULL) {
+			restricted = strcmp(r, restricted_filename) == 0;
+			free(r);
+			return restricted;
+		}
+	}
+
+	return restricted;
+}
+
 int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
+	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+		return -1;
+
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
@@ -1790,6 +1811,9 @@ static int machine__create_modules(struct machine *machine)
 		modules = path;
 	}
 
+	if (symbol__restricted_filename(path, "/proc/modules"))
+		return -1;
+
 	file = fopen(modules, "r");
 	if (file == NULL)
 		return -1;
@@ -2239,6 +2263,9 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 		}
 	}
 
+	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+		return 0;
+
 	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
 		return 0;
 
@@ -2410,6 +2437,25 @@ static int setup_list(struct strlist **list, const char *list_str,
 	return 0;
 }
 
+static bool symbol__read_kptr_restrict(void)
+{
+	bool value = false;
+
+	if (geteuid() != 0) {
+		FILE *fp = fopen("/proc/sys/kernel/kptr_restrict", "r");
+		if (fp != NULL) {
+			char line[8];
+
+			if (fgets(line, sizeof(line), fp) != NULL)
+				value = atoi(line) != 0;
+
+			fclose(fp);
+		}
+	}
+
+	return value;
+}
+
 int symbol__init(void)
 {
 	const char *symfs;
@@ -2456,6 +2502,8 @@ int symbol__init(void)
 	if (symfs != symbol_conf.symfs)
 		free((void *)symfs);
 
+	symbol_conf.kptr_restrict = symbol__read_kptr_restrict();
+
 	symbol_conf.initialized = true;
 	return 0;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 242de01..325ee36 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -75,7 +75,8 @@ struct symbol_conf {
 			use_callchain,
 			exclude_other,
 			show_cpu_utilization,
-			initialized;
+			initialized,
+			kptr_restrict;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
