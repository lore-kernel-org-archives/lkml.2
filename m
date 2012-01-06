Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2AFXlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:41:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab2AFXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:41:11 -0500
Date: Fri, 6 Jan 2012 15:41:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for Jan 6
Message-Id: <20120106154109.2a104bbb.akpm@linux-foundation.org>
In-Reply-To: <20120106192604.5949309aa93444ed2a9f2266@canb.auug.org.au>
References: <20120106192604.5949309aa93444ed2a9f2266@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 19:26:04 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Did you get this?

kernel/sched/core.c: In function 'sched_setaffinity':
kernel/sched/core.c:4333: error: implicit declaration of function 'task_ns_capable'

Apparently because Eric has today added a two-month old patch into
linux-next at the same time as mainline moved the entire file.

Eric, please never put 3.x material into linux-next until 3.x-rc1 has
opened.  Please remove these patches from linux-next until 3.3-rc1
opens.


Also, more gregmess:

kernel/sched/core.c:6680: warning: 'struct sysdev_class_attribute' declared inside parameter list
kernel/sched/core.c:6680: warning: its scope is only this definition or declaration, which is probably not what you want
kernel/sched/core.c:6680: warning: 'struct sysdev_class' declared inside parameter list
kernel/sched/core.c:6686: warning: 'struct sysdev_class_attribute' declared inside parameter list
kernel/sched/core.c:6686: warning: 'struct sysdev_class' declared inside parameter list
kernel/sched/core.c:6690: error: expected ')' before numeric constant
kernel/sched/core.c:6698: warning: 'struct sysdev_class_attribute' declared inside parameter list
kernel/sched/core.c:6698: warning: 'struct sysdev_class' declared inside parameter list
kernel/sched/core.c:6704: warning: 'struct sysdev_class_attribute' declared inside parameter list
kernel/sched/core.c:6704: warning: 'struct sysdev_class' declared inside parameter list
kernel/sched/core.c:6708: error: expected ')' before numeric constant
kernel/sched/core.c:6713: warning: 'struct sysdev_class' declared inside parameter list
kernel/sched/core.c:6713: error: conflicting types for 'sched_create_sysfs_power_savings_entries'
include/linux/cpu.h:38: note: previous declaration of 'sched_create_sysfs_power_savings_entries' was here
kernel/sched/core.c: In function 'sched_create_sysfs_power_savings_entries':
kernel/sched/core.c:6719: error: dereferencing pointer to incomplete type
kernel/sched/core.c:6720: error: 'attr_sched_smt_power_savings' undeclared (first use in this function)
kernel/sched/core.c:6720: error: (Each undeclared identifier is reported only once
kernel/sched/core.c:6720: error: for each function it appears in.)
kernel/sched/core.c:6724: error: dereferencing pointer to incomplete type
kernel/sched/core.c:6725: error: 'attr_sched_mc_power_savings' undeclared (first use in this function)


And below is what I had to do to fix up all the conflicts between
mainline and linux-next.  This all results from a single morning's
merging into mainline.  It's mainly tools/perf.  I have to fix up
all this crap so I can get code tested and released.  Or I can turn
off the machines, stomp home and see if things have improved on
Monday.  Bye.



 arch/ia64/include/asm/cputime.h    |    8 ---
 arch/powerpc/include/asm/cputime.h |    4 -
 arch/score/Kconfig                 |    3 -
 arch/x86/kernel/cpu/perf_event.c   |    8 ---
 include/asm-generic/cputime.h      |    9 ---
 include/linux/cpu.h                |    4 -
 include/linux/sched.h              |    4 -
 kernel/Makefile                    |    3 -
 kernel/events/core.c               |    7 --
 kernel/rcutorture.c                |    8 ---
 kernel/time/tick-sched.c           |   14 -----
 tools/perf/builtin-record.c        |   35 --------------
 tools/perf/builtin-test.c          |   30 ------------
 tools/perf/util/header.c           |   64 ---------------------------
 14 files changed, 201 deletions(-)

diff -puN arch/ia64/include/asm/cputime.h~linux-next-git-rejects arch/ia64/include/asm/cputime.h
--- a/arch/ia64/include/asm/cputime.h~linux-next-git-rejects
+++ a/arch/ia64/include/asm/cputime.h
@@ -46,19 +46,11 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> microseconds
  */
