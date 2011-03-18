Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1CRNrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:47:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab1CRNro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:47:44 -0400
Date: Fri, 18 Mar 2011 14:47:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes/updates
Message-ID: <20110318134717.GA2613@elte.hu>
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

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

It includes the v2.6.39 Oprofile bits, some late tools/perf infrastructure 
updates and fixes.

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      perf, powerpc: Handle events that raise an exception without overflowing

Arnaldo Carvalho de Melo (5):
      perf top: Remove redundant perf_top->sym_counter
      perf top: Remove redundant syme->origin field
      perf symbols: Rename dso->origin to dso->symtab_type
      perf symbol: Move sym_entry->skip to symbol->ignore
      perf evlist: New command to list the names of events present in a perf.data file

David Ahern (6):
      perf script: Change process_event prototype
      perf tracing: Remove print_graph_cpu and print_graph_proc from trace-event-parse
      perf script: Move printing of 'common' data from print_event and rename
      perf script: Support custom field selection for output
      perf script: Add support for dumping symbols
      perf script: Add support for H/W and S/W events

David Rientjes (1):
      trace, documentation: Fix branch profiling location in debugfs

Frederic Weisbecker (3):
      perf stat: Provide support for filters
      perf: Fix the software events state check
      perf: Handle stopped state with tracepoints

Heinz Graalfs (4):
      oprofile: Introduce new oprofile sample add function (oprofile_add_ext_hw_sample)
      oprofile, s390: Add support for hardware based sampling on System z processors
      oprofile, s390: Enhance OProfile to support System zs hardware sampling feature
      oprofile, s390: Remove hwsampler_files.c and merge it into init.c

Ingo Molnar (1):
      trace, filters: Initialize the match variable in process_ops() properly

Josh Hunt (1):
      perf tools: Version incorrect with some versions of grep

Lin Ming (2):
      perf, x86: Clean up SandyBridge PEBS events
      perf, x86: Use INTEL_*_CONSTRAINT() for all PEBS event constraints

Marcin Slusarz (1):
      perf lock: Fix sorting by wait_min

Peter Zijlstra (1):
      perf: Fix tear-down of inherited group events

Richard Kennedy (1):
      perf: Reorder & optimize perf_event_context to remove alignment padding on 64 bit builds

Robert Richter (3):
      oprofile, s390: Rework hwsampler implementation
      oprofile, s390: Fix section mismatch of function hws_cpu_callback()
      oprofile, s390: Cleanups


 arch/powerpc/include/asm/reg.h                     |    1 +
 arch/powerpc/kernel/perf_event.c                   |   24 +-
 arch/s390/oprofile/Makefile                        |    2 +-
 arch/s390/oprofile/hwsampler.c                     | 1256 ++++++++++++++++++++
 arch/s390/oprofile/hwsampler.h                     |  113 ++
 arch/s390/oprofile/init.c                          |  165 +++-
 arch/x86/kernel/cpu/perf_event.c                   |    2 -
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  112 +-
 drivers/oprofile/cpu_buffer.c                      |   24 +-
 drivers/oprofile/timer_int.c                       |    4 +-
 include/linux/oprofile.h                           |    7 +
 include/linux/perf_event.h                         |    2 +-
 kernel/perf_event.c                                |   17 +-
 kernel/trace/Kconfig                               |    4 +-
 kernel/trace/trace_events_filter.c                 |    2 +-
 tools/perf/Documentation/perf-evlist.txt           |   26 +
 tools/perf/Documentation/perf-script.txt           |   22 +
 tools/perf/Makefile                                |    1 +
 tools/perf/builtin-evlist.c                        |   54 +
 tools/perf/builtin-lock.c                          |   13 +-
 tools/perf/builtin-script.c                        |  300 +++++-
 tools/perf/builtin-stat.c                          |    8 +
 tools/perf/builtin-top.c                           |   20 +-
 tools/perf/builtin.h                               |    1 +
 tools/perf/command-list.txt                        |    1 +
 tools/perf/perf.c                                  |    1 +
 tools/perf/util/PERF-VERSION-GEN                   |    8 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/parse-events.c                     |   22 +
 tools/perf/util/parse-events.h                     |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |   11 +-
 .../util/scripting-engines/trace-event-python.c    |   11 +-
 tools/perf/util/session.c                          |   61 +
 tools/perf/util/session.h                          |    4 +
 tools/perf/util/symbol.c                           |   64 +-
 tools/perf/util/symbol.h                           |   31 +-
 tools/perf/util/top.c                              |    6 +-
 tools/perf/util/top.h                              |    4 +-
 tools/perf/util/trace-event-parse.c                |  110 +--
 tools/perf/util/trace-event-scripting.c            |    9 +-
 tools/perf/util/trace-event.h                      |   10 +-
 41 files changed, 2240 insertions(+), 296 deletions(-)
 create mode 100644 arch/s390/oprofile/hwsampler.c
 create mode 100644 arch/s390/oprofile/hwsampler.h
 create mode 100644 tools/perf/Documentation/perf-evlist.txt
 create mode 100644 tools/perf/builtin-evlist.c

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 125fc1a..7626fa7 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -880,6 +880,7 @@
 #define PV_970		0x0039
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
+#define PV_POWER7	0x003F
 #define PV_970FX	0x003C
 #define PV_630		0x0040
 #define PV_630p	0x0041
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index ab6f6be..97e0ae4 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1269,6 +1269,28 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 	return ip;
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
 /*
  * Performance monitor interrupt stuff
  */
@@ -1316,7 +1338,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 			if (is_limited_pmc(i + 1))
 				continue;
 			val = read_pmc(i + 1);
-			if ((int)val < 0)
+			if (pmc_overflow(val))
 				write_pmc(i + 1, 0);
 		}
 	}
diff --git a/arch/s390/oprofile/Makefile b/arch/s390/oprofile/Makefile
index 537b2d8..d698cdd 100644
--- a/arch/s390/oprofile/Makefile
+++ b/arch/s390/oprofile/Makefile
@@ -6,4 +6,4 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o  \
 		timer_int.o )
 
-oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
+oprofile-y :=	$(DRIVER_OBJS) init.o backtrace.o hwsampler.o
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
new file mode 100644
index 0000000..3d48f4d
--- /dev/null
+++ b/arch/s390/oprofile/hwsampler.c
@@ -0,0 +1,1256 @@
+/**
+ * arch/s390/oprofile/hwsampler.c
+ *
+ * Copyright IBM Corp. 2010
+ * Author: Heinz Graalfs <graalfs@de.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/semaphore.h>
+#include <linux/oom.h>
+#include <linux/oprofile.h>
+
+#include <asm/lowcore.h>
+#include <asm/s390_ext.h>
+
+#include "hwsampler.h"
+
+#define MAX_NUM_SDB 511
+#define MIN_NUM_SDB 1
+
+#define ALERT_REQ_MASK   0x4000000000000000ul
+#define BUFFER_FULL_MASK 0x8000000000000000ul
+
+#define EI_IEA      (1 << 31)	/* invalid entry address              */
+#define EI_ISE      (1 << 30)	/* incorrect SDBT entry               */
+#define EI_PRA      (1 << 29)	/* program request alert              */
+#define EI_SACA     (1 << 23)	/* sampler authorization change alert */
+#define EI_LSDA     (1 << 22)	/* loss of sample data alert          */
+
+DECLARE_PER_CPU(struct hws_cpu_buffer, sampler_cpu_buffer);
+
+struct hws_execute_parms {
+	void *buffer;
+	signed int rc;
+};
+
+DEFINE_PER_CPU(struct hws_cpu_buffer, sampler_cpu_buffer);
+EXPORT_PER_CPU_SYMBOL(sampler_cpu_buffer);
+
+static DEFINE_MUTEX(hws_sem);
+static DEFINE_MUTEX(hws_sem_oom);
+
+static unsigned char hws_flush_all;
+static unsigned int hws_oom;
+static struct workqueue_struct *hws_wq;
+
+static unsigned int hws_state;
+enum {
+	HWS_INIT = 1,
+	HWS_DEALLOCATED,
+	HWS_STOPPED,
+	HWS_STARTED,
+	HWS_STOPPING };
+
+/* set to 1 if called by kernel during memory allocation */
+static unsigned char oom_killer_was_active;
+/* size of SDBT and SDB as of allocate API */
+static unsigned long num_sdbt = 100;
+static unsigned long num_sdb = 511;
+/* sampling interval (machine cycles) */
+static unsigned long interval;
+
+static unsigned long min_sampler_rate;
+static unsigned long max_sampler_rate;
+
+static int ssctl(void *buffer)
+{
+	int cc;
+
+	/* set in order to detect a program check */
+	cc = 1;
+
+	asm volatile(
+		"0: .insn s,0xB2870000,0(%1)\n"
+		"1: ipm %0\n"
+		"   srl %0,28\n"
+		"2:\n"
+		EX_TABLE(0b, 2b) EX_TABLE(1b, 2b)
+		: "+d" (cc), "+a" (buffer)
+		: "m" (*((struct hws_ssctl_request_block *)buffer))
+		: "cc", "memory");
+
+	return cc ? -EINVAL : 0 ;
+}
+
+static int qsi(void *buffer)
+{
+	int cc;
+	cc = 1;
+
+	asm volatile(
+		"0: .insn s,0xB2860000,0(%1)\n"
+		"1: lhi %0,0\n"
+		"2:\n"
+		EX_TABLE(0b, 2b) EX_TABLE(1b, 2b)
+		: "=d" (cc), "+a" (buffer)
+		: "m" (*((struct hws_qsi_info_block *)buffer))
+		: "cc", "memory");
+
+	return cc ? -EINVAL : 0;
+}
+
+static void execute_qsi(void *parms)
+{
+	struct hws_execute_parms *ep = parms;
+
+	ep->rc = qsi(ep->buffer);
+}
+
+static void execute_ssctl(void *parms)
+{
+	struct hws_execute_parms *ep = parms;
+
+	ep->rc = ssctl(ep->buffer);
+}
+
+static int smp_ctl_ssctl_stop(int cpu)
+{
+	int rc;
+	struct hws_execute_parms ep;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	cb->ssctl.es = 0;
+	cb->ssctl.cs = 0;
+
+	ep.buffer = &cb->ssctl;
+	smp_call_function_single(cpu, execute_ssctl, &ep, 1);
+	rc = ep.rc;
+	if (rc) {
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF SSCTL failed.\n", cpu);
+		dump_stack();
+	}
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+
+	if (cb->qsi.es || cb->qsi.cs) {
+		printk(KERN_EMERG "CPUMF sampling did not stop properly.\n");
+		dump_stack();
+	}
+
+	return rc;
+}
+
+static int smp_ctl_ssctl_deactivate(int cpu)
+{
+	int rc;
+	struct hws_execute_parms ep;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	cb->ssctl.es = 1;
+	cb->ssctl.cs = 0;
+
+	ep.buffer = &cb->ssctl;
+	smp_call_function_single(cpu, execute_ssctl, &ep, 1);
+	rc = ep.rc;
+	if (rc)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF SSCTL failed.\n", cpu);
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+
+	if (cb->qsi.cs)
+		printk(KERN_EMERG "CPUMF sampling was not set inactive.\n");
+
+	return rc;
+}
+
+static int smp_ctl_ssctl_enable_activate(int cpu, unsigned long interval)
+{
+	int rc;
+	struct hws_execute_parms ep;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	cb->ssctl.h = 1;
+	cb->ssctl.tear = cb->first_sdbt;
+	cb->ssctl.dear = *(unsigned long *) cb->first_sdbt;
+	cb->ssctl.interval = interval;
+	cb->ssctl.es = 1;
+	cb->ssctl.cs = 1;
+
+	ep.buffer = &cb->ssctl;
+	smp_call_function_single(cpu, execute_ssctl, &ep, 1);
+	rc = ep.rc;
+	if (rc)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF SSCTL failed.\n", cpu);
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+	if (ep.rc)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF QSI failed.\n", cpu);
+
+	return rc;
+}
+
+static int smp_ctl_qsi(int cpu)
+{
+	struct hws_execute_parms ep;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+
+	return ep.rc;
+}
+
+static inline unsigned long *trailer_entry_ptr(unsigned long v)
+{
+	void *ret;
+
+	ret = (void *)v;
+	ret += PAGE_SIZE;
+	ret -= sizeof(struct hws_trailer_entry);
+
+	return (unsigned long *) ret;
+}
+
+/* prototypes for external interrupt handler and worker */
+static void hws_ext_handler(unsigned int ext_int_code,
+				unsigned int param32, unsigned long param64);
+
+static void worker(struct work_struct *work);
+
+static void add_samples_to_oprofile(unsigned cpu, unsigned long *,
+				unsigned long *dear);
+
+static void init_all_cpu_buffers(void)
+{
+	int cpu;
+	struct hws_cpu_buffer *cb;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+		memset(cb, 0, sizeof(struct hws_cpu_buffer));
+	}
+}
+
+static int is_link_entry(unsigned long *s)
+{
+	return *s & 0x1ul ? 1 : 0;
+}
+
+static unsigned long *get_next_sdbt(unsigned long *s)
+{
+	return (unsigned long *) (*s & ~0x1ul);
+}
+
+static int prepare_cpu_buffers(void)
+{
+	int cpu;
+	int rc;
+	struct hws_cpu_buffer *cb;
+
+	rc = 0;
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+		atomic_set(&cb->ext_params, 0);
+		cb->worker_entry = 0;
+		cb->sample_overflow = 0;
+		cb->req_alert = 0;
+		cb->incorrect_sdbt_entry = 0;
+		cb->invalid_entry_address = 0;
+		cb->loss_of_sample_data = 0;
+		cb->sample_auth_change_alert = 0;
+		cb->finish = 0;
+		cb->oom = 0;
+		cb->stop_mode = 0;
+	}
+
+	return rc;
+}
+
+/*
+ * allocate_sdbt() - allocate sampler memory
+ * @cpu: the cpu for which sampler memory is allocated
+ *
+ * A 4K page is allocated for each requested SDBT.
+ * A maximum of 511 4K pages are allocated for the SDBs in each of the SDBTs.
+ * Set ALERT_REQ mask in each SDBs trailer.
+ * Returns zero if successful, <0 otherwise.
+ */
+static int allocate_sdbt(int cpu)
+{
+	int j, k, rc;
+	unsigned long *sdbt;
+	unsigned long  sdb;
+	unsigned long *tail;
+	unsigned long *trailer;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	if (cb->first_sdbt)
+		return -EINVAL;
+
+	sdbt = NULL;
+	tail = sdbt;
+
+	for (j = 0; j < num_sdbt; j++) {
+		sdbt = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+
+		mutex_lock(&hws_sem_oom);
+		/* OOM killer might have been activated */
+		barrier();
+		if (oom_killer_was_active || !sdbt) {
+			if (sdbt)
+				free_page((unsigned long)sdbt);
+
+			goto allocate_sdbt_error;
+		}
+		if (cb->first_sdbt == 0)
+			cb->first_sdbt = (unsigned long)sdbt;
+
+		/* link current page to tail of chain */
+		if (tail)
+			*tail = (unsigned long)(void *)sdbt + 1;
+
+		mutex_unlock(&hws_sem_oom);
+
+		for (k = 0; k < num_sdb; k++) {
+			/* get and set SDB page */
+			sdb = get_zeroed_page(GFP_KERNEL);
+
+			mutex_lock(&hws_sem_oom);
+			/* OOM killer might have been activated */
+			barrier();
+			if (oom_killer_was_active || !sdb) {
+				if (sdb)
+					free_page(sdb);
+
+				goto allocate_sdbt_error;
+			}
+			*sdbt = sdb;
+			trailer = trailer_entry_ptr(*sdbt);
+			*trailer = ALERT_REQ_MASK;
+			sdbt++;
+			mutex_unlock(&hws_sem_oom);
+		}
+		tail = sdbt;
+	}
+	mutex_lock(&hws_sem_oom);
+	if (oom_killer_was_active)
+		goto allocate_sdbt_error;
+
+	rc = 0;
+	if (tail)
+		*tail = (unsigned long)
+			((void *)cb->first_sdbt) + 1;
+
+allocate_sdbt_exit:
+	mutex_unlock(&hws_sem_oom);
+	return rc;
+
+allocate_sdbt_error:
+	rc = -ENOMEM;
+	goto allocate_sdbt_exit;
+}
+
+/*
+ * deallocate_sdbt() - deallocate all sampler memory
+ *
+ * For each online CPU all SDBT trees are deallocated.
+ * Returns the number of freed pages.
+ */
+static int deallocate_sdbt(void)
+{
+	int cpu;
+	int counter;
+
+	counter = 0;
+
+	for_each_online_cpu(cpu) {
+		unsigned long start;
+		unsigned long sdbt;
+		unsigned long *curr;
+		struct hws_cpu_buffer *cb;
+
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+		if (!cb->first_sdbt)
+			continue;
+
+		sdbt = cb->first_sdbt;
+		curr = (unsigned long *) sdbt;
+		start = sdbt;
+
+		/* we'll free the SDBT after all SDBs are processed... */
+		while (1) {
+			if (!*curr || !sdbt)
+				break;
+
+			/* watch for link entry reset if found */
+			if (is_link_entry(curr)) {
+				curr = get_next_sdbt(curr);
+				if (sdbt)
+					free_page(sdbt);
+
+				/* we are done if we reach the start */
+				if ((unsigned long) curr == start)
+					break;
+				else
+					sdbt = (unsigned long) curr;
+			} else {
+				/* process SDB pointer */
+				if (*curr) {
+					free_page(*curr);
+					curr++;
+				}
+			}
+			counter++;
+		}
+		cb->first_sdbt = 0;
+	}
+	return counter;
+}
+
+static int start_sampling(int cpu)
+{
+	int rc;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+	rc = smp_ctl_ssctl_enable_activate(cpu, interval);
+	if (rc) {
+		printk(KERN_INFO "hwsampler: CPU %d ssctl failed.\n", cpu);
+		goto start_exit;
+	}
+
+	rc = -EINVAL;
+	if (!cb->qsi.es) {
+		printk(KERN_INFO "hwsampler: CPU %d ssctl not enabled.\n", cpu);
+		goto start_exit;
+	}
+
+	if (!cb->qsi.cs) {
+		printk(KERN_INFO "hwsampler: CPU %d ssctl not active.\n", cpu);
+		goto start_exit;
+	}
+
+	printk(KERN_INFO
+		"hwsampler: CPU %d, CPUMF Sampling started, interval %lu.\n",
+		cpu, interval);
+
+	rc = 0;
+
+start_exit:
+	return rc;
+}
+
+static int stop_sampling(int cpu)
+{
+	unsigned long v;
+	int rc;
+	struct hws_cpu_buffer *cb;
+
+	rc = smp_ctl_qsi(cpu);
+	WARN_ON(rc);
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+	if (!rc && !cb->qsi.es)
+		printk(KERN_INFO "hwsampler: CPU %d, already stopped.\n", cpu);
+
+	rc = smp_ctl_ssctl_stop(cpu);
+	if (rc) {
+		printk(KERN_INFO "hwsampler: CPU %d, ssctl stop error %d.\n",
+				cpu, rc);
+		goto stop_exit;
+	}
+
+	printk(KERN_INFO "hwsampler: CPU %d, CPUMF Sampling stopped.\n", cpu);
+
+stop_exit:
+	v = cb->req_alert;
+	if (v)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF Request alert,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->loss_of_sample_data;
+	if (v)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF Loss of sample data,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->invalid_entry_address;
+	if (v)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF Invalid entry address,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->incorrect_sdbt_entry;
+	if (v)
+		printk(KERN_ERR
+				"hwsampler: CPU %d CPUMF Incorrect SDBT address,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->sample_auth_change_alert;
+	if (v)
+		printk(KERN_ERR
+				"hwsampler: CPU %d CPUMF Sample authorization change,"
+				" count=%lu.\n", cpu, v);
+
+	return rc;
+}
+
+static int check_hardware_prerequisites(void)
+{
+	unsigned long long facility_bits[2];
+
+	memcpy(facility_bits, S390_lowcore.stfle_fac_list, 32);
+	if (!(facility_bits[1] & (1ULL << 59)))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+/*
+ * hws_oom_callback() - the OOM callback function
+ *
+ * In case the callback is invoked during memory allocation for the
+ *  hw sampler, all obtained memory is deallocated and a flag is set
+ *  so main sampler memory allocation can exit with a failure code.
+ * In case the callback is invoked during sampling the hw sampler
+ *  is deactivated for all CPUs.
+ */
+static int hws_oom_callback(struct notifier_block *nfb,
+	unsigned long dummy, void *parm)
+{
+	unsigned long *freed;
+	int cpu;
+	struct hws_cpu_buffer *cb;
+
+	freed = parm;
+
+	mutex_lock(&hws_sem_oom);
+
+	if (hws_state == HWS_DEALLOCATED) {
+		/* during memory allocation */
+		if (oom_killer_was_active == 0) {
+			oom_killer_was_active = 1;
+			*freed += deallocate_sdbt();
+		}
+	} else {
+		int i;
+		cpu = get_cpu();
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+		if (!cb->oom) {
+			for_each_online_cpu(i) {
+				smp_ctl_ssctl_deactivate(i);
+				cb->oom = 1;
+			}
+			cb->finish = 1;
+
+			printk(KERN_INFO
+				"hwsampler: CPU %d, OOM notify during CPUMF Sampling.\n",
+				cpu);
+		}
+	}
+
+	mutex_unlock(&hws_sem_oom);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block hws_oom_notifier = {
+	.notifier_call = hws_oom_callback
+};
+
+static int hws_cpu_callback(struct notifier_block *nfb,
+	unsigned long action, void *hcpu)
+{
+	/* We do not have sampler space available for all possible CPUs.
+	   All CPUs should be online when hw sampling is activated. */
+	return NOTIFY_BAD;
+}
+
+static struct notifier_block hws_cpu_notifier = {
+	.notifier_call = hws_cpu_callback
+};
+
+/**
+ * hwsampler_deactivate() - set hardware sampling temporarily inactive
+ * @cpu:  specifies the CPU to be set inactive.
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_deactivate(unsigned int cpu)
+{
+	/*
+	 * Deactivate hw sampling temporarily and flush the buffer
+	 * by pushing all the pending samples to oprofile buffer.
+	 *
+	 * This function can be called under one of the following conditions:
+	 *     Memory unmap, task is exiting.
+	 */
+	int rc;
+	struct hws_cpu_buffer *cb;
+
+	rc = 0;
+	mutex_lock(&hws_sem);
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+	if (hws_state == HWS_STARTED) {
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (cb->qsi.cs) {
+			rc = smp_ctl_ssctl_deactivate(cpu);
+			if (rc) {
+				printk(KERN_INFO
+				"hwsampler: CPU %d, CPUMF Deactivation failed.\n", cpu);
+				cb->finish = 1;
+				hws_state = HWS_STOPPING;
+			} else  {
+				hws_flush_all = 1;
+				/* Add work to queue to read pending samples.*/
+				queue_work_on(cpu, hws_wq, &cb->worker);
+			}
+		}
+	}
+	mutex_unlock(&hws_sem);
+
+	if (hws_wq)
+		flush_workqueue(hws_wq);
+
+	return rc;
+}
+
+/**
+ * hwsampler_activate() - activate/resume hardware sampling which was deactivated
+ * @cpu:  specifies the CPU to be set active.
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_activate(unsigned int cpu)
+{
+	/*
+	 * Re-activate hw sampling. This should be called in pair with
+	 * hwsampler_deactivate().
+	 */
+	int rc;
+	struct hws_cpu_buffer *cb;
+
+	rc = 0;
+	mutex_lock(&hws_sem);
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+	if (hws_state == HWS_STARTED) {
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (!cb->qsi.cs) {
+			hws_flush_all = 0;
+			rc = smp_ctl_ssctl_enable_activate(cpu, interval);
+			if (rc) {
+				printk(KERN_ERR
+				"CPU %d, CPUMF activate sampling failed.\n",
+					 cpu);
+			}
+		}
+	}
+
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
+
+static void hws_ext_handler(unsigned int ext_int_code,
+			    unsigned int param32, unsigned long param64)
+{
+	int cpu;
+	struct hws_cpu_buffer *cb;
+
+	cpu = smp_processor_id();
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	atomic_xchg(
+			&cb->ext_params,
+			atomic_read(&cb->ext_params)
+				| S390_lowcore.ext_params);
+
+	if (hws_wq)
+		queue_work(hws_wq, &cb->worker);
+}
+
+static int check_qsi_on_setup(void)
+{
+	int rc;
+	unsigned int cpu;
+	struct hws_cpu_buffer *cb;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (rc)
+			return -EOPNOTSUPP;
+
+		if (!cb->qsi.as) {
+			printk(KERN_INFO "hwsampler: CPUMF sampling is not authorized.\n");
+			return -EINVAL;
+		}
+
+		if (cb->qsi.es) {
+			printk(KERN_WARNING "hwsampler: CPUMF is still enabled.\n");
+			rc = smp_ctl_ssctl_stop(cpu);
+			if (rc)
+				return -EINVAL;
+
+			printk(KERN_INFO
+				"CPU %d, CPUMF Sampling stopped now.\n", cpu);
+		}
+	}
+	return 0;
+}
+
+static int check_qsi_on_start(void)
+{
+	unsigned int cpu;
+	int rc;
+	struct hws_cpu_buffer *cb;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+
+		if (!cb->qsi.as)
+			return -EINVAL;
+
+		if (cb->qsi.es)
+			return -EINVAL;
+
+		if (cb->qsi.cs)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static void worker_on_start(unsigned int cpu)
+{
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+	cb->worker_entry = cb->first_sdbt;
+}
+
+static int worker_check_error(unsigned int cpu, int ext_params)
+{
+	int rc;
+	unsigned long *sdbt;
+	struct hws_cpu_buffer *cb;
+
+	rc = 0;
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+	sdbt = (unsigned long *) cb->worker_entry;
+
+	if (!sdbt || !*sdbt)
+		return -EINVAL;
+
+	if (ext_params & EI_IEA)
+		cb->req_alert++;
+
+	if (ext_params & EI_LSDA)
+		cb->loss_of_sample_data++;
+
+	if (ext_params & EI_IEA) {
+		cb->invalid_entry_address++;
+		rc = -EINVAL;
+	}
+
+	if (ext_params & EI_ISE) {
+		cb->incorrect_sdbt_entry++;
+		rc = -EINVAL;
+	}
+
+	if (ext_params & EI_SACA) {
+		cb->sample_auth_change_alert++;
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static void worker_on_finish(unsigned int cpu)
+{
+	int rc, i;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	if (cb->finish) {
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (cb->qsi.es) {
+			printk(KERN_INFO
+				"hwsampler: CPU %d, CPUMF Stop/Deactivate sampling.\n",
+				cpu);
+			rc = smp_ctl_ssctl_stop(cpu);
+			if (rc)
+				printk(KERN_INFO
+					"hwsampler: CPU %d, CPUMF Deactivation failed.\n",
+					cpu);
+
+			for_each_online_cpu(i) {
+				if (i == cpu)
+					continue;
+				if (!cb->finish) {
+					cb->finish = 1;
+					queue_work_on(i, hws_wq,
+						&cb->worker);
+				}
+			}
+		}
+	}
+}
+
+static void worker_on_interrupt(unsigned int cpu)
+{
+	unsigned long *sdbt;
+	unsigned char done;
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	sdbt = (unsigned long *) cb->worker_entry;
+
+	done = 0;
+	/* do not proceed if stop was entered,
+	 * forget the buffers not yet processed */
+	while (!done && !cb->stop_mode) {
+		unsigned long *trailer;
+		struct hws_trailer_entry *te;
+		unsigned long *dear = 0;
+
+		trailer = trailer_entry_ptr(*sdbt);
+		/* leave loop if no more work to do */
+		if (!(*trailer & BUFFER_FULL_MASK)) {
+			done = 1;
+			if (!hws_flush_all)
+				continue;
+		}
+
+		te = (struct hws_trailer_entry *)trailer;
+		cb->sample_overflow += te->overflow;
+
+		add_samples_to_oprofile(cpu, sdbt, dear);
+
+		/* reset trailer */
+		xchg((unsigned char *) te, 0x40);
+
+		/* advance to next sdb slot in current sdbt */
+		sdbt++;
+		/* in case link bit is set use address w/o link bit */
+		if (is_link_entry(sdbt))
+			sdbt = get_next_sdbt(sdbt);
+
+		cb->worker_entry = (unsigned long)sdbt;
+	}
+}
+
+static void add_samples_to_oprofile(unsigned int cpu, unsigned long *sdbt,
+		unsigned long *dear)
+{
+	struct hws_data_entry *sample_data_ptr;
+	unsigned long *trailer;
+
+	trailer = trailer_entry_ptr(*sdbt);
+	if (dear) {
+		if (dear > trailer)
+			return;
+		trailer = dear;
+	}
+
+	sample_data_ptr = (struct hws_data_entry *)(*sdbt);
+
+	while ((unsigned long *)sample_data_ptr < trailer) {
+		struct pt_regs *regs = NULL;
+		struct task_struct *tsk = NULL;
+
+		/*
+		 * Check sampling mode, 1 indicates basic (=customer) sampling
+		 * mode.
+		 */
+		if (sample_data_ptr->def != 1) {
+			/* sample slot is not yet written */
+			break;
+		} else {
+			/* make sure we don't use it twice,
+			 * the next time the sampler will set it again */
+			sample_data_ptr->def = 0;
+		}
+
+		/* Get pt_regs. */
+		if (sample_data_ptr->P == 1) {
+			/* userspace sample */
+			unsigned int pid = sample_data_ptr->prim_asn;
+			rcu_read_lock();
+			tsk = pid_task(find_vpid(pid), PIDTYPE_PID);
+			if (tsk)
+				regs = task_pt_regs(tsk);
+			rcu_read_unlock();
+		} else {
+			/* kernelspace sample */
+			regs = task_pt_regs(current);
+		}
+
+		mutex_lock(&hws_sem);
+		oprofile_add_ext_hw_sample(sample_data_ptr->ia, regs, 0,
+				!sample_data_ptr->P, tsk);
+		mutex_unlock(&hws_sem);
+
+		sample_data_ptr++;
+	}
+}
+
+static void worker(struct work_struct *work)
+{
+	unsigned int cpu;
+	int ext_params;
+	struct hws_cpu_buffer *cb;
+
+	cb = container_of(work, struct hws_cpu_buffer, worker);
+	cpu = smp_processor_id();
+	ext_params = atomic_xchg(&cb->ext_params, 0);
+
+	if (!cb->worker_entry)
+		worker_on_start(cpu);
+
+	if (worker_check_error(cpu, ext_params))
+		return;
+
+	if (!cb->finish)
+		worker_on_interrupt(cpu);
+
+	if (cb->finish)
+		worker_on_finish(cpu);
+}
+
+/**
+ * hwsampler_allocate() - allocate memory for the hardware sampler
+ * @sdbt:  number of SDBTs per online CPU (must be > 0)
+ * @sdb:   number of SDBs per SDBT (minimum 1, maximum 511)
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_allocate(unsigned long sdbt, unsigned long sdb)
+{
+	int cpu, rc;
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state != HWS_DEALLOCATED)
+		goto allocate_exit;
+
+	if (sdbt < 1)
+		goto allocate_exit;
+
+	if (sdb > MAX_NUM_SDB || sdb < MIN_NUM_SDB)
+		goto allocate_exit;
+
+	num_sdbt = sdbt;
+	num_sdb = sdb;
+
+	oom_killer_was_active = 0;
+	register_oom_notifier(&hws_oom_notifier);
+
+	for_each_online_cpu(cpu) {
+		if (allocate_sdbt(cpu)) {
+			unregister_oom_notifier(&hws_oom_notifier);
+			goto allocate_error;
+		}
+	}
+	unregister_oom_notifier(&hws_oom_notifier);
+	if (oom_killer_was_active)
+		goto allocate_error;
+
+	hws_state = HWS_STOPPED;
+	rc = 0;
+
+allocate_exit:
+	mutex_unlock(&hws_sem);
+	return rc;
+
+allocate_error:
+	rc = -ENOMEM;
+	printk(KERN_ERR "hwsampler: CPUMF Memory allocation failed.\n");
+	goto allocate_exit;
+}
+
+/**
+ * hwsampler_deallocate() - deallocate hardware sampler memory
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_deallocate()
+{
+	int rc;
+
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state != HWS_STOPPED)
+		goto deallocate_exit;
+
+	smp_ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
+	deallocate_sdbt();
+
+	hws_state = HWS_DEALLOCATED;
+	rc = 0;
+
+deallocate_exit:
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
+
+long hwsampler_query_min_interval(void)
+{
+	if (min_sampler_rate)
+		return min_sampler_rate;
+	else
+		return -EINVAL;
+}
+
+long hwsampler_query_max_interval(void)
+{
+	if (max_sampler_rate)
+		return max_sampler_rate;
+	else
+		return -EINVAL;
+}
+
+unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu)
+{
+	struct hws_cpu_buffer *cb;
+
+	cb = &per_cpu(sampler_cpu_buffer, cpu);
+
+	return cb->sample_overflow;
+}
+
+int hwsampler_setup()
+{
+	int rc;
+	int cpu;
+	struct hws_cpu_buffer *cb;
+
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state)
+		goto setup_exit;
+
+	hws_state = HWS_INIT;
+
+	init_all_cpu_buffers();
+
+	rc = check_hardware_prerequisites();
+	if (rc)
+		goto setup_exit;
+
+	rc = check_qsi_on_setup();
+	if (rc)
+		goto setup_exit;
+
+	rc = -EINVAL;
+	hws_wq = create_workqueue("hwsampler");
+	if (!hws_wq)
+		goto setup_exit;
+
+	register_cpu_notifier(&hws_cpu_notifier);
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+		INIT_WORK(&cb->worker, worker);
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (min_sampler_rate != cb->qsi.min_sampl_rate) {
+			if (min_sampler_rate) {
+				printk(KERN_WARNING
+					"hwsampler: different min sampler rate values.\n");
+				if (min_sampler_rate < cb->qsi.min_sampl_rate)
+					min_sampler_rate =
+						cb->qsi.min_sampl_rate;
+			} else
+				min_sampler_rate = cb->qsi.min_sampl_rate;
+		}
+		if (max_sampler_rate != cb->qsi.max_sampl_rate) {
+			if (max_sampler_rate) {
+				printk(KERN_WARNING
+					"hwsampler: different max sampler rate values.\n");
+				if (max_sampler_rate > cb->qsi.max_sampl_rate)
+					max_sampler_rate =
+						cb->qsi.max_sampl_rate;
+			} else
+				max_sampler_rate = cb->qsi.max_sampl_rate;
+		}
+	}
+	register_external_interrupt(0x1407, hws_ext_handler);
+
+	hws_state = HWS_DEALLOCATED;
+	rc = 0;
+
+setup_exit:
+	mutex_unlock(&hws_sem);
+	return rc;
+}
+
+int hwsampler_shutdown()
+{
+	int rc;
+
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state == HWS_DEALLOCATED || hws_state == HWS_STOPPED) {
+		mutex_unlock(&hws_sem);
+
+		if (hws_wq)
+			flush_workqueue(hws_wq);
+
+		mutex_lock(&hws_sem);
+
+		if (hws_state == HWS_STOPPED) {
+			smp_ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
+			deallocate_sdbt();
+		}
+		if (hws_wq) {
+			destroy_workqueue(hws_wq);
+			hws_wq = NULL;
+		}
+
+		unregister_external_interrupt(0x1407, hws_ext_handler);
+		hws_state = HWS_INIT;
+		rc = 0;
+	}
+	mutex_unlock(&hws_sem);
+
+	unregister_cpu_notifier(&hws_cpu_notifier);
+
+	return rc;
+}
+
+/**
+ * hwsampler_start_all() - start hardware sampling on all online CPUs
+ * @rate:  specifies the used interval when samples are taken
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_start_all(unsigned long rate)
+{
+	int rc, cpu;
+
+	mutex_lock(&hws_sem);
+
+	hws_oom = 0;
+
+	rc = -EINVAL;
+	if (hws_state != HWS_STOPPED)
+		goto start_all_exit;
+
+	interval = rate;
+
+	/* fail if rate is not valid */
+	if (interval < min_sampler_rate || interval > max_sampler_rate)
+		goto start_all_exit;
+
+	rc = check_qsi_on_start();
+	if (rc)
+		goto start_all_exit;
+
+	rc = prepare_cpu_buffers();
+	if (rc)
+		goto start_all_exit;
+
+	for_each_online_cpu(cpu) {
+		rc = start_sampling(cpu);
+		if (rc)
+			break;
+	}
+	if (rc) {
+		for_each_online_cpu(cpu) {
+			stop_sampling(cpu);
+		}
+		goto start_all_exit;
+	}
+	hws_state = HWS_STARTED;
+	rc = 0;
+
+start_all_exit:
+	mutex_unlock(&hws_sem);
+
+	if (rc)
+		return rc;
+
+	register_oom_notifier(&hws_oom_notifier);
+	hws_oom = 1;
+	hws_flush_all = 0;
+	/* now let them in, 1407 CPUMF external interrupts */
+	smp_ctl_set_bit(0, 5); /* set CR0 bit 58 */
+
+	return 0;
+}
+
+/**
+ * hwsampler_stop_all() - stop hardware sampling on all online CPUs
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_stop_all()
+{
+	int tmp_rc, rc, cpu;
+	struct hws_cpu_buffer *cb;
+
+	mutex_lock(&hws_sem);
+
+	rc = 0;
+	if (hws_state == HWS_INIT) {
+		mutex_unlock(&hws_sem);
+		return rc;
+	}
+	hws_state = HWS_STOPPING;
+	mutex_unlock(&hws_sem);
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(sampler_cpu_buffer, cpu);
+		cb->stop_mode = 1;
+		tmp_rc = stop_sampling(cpu);
+		if (tmp_rc)
+			rc = tmp_rc;
+	}
+
+	if (hws_wq)
+		flush_workqueue(hws_wq);
+
+	mutex_lock(&hws_sem);
+	if (hws_oom) {
+		unregister_oom_notifier(&hws_oom_notifier);
+		hws_oom = 0;
+	}
+	hws_state = HWS_STOPPED;
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
diff --git a/arch/s390/oprofile/hwsampler.h b/arch/s390/oprofile/hwsampler.h
new file mode 100644
index 0000000..8c72b59
--- /dev/null
+++ b/arch/s390/oprofile/hwsampler.h
@@ -0,0 +1,113 @@
+/*
+ * CPUMF HW sampler functions and internal structures
+ *
+ *    Copyright IBM Corp. 2010
+ *    Author(s): Heinz Graalfs <graalfs@de.ibm.com>
+ */
+
+#ifndef HWSAMPLER_H_
+#define HWSAMPLER_H_
+
+#include <linux/workqueue.h>
+
+struct hws_qsi_info_block          /* QUERY SAMPLING information block  */
+{ /* Bit(s) */
+	unsigned int b0_13:14;      /* 0-13: zeros                       */
+	unsigned int as:1;          /* 14: sampling authorisation control*/
+	unsigned int b15_21:7;      /* 15-21: zeros                      */
+	unsigned int es:1;          /* 22: sampling enable control       */
+	unsigned int b23_29:7;      /* 23-29: zeros                      */
+	unsigned int cs:1;          /* 30: sampling activation control   */
+	unsigned int:1;             /* 31: reserved                      */
+	unsigned int bsdes:16;      /* 4-5: size of sampling entry       */
+	unsigned int:16;            /* 6-7: reserved                     */
+	unsigned long min_sampl_rate; /* 8-15: minimum sampling interval */
+	unsigned long max_sampl_rate; /* 16-23: maximum sampling interval*/
+	unsigned long tear;         /* 24-31: TEAR contents              */
+	unsigned long dear;         /* 32-39: DEAR contents              */
+	unsigned int rsvrd0;        /* 40-43: reserved                   */
+	unsigned int cpu_speed;     /* 44-47: CPU speed                  */
+	unsigned long long rsvrd1;  /* 48-55: reserved                   */
+	unsigned long long rsvrd2;  /* 56-63: reserved                   */
+};
+
+struct hws_ssctl_request_block     /* SET SAMPLING CONTROLS req block   */
+{ /* bytes 0 - 7  Bit(s) */
+	unsigned int s:1;           /* 0: maximum buffer indicator       */
+	unsigned int h:1;           /* 1: part. level reserved for VM use*/
+	unsigned long b2_53:52;     /* 2-53: zeros                       */
+	unsigned int es:1;          /* 54: sampling enable control       */
+	unsigned int b55_61:7;      /* 55-61: - zeros                    */
+	unsigned int cs:1;          /* 62: sampling activation control   */
+	unsigned int b63:1;         /* 63: zero                          */
+	unsigned long interval;     /* 8-15: sampling interval           */
+	unsigned long tear;         /* 16-23: TEAR contents              */
+	unsigned long dear;         /* 24-31: DEAR contents              */
+	/* 32-63:                                                        */
+	unsigned long rsvrd1;       /* reserved                          */
+	unsigned long rsvrd2;       /* reserved                          */
+	unsigned long rsvrd3;       /* reserved                          */
+	unsigned long rsvrd4;       /* reserved                          */
+};
+
+struct hws_cpu_buffer {
+	unsigned long first_sdbt;       /* @ of 1st SDB-Table for this CP*/
+	unsigned long worker_entry;
+	unsigned long sample_overflow;  /* taken from SDB ...            */
+	struct hws_qsi_info_block qsi;
+	struct hws_ssctl_request_block ssctl;
+	struct work_struct worker;
+	atomic_t ext_params;
+	unsigned long req_alert;
+	unsigned long loss_of_sample_data;
+	unsigned long invalid_entry_address;
+	unsigned long incorrect_sdbt_entry;
+	unsigned long sample_auth_change_alert;
+	unsigned int finish:1;
+	unsigned int oom:1;
+	unsigned int stop_mode:1;
+};
+
+struct hws_data_entry {
+	unsigned int def:16;        /* 0-15  Data Entry Format           */
+	unsigned int R:4;           /* 16-19 reserved                    */
+	unsigned int U:4;           /* 20-23 Number of unique instruct.  */
+	unsigned int z:2;           /* zeros                             */
+	unsigned int T:1;           /* 26 PSW DAT mode                   */
+	unsigned int W:1;           /* 27 PSW wait state                 */
+	unsigned int P:1;           /* 28 PSW Problem state              */
+	unsigned int AS:2;          /* 29-30 PSW address-space control   */
+	unsigned int I:1;           /* 31 entry valid or invalid         */
+	unsigned int:16;
+	unsigned int prim_asn:16;   /* primary ASN                       */
+	unsigned long long ia;      /* Instruction Address               */
+	unsigned long long lpp;     /* Logical-Partition Program Param.  */
+	unsigned long long vpp;     /* Virtual-Machine Program Param.    */
+};
+
+struct hws_trailer_entry {
+	unsigned int f:1;           /* 0 - Block Full Indicator          */
+	unsigned int a:1;           /* 1 - Alert request control         */
+	unsigned long:62;           /* 2 - 63: Reserved                  */
+	unsigned long overflow;     /* 64 - sample Overflow count        */
+	unsigned long timestamp;    /* 16 - time-stamp                   */
+	unsigned long timestamp1;   /*                                   */
+	unsigned long reserved1;    /* 32 -Reserved                      */
+	unsigned long reserved2;    /*                                   */
+	unsigned long progusage1;   /* 48 - reserved for programming use */
+	unsigned long progusage2;   /*                                   */
+};
+
+int hwsampler_setup(void);
+int hwsampler_shutdown(void);
+int hwsampler_allocate(unsigned long sdbt, unsigned long sdb);
+int hwsampler_deallocate(void);
+long hwsampler_query_min_interval(void);
+long hwsampler_query_max_interval(void);
+int hwsampler_start_all(unsigned long interval);
+int hwsampler_stop_all(void);
+int hwsampler_deactivate(unsigned int cpu);
+int hwsampler_activate(unsigned int cpu);
+unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu);
+
+#endif /*HWSAMPLER_H_*/
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 7a99511..16c76de 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -4,23 +4,182 @@
  * S390 Version
  *   Copyright (C) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
  *   Author(s): Thomas Spatzier (tspat@de.ibm.com)
+ *   Author(s): Mahesh Salgaonkar (mahesh@linux.vnet.ibm.com)
+ *   Author(s): Heinz Graalfs (graalfs@linux.vnet.ibm.com)
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2011 OProfile authors
  */
 
 #include <linux/oprofile.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/oprofile.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+
+#include "../../../drivers/oprofile/oprof.h"
+#include "hwsampler.h"
+
+#define DEFAULT_INTERVAL	4096
+
+#define DEFAULT_SDBT_BLOCKS	1
+#define DEFAULT_SDB_BLOCKS	511
+
+static unsigned long oprofile_hw_interval = DEFAULT_INTERVAL;
+static unsigned long oprofile_min_interval;
+static unsigned long oprofile_max_interval;
+
+static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
+static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
 
+static int hwsampler_file;
+static int hwsampler_running;	/* start_mutex must be held to change */
+
+static struct oprofile_operations timer_ops;
 
 extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
 
-int __init oprofile_arch_init(struct oprofile_operations* ops)
+static int oprofile_hwsampler_start(void)
+{
+	int retval;
+
+	hwsampler_running = hwsampler_file;
+
+	if (!hwsampler_running)
+		return timer_ops.start();
+
+	retval = hwsampler_allocate(oprofile_sdbt_blocks, oprofile_sdb_blocks);
+	if (retval)
+		return retval;
+
+	retval = hwsampler_start_all(oprofile_hw_interval);
+	if (retval)
+		hwsampler_deallocate();
+
+	return retval;
+}
+
+static void oprofile_hwsampler_stop(void)
+{
+	if (!hwsampler_running) {
+		timer_ops.stop();
+		return;
+	}
+
+	hwsampler_stop_all();
+	hwsampler_deallocate();
+	return;
+}
+
+static ssize_t hwsampler_read(struct file *file, char __user *buf,
+		size_t count, loff_t *offset)
+{
+	return oprofilefs_ulong_to_user(hwsampler_file, buf, count, offset);
+}
+
+static ssize_t hwsampler_write(struct file *file, char const __user *buf,
+		size_t count, loff_t *offset)
+{
+	unsigned long val;
+	int retval;
+
+	if (*offset)
+		return -EINVAL;
+
+	retval = oprofilefs_ulong_from_user(&val, buf, count);
+	if (retval)
+		return retval;
+
+	if (oprofile_started)
+		/*
+		 * save to do without locking as we set
+		 * hwsampler_running in start() when start_mutex is
+		 * held
+		 */
+		return -EBUSY;
+
+	hwsampler_file = val;
+
+	return count;
+}
+
+static const struct file_operations hwsampler_fops = {
+	.read		= hwsampler_read,
+	.write		= hwsampler_write,
+};
+
+static int oprofile_create_hwsampling_files(struct super_block *sb,
+						struct dentry *root)
+{
+	struct dentry *hw_dir;
+
+	/* reinitialize default values */
+	hwsampler_file = 1;
+
+	hw_dir = oprofilefs_mkdir(sb, root, "hwsampling");
+	if (!hw_dir)
+		return -EINVAL;
+
+	oprofilefs_create_file(sb, hw_dir, "hwsampler", &hwsampler_fops);
+	oprofilefs_create_ulong(sb, hw_dir, "hw_interval",
+				&oprofile_hw_interval);
+	oprofilefs_create_ro_ulong(sb, hw_dir, "hw_min_interval",
+				&oprofile_min_interval);
+	oprofilefs_create_ro_ulong(sb, hw_dir, "hw_max_interval",
+				&oprofile_max_interval);
+	oprofilefs_create_ulong(sb, hw_dir, "hw_sdbt_blocks",
+				&oprofile_sdbt_blocks);
+
+	return 0;
+}
+
+static int oprofile_hwsampler_init(struct oprofile_operations *ops)
+{
+	if (hwsampler_setup())
+		return -ENODEV;
+
+	/*
+	 * create hwsampler files only if hwsampler_setup() succeeds.
+	 */
+	oprofile_min_interval = hwsampler_query_min_interval();
+	if (oprofile_min_interval < 0) {
+		oprofile_min_interval = 0;
+		return -ENODEV;
+	}
+	oprofile_max_interval = hwsampler_query_max_interval();
+	if (oprofile_max_interval < 0) {
+		oprofile_max_interval = 0;
+		return -ENODEV;
+	}
+
+	if (oprofile_timer_init(ops))
+		return -ENODEV;
+
+	printk(KERN_INFO "oprofile: using hardware sampling\n");
+
+	memcpy(&timer_ops, ops, sizeof(timer_ops));
+
+	ops->start = oprofile_hwsampler_start;
+	ops->stop = oprofile_hwsampler_stop;
+	ops->create_files = oprofile_create_hwsampling_files;
+
+	return 0;
+}
+
+static void oprofile_hwsampler_exit(void)
+{
+	oprofile_timer_exit();
+	hwsampler_shutdown();
+}
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	ops->backtrace = s390_backtrace;
-	return -ENODEV;
+
+	return oprofile_hwsampler_init(ops);
 }
 
 void oprofile_arch_exit(void)
 {
+	oprofile_hwsampler_exit();
 }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2660418..e8dbe17 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -178,8 +178,6 @@ struct cpu_hw_events {
  */
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
-#define PEBS_EVENT_CONSTRAINT(c, n)	\
-	INTEL_UEVENT_CONSTRAINT(c, n)
 
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b95c66a..bab491b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -362,87 +362,69 @@ static int intel_pmu_drain_bts_buffer(void)
  * PEBS
  */
 static struct event_constraint intel_core2_pebs_event_constraints[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
-	PEBS_EVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
+	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
+	INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_atom_pebs_event_constraints[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INST_RETIRED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),  /* FP_ASSIST.* */
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_westmere_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INSTR_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
-
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
-	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),  /* FP_ASSIST.* */
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_snb_pebs_events[] = {
-	PEBS_EVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	PEBS_EVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	PEBS_EVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	PEBS_EVENT_CONSTRAINT(0x01c4, 0xf), /* BR_INST_RETIRED.CONDITIONAL */
-	PEBS_EVENT_CONSTRAINT(0x02c4, 0xf), /* BR_INST_RETIRED.NEAR_CALL */
-	PEBS_EVENT_CONSTRAINT(0x04c4, 0xf), /* BR_INST_RETIRED.ALL_BRANCHES */
-	PEBS_EVENT_CONSTRAINT(0x08c4, 0xf), /* BR_INST_RETIRED.NEAR_RETURN */
-	PEBS_EVENT_CONSTRAINT(0x10c4, 0xf), /* BR_INST_RETIRED.NOT_TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x20c4, 0xf), /* BR_INST_RETIRED.NEAR_TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x40c4, 0xf), /* BR_INST_RETIRED.FAR_BRANCH */
-	PEBS_EVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
-	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	PEBS_EVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
-	PEBS_EVENT_CONSTRAINT(0x10c5, 0xf), /* BR_MISP_RETIRED.NOT_TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.TAKEN */
-	PEBS_EVENT_CONSTRAINT(0x01cd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
-	PEBS_EVENT_CONSTRAINT(0x02cd, 0x8), /* MEM_TRANS_RETIRED.PRECISE_STORE */
-	PEBS_EVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
-	PEBS_EVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
-	PEBS_EVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
-	PEBS_EVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
-	PEBS_EVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
-	PEBS_EVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
-	PEBS_EVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
-	PEBS_EVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
-	PEBS_EVENT_CONSTRAINT(0x40d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
-	PEBS_EVENT_CONSTRAINT(0x01d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
-	PEBS_EVENT_CONSTRAINT(0x02d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
-	PEBS_EVENT_CONSTRAINT(0x04d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HITM */
-	PEBS_EVENT_CONSTRAINT(0x08d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_NONE */
-	PEBS_EVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 59f5544..b8ef8dd 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -258,8 +258,10 @@ op_add_sample(struct oprofile_cpu_buffer *cpu_buf,
  */
 static int
 log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
-	   unsigned long backtrace, int is_kernel, unsigned long event)
+	   unsigned long backtrace, int is_kernel, unsigned long event,
+	   struct task_struct *task)
 {
+	struct task_struct *tsk = task ? task : current;
 	cpu_buf->sample_received++;
 
 	if (pc == ESCAPE_CODE) {
@@ -267,7 +269,7 @@ log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 		return 0;
 	}
 
-	if (op_add_code(cpu_buf, backtrace, is_kernel, current))
+	if (op_add_code(cpu_buf, backtrace, is_kernel, tsk))
 		goto fail;
 
 	if (op_add_sample(cpu_buf, pc, event))
@@ -292,7 +294,8 @@ static inline void oprofile_end_trace(struct oprofile_cpu_buffer *cpu_buf)
 
 static inline void
 __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
-			  unsigned long event, int is_kernel)
+			  unsigned long event, int is_kernel,
+			  struct task_struct *task)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
 	unsigned long backtrace = oprofile_backtrace_depth;
@@ -301,7 +304,7 @@ __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	 * if log_sample() fail we can't backtrace since we lost the
 	 * source of this event
 	 */
-	if (!log_sample(cpu_buf, pc, backtrace, is_kernel, event))
+	if (!log_sample(cpu_buf, pc, backtrace, is_kernel, event, task))
 		/* failed */
 		return;
 
@@ -313,10 +316,17 @@ __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	oprofile_end_trace(cpu_buf);
 }
 
+void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
+				unsigned long event, int is_kernel,
+				struct task_struct *task)
+{
+	__oprofile_add_ext_sample(pc, regs, event, is_kernel, task);
+}
+
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 			     unsigned long event, int is_kernel)
 {
-	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
+	__oprofile_add_ext_sample(pc, regs, event, is_kernel, NULL);
 }
 
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
@@ -332,7 +342,7 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 		pc = ESCAPE_CODE; /* as this causes an early return. */
 	}
 
-	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
+	__oprofile_add_ext_sample(pc, regs, event, is_kernel, NULL);
 }
 
 /*
@@ -403,7 +413,7 @@ int oprofile_write_commit(struct op_entry *entry)
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
-	log_sample(cpu_buf, pc, 0, is_kernel, event);
+	log_sample(cpu_buf, pc, 0, is_kernel, event, NULL);
 }
 
 void oprofile_add_trace(unsigned long pc)
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 0107251..3ef4462 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -97,7 +97,7 @@ static struct notifier_block __refdata oprofile_cpu_notifier = {
 	.notifier_call = oprofile_cpu_notify,
 };
 
-int __init oprofile_timer_init(struct oprofile_operations *ops)
+int oprofile_timer_init(struct oprofile_operations *ops)
 {
 	int rc;
 
@@ -113,7 +113,7 @@ int __init oprofile_timer_init(struct oprofile_operations *ops)
 	return 0;
 }
 
-void __exit oprofile_timer_exit(void)
+void oprofile_timer_exit(void)
 {
 	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
 }
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 1ca6411..7f5cfd3 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -106,6 +106,13 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel);
 
+/**
+ * Add an hardware sample.
+ */
+void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
+	unsigned long event, int is_kernel,
+	struct task_struct *task);
+
 /* Use this instead when the PC value is not from the regs. Doesn't
  * backtrace. */
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 614615b..f495c01 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -878,8 +878,8 @@ enum perf_event_context_type {
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
-	enum perf_event_context_type	type;
 	struct pmu			*pmu;
+	enum perf_event_context_type	type;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ed253aa..3472bb1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5122,7 +5122,7 @@ static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
+		return 1;
 
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))
@@ -5478,6 +5478,8 @@ static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->hw.state & PERF_HES_STOPPED)
+		return 0;
 	/*
 	 * All tracepoints are from kernel-space.
 	 */