-<<<<<<< HEAD
-=======
 #define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
->>>>>>> linux-next/akpm-end
 #define cputime_to_usecs(__ct)		\
 	((__force u64)(__ct) / NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	\
 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
-<<<<<<< HEAD
-#define usecs_to_cputime64(__usecs)	\
-	(__force cputime64_t)((__usecs) * NSEC_PER_USEC)
-=======
->>>>>>> linux-next/akpm-end
 
 /*
  * Convert cputime <-> seconds
diff -puN arch/powerpc/include/asm/cputime.h~linux-next-git-rejects arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~linux-next-git-rejects
+++ a/arch/powerpc/include/asm/cputime.h
@@ -114,11 +114,7 @@ extern u64 __cputime_usec_factor;
 
 static inline unsigned long cputime_to_usecs(const cputime_t ct)
 {
-<<<<<<< HEAD
-	return mulhdu((__force u64) ct, __cputime_msec_factor) * USEC_PER_MSEC;
-=======
 	return mulhdu((__force u64) ct, __cputime_usec_factor);
->>>>>>> linux-next/akpm-end
 }
 
 static inline cputime_t usecs_to_cputime(const unsigned long us)
diff -puN arch/score/Kconfig~linux-next-git-rejects arch/score/Kconfig
--- a/arch/score/Kconfig~linux-next-git-rejects
+++ a/arch/score/Kconfig
@@ -4,10 +4,7 @@ config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
-<<<<<<< HEAD
-=======
        select GENERIC_IOMAP
->>>>>>> linux-next/akpm-end
        select HAVE_MEMBLOCK
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
diff -puN arch/x86/kernel/cpu/perf_event.c~linux-next-git-rejects arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -700,19 +700,11 @@ int x86_schedule_events(struct cpu_hw_ev
 		if (assign)
 			assign[i] = hwc->idx;
 	}
-<<<<<<< HEAD
 
 	/* slow path */
 	if (i != n)
 		num = perf_assign_events(constraints, n, wmin, wmax, assign);
 
-=======
-
-	/* slow path */
-	if (i != n)
-		num = perf_assign_events(constraints, n, wmin, wmax, assign);
-
->>>>>>> linux-next/akpm-end
 	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
diff -puN include/asm-generic/cputime.h~linux-next-git-rejects include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~linux-next-git-rejects
+++ a/include/asm-generic/cputime.h
@@ -23,20 +23,11 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime to microseconds and back.
  */
-<<<<<<< HEAD
-#define cputime_to_usecs(__ct)		\
-	jiffies_to_usecs(cputime_to_jiffies(__ct))
-#define usecs_to_cputime(__usec)	\
-	jiffies_to_cputime(usecs_to_jiffies(__usec))
-#define usecs_to_cputime64(__usec)	\
-	jiffies64_to_cputime64(nsecs_to_jiffies64((__usec) * 1000))
-=======
 #define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 #define cputime_to_usecs(__ct)		\
 	jiffies_to_usecs(cputime_to_jiffies(__ct));
 #define usecs_to_cputime(__msecs)	\
 	jiffies_to_cputime(usecs_to_jiffies(__msecs));
->>>>>>> linux-next/akpm-end
 
 /*
  * Convert cputime to seconds and back.
diff -puN include/linux/cpu.h~linux-next-git-rejects include/linux/cpu.h
--- a/include/linux/cpu.h~linux-next-git-rejects
+++ a/include/linux/cpu.h
@@ -26,11 +26,7 @@ struct cpu {
 };
 
 extern int register_cpu(struct cpu *cpu, int num);
-<<<<<<< HEAD
-extern struct sys_device *get_cpu_sysdev(unsigned cpu);
-=======
 extern struct device *get_cpu_device(unsigned cpu);
->>>>>>> linux-next/akpm-end
 extern bool cpu_is_hotpluggable(unsigned cpu);
 
 extern int cpu_add_dev_attr(struct device_attribute *attr);
diff -puN include/linux/sched.h~linux-next-git-rejects include/linux/sched.h
--- a/include/linux/sched.h~linux-next-git-rejects
+++ a/include/linux/sched.h
@@ -2094,11 +2094,7 @@ extern struct task_struct *idle_task(int
  * is_idle_task - is the specified task an idle task?
  * @tsk: the task in question.
  */
-<<<<<<< HEAD
-static inline bool is_idle_task(struct task_struct *p)
-=======
 static inline bool is_idle_task(const struct task_struct *p)
->>>>>>> linux-next/akpm-end
 {
 	return p->pid == 0;
 }
diff -puN kernel/Makefile~linux-next-git-rejects kernel/Makefile
--- a/kernel/Makefile~linux-next-git-rejects
+++ a/kernel/Makefile
@@ -108,10 +108,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += us
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_UPROBES) += uprobes.o
->>>>>>> linux-next/akpm-end
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff -puN kernel/events/core.c~linux-next-git-rejects kernel/events/core.c
--- a/kernel/events/core.c~linux-next-git-rejects
+++ a/kernel/events/core.c
@@ -2429,17 +2429,10 @@ static void perf_rotate_context(struct p
 		rotate_ctx(&cpuctx->ctx);
 		if (ctx)
 			rotate_ctx(ctx);
-<<<<<<< HEAD
 
 		perf_event_sched_in(cpuctx, ctx, current);
 	}
 