@@ -6720,17 +6722,20 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	struct perf_event *parent_event;
+	if (child_event->parent) {
+		raw_spin_lock_irq(&child_ctx->lock);
+		perf_group_detach(child_event);
+		raw_spin_unlock_irq(&child_ctx->lock);
+	}
 
 	perf_remove_from_context(child_event);
 
-	parent_event = child_event->parent;
 	/*
-	 * It can happen that parent exits first, and has events
+	 * It can happen that the parent exits first, and has events
 	 * that are still around due to the child reference. These
-	 * events need to be zapped - but otherwise linger.
+	 * events need to be zapped.
 	 */
-	if (parent_event) {
+	if (child_event->parent) {
 		sync_child_event(child_event, child);
 		free_event(child_event);
 	}
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 14674dc..61d7d59f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -275,7 +275,7 @@ config PROFILE_ANNOTATED_BRANCHES
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
 
-	  /sys/kernel/debug/tracing/profile_annotated_branch
+	  /sys/kernel/debug/tracing/trace_stat/branch_annotated
 
 	  Note: this will add a significant overhead; only turn this
 	  on if you need to profile the system's use of these macros.
@@ -288,7 +288,7 @@ config PROFILE_ALL_BRANCHES
 	  taken in the kernel is recorded whether it hit or miss.
 	  The results will be displayed in:
 
-	  /sys/kernel/debug/tracing/profile_branch
+	  /sys/kernel/debug/tracing/trace_stat/branch_all
 
 	  This option also enables the likely/unlikely profiler.
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 3249b4f..8008ddc 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -391,8 +391,8 @@ static int process_ops(struct filter_pred *preds,
 		       struct filter_pred *op, void *rec)
 {
 	struct filter_pred *pred;
+	int match = 0;
 	int type;
-	int match;
 	int i;
 
 	/*
diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
new file mode 100644
index 0000000..0cada9e
--- /dev/null
+++ b/tools/perf/Documentation/perf-evlist.txt
@@ -0,0 +1,26 @@
+perf-evlist(1)
+==============
+
+NAME
+----
+perf-evlist - List the event names in a perf.data file
+
+SYNOPSIS
+--------
+[verse]
+'perf evlist <options>'
+
+DESCRIPTION
+-----------
+This command displays the names of events sampled in a perf.data file.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Input file name. (default: perf.data)
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-list[1],
+linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 29ad942..66f040b 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -112,6 +112,28 @@ OPTIONS
 --debug-mode::
         Do various checks like samples ordering and lost events.
 
+-f::
+--fields
+        Comma separated list of fields to print. Options are:
+        comm, tid, pid, time, cpu, event, trace, sym. Field
+        list must be prepended with the type, trace, sw or hw,
+        to indicate to which event type the field list applies.
+        e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
+
+-k::
+--vmlinux=<file>::
+        vmlinux pathname
+
+--kallsyms=<file>::
+        kallsyms pathname
+
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
+-G::
+--hide-call-graph::
+        When printing symbols do not display call chain.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9b84218..158c30e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -338,6 +338,7 @@ endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
+BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
 BUILTIN_OBJS += $(OUTPUT)builtin-help.o
 BUILTIN_OBJS += $(OUTPUT)builtin-sched.o
 BUILTIN_OBJS += $(OUTPUT)builtin-buildid-list.o
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
new file mode 100644
index 0000000..4c5e9e0
--- /dev/null
+++ b/tools/perf/builtin-evlist.c
@@ -0,0 +1,54 @@
+/*
+ * Builtin evlist command: Show the list of event selectors present
+ * in a perf.data file.
+ */
+#include "builtin.h"
+
+#include "util/util.h"
+
+#include <linux/list.h>
+
+#include "perf.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include "util/parse-events.h"
+#include "util/parse-options.h"
+#include "util/session.h"
+
+static char const *input_name = "perf.data";
+
+static int __cmd_evlist(void)
+{
+	struct perf_session *session;
+	struct perf_evsel *pos;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	if (session == NULL)
+		return -ENOMEM;
+
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		printf("%s\n", event_name(pos));
+
+	perf_session__delete(session);
+	return 0;
+}
+
+static const char * const evlist_usage[] = {
+	"perf evlist [<options>]",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_END()
+};
+
+int cmd_evlist(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, options, evlist_usage, 0);
+	if (argc)
+		usage_with_options(evlist_usage, options);
+
+	return __cmd_evlist();
+}
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2e93f99..7a2a79d 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -202,9 +202,20 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
 SINGLE_KEY(nr_acquired)
 SINGLE_KEY(nr_contended)
 SINGLE_KEY(wait_time_total)
-SINGLE_KEY(wait_time_min)
 SINGLE_KEY(wait_time_max)
 
+static int lock_stat_key_wait_time_min(struct lock_stat *one,
+					struct lock_stat *two)
+{
+	u64 s1 = one->wait_time_min;
+	u64 s2 = two->wait_time_min;
+	if (s1 == ULLONG_MAX)
+		s1 = 0;
+	if (s2 == ULLONG_MAX)
+		s2 = 0;
+	return s1 > s2;
+}
+
 struct lock_key {
 	/*
 	 * name: the value for specify by user
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5f40df6..9f5fc54 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -12,6 +12,8 @@
 #include "util/trace-event.h"
 #include "util/parse-options.h"
 #include "util/util.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -19,6 +21,183 @@ static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
+static bool			no_callchain;
+
+enum perf_output_field {
+	PERF_OUTPUT_COMM            = 1U << 0,
+	PERF_OUTPUT_TID             = 1U << 1,
+	PERF_OUTPUT_PID             = 1U << 2,
+	PERF_OUTPUT_TIME            = 1U << 3,
+	PERF_OUTPUT_CPU             = 1U << 4,
+	PERF_OUTPUT_EVNAME          = 1U << 5,
+	PERF_OUTPUT_TRACE           = 1U << 6,
+	PERF_OUTPUT_SYM             = 1U << 7,
+};
+
+struct output_option {
+	const char *str;
+	enum perf_output_field field;
+} all_output_options[] = {
+	{.str = "comm",  .field = PERF_OUTPUT_COMM},
+	{.str = "tid",   .field = PERF_OUTPUT_TID},
+	{.str = "pid",   .field = PERF_OUTPUT_PID},
+	{.str = "time",  .field = PERF_OUTPUT_TIME},
+	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
+	{.str = "event", .field = PERF_OUTPUT_EVNAME},
+	{.str = "trace", .field = PERF_OUTPUT_TRACE},
+	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+};
+
+/* default set to maintain compatibility with current format */
+static u64 output_fields[PERF_TYPE_MAX] = {
+	[PERF_TYPE_HARDWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+	[PERF_TYPE_SOFTWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+	[PERF_TYPE_TRACEPOINT] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+				 PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+				 PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+};
+
+static bool output_set_by_user;
+
+#define PRINT_FIELD(x)  (output_fields[attr->type] & PERF_OUTPUT_##x)
+
+static int perf_session__check_attr(struct perf_session *session,
+				    struct perf_event_attr *attr)
+{
+	if (PRINT_FIELD(TRACE) &&
+		!perf_session__has_traces(session, "record -R"))
+		return -EINVAL;
+
+	if (PRINT_FIELD(SYM)) {
+		if (!(session->sample_type & PERF_SAMPLE_IP)) {
+			pr_err("Samples do not contain IP data.\n");
+			return -EINVAL;
+		}
+		if (!no_callchain &&
+		    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
+			symbol_conf.use_callchain = false;
+	}
+
+	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
+		!(session->sample_type & PERF_SAMPLE_TID)) {
+		pr_err("Samples do not contain TID/PID data.\n");
+		return -EINVAL;
+	}
+
+	if (PRINT_FIELD(TIME) &&
+		!(session->sample_type & PERF_SAMPLE_TIME)) {
+		pr_err("Samples do not contain timestamps.\n");
+		return -EINVAL;
+	}
+
+	if (PRINT_FIELD(CPU) &&
+		!(session->sample_type & PERF_SAMPLE_CPU)) {
+		pr_err("Samples do not contain cpu.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void print_sample_start(struct perf_sample *sample,
+			       struct thread *thread,
+			       struct perf_event_attr *attr)
+{
+	int type;
+	struct event *event;
+	const char *evname = NULL;
+	unsigned long secs;
+	unsigned long usecs;
+	unsigned long long nsecs;
+
+	if (PRINT_FIELD(COMM)) {
+		if (latency_format)
+			printf("%8.8s ", thread->comm);
+		else if (PRINT_FIELD(SYM) && symbol_conf.use_callchain)
+			printf("%s ", thread->comm);
+		else
+			printf("%16s ", thread->comm);
+	}
+
+	if (PRINT_FIELD(PID) && PRINT_FIELD(TID))
+		printf("%5d/%-5d ", sample->pid, sample->tid);
+	else if (PRINT_FIELD(PID))
+		printf("%5d ", sample->pid);
+	else if (PRINT_FIELD(TID))
+		printf("%5d ", sample->tid);
+
+	if (PRINT_FIELD(CPU)) {
+		if (latency_format)
+			printf("%3d ", sample->cpu);
+		else
+			printf("[%03d] ", sample->cpu);
+	}
+
+	if (PRINT_FIELD(TIME)) {
+		nsecs = sample->time;
+		secs = nsecs / NSECS_PER_SEC;
+		nsecs -= secs * NSECS_PER_SEC;
+		usecs = nsecs / NSECS_PER_USEC;
+		printf("%5lu.%06lu: ", secs, usecs);
+	}
+
+	if (PRINT_FIELD(EVNAME)) {
+		if (attr->type == PERF_TYPE_TRACEPOINT) {
+			type = trace_parse_common_type(sample->raw_data);
+			event = trace_find_event(type);
+			if (event)
+				evname = event->name;
+		} else
+			evname = __event_name(attr->type, attr->config);
+
+		printf("%s: ", evname ? evname : "(unknown)");
+	}
+}
+
+static void process_event(union perf_event *event __unused,
+			  struct perf_sample *sample,
+			  struct perf_session *session,
+			  struct thread *thread)
+{
+	struct perf_event_attr *attr;
+	struct perf_evsel *evsel;
+
+	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+	if (evsel == NULL) {
+		pr_err("Invalid data. Contains samples with id not in "
+		       "its header!\n");
+		return;
+	}
+	attr = &evsel->attr;
+
+	if (output_fields[attr->type] == 0)
+		return;
+
+	if (perf_session__check_attr(session, attr) < 0)
+		return;
+
+	print_sample_start(sample, thread, attr);
+
+	if (PRINT_FIELD(TRACE))
+		print_trace_event(sample->cpu, sample->raw_data,
+				  sample->raw_size);
+
+	if (PRINT_FIELD(SYM)) {
+		if (!symbol_conf.use_callchain)
+			printf(" ");
+		else
+			printf("\n");
+		perf_session__print_symbols(event, sample, session);
+	}
+
+	printf("\n");
+}
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -40,7 +219,7 @@ static int default_generate_script(const char *outfile __unused)
 static struct scripting_ops default_scripting_ops = {
 	.start_script		= default_start_script,
 	.stop_script		= default_stop_script,
-	.process_event		= print_event,
+	.process_event		= process_event,
 	.generate_script	= default_generate_script,
 };
 
@@ -75,26 +254,17 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (session->sample_type & PERF_SAMPLE_RAW) {
-		if (debug_mode) {
-			if (sample->time < last_timestamp) {
-				pr_err("Samples misordered, previous: %" PRIu64
-					" this: %" PRIu64 "\n", last_timestamp,
-					sample->time);
-				nr_unordered++;
-			}
-			last_timestamp = sample->time;
-			return 0;
+	if (debug_mode) {
+		if (sample->time < last_timestamp) {
+			pr_err("Samples misordered, previous: %" PRIu64
+				" this: %" PRIu64 "\n", last_timestamp,
+				sample->time);
+			nr_unordered++;
 		}
-		/*
-		 * FIXME: better resolve from pid from the struct trace_entry
-		 * field, although it should be the same than this perf
-		 * event pid
-		 */
-		scripting_ops->process_event(sample->cpu, sample->raw_data,
-					     sample->raw_size,
-					     sample->time, thread->comm);
+		last_timestamp = sample->time;
+		return 0;
 	}
+	scripting_ops->process_event(event, sample, session, thread);
 
 	session->hists.stats.total_period += sample->period;
 	return 0;
@@ -102,7 +272,10 @@ static int process_sample_event(union perf_event *event,
 
 static struct perf_event_ops event_ops = {
 	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
 	.comm		 = perf_event__process_comm,
+	.exit		 = perf_event__process_task,
+	.fork		 = perf_event__process_task,
 	.attr		 = perf_event__process_attr,
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
@@ -280,6 +453,68 @@ static int parse_scriptname(const struct option *opt __used,
 	return 0;
 }
 
+static int parse_output_fields(const struct option *opt __used,
+			    const char *arg, int unset __used)
+{
+	char *tok;
+	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int rc = 0;
+	char *str = strdup(arg);
+	int type = -1;
+
+	if (!str)
+		return -ENOMEM;
+
+	tok = strtok(str, ":");
+	if (!tok) {
+		fprintf(stderr,
+			"Invalid field string - not prepended with type.");
+		return -EINVAL;
+	}
+
+	/* first word should state which event type user
+	 * is specifying the fields
+	 */
+	if (!strcmp(tok, "hw"))
+		type = PERF_TYPE_HARDWARE;
+	else if (!strcmp(tok, "sw"))
+		type = PERF_TYPE_SOFTWARE;
+	else if (!strcmp(tok, "trace"))
+		type = PERF_TYPE_TRACEPOINT;
+	else {
+		fprintf(stderr, "Invalid event type in field string.");
+		return -EINVAL;
+	}
+
+	output_fields[type] = 0;
+	while (1) {
+		tok = strtok(NULL, ",");
+		if (!tok)
+			break;
+		for (i = 0; i < imax; ++i) {
+			if (strcmp(tok, all_output_options[i].str) == 0) {
+				output_fields[type] |= all_output_options[i].field;
+				break;
+			}
+		}
+		if (i == imax) {
+			fprintf(stderr, "Invalid field requested.");
+			rc = -EINVAL;
+			break;
+		}
+	}
+
+	if (output_fields[type] == 0) {
+		pr_debug("No fields requested for %s type. "
+			 "Events will not be displayed\n", event_type(type));
+	}
+
+	output_set_by_user = true;
+
+	free(str);
+	return rc;
+}
+
 /* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
 static int is_directory(const char *base_path, const struct dirent *dent)
 {
@@ -592,6 +827,17 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_BOOLEAN('G', "hide-call-graph", &no_callchain,
+		    "When printing symbols do not display call chain"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
+	OPT_CALLBACK('f', "fields", NULL, "str",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     parse_output_fields),
 
 	OPT_END()
 };
@@ -772,14 +1018,22 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (strcmp(input_name, "-") &&
-	    !perf_session__has_traces(session, "record -R"))
-		return -EINVAL;
+	if (!no_callchain)
+		symbol_conf.use_callchain = true;
+	else
+		symbol_conf.use_callchain = false;
 
 	if (generate_script_lang) {
 		struct stat perf_stat;
+		int input;
+
+		if (output_set_by_user) {
+			fprintf(stderr,
+				"custom fields not supported for generated scripts");
+			return -1;
+		}
 
-		int input = open(input_name, O_RDONLY);
+		input = open(input_name, O_RDONLY);
 		if (input < 0) {
 			perror("failed to open file");
 			exit(-1);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 21c0252..e2109f9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -333,6 +333,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 		}
 	}
 
+	if (perf_evlist__set_filters(evsel_list)) {
+		error("failed to set filter with %d (%s)\n", errno,
+			strerror(errno));
+		return -1;
+	}
+
 	/*
 	 * Enable counters and exec the command:
 	 */
@@ -634,6 +640,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
+	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
+		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 80c9e06..70f1075 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -152,7 +152,7 @@ static int parse_source(struct sym_entry *syme)
 	/*
 	 * We can't annotate with just /proc/kallsyms
 	 */
-	if (map->dso->origin == DSO__ORIG_KERNEL) {
+	if (map->dso->symtab_type == SYMTAB__KALLSYMS) {
 		pr_err("Can't annotate %s: No vmlinux file was found in the "
 		       "path\n", sym->name);
 		sleep(1);
@@ -515,24 +515,25 @@ static void handle_keypress(struct perf_session *session, int c)
 			break;
 		case 'E':
 			if (top.evlist->nr_entries > 1) {
+				int counter;
 				fprintf(stderr, "\nAvailable events:");
 
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
 					fprintf(stderr, "\n\t%d %s", top.sym_evsel->idx, event_name(top.sym_evsel));
 
-				prompt_integer(&top.sym_counter, "Enter details event counter");
+				prompt_integer(&counter, "Enter details event counter");
 
-				if (top.sym_counter >= top.evlist->nr_entries) {
+				if (counter >= top.evlist->nr_entries) {
 					top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
-					top.sym_counter = 0;
 					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(top.sym_evsel));
 					sleep(1);
 					break;
 				}
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
-					if (top.sym_evsel->idx == top.sym_counter)
+					if (top.sym_evsel->idx == counter)
 						break;
-			} else top.sym_counter = 0;
+			} else
+				top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 			break;
 		case 'f':
 			prompt_integer(&top.count_filter, "Enter display event count filter");
@@ -675,7 +676,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
-			syme->skip = 1;
+			sym->ignore = true;
 			break;
 		}
 	}
@@ -768,7 +769,7 @@ static void perf_event__process_sample(const union perf_event *event,
 			struct symbol *sym = sym_entry__symbol(top.sym_filter_entry);
 
 			pr_err("Can't annotate %s", sym->name);
-			if (top.sym_filter_entry->map->dso->origin == DSO__ORIG_KERNEL) {
+			if (top.sym_filter_entry->map->dso->symtab_type == SYMTAB__KALLSYMS) {
 				pr_err(": No vmlinux file was found in the path:\n");
 				machine__fprintf_vmlinux_path(machine, stderr);
 			} else
@@ -778,10 +779,9 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 
 	syme = symbol__priv(al.sym);
-	if (!syme->skip) {
+	if (!al.sym->ignore) {
 		struct perf_evsel *evsel;
 
-		syme->origin = origin;
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
 		syme->count[evsel->idx]++;
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index c7798c7..4702e24 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -19,6 +19,7 @@ extern int cmd_bench(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_cache(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
 extern int cmd_diff(int argc, const char **argv, const char *prefix);
+extern int cmd_evlist(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
 extern int cmd_sched(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 16b5088..d695fe4 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -8,6 +8,7 @@ perf-bench			mainporcelain common
 perf-buildid-cache		mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
+perf-evlist			mainporcelain common
 perf-inject			mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 595d0f4..ec635b7 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -313,6 +313,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "buildid-cache", cmd_buildid_cache, 0 },
 		{ "buildid-list", cmd_buildid_list, 0 },
 		{ "diff",	cmd_diff,	0 },
+		{ "evlist",	cmd_evlist,	0 },
 		{ "help",	cmd_help,	0 },
 		{ "list",	cmd_list,	0 },
 		{ "record",	cmd_record,	0 },
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 97d7656..26d4d3f 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -23,10 +23,10 @@ if test -d ../../.git -o -f ../../.git &&
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	eval `grep '^VERSION\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^PATCHLEVEL\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^SUBLEVEL\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^EXTRAVERSION\s*=' ../../Makefile|tr -d ' '`
+	eval $(grep '^VERSION[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^PATCHLEVEL[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^SUBLEVEL[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^EXTRAVERSION[[:space:]]*=' ../../Makefile|tr -d ' ')
 
 	VN="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
 fi
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0d0830c..e01af2b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -294,7 +294,7 @@ fallback:
 		free_filename = false;
 	}
 
-	if (dso->origin == DSO__ORIG_KERNEL) {
+	if (dso->symtab_type == SYMTAB__KALLSYMS) {
 		char bf[BUILD_ID_SIZE * 2 + 16] = " with build id ";
 		char *build_id_msg = NULL;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 54a7e26..952b4ae 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -263,6 +263,28 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
 	return name;
 }
 
+const char *event_type(int type)
+{
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+		return "hardware";
+
+	case PERF_TYPE_SOFTWARE:
+		return "software";
+
+	case PERF_TYPE_TRACEPOINT:
+		return "tracepoint";
+
+	case PERF_TYPE_HW_CACHE:
+		return "hardware-cache";
+
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
 const char *event_name(struct perf_evsel *evsel)
 {
 	u64 config = evsel->attr.config;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 212f88e..746d3fc 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -20,6 +20,7 @@ struct tracepoint_path {
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
+const char *event_type(int type);
 const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 9368081..6214272 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -245,9 +245,10 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void perl_process_event(int cpu, void *data,
-			       int size __unused,
-			       unsigned long long nsecs, char *comm)
+static void perl_process_event(union perf_event *pevent __unused,
+			       struct perf_sample *sample,
+			       struct perf_session *session __unused,
+			       struct thread *thread)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -256,6 +257,10 @@ static void perl_process_event(int cpu, void *data,
 	struct event *event;
 	int type;
 	int pid;
+	int cpu = sample->cpu;
+	void *data = sample->raw_data;
+	unsigned long long nsecs = sample->time;
+	char *comm = thread->comm;
 
 	dSP;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 2040b85..1b85d60 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -204,9 +204,10 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void python_process_event(int cpu, void *data,
-				 int size __unused,
-				 unsigned long long nsecs, char *comm)
+static void python_process_event(union perf_event *pevent __unused,
+				 struct perf_sample *sample,
+				 struct perf_session *session __unused,
+				 struct thread *thread)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -217,6 +218,10 @@ static void python_process_event(int cpu, void *data,
 	unsigned n = 0;
 	int type;
 	int pid;
+	int cpu = sample->cpu;
+	void *data = sample->raw_data;
+	unsigned long long nsecs = sample->time;
+	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f26639f..c68cf40 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1134,3 +1134,64 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 
 	return ret;
 }
+
+void perf_session__print_symbols(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_session *session)
+{
+	struct addr_location al;
+	const char *symname, *dsoname;
+	struct callchain_cursor *cursor = &session->callchain_cursor;
+	struct callchain_cursor_node *node;
+
+	if (perf_event__preprocess_sample(event, session, &al, sample,
+					  NULL) < 0) {
+		error("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return;
+	}
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+
+		if (perf_session__resolve_callchain(session, al.thread,
+						sample->callchain, NULL) != 0) {
+			if (verbose)
+				error("Failed to resolve callchain. Skipping\n");
+			return;
+		}
+		callchain_cursor_commit(cursor);
+
+		while (1) {
+			node = callchain_cursor_current(cursor);
+			if (!node)
+				break;
+
+			if (node->sym && node->sym->name)
+				symname = node->sym->name;
+			else
+				symname = "";
+
+			if (node->map && node->map->dso && node->map->dso->name)
+				dsoname = node->map->dso->name;
+			else
+				dsoname = "";
+
+			printf("\t%16" PRIx64 " %s (%s)\n", node->ip, symname, dsoname);
+
+			callchain_cursor_advance(cursor);
+		}
+
+	} else {
+		if (al.sym && al.sym->name)
+			symname = al.sym->name;
+		else
+			symname = "";
+
+		if (al.map && al.map->dso && al.map->dso->name)
+			dsoname = al.map->dso->name;
+		else
+			dsoname = "";
+
+		printf("%16" PRIx64 " %s (%s)", al.addr, symname, dsoname);
+	}
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index b5b148b..0b3c9af 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -159,4 +159,8 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->sample_id_all, sample);
 }
 
+void perf_session__print_symbols(union perf_event *event,
+				 struct perf_sample *sample,
+				 struct perf_session *session);
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 00014e3..651dbfe 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -207,7 +207,7 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(self, self->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->origin = DSO__ORIG_NOT_FOUND;
+		self->symtab_type = SYMTAB__NOT_FOUND;
 		self->loaded = 0;
 		self->sorted_by_name = 0;
 		self->has_build_id = 0;
@@ -680,9 +680,9 @@ int dso__load_kallsyms(struct dso *self, const char *filename,
 		return -1;
 
 	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		self->origin = DSO__ORIG_GUEST_KERNEL;
+		self->symtab_type = SYMTAB__GUEST_KALLSYMS;
 	else
-		self->origin = DSO__ORIG_KERNEL;
+		self->symtab_type = SYMTAB__KALLSYMS;
 
 	return dso__split_kallsyms(self, map, filter);
 }
@@ -1204,7 +1204,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				}
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->origin = self->origin;
+				curr_dso->symtab_type = self->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
 				dsos__add(&self->node, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
@@ -1430,21 +1430,21 @@ out:
 char dso__symtab_origin(const struct dso *self)
 {
 	static const char origin[] = {
-		[DSO__ORIG_KERNEL] =   'k',
-		[DSO__ORIG_JAVA_JIT] = 'j',
-		[DSO__ORIG_BUILD_ID_CACHE] = 'B',
-		[DSO__ORIG_FEDORA] =   'f',
-		[DSO__ORIG_UBUNTU] =   'u',
-		[DSO__ORIG_BUILDID] =  'b',
-		[DSO__ORIG_DSO] =      'd',
-		[DSO__ORIG_KMODULE] =  'K',
-		[DSO__ORIG_GUEST_KERNEL] =  'g',
-		[DSO__ORIG_GUEST_KMODULE] =  'G',
+		[SYMTAB__KALLSYMS]	      = 'k',
+		[SYMTAB__JAVA_JIT]	      = 'j',
+		[SYMTAB__BUILD_ID_CACHE]      = 'B',
+		[SYMTAB__FEDORA_DEBUGINFO]    = 'f',
+		[SYMTAB__UBUNTU_DEBUGINFO]    = 'u',
+		[SYMTAB__BUILDID_DEBUGINFO]   = 'b',
+		[SYMTAB__SYSTEM_PATH_DSO]     = 'd',
+		[SYMTAB__SYSTEM_PATH_KMODULE] = 'K',
+		[SYMTAB__GUEST_KALLSYMS]      =  'g',
+		[SYMTAB__GUEST_KMODULE]	      =  'G',
 	};
 
-	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
+	if (self == NULL || self->symtab_type == SYMTAB__NOT_FOUND)
 		return '!';
-	return origin[self->origin];
+	return origin[self->symtab_type];
 }
 
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
@@ -1477,8 +1477,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
 		ret = dso__load_perf_map(self, map, filter);
-		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
-					 DSO__ORIG_NOT_FOUND;
+		self->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
+					      SYMTAB__NOT_FOUND;
 		return ret;
 	}
 
@@ -1486,26 +1486,26 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 * On the first pass, only load images if they have a full symtab.
 	 * Failing that, do a second pass where we accept .dynsym also
 	 */
-	for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
-	     self->origin != DSO__ORIG_NOT_FOUND;
-	     self->origin++) {
-		switch (self->origin) {
-		case DSO__ORIG_BUILD_ID_CACHE:
+	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE, want_symtab = 1;
+	     self->symtab_type != SYMTAB__NOT_FOUND;
+	     self->symtab_type++) {
+		switch (self->symtab_type) {
+		case SYMTAB__BUILD_ID_CACHE:
 			/* skip the locally configured cache if a symfs is given */
 			if (symbol_conf.symfs[0] ||
 			    (dso__build_id_filename(self, name, size) == NULL)) {
 				continue;
 			}
 			break;
-		case DSO__ORIG_FEDORA:
+		case SYMTAB__FEDORA_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s.debug",
 				 symbol_conf.symfs, self->long_name);
 			break;
-		case DSO__ORIG_UBUNTU:
+		case SYMTAB__UBUNTU_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s",
 				 symbol_conf.symfs, self->long_name);
 			break;
-		case DSO__ORIG_BUILDID: {
+		case SYMTAB__BUILDID_DEBUGINFO: {
 			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 
 			if (!self->has_build_id)
@@ -1519,11 +1519,11 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 				 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
 			}
 			break;
-		case DSO__ORIG_DSO:
+		case SYMTAB__SYSTEM_PATH_DSO:
 			snprintf(name, size, "%s%s",
 			     symbol_conf.symfs, self->long_name);
 			break;
-		case DSO__ORIG_GUEST_KMODULE:
+		case SYMTAB__GUEST_KMODULE:
 			if (map->groups && machine)
 				root_dir = machine->root_dir;
 			else
@@ -1532,7 +1532,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 				 root_dir, self->long_name);
 			break;
 
-		case DSO__ORIG_KMODULE:
+		case SYMTAB__SYSTEM_PATH_KMODULE:
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
 				 self->long_name);
 			break;
@@ -1544,7 +1544,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			 */
 			if (want_symtab) {
 				want_symtab = 0;
-				self->origin = DSO__ORIG_BUILD_ID_CACHE;
+				self->symtab_type = SYMTAB__BUILD_ID_CACHE;
 			} else
 				continue;
 		}
@@ -1757,9 +1757,9 @@ struct map *machine__new_module(struct machine *self, u64 start,
 		return NULL;
 
 	if (machine__is_host(self))
-		dso->origin = DSO__ORIG_KMODULE;
+		dso->symtab_type = SYMTAB__SYSTEM_PATH_KMODULE;
 	else
-		dso->origin = DSO__ORIG_GUEST_KMODULE;
+		dso->symtab_type = SYMTAB__GUEST_KMODULE;
 	map_groups__insert(&self->kmaps, map);
 	return map;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4d7ed09..713b0b4 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -48,12 +48,17 @@ char *strxfrchar(char *s, char from, char to);
 
 #define BUILD_ID_SIZE 20
 
+/** struct symbol - symtab entry
+ *
+ * @ignore - resolvable but tools ignore it (e.g. idle routines)
+ */
 struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
 	u64		end;
 	u16		namelen;
 	u8		binding;
+	bool		ignore;
 	char		name[0];
 };
 
@@ -137,7 +142,7 @@ struct dso {
 	u8		 annotate_warned:1;
 	u8		 sname_alloc:1;
 	u8		 lname_alloc:1;
-	unsigned char	 origin;
+	unsigned char	 symtab_type;
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
@@ -188,18 +193,18 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 
-enum dso_origin {
-	DSO__ORIG_KERNEL = 0,
-	DSO__ORIG_GUEST_KERNEL,
-	DSO__ORIG_JAVA_JIT,
-	DSO__ORIG_BUILD_ID_CACHE,
-	DSO__ORIG_FEDORA,
-	DSO__ORIG_UBUNTU,
-	DSO__ORIG_BUILDID,
-	DSO__ORIG_DSO,
-	DSO__ORIG_GUEST_KMODULE,
-	DSO__ORIG_KMODULE,
-	DSO__ORIG_NOT_FOUND,
+enum symtab_type {
+	SYMTAB__KALLSYMS = 0,
+	SYMTAB__GUEST_KALLSYMS,
+	SYMTAB__JAVA_JIT,
+	SYMTAB__BUILD_ID_CACHE,
+	SYMTAB__FEDORA_DEBUGINFO,
+	SYMTAB__UBUNTU_DEBUGINFO,
+	SYMTAB__BUILDID_DEBUGINFO,
+	SYMTAB__SYSTEM_PATH_DSO,
+	SYMTAB__GUEST_KMODULE,
+	SYMTAB__SYSTEM_PATH_KMODULE,
+	SYMTAB__NOT_FOUND,
 };
 
 char dso__symtab_origin(const struct dso *self);
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 75cfe4d..a11f607 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -171,7 +171,7 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 {
 	struct sym_entry *syme, *n;
 	float sum_ksamples = 0.0;
-	int snap = !top->display_weighted ? top->sym_counter : 0, j;
+	int snap = !top->display_weighted ? top->sym_evsel->idx : 0, j;
 
 	/* Sort the active symbols */
 	pthread_mutex_lock(&top->active_symbols_lock);
@@ -184,9 +184,9 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 		if (syme->snap_count != 0) {
 
 			if ((top->hide_user_symbols &&
-			     syme->origin == PERF_RECORD_MISC_USER) ||
+			     syme->map->dso->kernel == DSO_TYPE_USER) ||
 			    (top->hide_kernel_symbols &&
-			     syme->origin == PERF_RECORD_MISC_KERNEL)) {
+			     syme->map->dso->kernel == DSO_TYPE_KERNEL)) {
 				perf_top__remove_active_sym(top, syme);
 				continue;
 			}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 96d1cb7..bfbf95b 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -16,8 +16,6 @@ struct sym_entry {
 	struct list_head	node;
 	unsigned long		snap_count;
 	double			weight;
-	int			skip;
-	u8			origin;
 	struct map		*map;
 	unsigned long		count[0];
 };
@@ -41,7 +39,7 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq, rb_entries, sym_counter;
+	int		   display_weighted, freq, rb_entries;
 	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8e622d..0a7ed5b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2643,68 +2643,13 @@ static void print_lat_fmt(void *data, int size __unused)
 		printf(".");
 
 	if (lock_depth < 0)
-		printf(".");
+		printf(". ");
 	else
-		printf("%d", lock_depth);
+		printf("%d ", lock_depth);
 }
 
-/* taken from Linux, written by Frederic Weisbecker */
-static void print_graph_cpu(int cpu)
-{
-	int i;
-	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpus);
-
-
-	/*
-	 * Start with a space character - to make it stand out
-	 * to the right a bit when trace output is pasted into
-	 * email:
-	 */
-	printf(" ");
-
-	/*
-	 * Tricky - we space the CPU field according to the max
-	 * number of online CPUs. On a 2-cpu system it would take
-	 * a maximum of 1 digit - on a 128 cpu system it would
-	 * take up to 3 digits:
-	 */
-	for (i = 0; i < log10_all - log10_this; i++)
-		printf(" ");
-
-	printf("%d) ", cpu);
-}
-
-#define TRACE_GRAPH_PROCINFO_LENGTH	14
 #define TRACE_GRAPH_INDENT	2
 
-static void print_graph_proc(int pid, const char *comm)
-{
-	/* sign + log10(MAX_INT) + '\0' */
-	char pid_str[11];
-	int spaces = 0;
-	int len;
-	int i;
-
-	sprintf(pid_str, "%d", pid);
-
-	/* 1 stands for the "-" character */
-	len = strlen(comm) + strlen(pid_str) + 1;
-
-	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
-		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
-
-	/* First spaces to align center */
-	for (i = 0; i < spaces / 2; i++)
-		printf(" ");
-
-	printf("%s-%s", comm, pid_str);
-
-	/* Last spaces to align center */
-	for (i = 0; i < spaces - (spaces / 2); i++)
-		printf(" ");
-}
-
 static struct record *
 get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 		    struct record *next)
@@ -2876,21 +2821,13 @@ static void print_graph_nested(struct event *event, void *data)
 
 static void
 pretty_print_func_ent(void *data, int size, struct event *event,
-		      int cpu, int pid, const char *comm,
-		      unsigned long secs, unsigned long usecs)
+		      int cpu, int pid)
 {
 	struct format_field *field;
 	struct record *rec;
 	void *copy_data;
 	unsigned long val;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
-
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
-	printf(" | ");
-
 	if (latency_format) {
 		print_lat_fmt(data, size);
 		printf(" | ");
@@ -2923,22 +2860,13 @@ out_free:
 }
 
 static void
-pretty_print_func_ret(void *data, int size __unused, struct event *event,
-		      int cpu, int pid, const char *comm,
-		      unsigned long secs, unsigned long usecs)
+pretty_print_func_ret(void *data, int size __unused, struct event *event)
 {
 	unsigned long long rettime, calltime;
 	unsigned long long duration, depth;
 	struct format_field *field;
 	int i;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
-
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
-	printf(" | ");
-
 	if (latency_format) {
 		print_lat_fmt(data, size);
 		printf(" | ");
@@ -2976,31 +2904,21 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 
 static void
 pretty_print_func_graph(void *data, int size, struct event *event,
-			int cpu, int pid, const char *comm,
-			unsigned long secs, unsigned long usecs)
+			int cpu, int pid)
 {
 	if (event->flags & EVENT_FL_ISFUNCENT)
-		pretty_print_func_ent(data, size, event,
-				      cpu, pid, comm, secs, usecs);
+		pretty_print_func_ent(data, size, event, cpu, pid);
 	else if (event->flags & EVENT_FL_ISFUNCRET)
-		pretty_print_func_ret(data, size, event,
-				      cpu, pid, comm, secs, usecs);
+		pretty_print_func_ret(data, size, event);
 	printf("\n");
 }
 
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
+void print_trace_event(int cpu, void *data, int size)
 {
 	struct event *event;
-	unsigned long secs;
-	unsigned long usecs;
 	int type;
 	int pid;
 
-	secs = nsecs / NSECS_PER_SEC;
-	nsecs -= secs * NSECS_PER_SEC;
-	usecs = nsecs / NSECS_PER_USEC;
-
 	type = trace_parse_common_type(data);
 
 	event = trace_find_event(type);
@@ -3012,17 +2930,10 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	pid = trace_parse_common_pid(data);
 
 	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
-		return pretty_print_func_graph(data, size, event, cpu,
-					       pid, comm, secs, usecs);
+		return pretty_print_func_graph(data, size, event, cpu, pid);
 
-	if (latency_format) {
-		printf("%8.8s-%-5d %3d",
-		       comm, pid, cpu);
+	if (latency_format)
 		print_lat_fmt(data, size);
-	} else
-		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
-
-	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
 
 	if (event->flags & EVENT_FL_FAILED) {
 		printf("EVENT '%s' FAILED TO PARSE\n",
@@ -3031,7 +2942,6 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	}
 
 	pretty_print(data, size, event);
-	printf("\n");
 }
 
 static void print_fields(struct print_flag_sym *field)
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index f7af2fc..66f4b78 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -36,11 +36,10 @@ static int stop_script_unsupported(void)
 	return 0;
 }
 
-static void process_event_unsupported(int cpu __unused,
-				      void *data __unused,
-				      int size __unused,
-				      unsigned long long nsecs __unused,
-				      char *comm __unused)
+static void process_event_unsupported(union perf_event *event __unused,
+				      struct perf_sample *sample __unused,
+				      struct perf_session *session __unused,
+				      struct thread *thread __unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b5f12ca..b04da57 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "parse-events.h"
+#include "session.h"
 
 #define __unused __attribute__((unused))
 
@@ -176,8 +177,7 @@ void print_printk(void);
 
 int parse_ftrace_file(char *buf, unsigned long size);
 int parse_event_file(char *buf, unsigned long size, char *sys);
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm);
+void print_trace_event(int cpu, void *data, int size);
 
 extern int file_bigendian;
 extern int host_bigendian;
@@ -278,8 +278,10 @@ struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
-	void (*process_event) (int cpu, void *data, int size,
-			       unsigned long long nsecs, char *comm);
+	void (*process_event) (union perf_event *event,
+			       struct perf_sample *sample,
+			       struct perf_session *session,
+			       struct thread *thread);
 	int (*generate_script) (const char *outfile);
 };
 