-=======
-
-		perf_event_sched_in(cpuctx, ctx, current);
-	}
-
->>>>>>> linux-next/akpm-end
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 
diff -puN kernel/rcutorture.c~linux-next-git-rejects kernel/rcutorture.c
--- a/kernel/rcutorture.c~linux-next-git-rejects
+++ a/kernel/rcutorture.c
@@ -1399,11 +1399,7 @@ rcu_torture_shutdown(void *arg)
  * Execute random CPU-hotplug operations at the interval specified
  * by the onoff_interval.
  */
-<<<<<<< HEAD
-static int
-=======
 static int __cpuinit
->>>>>>> linux-next/akpm-end
 rcu_torture_onoff(void *arg)
 {
 	int cpu;
@@ -1451,11 +1447,7 @@ rcu_torture_onoff(void *arg)
 	return 0;
 }
 
-<<<<<<< HEAD
-static int
-=======
 static int __cpuinit
->>>>>>> linux-next/akpm-end
 rcu_torture_onoff_init(void)
 {
 	if (onoff_interval <= 0)
diff -puN kernel/time/tick-sched.c~linux-next-git-rejects kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~linux-next-git-rejects
+++ a/kernel/time/tick-sched.c
@@ -466,17 +466,6 @@ void tick_nohz_idle_enter(void)
 
 	WARN_ON_ONCE(irqs_disabled());
 
-<<<<<<< HEAD
-	/*
- 	 * Update the idle state in the scheduler domain hierarchy
- 	 * when tick_nohz_stop_sched_tick() is called from the idle loop.
- 	 * State will be updated to busy during the first busy tick after
- 	 * exiting idle.
- 	 */
-	set_cpu_sd_state_idle();
-
-=======
->>>>>>> linux-next/akpm-end
 	local_irq_disable();
 
 	ts = &__get_cpu_var(tick_cpu_sched);
@@ -486,8 +475,6 @@ void tick_nohz_idle_enter(void)
 	 * update of the idle time accounting in tick_nohz_start_idle().
 	 */
 	ts->inidle = 1;
-<<<<<<< HEAD
-=======
 
 	/*
 	 * Update the idle state in the scheduler domain hierarchy
@@ -496,7 +483,6 @@ void tick_nohz_idle_enter(void)
 	 * exiting idle.
 	 */
 	set_cpu_sd_state_idle();
->>>>>>> linux-next/akpm-end
 	tick_nohz_stop_sched_tick(ts);
 
 	local_irq_enable();
diff -puN tools/perf/builtin-record.c~linux-next-git-rejects tools/perf/builtin-record.c
--- a/tools/perf/builtin-record.c~linux-next-git-rejects
+++ a/tools/perf/builtin-record.c
@@ -385,11 +385,7 @@ static int __cmd_record(struct perf_reco
 {
 	struct stat st;
 	int flags;
-<<<<<<< HEAD
-	int err, output;
-=======
 	int err, output, feat;
->>>>>>> linux-next/akpm-end
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -456,11 +452,6 @@ static int __cmd_record(struct perf_reco
 
 	rec->session = session;
 
-<<<<<<< HEAD
-	if (!rec->no_buildid)
-		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
-
-=======
 	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
 		perf_header__set_feat(&session->header, feat);
 
@@ -470,32 +461,12 @@ static int __cmd_record(struct perf_reco
 	if (!have_tracepoints(&evsel_list->entries))
 		perf_header__clear_feat(&session->header, HEADER_TRACE_INFO);
 
->>>>>>> linux-next/akpm-end
 	if (!rec->file_new) {
 		err = perf_session__read_header(session, output);
 		if (err < 0)
 			goto out_delete_session;
 	}
 
-<<<<<<< HEAD
-	if (have_tracepoints(&evsel_list->entries))
-		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
-
-	perf_header__set_feat(&session->header, HEADER_HOSTNAME);
-	perf_header__set_feat(&session->header, HEADER_OSRELEASE);
-	perf_header__set_feat(&session->header, HEADER_ARCH);
-	perf_header__set_feat(&session->header, HEADER_CPUDESC);
-	perf_header__set_feat(&session->header, HEADER_NRCPUS);
-	perf_header__set_feat(&session->header, HEADER_EVENT_DESC);
-	perf_header__set_feat(&session->header, HEADER_CMDLINE);
-	perf_header__set_feat(&session->header, HEADER_VERSION);
-	perf_header__set_feat(&session->header, HEADER_CPU_TOPOLOGY);
-	perf_header__set_feat(&session->header, HEADER_TOTAL_MEM);
-	perf_header__set_feat(&session->header, HEADER_NUMA_TOPOLOGY);
-	perf_header__set_feat(&session->header, HEADER_CPUID);
-
-=======
->>>>>>> linux-next/akpm-end
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, opts, argv);
 		if (err < 0) {
@@ -528,15 +499,9 @@ static int __cmd_record(struct perf_reco
 		       "Use --no-buildid to profile anyway.\n");
 		return -1;
 	}
-<<<<<<< HEAD
-
-	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
-
-=======
 
 	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
 
->>>>>>> linux-next/akpm-end
 	machine = perf_session__find_host_machine(session);
 	if (!machine) {
 		pr_err("Couldn't find native kernel information.\n");
diff -puN tools/perf/builtin-test.c~linux-next-git-rejects tools/perf/builtin-test.c
--- a/tools/perf/builtin-test.c~linux-next-git-rejects
+++ a/tools/perf/builtin-test.c
@@ -15,11 +15,8 @@
 #include "util/thread_map.h"
 #include "../../include/linux/hw_breakpoint.h"
 
-<<<<<<< HEAD
-=======
 #include <sys/mman.h>
 
->>>>>>> linux-next/akpm-end
 static int vmlinux_matches_kallsyms_filter(struct map *map __used, struct symbol *sym)
 {
 	bool *visited = symbol__priv(sym);
@@ -1301,9 +1298,6 @@ out:
 	return (err < 0 || errs > 0) ? -1 : 0;
 }
 
-<<<<<<< HEAD
-=======
-
 #if defined(__x86_64__) || defined(__i386__)
 
 #define barrier() asm volatile("" ::: "memory")
@@ -1470,7 +1464,6 @@ static int test__rdpmc(void)
 
 #endif
 
->>>>>>> linux-next/akpm-end
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1520,19 +1513,11 @@ static bool perf_test__matches(int curr,
 
 	if (argc == 0)
 		return true;
-<<<<<<< HEAD
 
 	for (i = 0; i < argc; ++i) {
 		char *end;
 		long nr = strtoul(argv[i], &end, 10);
 
-=======
-
-	for (i = 0; i < argc; ++i) {
-		char *end;
-		long nr = strtoul(argv[i], &end, 10);
-
->>>>>>> linux-next/akpm-end
 		if (*end == '\0') {
 			if (nr == curr + 1)
 				return true;
@@ -1572,15 +1557,6 @@ static int perf_test__list(int argc, con
 
 	while (tests[i].func) {
 		int curr = i++;
-<<<<<<< HEAD
-
-		if (argc > 1 && !strstr(tests[curr].desc, argv[1]))
-			continue;
-
-		pr_info("%2d: %s\n", i, tests[curr].desc);
-	}
-
-=======
 
 		if (argc > 1 && !strstr(tests[curr].desc, argv[1]))
 			continue;
@@ -1588,7 +1564,6 @@ static int perf_test__list(int argc, con
 		pr_info("%2d: %s\n", i, tests[curr].desc);
 	}
 
->>>>>>> linux-next/akpm-end
 	return 0;
 }
 
@@ -1615,10 +1590,5 @@ int cmd_test(int argc, const char **argv
 	if (symbol__init() < 0)
 		return -1;
 
-<<<<<<< HEAD
-	setup_pager();
-
-=======
->>>>>>> linux-next/akpm-end
 	return __cmd_test(argc, argv);
 }
diff -puN tools/perf/util/header.c~linux-next-git-rejects tools/perf/util/header.c
--- a/tools/perf/util/header.c~linux-next-git-rejects
+++ a/tools/perf/util/header.c
@@ -1372,40 +1372,6 @@ static void print_cpuid(struct perf_head
 	free(str);
 }
 
-<<<<<<< HEAD
-struct feature_ops {
-	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
-	void (*print)(struct perf_header *h, int fd, FILE *fp);
-	const char *name;
-	bool full_only;
-};
-
-#define FEAT_OPA(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func }
-#define FEAT_OPF(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func, .full_only = true }
-
-/* feature_ops not implemented: */
-#define print_trace_info		NULL
-#define print_build_id			NULL
-
-static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
-	FEAT_OPA(HEADER_TRACE_INFO,	trace_info),
-	FEAT_OPA(HEADER_BUILD_ID,	build_id),
-	FEAT_OPA(HEADER_HOSTNAME,	hostname),
-	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
-	FEAT_OPA(HEADER_VERSION,	version),
-	FEAT_OPA(HEADER_ARCH,		arch),
-	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
-	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
-	FEAT_OPA(HEADER_CPUID,		cpuid),
-	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
-	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
-	FEAT_OPA(HEADER_CMDLINE,	cmdline),
-	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
-	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
-};
-=======
 static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 {
 	const char *delimiter = "# pmu mappings: ";
@@ -1413,7 +1379,6 @@ static void print_pmu_mappings(struct pe
 	int ret;
 	u32 pmu_num;
 	u32 type;
->>>>>>> linux-next/akpm-end
 
 	ret = read(fd, &pmu_num, sizeof(pmu_num));
 	if (ret != sizeof(pmu_num))
@@ -1422,16 +1387,6 @@ static void print_pmu_mappings(struct pe
 	if (!pmu_num)
 		goto error;
 
-<<<<<<< HEAD
-	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
-		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
-				"%d, continuing...\n", section->offset, feat);
-		return 0;
-	}
-	if (feat >= HEADER_LAST_FEATURE) {
-		pr_warning("unknown feature %d\n", feat);
-		return 0;
-=======
 	while (pmu_num--) {
 		if (read(fd, &type, sizeof(type)) != sizeof(type))
 			goto error;
@@ -1439,7 +1394,6 @@ static void print_pmu_mappings(struct pe
 		fprintf(fp, "%s%s = %" PRIu32, delimiter, name, type);
 		free(name);
 		delimiter = ", ";
->>>>>>> linux-next/akpm-end
 	}
 
 	fprintf(fp, "\n");
@@ -1453,8 +1407,6 @@ static int __event_process_build_id(stru
 				    char *filename,
 				    struct perf_session *session)
 {
-<<<<<<< HEAD
-=======
 	int err = -1;
 	struct list_head *head;
 	struct machine *machine;
@@ -1692,7 +1644,6 @@ static int perf_file_section__fprintf_in
 
 int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 {
->>>>>>> linux-next/akpm-end
 	struct header_print_data hd;
 	struct perf_header *header = &session->header;
 	int fd = session->fd;
@@ -2023,21 +1974,6 @@ static int perf_file_section__process(st
 	if (feat >= HEADER_LAST_FEATURE) {
 		pr_debug("unknown feature %d, continuing...\n", feat);
 		return 0;
-<<<<<<< HEAD
-	}
-
-	switch (feat) {
-	case HEADER_TRACE_INFO:
-		trace_report(fd, false);
-		break;
-	case HEADER_BUILD_ID:
-		if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
-			pr_debug("Failed to read buildids, continuing...\n");
-		break;
-	default:
-		break;
-=======
->>>>>>> linux-next/akpm-end
 	}
 
 	if (!feat_ops[feat].process)
_

