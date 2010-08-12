Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505Ab0HLUEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:04:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab0HLUEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:04:51 -0400
Date: Thu, 12 Aug 2010 22:04:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates and fixes
Message-ID: <20100812200425.GA26852@elte.hu>
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

( Most of the diffstat is in tools/perf/ and due to a late coming 
  reorganization of the Newt bits. )

 Thanks,

	Ingo

------------------>
Andrea Gelmini (2):
      perf probe: Remove duplicated #include
      perf trace: Clean up #includes

Arnaldo Carvalho de Melo (21):
      perf symbols: Store the symbol binding
      perf ui: Add a map browser
      perf ui: Shorten ui_browser->refresh_entries to refresh
      perf hists: Handle verbose in hists__sort_list_width
      perf hists: Fixup addr snprintf width on 32 bit arches
      perf ui: Add search by name/addr to the map__browser
      perf report: Speed up exit path
      perf tui: Introduce list_head based generic ui_browser refresh routine
      perf ui: Start breaking down newt.c into multiple files
      perf ui: Shorten ui_browser member names
      perf ui: Move ui_helpline routines to separate file in util/ui/
      perf ui: Move ui_progress routines to separate file in util/ui/
      perf ui: Move annotate browser to util/ui/browsers/
      perf ui: Move map browser to util/ui/browsers/
      perf ui: Move hists browser to util/ui/browsers/
      perf ui: Complete the breakdown of util/newt.c
      perf annotate: Sort by hottest lines in the TUI
      perf ui: Make SPACE work as PGDN in all browsers
      perf annotate: Cycle thru sorted lines with samples
      perf ui browser: Add ui_browser__show counterpart: __hide
      perf ui hist browser: Fixup key bindings

Cyrill Gorcunov (1):
      perf, x86: P4 PMU -- update nmi irq statistics and unmask lvt entry properly

Dave Martin (1):
      perf symbols: Ignore mapping symbols on ARM

Ingo Molnar (1):
      perf: Add back list_head data types

Josh Hunt (1):
      oprofile: add support for Intel processor model 30

Julia Lawall (1):
      perf timechart: Adjust confusing if indentation

Masami Hiramatsu (2):
      perf probe: Fix to copy the type for raw parameters
      perf probe: Fix memory leaks in add_perf_probe_events


 arch/x86/kernel/cpu/perf_event_p4.c    |    9 +-
 arch/x86/oprofile/nmi_int.c            |    1 +
 tools/perf/Makefile                    |   31 +-
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/builtin-report.c            |   31 +-
 tools/perf/builtin-timechart.c         |    4 +-
 tools/perf/builtin-trace.c             |   19 +-
 tools/perf/util/debug.c                |    2 +-
 tools/perf/util/debug.h                |    9 +-
 tools/perf/util/hist.c                 |   16 +-
 tools/perf/util/hist.h                 |    3 +-
 tools/perf/util/include/linux/list.h   |    8 +
 tools/perf/util/include/linux/types.h  |   12 +
 tools/perf/util/newt.c                 | 1568 --------------------------------
 tools/perf/util/probe-event.c          |   11 +-
 tools/perf/util/probe-finder.c         |    9 +-
 tools/perf/util/pstack.h               |    2 +
 tools/perf/util/sort.c                 |    6 +-
 tools/perf/util/symbol.c               |   40 +-
 tools/perf/util/symbol.h               |    1 +
 tools/perf/util/ui/browser.c           |  329 +++++++
 tools/perf/util/ui/browser.h           |   46 +
 tools/perf/util/ui/browsers/annotate.c |  240 +++++
 tools/perf/util/ui/browsers/hists.c    |  948 +++++++++++++++++++
 tools/perf/util/ui/browsers/map.c      |  161 ++++
 tools/perf/util/ui/browsers/map.h      |    6 +
 tools/perf/util/ui/helpline.c          |   69 ++
 tools/perf/util/ui/helpline.h          |   11 +
 tools/perf/util/ui/libslang.h          |   27 +
 tools/perf/util/ui/progress.c          |   60 ++
 tools/perf/util/ui/progress.h          |   11 +
 tools/perf/util/ui/setup.c             |   42 +
 tools/perf/util/ui/util.c              |  114 +++
 tools/perf/util/ui/util.h              |   10 +
 34 files changed, 2236 insertions(+), 1622 deletions(-)
 delete mode 100644 tools/perf/util/newt.c
 create mode 100644 tools/perf/util/ui/browser.c
 create mode 100644 tools/perf/util/ui/browser.h
 create mode 100644 tools/perf/util/ui/browsers/annotate.c
 create mode 100644 tools/perf/util/ui/browsers/hists.c
 create mode 100644 tools/perf/util/ui/browsers/map.c
 create mode 100644 tools/perf/util/ui/browsers/map.h
 create mode 100644 tools/perf/util/ui/helpline.c
 create mode 100644 tools/perf/util/ui/helpline.h
 create mode 100644 tools/perf/util/ui/libslang.h
 create mode 100644 tools/perf/util/ui/progress.c
 create mode 100644 tools/perf/util/ui/progress.h
 create mode 100644 tools/perf/util/ui/setup.c
 create mode 100644 tools/perf/util/ui/util.c
 create mode 100644 tools/perf/util/ui/util.h

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 107711b..febb12c 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -656,6 +656,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		int overflow;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -666,12 +667,14 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		WARN_ON_ONCE(hwc->idx != idx);
 
 		/* it might be unflagged overflow */
-		handled = p4_pmu_clear_cccr_ovf(hwc);
+		overflow = p4_pmu_clear_cccr_ovf(hwc);
 
 		val = x86_perf_event_update(event);
-		if (!handled && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
+		if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
 			continue;
 
+		handled += overflow;
+
 		/* event overflow for sure */
 		data.period = event->hw.last_period;
 
@@ -687,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled;
+	return handled > 0;
 }
 
 /*
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 1ba67dc..f6b48f6 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -668,6 +668,7 @@ static int __init ppro_init(char **cpu_type)
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:
+	case 0x1e:
 	case 0x2e:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 26f626d..41abb90 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,9 +157,8 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/python/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/perl/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/scripting-engines/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
 $(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
@@ -568,7 +567,20 @@ else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
 		EXTLIBS += -lnewt -lslang
-		LIB_OBJS += $(OUTPUT)util/newt.o
+		LIB_OBJS += $(OUTPUT)util/ui/setup.o
+		LIB_OBJS += $(OUTPUT)util/ui/browser.o
+		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
+		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
+		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
+		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
+		LIB_OBJS += $(OUTPUT)util/ui/progress.o
+		LIB_OBJS += $(OUTPUT)util/ui/util.o
+		LIB_H += util/ui/browser.h
+		LIB_H += util/ui/browsers/map.h
+		LIB_H += util/ui/helpline.h
+		LIB_H += util/ui/libslang.h
+		LIB_H += util/ui/progress.h
+		LIB_H += util/ui/util.h
 	endif
 endif
 
@@ -966,7 +978,16 @@ $(OUTPUT)builtin-init-db.o: builtin-init-db.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-$(OUTPUT)util/newt.o: util/newt.c $(OUTPUT)PERF-CFLAGS
+$(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index fd20670..1478dc6 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -285,7 +285,7 @@ static int hist_entry__tty_annotate(struct hist_entry *he)
 	LIST_HEAD(head);
 	struct objdump_line *pos, *n;
 
-	if (hist_entry__annotate(he, &head) < 0)
+	if (hist_entry__annotate(he, &head, 0) < 0)
 		return -1;
 
 	if (full_paths)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2f4b929..55fc1f4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -348,7 +348,18 @@ static int __cmd_report(void)
 		hists__tty_browse_tree(&session->hists_tree, help);
 
 out_delete:
-	perf_session__delete(session);
+	/*
+	 * Speed up the exit process, for large files this can
+	 * take quite a while.
+	 *
+	 * XXX Enable this when using valgrind or if we ever
+	 * librarize this command.
+	 *
+	 * Also experiment with obstacks to see how much speed
+	 * up we'll get here.
+	 *
+ 	 * perf_session__delete(session);
+ 	 */
 	return ret;
 }
 
@@ -478,8 +489,24 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser > 0)
+	if (use_browser > 0) {
 		symbol_conf.priv_size = sizeof(struct sym_priv);
+		/*
+ 		 * For searching by name on the "Browse map details".
+ 		 * providing it only in verbose mode not to bloat too
+ 		 * much struct symbol.
+ 		 */
+		if (verbose) {
+			/*
+			 * XXX: Need to provide a less kludgy way to ask for
+			 * more space per symbol, the u32 is for the index on
+			 * the ui browser.
+			 * See symbol__browser_index.
+			 */
+			symbol_conf.priv_size += sizeof(u32);
+			symbol_conf.sort_by_name = true;
+		}
+	}
 
 	if (symbol__init() < 0)
 		return -1;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 5161619..9bcc38f 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -455,8 +455,8 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 		if (p->current->state != TYPE_NONE)
 			pid_put_sample(sw->next_pid, p->current->state, cpu, p->current->state_since, timestamp);
 
-			p->current->state_since = timestamp;
-			p->current->state = TYPE_RUNNING;
+		p->current->state_since = timestamp;
+		p->current->state = TYPE_RUNNING;
 	}
 
 	if (prev_p->current) {
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 294da72..40a6a29 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,13 +1,16 @@
 #include "builtin.h"
 
-#include "util/util.h"
+#include "perf.h"
 #include "util/cache.h"
+#include "util/debug.h"
+#include "util/exec_cmd.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
-#include "util/exec_cmd.h"
 #include "util/trace-event.h"
-#include "util/session.h"
+#include "util/util.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -59,14 +62,6 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-#include "util/parse-options.h"
-
-#include "perf.h"
-#include "util/debug.h"
-
-#include "util/trace-event.h"
-#include "util/exec_cmd.h"
-
 static char const		*input_name = "perf.data";
 
 static int process_sample_event(event_t *event, struct perf_session *session)
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 318dab1..f9c7e3a 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -23,7 +23,7 @@ int eprintf(int level, const char *fmt, ...)
 	if (verbose >= level) {
 		va_start(args, fmt);
 		if (use_browser > 0)
-			ret = browser__show_help(fmt, args);
+			ret = ui_helpline__show_help(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
 		va_end(args);
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 047ac33..7a17ee0 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -14,7 +14,7 @@ void trace_event(event_t *event);
 struct ui_progress;
 
 #ifdef NO_NEWT_SUPPORT
-static inline int browser__show_help(const char *format __used, va_list ap __used)
+static inline int ui_helpline__show_help(const char *format __used, va_list ap __used)
 {
 	return 0;
 }
@@ -30,10 +30,9 @@ static inline void ui_progress__update(struct ui_progress *self __used,
 
 static inline void ui_progress__delete(struct ui_progress *self __used) {}
 #else
-int browser__show_help(const char *format, va_list ap);
-struct ui_progress *ui_progress__new(const char *title, u64 total);
-void ui_progress__update(struct ui_progress *self, u64 curr);
-void ui_progress__delete(struct ui_progress *self);
+extern char ui_helpline__last_msg[];
+int ui_helpline__show_help(const char *format, va_list ap);
+#include "ui/progress.h"
 #endif
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e7263d4..be22ae6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -876,6 +876,9 @@ unsigned int hists__sort_list_width(struct hists *self)
 		if (!se->elide)
 			ret += 2 + hists__col_len(self, se->se_width_idx);
 
+	if (verbose) /* Addr + origin */
+		ret += 3 + BITS_PER_LONG / 4;
+
 	return ret;
 }
 
@@ -980,9 +983,9 @@ int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
 	return 0;
 }
 
-static struct objdump_line *objdump_line__new(s64 offset, char *line)
+static struct objdump_line *objdump_line__new(s64 offset, char *line, size_t privsize)
 {
-	struct objdump_line *self = malloc(sizeof(*self));
+	struct objdump_line *self = malloc(sizeof(*self) + privsize);
 
 	if (self != NULL) {
 		self->offset = offset;
@@ -1014,7 +1017,7 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 }
 
 static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
-					  struct list_head *head)
+					  struct list_head *head, size_t privsize)
 {
 	struct symbol *sym = self->ms.sym;
 	struct objdump_line *objdump_line;
@@ -1065,7 +1068,7 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 			offset = -1;
 	}
 
-	objdump_line = objdump_line__new(offset, line);
+	objdump_line = objdump_line__new(offset, line, privsize);
 	if (objdump_line == NULL) {
 		free(line);
 		return -1;
@@ -1075,7 +1078,8 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 	return 0;
 }
 
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
+			 size_t privsize)
 {
 	struct symbol *sym = self->ms.sym;
 	struct map *map = self->ms.map;
@@ -1140,7 +1144,7 @@ fallback:
 		goto out_free_filename;
 
 	while (!feof(file))
-		if (hist_entry__parse_objdump_line(self, file, head) < 0)
+		if (hist_entry__parse_objdump_line(self, file, head, privsize) < 0)
 			break;
 
 	pclose(file);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 65a48db..587d375 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -101,7 +101,8 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip);
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head);
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
+			 size_t privsize);
 
 void hists__filter_by_dso(struct hists *self, const struct dso *dso);
 void hists__filter_by_thread(struct hists *self, const struct thread *thread);
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index dbe4b81..f5ca26e 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -15,4 +15,12 @@ static inline void list_del_range(struct list_head *begin,
 	begin->prev->next = end->next;
 	end->next->prev = begin->prev;
 }
+
+/**
+ * list_for_each_from	-	iterate over a list from one of its nodes
+ * @pos:  the &struct list_head to use as a loop cursor, from where to start
+ * @head: the head for your list.
+ */
+#define list_for_each_from(pos, head) \
+	for (; prefetch(pos->next), pos != (head); pos = pos->next)
 #endif
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
index 196862a..12de3b8 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -6,4 +6,16 @@
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct hlist_node {
+	struct hlist_node *next, **pprev;
+};
+
 #endif
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
deleted file mode 100644
index 91de99b..0000000
--- a/tools/perf/util/newt.c
+++ /dev/null
@@ -1,1568 +0,0 @@
-#define _GNU_SOURCE
-#include <stdio.h>
-#undef _GNU_SOURCE
-/*
- * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
- * the build if it isn't defined. Use the equivalent one that glibc
- * has on features.h.
- */
-#include <features.h>
-#ifndef HAVE_LONG_LONG
-#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
-#endif
-#include <slang.h>
-#include <signal.h>
-#include <stdlib.h>
-#include <newt.h>
-#include <sys/ttydefaults.h>
-
-#include "cache.h"
-#include "hist.h"
-#include "pstack.h"
-#include "session.h"
-#include "sort.h"
-#include "symbol.h"
-
-#if SLANG_VERSION < 20104
-#define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
-#define slsmg_write_nstring(msg, len) SLsmg_write_nstring((char *)msg, len)
-#define sltt_set_color(obj, name, fg, bg) SLtt_set_color(obj,(char *)name,\
-							 (char *)fg, (char *)bg)
-#else
-#define slsmg_printf SLsmg_printf
-#define slsmg_write_nstring SLsmg_write_nstring
-#define sltt_set_color SLtt_set_color
-#endif
-
-struct ui_progress {
-	newtComponent form, scale;
-};
-
-struct ui_progress *ui_progress__new(const char *title, u64 total)
-{
-	struct ui_progress *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		int cols;
-
-		if (use_browser <= 0)	
-			return self;
-		newtGetScreenSize(&cols, NULL);
-		cols -= 4;
-		newtCenteredWindow(cols, 1, title);
-		self->form  = newtForm(NULL, NULL, 0);
-		if (self->form == NULL)
-			goto out_free_self;
-		self->scale = newtScale(0, 0, cols, total);
-		if (self->scale == NULL)
-			goto out_free_form;
-		newtFormAddComponent(self->form, self->scale);
-		newtRefresh();
-	}
-
-	return self;
-
-out_free_form:
-	newtFormDestroy(self->form);
-out_free_self:
-	free(self);
-	return NULL;
-}
-
-void ui_progress__update(struct ui_progress *self, u64 curr)
-{
-	/*
-	 * FIXME: We should have a per UI backend way of showing progress,
-	 * stdio will just show a percentage as NN%, etc.
-	 */
-	if (use_browser <= 0)
-		return;
-	newtScaleSet(self->scale, curr);
-	newtRefresh();
-}
-
-void ui_progress__delete(struct ui_progress *self)
-{
-	if (use_browser > 0) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-	free(self);
-}
-
-static void ui_helpline__pop(void)
-{
-	newtPopHelpLine();
-}
-
-static void ui_helpline__push(const char *msg)
-{
-	newtPushHelpLine(msg);
-}
-
-static void ui_helpline__vpush(const char *fmt, va_list ap)
-{
-	char *s;
-
-	if (vasprintf(&s, fmt, ap) < 0)
-		vfprintf(stderr, fmt, ap);
-	else {
-		ui_helpline__push(s);
-		free(s);
-	}
-}
-
-static void ui_helpline__fpush(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	ui_helpline__vpush(fmt, ap);
-	va_end(ap);
-}
-
-static void ui_helpline__puts(const char *msg)
-{
-	ui_helpline__pop();
-	ui_helpline__push(msg);
-}
-
-static char browser__last_msg[1024];
-
-int browser__show_help(const char *format, va_list ap)
-{
-	int ret;
-	static int backlog;
-
-        ret = vsnprintf(browser__last_msg + backlog,
-			sizeof(browser__last_msg) - backlog, format, ap);
-	backlog += ret;
-
-	if (browser__last_msg[backlog - 1] == '\n') {
-		ui_helpline__puts(browser__last_msg);
-		newtRefresh();
-		backlog = 0;
-	}
-
-	return ret;
-}
-
-static void newt_form__set_exit_keys(newtComponent self)
-{
-	newtFormAddHotKey(self, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(self, 'Q');
-	newtFormAddHotKey(self, 'q');
-	newtFormAddHotKey(self, CTRL('c'));
-}
-
-static newtComponent newt_form__new(void)
-{
-	newtComponent self = newtForm(NULL, NULL, 0);
-	if (self)
-		newt_form__set_exit_keys(self);
-	return self;
-}
-
-static int popup_menu(int argc, char * const argv[])
-{
-	struct newtExitStruct es;
-	int i, rc = -1, max_len = 5;
-	newtComponent listbox, form = newt_form__new();
-
-	if (form == NULL)
-		return -1;
-
-	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
-	if (listbox == NULL)
-		goto out_destroy_form;
-
-	newtFormAddComponent(form, listbox);
-
-	for (i = 0; i < argc; ++i) {
-		int len = strlen(argv[i]);
-		if (len > max_len)
-			max_len = len;
-		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
-			goto out_destroy_form;
-	}
-
-	newtCenteredWindow(max_len, argc, NULL);
-	newtFormRun(form, &es);
-	rc = newtListboxGetCurrent(listbox) - NULL;
-	if (es.reason == NEWT_EXIT_HOTKEY)
-		rc = -1;
-	newtPopWindow();
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
-}
-
-static int ui__help_window(const char *text)
-{
-	struct newtExitStruct es;
-	newtComponent tb, form = newt_form__new();
-	int rc = -1;
-	int max_len = 0, nr_lines = 0;
-	const char *t;
-
-	if (form == NULL)
-		return -1;
-
-	t = text;
-	while (1) {
-		const char *sep = strchr(t, '\n');
-		int len;
-
-		if (sep == NULL)
-			sep = strchr(t, '\0');
-		len = sep - t;
-		if (max_len < len)
-			max_len = len;
-		++nr_lines;
-		if (*sep == '\0')
-			break;
-		t = sep + 1;
-	}
-
-	tb = newtTextbox(0, 0, max_len, nr_lines, 0);
-	if (tb == NULL)
-		goto out_destroy_form;
-
-	newtTextboxSetText(tb, text);
-	newtFormAddComponent(form, tb);
-	newtCenteredWindow(max_len, nr_lines, NULL);
-	newtFormRun(form, &es);
-	newtPopWindow();
-	rc = 0;
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
-}
-
-static bool dialog_yesno(const char *msg)
-{
-	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
-	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
-}
-
-static void ui__error_window(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
-	va_end(ap);
-}
-
-#define HE_COLORSET_TOP		50
-#define HE_COLORSET_MEDIUM	51
-#define HE_COLORSET_NORMAL	52
-#define HE_COLORSET_SELECTED	53
-#define HE_COLORSET_CODE	54
-
-static int ui_browser__percent_color(double percent, bool current)
-{
-	if (current)
-		return HE_COLORSET_SELECTED;
-	if (percent >= MIN_RED)
-		return HE_COLORSET_TOP;
-	if (percent >= MIN_GREEN)
-		return HE_COLORSET_MEDIUM;
-	return HE_COLORSET_NORMAL;
-}
-
-struct ui_browser {
-	newtComponent	form, sb;
-	u64		index, first_visible_entry_idx;
-	void		*first_visible_entry, *entries;
-	u16		top, left, width, height;
-	void		*priv;
-	unsigned int	(*refresh_entries)(struct ui_browser *self);
-	void		(*seek)(struct ui_browser *self,
-				off_t offset, int whence);
-	u32		nr_entries;
-};
-
-static void ui_browser__list_head_seek(struct ui_browser *self,
-				       off_t offset, int whence)
-{
-	struct list_head *head = self->entries;
-	struct list_head *pos;
-
-	switch (whence) {
-	case SEEK_SET:
-		pos = head->next;
-		break;
-	case SEEK_CUR:
-		pos = self->first_visible_entry;
-		break;
-	case SEEK_END:
-		pos = head->prev;
-		break;
-	default:
-		return;
-	}
-
-	if (offset > 0) {
-		while (offset-- != 0)
-			pos = pos->next;
-	} else {
-		while (offset++ != 0)
-			pos = pos->prev;
-	}
-
-	self->first_visible_entry = pos;
-}
-
-static bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
-{
-	return (self->first_visible_entry_idx + row) == self->index;
-}
-
-static void ui_browser__refresh_dimensions(struct ui_browser *self)
-{
-	int cols, rows;
-	newtGetScreenSize(&cols, &rows);
-
-	if (self->width > cols - 4)
-		self->width = cols - 4;
-	self->height = rows - 5;
-	if (self->height > self->nr_entries)
-		self->height = self->nr_entries;
-	self->top  = (rows - self->height) / 2;
-	self->left = (cols - self->width) / 2;
-}
-
-static void ui_browser__reset_index(struct ui_browser *self)
-{
-	self->index = self->first_visible_entry_idx = 0;
-	self->seek(self, 0, SEEK_SET);
-}
-
-static int ui_browser__show(struct ui_browser *self, const char *title)
-{
-	if (self->form != NULL) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-	ui_browser__refresh_dimensions(self);
-	newtCenteredWindow(self->width, self->height, title);
-	self->form = newt_form__new();
-	if (self->form == NULL)
-		return -1;
-
-	self->sb = newtVerticalScrollbar(self->width, 0, self->height,
-					 HE_COLORSET_NORMAL,
-					 HE_COLORSET_SELECTED);
-	if (self->sb == NULL)
-		return -1;
-
-	newtFormAddHotKey(self->form, NEWT_KEY_UP);
-	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
-	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
-	newtFormAddHotKey(self->form, NEWT_KEY_END);
-	newtFormAddComponent(self->form, self->sb);
-	return 0;
-}
-
-static int objdump_line__show(struct objdump_line *self, struct list_head *head,
-			      int width, struct hist_entry *he, int len,
-			      bool current_entry)
-{
-	if (self->offset != -1) {
-		struct symbol *sym = he->ms.sym;
-		unsigned int hits = 0;
-		double percent = 0.0;
-		int color;
-		struct sym_priv *priv = symbol__priv(sym);
-		struct sym_ext *sym_ext = priv->ext;
-		struct sym_hist *h = priv->hist;
-		s64 offset = self->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(head, self);
-
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (sym_ext) {
-				percent += sym_ext[offset].percent;
-			} else
-				hits += h->ip[offset];
-
-			++offset;
-		}
-
-		if (sym_ext == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
-
-		color = ui_browser__percent_color(percent, current_entry);
-		SLsmg_set_color(color);
-		slsmg_printf(" %7.2f ", percent);
-		if (!current_entry)
-			SLsmg_set_color(HE_COLORSET_CODE);
-	} else {
-		int color = ui_browser__percent_color(0, current_entry);
-		SLsmg_set_color(color);
-		slsmg_write_nstring(" ", 9);
-	}
-
-	SLsmg_write_char(':');
-	slsmg_write_nstring(" ", 8);
-	if (!*self->line)
-		slsmg_write_nstring(" ", width - 18);
-	else
-		slsmg_write_nstring(self->line, width - 18);
-
-	return 0;
-}
-
-static int ui_browser__refresh_entries(struct ui_browser *self)
-{
-	int row;
-
-	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
-	row = self->refresh_entries(self);
-	SLsmg_set_color(HE_COLORSET_NORMAL);
-	SLsmg_fill_region(self->top + row, self->left,
-			  self->height - row, self->width, ' ');
-
-	return 0;
-}
-
-static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
-{
-	if (ui_browser__refresh_entries(self) < 0)
-		return -1;
-
-	while (1) {
-		off_t offset;
-
-		newtFormRun(self->form, es);
-
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-		if (is_exit_key(es->u.key))
-			return es->u.key;
-		switch (es->u.key) {
-		case NEWT_KEY_DOWN:
-			if (self->index == self->nr_entries - 1)
-				break;
-			++self->index;
-			if (self->index == self->first_visible_entry_idx + self->height) {
-				++self->first_visible_entry_idx;
-				self->seek(self, +1, SEEK_CUR);
-			}
-			break;
-		case NEWT_KEY_UP:
-			if (self->index == 0)
-				break;
-			--self->index;
-			if (self->index < self->first_visible_entry_idx) {
-				--self->first_visible_entry_idx;
-				self->seek(self, -1, SEEK_CUR);
-			}
-			break;
-		case NEWT_KEY_PGDN:
-		case ' ':
-			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
-				break;
-
-			offset = self->height;
-			if (self->index + offset > self->nr_entries - 1)
-				offset = self->nr_entries - 1 - self->index;
-			self->index += offset;
-			self->first_visible_entry_idx += offset;
-			self->seek(self, +offset, SEEK_CUR);
-			break;
-		case NEWT_KEY_PGUP:
-			if (self->first_visible_entry_idx == 0)
-				break;
-
-			if (self->first_visible_entry_idx < self->height)
-				offset = self->first_visible_entry_idx;
-			else
-				offset = self->height;
-
-			self->index -= offset;
-			self->first_visible_entry_idx -= offset;
-			self->seek(self, -offset, SEEK_CUR);
-			break;
-		case NEWT_KEY_HOME:
-			ui_browser__reset_index(self);
-			break;
-		case NEWT_KEY_END:
-			offset = self->height - 1;
-			if (offset >= self->nr_entries)
-				offset = self->nr_entries - 1;
-
-			self->index = self->nr_entries - 1;
-			self->first_visible_entry_idx = self->index - offset;
-			self->seek(self, -offset, SEEK_END);
-			break;
-		default:
-			return es->u.key;
-		}
-		if (ui_browser__refresh_entries(self) < 0)
-			return -1;
-	}
-	return 0;
-}
-
-static char *callchain_list__sym_name(struct callchain_list *self,
-				      char *bf, size_t bfsize)
-{
-	if (self->ms.sym)
-		return self->ms.sym->name;
-
-	snprintf(bf, bfsize, "%#Lx", self->ip);
-	return bf;
-}
-
-static unsigned int hist_entry__annotate_browser_refresh(struct ui_browser *self)
-{
-	struct objdump_line *pos;
-	struct list_head *head = self->entries;
-	struct hist_entry *he = self->priv;
-	int row = 0;
-	int len = he->ms.sym->end - he->ms.sym->start;
-
-	if (self->first_visible_entry == NULL || self->first_visible_entry == self->entries)
-                self->first_visible_entry = head->next;
-
-	pos = list_entry(self->first_visible_entry, struct objdump_line, node);
-
-	list_for_each_entry_from(pos, head, node) {
-		bool current_entry = ui_browser__is_current_entry(self, row);
-		SLsmg_gotorc(self->top + row, self->left);
-		objdump_line__show(pos, head, self->width,
-				   he, len, current_entry);
-		if (++row == self->height)
-			break;
-	}
-
-	return row;
-}
-
-int hist_entry__tui_annotate(struct hist_entry *self)
-{
-	struct ui_browser browser;
-	struct newtExitStruct es;
-	struct objdump_line *pos, *n;
-	LIST_HEAD(head);
-	int ret;
-
-	if (self->ms.sym == NULL)
-		return -1;
-
-	if (self->ms.map->dso->annotate_warned)
-		return -1;
-
-	if (hist_entry__annotate(self, &head) < 0) {
-		ui__error_window(browser__last_msg);
-		return -1;
-	}
-
-	ui_helpline__push("Press <- or ESC to exit");
-
-	memset(&browser, 0, sizeof(browser));
-	browser.entries		= &head;
-	browser.refresh_entries = hist_entry__annotate_browser_refresh;
-	browser.seek		= ui_browser__list_head_seek;
-	browser.priv = self;
-	list_for_each_entry(pos, &head, node) {
-		size_t line_len = strlen(pos->line);
-		if (browser.width < line_len)
-			browser.width = line_len;
-		++browser.nr_entries;
-	}
-
-	browser.width += 18; /* Percentage */
-	ui_browser__show(&browser, self->ms.sym->name);
-	newtFormAddHotKey(browser.form, ' ');
-	ret = ui_browser__run(&browser, &es);
-	newtFormDestroy(browser.form);
-	newtPopWindow();
-	list_for_each_entry_safe(pos, n, &head, node) {
-		list_del(&pos->node);
-		objdump_line__free(pos);
-	}
-	ui_helpline__pop();
-	return ret;
-}
-
-struct hist_browser {
-	struct ui_browser   b;
-	struct hists	    *hists;
-	struct hist_entry   *he_selection;
-	struct map_symbol   *selection;
-};
-
-static void hist_browser__reset(struct hist_browser *self);
-static int hist_browser__run(struct hist_browser *self, const char *title,
-			     struct newtExitStruct *es);
-static unsigned int hist_browser__refresh_entries(struct ui_browser *self);
-static void ui_browser__hists_seek(struct ui_browser *self,
-				   off_t offset, int whence);
-
-static struct hist_browser *hist_browser__new(struct hists *hists)
-{
-	struct hist_browser *self = zalloc(sizeof(*self));
-
-	if (self) {
-		self->hists = hists;
-		self->b.refresh_entries = hist_browser__refresh_entries;
-		self->b.seek = ui_browser__hists_seek;
-	}
-
-	return self;
-}
-
-static void hist_browser__delete(struct hist_browser *self)
-{
-	newtFormDestroy(self->b.form);
-	newtPopWindow();
-	free(self);
-}
-
-static struct hist_entry *hist_browser__selected_entry(struct hist_browser *self)
-{
-	return self->he_selection;
-}
-
-static struct thread *hist_browser__selected_thread(struct hist_browser *self)
-{
-	return self->he_selection->thread;
-}
-
-static int hist_browser__title(char *bf, size_t size, const char *ev_name,
-			       const struct dso *dso, const struct thread *thread)
-{
-	int printed = 0;
-
-	if (thread)
-		printed += snprintf(bf + printed, size - printed,
-				    "Thread: %s(%d)",
-				    (thread->comm_set ?  thread->comm : ""),
-				    thread->pid);
-	if (dso)
-		printed += snprintf(bf + printed, size - printed,
-				    "%sDSO: %s", thread ? " " : "",
-				    dso->short_name);
-	return printed ?: snprintf(bf, size, "Event: %s", ev_name);
-}
-
-int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
-{
-	struct hist_browser *browser = hist_browser__new(self);
-	struct pstack *fstack;
-	const struct thread *thread_filter = NULL;
-	const struct dso *dso_filter = NULL;
-	struct newtExitStruct es;
-	char msg[160];
-	int key = -1;
-
-	if (browser == NULL)
-		return -1;
-
-	fstack = pstack__new(2);
-	if (fstack == NULL)
-		goto out;
-
-	ui_helpline__push(helpline);
-
-	hist_browser__title(msg, sizeof(msg), ev_name,
-			    dso_filter, thread_filter);
-
-	while (1) {
-		const struct thread *thread;
-		const struct dso *dso;
-		char *options[16];
-		int nr_options = 0, choice = 0, i,
-		    annotate = -2, zoom_dso = -2, zoom_thread = -2;
-
-		if (hist_browser__run(browser, msg, &es))
-			break;
-
-		thread = hist_browser__selected_thread(browser);
-		dso = browser->selection->map ? browser->selection->map->dso : NULL;
-
-		if (es.reason == NEWT_EXIT_HOTKEY) {
-			key = es.u.key;
-
-			switch (key) {
-			case NEWT_KEY_F1:
-				goto do_help;
-			case NEWT_KEY_TAB:
-			case NEWT_KEY_UNTAB:
-				/*
-				 * Exit the browser, let hists__browser_tree
-				 * go to the next or previous
-				 */
-				goto out_free_stack;
-			default:;
-			}
-
-			key = toupper(key);
-			switch (key) {
-			case 'A':
-				if (browser->selection->map == NULL &&
-				    browser->selection->map->dso->annotate_warned)
-					continue;
-				goto do_annotate;
-			case 'D':
-				goto zoom_dso;
-			case 'T':
-				goto zoom_thread;
-			case 'H':
-			case '?':
-do_help:
-				ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
-						"<-        Zoom out\n"
-						"a         Annotate current symbol\n"
-						"h/?/F1    Show this window\n"
-						"d         Zoom into current DSO\n"
-						"t         Zoom into current Thread\n"
-						"q/CTRL+C  Exit browser");
-				continue;
-			default:;
-			}
-			if (is_exit_key(key)) {
-				if (key == NEWT_KEY_ESCAPE) {
-					if (dialog_yesno("Do you really want to exit?"))
-						break;
-					else
-						continue;
-				} else
-					break;
-			}
-
-			if (es.u.key == NEWT_KEY_LEFT) {
-				const void *top;
-
-				if (pstack__empty(fstack))
-					continue;
-				top = pstack__pop(fstack);
-				if (top == &dso_filter)
-					goto zoom_out_dso;
-				if (top == &thread_filter)
-					goto zoom_out_thread;
-				continue;
-			}
-		}
-
-		if (browser->selection->sym != NULL &&
-		    !browser->selection->map->dso->annotate_warned &&
-		    asprintf(&options[nr_options], "Annotate %s",
-			     browser->selection->sym->name) > 0)
-			annotate = nr_options++;
-
-		if (thread != NULL &&
-		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
-			     (thread_filter ? "out of" : "into"),
-			     (thread->comm_set ? thread->comm : ""),
-			     thread->pid) > 0)
-			zoom_thread = nr_options++;
-
-		if (dso != NULL &&
-		    asprintf(&options[nr_options], "Zoom %s %s DSO",
-			     (dso_filter ? "out of" : "into"),
-			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
-			zoom_dso = nr_options++;
-
-		options[nr_options++] = (char *)"Exit";
-
-		choice = popup_menu(nr_options, options);
-
-		for (i = 0; i < nr_options - 1; ++i)
-			free(options[i]);
-
-		if (choice == nr_options - 1)
-			break;
-
-		if (choice == -1)
-			continue;
-
-		if (choice == annotate) {
-			struct hist_entry *he;
-do_annotate:
-			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
-				browser->selection->map->dso->annotate_warned = 1;
-				ui_helpline__puts("No vmlinux file found, can't "
-						 "annotate with just a "
-						 "kallsyms file");
-				continue;
-			}
-
-			he = hist_browser__selected_entry(browser);
-			if (he == NULL)
-				continue;
-
-			hist_entry__tui_annotate(he);
-		} else if (choice == zoom_dso) {
-zoom_dso:
-			if (dso_filter) {
-				pstack__remove(fstack, &dso_filter);
-zoom_out_dso:
-				ui_helpline__pop();
-				dso_filter = NULL;
-			} else {
-				if (dso == NULL)
-					continue;
-				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
-						   dso->kernel ? "the Kernel" : dso->short_name);
-				dso_filter = dso;
-				pstack__push(fstack, &dso_filter);
-			}
-			hists__filter_by_dso(self, dso_filter);
-			hist_browser__title(msg, sizeof(msg), ev_name,
-					    dso_filter, thread_filter);
-			hist_browser__reset(browser);
-		} else if (choice == zoom_thread) {
-zoom_thread:
-			if (thread_filter) {
-				pstack__remove(fstack, &thread_filter);
-zoom_out_thread:
-				ui_helpline__pop();
-				thread_filter = NULL;
-			} else {
-				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
-						   thread->comm_set ? thread->comm : "",
-						   thread->pid);
-				thread_filter = thread;
-				pstack__push(fstack, &thread_filter);
-			}
-			hists__filter_by_thread(self, thread_filter);
-			hist_browser__title(msg, sizeof(msg), ev_name,
-					    dso_filter, thread_filter);
-			hist_browser__reset(browser);
-		}
-	}
-out_free_stack:
-	pstack__delete(fstack);
-out:
-	hist_browser__delete(browser);
-	return key;
-}
-
-int hists__tui_browse_tree(struct rb_root *self, const char *help)
-{
-	struct rb_node *first = rb_first(self), *nd = first, *next;
-	int key = 0;
-
-	while (nd) {
-		struct hists *hists = rb_entry(nd, struct hists, rb_node);
-		const char *ev_name = __event_name(hists->type, hists->config);
-
-		key = hists__browse(hists, help, ev_name);
-
-		if (is_exit_key(key))
-			break;
-
-		switch (key) {
-		case NEWT_KEY_TAB:
-			next = rb_next(nd);
-			if (next)
-				nd = next;
-			break;
-		case NEWT_KEY_UNTAB:
-			if (nd == first)
-				continue;
-			nd = rb_prev(nd);
-		default:
-			break;
-		}
-	}
-
-	return key;
-}
-
-static struct newtPercentTreeColors {
-	const char *topColorFg, *topColorBg;
-	const char *mediumColorFg, *mediumColorBg;
-	const char *normalColorFg, *normalColorBg;
-	const char *selColorFg, *selColorBg;
-	const char *codeColorFg, *codeColorBg;
-} defaultPercentTreeColors = {
-	"red",       "lightgray",
-	"green",     "lightgray",
-	"black",     "lightgray",
-	"lightgray", "magenta",
-	"blue",	     "lightgray",
-};
-
-static void newt_suspend(void *d __used)
-{
-	newtSuspend();
-	raise(SIGTSTP);
-	newtResume();
-}
-
-void setup_browser(void)
-{
-	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
-
-	if (!isatty(1) || !use_browser || dump_trace) {
-		use_browser = 0;
-		setup_pager();
-		return;
-	}
-
-	use_browser = 1;
-	newtInit();
-	newtCls();
-	newtSetSuspendCallback(newt_suspend, NULL);
-	ui_helpline__puts(" ");
-	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
-	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
-	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
-	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
-	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
-}
-
-void exit_browser(bool wait_for_ok)
-{
-	if (use_browser > 0) {
-		if (wait_for_ok) {
-			char title[] = "Fatal Error", ok[] = "Ok";
-			newtWinMessage(title, ok, browser__last_msg);
-		}
-		newtFinished();
-	}
-}
-
-static void hist_browser__refresh_dimensions(struct hist_browser *self)
-{
-	/* 3 == +/- toggle symbol before actual hist_entry rendering */
-	self->b.width = 3 + (hists__sort_list_width(self->hists) +
-			     sizeof("[k]"));
-}
-
-static void hist_browser__reset(struct hist_browser *self)
-{
-	self->b.nr_entries = self->hists->nr_entries;
-	hist_browser__refresh_dimensions(self);
-	ui_browser__reset_index(&self->b);
-}
-
-static char tree__folded_sign(bool unfolded)
-{
-	return unfolded ? '-' : '+';
-}
-
-static char map_symbol__folded(const struct map_symbol *self)
-{
-	return self->has_children ? tree__folded_sign(self->unfolded) : ' ';
-}
-
-static char hist_entry__folded(const struct hist_entry *self)
-{
-	return map_symbol__folded(&self->ms);
-}
-
-static char callchain_list__folded(const struct callchain_list *self)
-{
-	return map_symbol__folded(&self->ms);
-}
-
-static bool map_symbol__toggle_fold(struct map_symbol *self)
-{
-	if (!self->has_children)
-		return false;
-
-	self->unfolded = !self->unfolded;
-	return true;
-}
-
-#define LEVEL_OFFSET_STEP 3
-
-static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
-						     struct callchain_node *chain_node,
-						     u64 total, int level,
-						     unsigned short row,
-						     off_t *row_offset,
-						     bool *is_current_entry)
-{
-	struct rb_node *node;
-	int first_row = row, width, offset = level * LEVEL_OFFSET_STEP;
-	u64 new_total, remaining;
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = chain_node->children_hit;
-	else
-		new_total = total;
-
-	remaining = new_total;
-	node = rb_first(&chain_node->rb_root);
-	while (node) {
-		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
-		struct rb_node *next = rb_next(node);
-		u64 cumul = cumul_hits(child);
-		struct callchain_list *chain;
-		char folded_sign = ' ';
-		int first = true;
-		int extra_offset = 0;
-
-		remaining -= cumul;
-
-		list_for_each_entry(chain, &child->val, list) {
-			char ipstr[BITS_PER_LONG / 4 + 1], *alloc_str;
-			const char *str;
-			int color;
-			bool was_first = first;
-
-			if (first) {
-				first = false;
-				chain->ms.has_children = chain->list.next != &child->val ||
-							 rb_first(&child->rb_root) != NULL;
-			} else {
-				extra_offset = LEVEL_OFFSET_STEP;
-				chain->ms.has_children = chain->list.next == &child->val &&
-							 rb_first(&child->rb_root) != NULL;
-			}
-
-			folded_sign = callchain_list__folded(chain);
-			if (*row_offset != 0) {
-				--*row_offset;
-				goto do_next;
-			}
-
-			alloc_str = NULL;
-			str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-			if (was_first) {
-				double percent = cumul * 100.0 / new_total;
-
-				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
-					str = "Not enough memory!";
-				else
-					str = alloc_str;
-			}
-
-			color = HE_COLORSET_NORMAL;
-			width = self->b.width - (offset + extra_offset + 2);
-			if (ui_browser__is_current_entry(&self->b, row)) {
-				self->selection = &chain->ms;
-				color = HE_COLORSET_SELECTED;
-				*is_current_entry = true;
-			}
-
-			SLsmg_set_color(color);
-			SLsmg_gotorc(self->b.top + row, self->b.left);
-			slsmg_write_nstring(" ", offset + extra_offset);
-			slsmg_printf("%c ", folded_sign);
-			slsmg_write_nstring(str, width);
-			free(alloc_str);
-
-			if (++row == self->b.height)
-				goto out;
-do_next:
-			if (folded_sign == '+')
-				break;
-		}
-
-		if (folded_sign == '-') {
-			const int new_level = level + (extra_offset ? 2 : 1);
-			row += hist_browser__show_callchain_node_rb_tree(self, child, new_total,
-									 new_level, row, row_offset,
-									 is_current_entry);
-		}
-		if (row == self->b.height)
-			goto out;
-		node = next;
-	}
-out:
-	return row - first_row;
-}
-
-static int hist_browser__show_callchain_node(struct hist_browser *self,
-					     struct callchain_node *node,
-					     int level, unsigned short row,
-					     off_t *row_offset,
-					     bool *is_current_entry)
-{
-	struct callchain_list *chain;
-	int first_row = row,
-	     offset = level * LEVEL_OFFSET_STEP,
-	     width = self->b.width - offset;
-	char folded_sign = ' ';
-
-	list_for_each_entry(chain, &node->val, list) {
-		char ipstr[BITS_PER_LONG / 4 + 1], *s;
-		int color;
-		/*
-		 * FIXME: This should be moved to somewhere else,
-		 * probably when the callchain is created, so as not to
-		 * traverse it all over again
-		 */
-		chain->ms.has_children = rb_first(&node->rb_root) != NULL;
-		folded_sign = callchain_list__folded(chain);
-
-		if (*row_offset != 0) {
-			--*row_offset;
-			continue;
-		}
-
-		color = HE_COLORSET_NORMAL;
-		if (ui_browser__is_current_entry(&self->b, row)) {
-			self->selection = &chain->ms;
-			color = HE_COLORSET_SELECTED;
-			*is_current_entry = true;
-		}
-
-		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		SLsmg_gotorc(self->b.top + row, self->b.left);
-		SLsmg_set_color(color);
-		slsmg_write_nstring(" ", offset);
-		slsmg_printf("%c ", folded_sign);
-		slsmg_write_nstring(s, width - 2);
-
-		if (++row == self->b.height)
-			goto out;
-	}
-
-	if (folded_sign == '-')
-		row += hist_browser__show_callchain_node_rb_tree(self, node,
-								 self->hists->stats.total_period,
-								 level + 1, row,
-								 row_offset,
-								 is_current_entry);
-out:
-	return row - first_row;
-}
-
-static int hist_browser__show_callchain(struct hist_browser *self,
-					struct rb_root *chain,
-					int level, unsigned short row,
-					off_t *row_offset,
-					bool *is_current_entry)
-{
-	struct rb_node *nd;
-	int first_row = row;
-
-	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
-		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-
-		row += hist_browser__show_callchain_node(self, node, level,
-							 row, row_offset,
-							 is_current_entry);
-		if (row == self->b.height)
-			break;
-	}
-
-	return row - first_row;
-}
-
-static int hist_browser__show_entry(struct hist_browser *self,
-				    struct hist_entry *entry,
-				    unsigned short row)
-{
-	char s[256];
-	double percent;
-	int printed = 0;
-	int color, width = self->b.width;
-	char folded_sign = ' ';
-	bool current_entry = ui_browser__is_current_entry(&self->b, row);
-	off_t row_offset = entry->row_offset;
-
-	if (current_entry) {
-		self->he_selection = entry;
-		self->selection = &entry->ms;
-	}
-
-	if (symbol_conf.use_callchain) {
-		entry->ms.has_children = !RB_EMPTY_ROOT(&entry->sorted_chain);
-		folded_sign = hist_entry__folded(entry);
-	}
-
-	if (row_offset == 0) {
-		hist_entry__snprintf(entry, s, sizeof(s), self->hists, NULL, false,
-				     0, false, self->hists->stats.total_period);
-		percent = (entry->period * 100.0) / self->hists->stats.total_period;
-
-		color = HE_COLORSET_SELECTED;
-		if (!current_entry) {
-			if (percent >= MIN_RED)
-				color = HE_COLORSET_TOP;
-			else if (percent >= MIN_GREEN)
-				color = HE_COLORSET_MEDIUM;
-			else
-				color = HE_COLORSET_NORMAL;
-		}
-
-		SLsmg_set_color(color);
-		SLsmg_gotorc(self->b.top + row, self->b.left);
-		if (symbol_conf.use_callchain) {
-			slsmg_printf("%c ", folded_sign);
-			width -= 2;
-		}
-		slsmg_write_nstring(s, width);
-		++row;
-		++printed;
-	} else
-		--row_offset;
-
-	if (folded_sign == '-' && row != self->b.height) {
-		printed += hist_browser__show_callchain(self, &entry->sorted_chain,
-							1, row, &row_offset,
-							&current_entry);
-		if (current_entry)
-			self->he_selection = entry;
-	}
-
-	return printed;
-}
-
-static unsigned int hist_browser__refresh_entries(struct ui_browser *self)
-{
-	unsigned row = 0;
-	struct rb_node *nd;
-	struct hist_browser *hb = container_of(self, struct hist_browser, b);
-
-	if (self->first_visible_entry == NULL)
-		self->first_visible_entry = rb_first(&hb->hists->entries);
-
-	for (nd = self->first_visible_entry; nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-
-		if (h->filtered)
-			continue;
-
-		row += hist_browser__show_entry(hb, h, row);
-		if (row == self->height)
-			break;
-	}
-
-	return row;
-}
-
-static void callchain_node__init_have_children_rb_tree(struct callchain_node *self)
-{
-	struct rb_node *nd = rb_first(&self->rb_root);
-
-	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
-		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
-		struct callchain_list *chain;
-		int first = true;
-
-		list_for_each_entry(chain, &child->val, list) {
-			if (first) {
-				first = false;
-				chain->ms.has_children = chain->list.next != &child->val ||
-							 rb_first(&child->rb_root) != NULL;
-			} else
-				chain->ms.has_children = chain->list.next == &child->val &&
-							 rb_first(&child->rb_root) != NULL;
-		}
-
-		callchain_node__init_have_children_rb_tree(child);
-	}
-}
-
-static void callchain_node__init_have_children(struct callchain_node *self)
-{
-	struct callchain_list *chain;
-
-	list_for_each_entry(chain, &self->val, list)
-		chain->ms.has_children = rb_first(&self->rb_root) != NULL;
-
-	callchain_node__init_have_children_rb_tree(self);
-}
-
-static void callchain__init_have_children(struct rb_root *self)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
-		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-		callchain_node__init_have_children(node);
-	}
-}
-
-static void hist_entry__init_have_children(struct hist_entry *self)
-{
-	if (!self->init_have_children) {
-		callchain__init_have_children(&self->sorted_chain);
-		self->init_have_children = true;
-	}
-}
-
-static struct rb_node *hists__filter_entries(struct rb_node *nd)
-{
-	while (nd != NULL) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		if (!h->filtered)
-			return nd;
-
-		nd = rb_next(nd);
-	}
-
-	return NULL;
-}
-
-static struct rb_node *hists__filter_prev_entries(struct rb_node *nd)
-{
-	while (nd != NULL) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		if (!h->filtered)
-			return nd;
-
-		nd = rb_prev(nd);
-	}
-
-	return NULL;
-}
-
-static void ui_browser__hists_seek(struct ui_browser *self,
-				   off_t offset, int whence)
-{
-	struct hist_entry *h;
-	struct rb_node *nd;
-	bool first = true;
-
-	switch (whence) {
-	case SEEK_SET:
-		nd = hists__filter_entries(rb_first(self->entries));
-		break;
-	case SEEK_CUR:
-		nd = self->first_visible_entry;
-		goto do_offset;
-	case SEEK_END:
-		nd = hists__filter_prev_entries(rb_last(self->entries));
-		first = false;
-		break;
-	default:
-		return;
-	}
-
-	/*
-	 * Moves not relative to the first visible entry invalidates its
-	 * row_offset:
-	 */
-	h = rb_entry(self->first_visible_entry, struct hist_entry, rb_node);
-	h->row_offset = 0;
-
-	/*
-	 * Here we have to check if nd is expanded (+), if it is we can't go
-	 * the next top level hist_entry, instead we must compute an offset of
-	 * what _not_ to show and not change the first visible entry.
-	 *
-	 * This offset increments when we are going from top to bottom and
-	 * decreases when we're going from bottom to top.
-	 *
-	 * As we don't have backpointers to the top level in the callchains
-	 * structure, we need to always print the whole hist_entry callchain,
-	 * skipping the first ones that are before the first visible entry
-	 * and stop when we printed enough lines to fill the screen.
-	 */
-do_offset:
-	if (offset > 0) {
-		do {
-			h = rb_entry(nd, struct hist_entry, rb_node);
-			if (h->ms.unfolded) {
-				u16 remaining = h->nr_rows - h->row_offset;
-				if (offset > remaining) {
-					offset -= remaining;
-					h->row_offset = 0;
-				} else {
-					h->row_offset += offset;
-					offset = 0;
-					self->first_visible_entry = nd;
-					break;
-				}
-			}
-			nd = hists__filter_entries(rb_next(nd));
-			if (nd == NULL)
-				break;
-			--offset;
-			self->first_visible_entry = nd;
-		} while (offset != 0);
-	} else if (offset < 0) {
-		while (1) {
-			h = rb_entry(nd, struct hist_entry, rb_node);
-			if (h->ms.unfolded) {
-				if (first) {
-					if (-offset > h->row_offset) {
-						offset += h->row_offset;
-						h->row_offset = 0;
-					} else {
-						h->row_offset += offset;
-						offset = 0;
-						self->first_visible_entry = nd;
-						break;
-					}
-				} else {
-					if (-offset > h->nr_rows) {
-						offset += h->nr_rows;
-						h->row_offset = 0;
-					} else {
-						h->row_offset = h->nr_rows + offset;
-						offset = 0;
-						self->first_visible_entry = nd;
-						break;
-					}
-				}
-			}
-
-			nd = hists__filter_prev_entries(rb_prev(nd));
-			if (nd == NULL)
-				break;
-			++offset;
-			self->first_visible_entry = nd;
-			if (offset == 0) {
-				/*
-				 * Last unfiltered hist_entry, check if it is
-				 * unfolded, if it is then we should have
-				 * row_offset at its last entry.
-				 */
-				h = rb_entry(nd, struct hist_entry, rb_node);
-				if (h->ms.unfolded)
-					h->row_offset = h->nr_rows;
-				break;
-			}
-			first = false;
-		}
-	} else {
-		self->first_visible_entry = nd;
-		h = rb_entry(nd, struct hist_entry, rb_node);
-		h->row_offset = 0;
-	}
-}
-
-static int callchain_node__count_rows_rb_tree(struct callchain_node *self)
-{
-	int n = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
-		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
-		struct callchain_list *chain;
-		char folded_sign = ' '; /* No children */
-
-		list_for_each_entry(chain, &child->val, list) {
-			++n;
-			/* We need this because we may not have children */
-			folded_sign = callchain_list__folded(chain);
-			if (folded_sign == '+')
-				break;
-		}
-
-		if (folded_sign == '-') /* Have children and they're unfolded */
-			n += callchain_node__count_rows_rb_tree(child);
-	}
-
-	return n;
-}
-
-static int callchain_node__count_rows(struct callchain_node *node)
-{
-	struct callchain_list *chain;
-	bool unfolded = false;
-	int n = 0;
-
-	list_for_each_entry(chain, &node->val, list) {
-		++n;
-		unfolded = chain->ms.unfolded;
-	}
-
-	if (unfolded)
-		n += callchain_node__count_rows_rb_tree(node);
-
-	return n;
-}
-
-static int callchain__count_rows(struct rb_root *chain)
-{
-	struct rb_node *nd;
-	int n = 0;
-
-	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
-		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-		n += callchain_node__count_rows(node);
-	}
-
-	return n;
-}
-
-static bool hist_browser__toggle_fold(struct hist_browser *self)
-{
-	if (map_symbol__toggle_fold(self->selection)) {
-		struct hist_entry *he = self->he_selection;
-
-		hist_entry__init_have_children(he);
-		self->hists->nr_entries -= he->nr_rows;
-
-		if (he->ms.unfolded)
-			he->nr_rows = callchain__count_rows(&he->sorted_chain);
-		else
-			he->nr_rows = 0;
-		self->hists->nr_entries += he->nr_rows;
-		self->b.nr_entries = self->hists->nr_entries;
-
-		return true;
-	}
-
-	/* If it doesn't have children, no toggling performed */
-	return false;
-}
-
-static int hist_browser__run(struct hist_browser *self, const char *title,
-			     struct newtExitStruct *es)
-{
-	char str[256], unit;
-	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
-
-	self->b.entries = &self->hists->entries;
-	self->b.nr_entries = self->hists->nr_entries;
-
-	hist_browser__refresh_dimensions(self);
-
-	nr_events = convert_unit(nr_events, &unit);
-	snprintf(str, sizeof(str), "Events: %lu%c                            ",
-		 nr_events, unit);
-	newtDrawRootText(0, 0, str);
-
-	if (ui_browser__show(&self->b, title) < 0)
-		return -1;
-
-	newtFormAddHotKey(self->b.form, 'A');
-	newtFormAddHotKey(self->b.form, 'a');
-	newtFormAddHotKey(self->b.form, '?');
-	newtFormAddHotKey(self->b.form, 'h');
-	newtFormAddHotKey(self->b.form, 'H');
-	newtFormAddHotKey(self->b.form, 'd');
-
-	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
-
-	while (1) {
-		ui_browser__run(&self->b, es);
-
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-		switch (es->u.key) {
-		case 'd': { /* Debug */
-			static int seq;
-			struct hist_entry *h = rb_entry(self->b.first_visible_entry,
-							struct hist_entry, rb_node);
-			ui_helpline__pop();
-			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
-					   seq++, self->b.nr_entries,
-					   self->hists->nr_entries,
-					   self->b.height,
-					   self->b.index,
-					   self->b.first_visible_entry_idx,
-					   h->row_offset, h->nr_rows);
-		}
-			continue;
-		case NEWT_KEY_ENTER:
-			if (hist_browser__toggle_fold(self))
-				break;
-			/* fall thru */
-		default:
-			return 0;
-		}
-	}
-	return 0;
-}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2e665cb..e72f05c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1606,8 +1606,10 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 
 	/* Init vmlinux path */
 	ret = init_vmlinux();
-	if (ret < 0)
+	if (ret < 0) {
+		free(pkgs);
 		return ret;
+	}
 
 	/* Loop 1: convert all events */
 	for (i = 0; i < npevs; i++) {
@@ -1625,10 +1627,13 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
 						pkgs[i].ntevs, force_add);
 end:
-	/* Loop 3: cleanup trace events  */
-	for (i = 0; i < npevs; i++)
+	/* Loop 3: cleanup and free trace events  */
+	for (i = 0; i < npevs; i++) {
 		for (j = 0; j < pkgs[i].ntevs; j++)
 			clear_probe_trace_event(&pkgs[i].tevs[j]);
+		free(pkgs[i].tevs);
+	}
+	free(pkgs);
 
 	return ret;
 }
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 840f1aa..5251366 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -33,7 +33,6 @@
 #include <ctype.h>
 #include <dwarf-regs.h>
 
-#include "string.h"
 #include "event.h"
 #include "debug.h"
 #include "util.h"
@@ -706,8 +705,12 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 		pf->tvar->value = strdup(pf->pvar->var);
 		if (pf->tvar->value == NULL)
 			return -ENOMEM;
-		else
-			return 0;
+		if (pf->pvar->type) {
+			pf->tvar->type = strdup(pf->pvar->type);
+			if (pf->tvar->type == NULL)
+				return -ENOMEM;
+		}
+		return 0;
 	}
 
 	pr_debug("Searching '%s' variable in context.\n",
diff --git a/tools/perf/util/pstack.h b/tools/perf/util/pstack.h
index 5ad0702..4cedea5 100644
--- a/tools/perf/util/pstack.h
+++ b/tools/perf/util/pstack.h
@@ -1,6 +1,8 @@
 #ifndef _PERF_PSTACK_
 #define _PERF_PSTACK_
 
+#include <stdbool.h>
+
 struct pstack;
 struct pstack *pstack__new(unsigned short max_nr_entries);
 void pstack__delete(struct pstack *self);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1c61a4f..b62a553 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -196,7 +196,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 
 	if (verbose) {
 		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
-		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
+		ret += repsep_snprintf(bf, size, "%*Lx %c ",
+				       BITS_PER_LONG / 4, self->ip, o);
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
@@ -204,7 +205,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 		ret += repsep_snprintf(bf + ret, size - ret, "%s",
 				       self->ms.sym->name);
 	else
-		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
+		ret += repsep_snprintf(bf + ret, size - ret, "%*Lx",
+				       BITS_PER_LONG / 4, self->ip);
 
 	return ret;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 6f0dd90..1a36773 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -131,7 +131,8 @@ static void map_groups__fixup_end(struct map_groups *self)
 		__map_groups__fixup_end(self, i);
 }
 
-static struct symbol *symbol__new(u64 start, u64 len, const char *name)
+static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
+				  const char *name)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *self = calloc(1, (symbol_conf.priv_size +
@@ -144,6 +145,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 
 	self->start   = start;
 	self->end     = len ? start + len - 1 : start;
+	self->binding = binding;
 	self->namelen = namelen - 1;
 
 	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
@@ -160,8 +162,11 @@ void symbol__delete(struct symbol *self)
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 {
-	return fprintf(fp, " %llx-%llx %s\n",
-		       self->start, self->end, self->name);
+	return fprintf(fp, " %llx-%llx %c %s\n",
+		       self->start, self->end,
+		       self->binding == STB_GLOBAL ? 'g' :
+		       self->binding == STB_LOCAL  ? 'l' : 'w',
+		       self->name);
 }
 
 void dso__set_long_name(struct dso *self, char *name)
@@ -453,6 +458,14 @@ struct process_kallsyms_args {
 	struct dso *dso;
 };
 
+static u8 kallsyms2elf_type(char type)
+{
+	if (type == 'W')
+		return STB_WEAK;
+
+	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
+}
+
 static int map__process_kallsym_symbol(void *arg, const char *name,
 				       char type, u64 start)
 {
@@ -466,7 +479,7 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 	/*
 	 * Will fix up the end later, when we have all symbols sorted.
 	 */
-	sym = symbol__new(start, 0, name);
+	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
 
 	if (sym == NULL)
 		return -ENOMEM;
@@ -661,7 +674,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (len + 2 >= line_len)
 			continue;
 
-		sym = symbol__new(start, size, line + len);
+		sym = symbol__new(start, size, STB_GLOBAL, line + len);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -873,7 +886,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname);
+					STB_GLOBAL, sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -895,7 +908,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname);
+					STB_GLOBAL, sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -1066,6 +1079,16 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
+		/* Reject ARM ELF "mapping symbols": these aren't unique and
+		 * don't identify functions, so will confuse the profile
+		 * output: */
+		if (ehdr.e_machine == EM_ARM) {
+			if (!strcmp(elf_name, "$a") ||
+			    !strcmp(elf_name, "$d") ||
+			    !strcmp(elf_name, "$t"))
+				continue;
+		}
+
 		if (opdsec && sym.st_shndx == opdidx) {
 			u32 offset = sym.st_value - opdshdr.sh_addr;
 			u64 *opd = opddata->d_buf + offset;
@@ -1146,7 +1169,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (demangled != NULL)
 			elf_name = demangled;
 new_symbol:
-		f = symbol__new(sym.st_value, sym.st_size, elf_name);
+		f = symbol__new(sym.st_value, sym.st_size,
+				GELF_ST_BIND(sym.st_info), elf_name);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 906be20..b7a8da4 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -53,6 +53,7 @@ struct symbol {
 	u64		start;
 	u64		end;
 	u16		namelen;
+	u8		binding;
 	char		name[0];
 };
 
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
new file mode 100644
index 0000000..66f2d58
--- /dev/null
+++ b/tools/perf/util/ui/browser.c
@@ -0,0 +1,329 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#undef _GNU_SOURCE
+/*
+ * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
+ * the build if it isn't defined. Use the equivalent one that glibc
+ * has on features.h.
+ */
+#include <features.h>
+#ifndef HAVE_LONG_LONG
+#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
+#endif
+#include <slang.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <stdlib.h>
+#include <sys/ttydefaults.h>
+#include "browser.h"
+#include "helpline.h"
+#include "../color.h"
+#include "../util.h"
+
+#if SLANG_VERSION < 20104
+#define sltt_set_color(obj, name, fg, bg) \
+	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
+#else
+#define sltt_set_color SLtt_set_color
+#endif
+
+newtComponent newt_form__new(void);
+
+int ui_browser__percent_color(double percent, bool current)
+{
+	if (current)
+		return HE_COLORSET_SELECTED;
+	if (percent >= MIN_RED)
+		return HE_COLORSET_TOP;
+	if (percent >= MIN_GREEN)
+		return HE_COLORSET_MEDIUM;
+	return HE_COLORSET_NORMAL;
+}
+
+void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence)
+{
+	struct list_head *head = self->entries;
+	struct list_head *pos;
+
+	switch (whence) {
+	case SEEK_SET:
+		pos = head->next;
+		break;
+	case SEEK_CUR:
+		pos = self->top;
+		break;
+	case SEEK_END:
+		pos = head->prev;
+		break;
+	default:
+		return;
+	}
+
+	if (offset > 0) {
+		while (offset-- != 0)
+			pos = pos->next;
+	} else {
+		while (offset++ != 0)
+			pos = pos->prev;
+	}
+
+	self->top = pos;
+}
+
+void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
+{
+	struct rb_root *root = self->entries;
+	struct rb_node *nd;
+
+	switch (whence) {
+	case SEEK_SET:
+		nd = rb_first(root);
+		break;
+	case SEEK_CUR:
+		nd = self->top;
+		break;
+	case SEEK_END:
+		nd = rb_last(root);
+		break;
+	default:
+		return;
+	}
+
+	if (offset > 0) {
+		while (offset-- != 0)
+			nd = rb_next(nd);
+	} else {
+		while (offset++ != 0)
+			nd = rb_prev(nd);
+	}
+
+	self->top = nd;
+}
+
+unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
+{
+	struct rb_node *nd;
+	int row = 0;
+
+	if (self->top == NULL)
+                self->top = rb_first(self->entries);
+
+	nd = self->top;
+
+	while (nd != NULL) {
+		SLsmg_gotorc(self->y + row, self->x);
+		self->write(self, nd, row);
+		if (++row == self->height)
+			break;
+		nd = rb_next(nd);
+	}
+
+	return row;
+}
+
+bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
+{
+	return self->top_idx + row == self->index;
+}
+
+void ui_browser__refresh_dimensions(struct ui_browser *self)
+{
+	int cols, rows;
+	newtGetScreenSize(&cols, &rows);
+
+	if (self->width > cols - 4)
+		self->width = cols - 4;
+	self->height = rows - 5;
+	if (self->height > self->nr_entries)
+		self->height = self->nr_entries;
+	self->y  = (rows - self->height) / 2;
+	self->x = (cols - self->width) / 2;
+}
+
+void ui_browser__reset_index(struct ui_browser *self)
+{
+	self->index = self->top_idx = 0;
+	self->seek(self, 0, SEEK_SET);
+}
+
+int ui_browser__show(struct ui_browser *self, const char *title,
+		     const char *helpline, ...)
+{
+	va_list ap;
+
+	if (self->form != NULL) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
+	ui_browser__refresh_dimensions(self);
+	newtCenteredWindow(self->width, self->height, title);
+	self->form = newt_form__new();
+	if (self->form == NULL)
+		return -1;
+
+	self->sb = newtVerticalScrollbar(self->width, 0, self->height,
+					 HE_COLORSET_NORMAL,
+					 HE_COLORSET_SELECTED);
+	if (self->sb == NULL)
+		return -1;
+
+	newtFormAddHotKey(self->form, NEWT_KEY_UP);
+	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
+	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
+	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
+	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
+	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddHotKey(self->form, ' ');
+	newtFormAddComponent(self->form, self->sb);
+
+	va_start(ap, helpline);
+	ui_helpline__vpush(helpline, ap);
+	va_end(ap);
+	return 0;
+}
+
+void ui_browser__hide(struct ui_browser *self)
+{
+	newtFormDestroy(self->form);
+	newtPopWindow();
+	self->form = NULL;
+	ui_helpline__pop();
+}
+
+int ui_browser__refresh(struct ui_browser *self)
+{
+	int row;
+
+	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
+	row = self->refresh(self);
+	SLsmg_set_color(HE_COLORSET_NORMAL);
+	SLsmg_fill_region(self->y + row, self->x,
+			  self->height - row, self->width, ' ');
+
+	return 0;
+}
+
+int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
+{
+	if (ui_browser__refresh(self) < 0)
+		return -1;
+
+	while (1) {
+		off_t offset;
+
+		newtFormRun(self->form, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		if (is_exit_key(es->u.key))
+			return es->u.key;
+		switch (es->u.key) {
+		case NEWT_KEY_DOWN:
+			if (self->index == self->nr_entries - 1)
+				break;
+			++self->index;
+			if (self->index == self->top_idx + self->height) {
+				++self->top_idx;
+				self->seek(self, +1, SEEK_CUR);
+			}
+			break;
+		case NEWT_KEY_UP:
+			if (self->index == 0)
+				break;
+			--self->index;
+			if (self->index < self->top_idx) {
+				--self->top_idx;
+				self->seek(self, -1, SEEK_CUR);
+			}
+			break;
+		case NEWT_KEY_PGDN:
+		case ' ':
+			if (self->top_idx + self->height > self->nr_entries - 1)
+				break;
+
+			offset = self->height;
+			if (self->index + offset > self->nr_entries - 1)
+				offset = self->nr_entries - 1 - self->index;
+			self->index += offset;
+			self->top_idx += offset;
+			self->seek(self, +offset, SEEK_CUR);
+			break;
+		case NEWT_KEY_PGUP:
+			if (self->top_idx == 0)
+				break;
+
+			if (self->top_idx < self->height)
+				offset = self->top_idx;
+			else
+				offset = self->height;
+
+			self->index -= offset;
+			self->top_idx -= offset;
+			self->seek(self, -offset, SEEK_CUR);
+			break;
+		case NEWT_KEY_HOME:
+			ui_browser__reset_index(self);
+			break;
+		case NEWT_KEY_END:
+			offset = self->height - 1;
+			if (offset >= self->nr_entries)
+				offset = self->nr_entries - 1;
+
+			self->index = self->nr_entries - 1;
+			self->top_idx = self->index - offset;
+			self->seek(self, -offset, SEEK_END);
+			break;
+		default:
+			return es->u.key;
+		}
+		if (ui_browser__refresh(self) < 0)
+			return -1;
+	}
+	return 0;
+}
+
+unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
+{
+	struct list_head *pos;
+	struct list_head *head = self->entries;
+	int row = 0;
+
+	if (self->top == NULL || self->top == self->entries)
+                self->top = head->next;
+
+	pos = self->top;
+
+	list_for_each_from(pos, head) {
+		SLsmg_gotorc(self->y + row, self->x);
+		self->write(self, pos, row);
+		if (++row == self->height)
+			break;
+	}
+
+	return row;
+}
+
+static struct newtPercentTreeColors {
+	const char *topColorFg, *topColorBg;
+	const char *mediumColorFg, *mediumColorBg;
+	const char *normalColorFg, *normalColorBg;
+	const char *selColorFg, *selColorBg;
+	const char *codeColorFg, *codeColorBg;
+} defaultPercentTreeColors = {
+	"red",       "lightgray",
+	"green",     "lightgray",
+	"black",     "lightgray",
+	"lightgray", "magenta",
+	"blue",	     "lightgray",
+};
+
+void ui_browser__init(void)
+{
+	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
+
+	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
+	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
+	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
+	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
+	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
+}
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
new file mode 100644
index 0000000..0b9f829
--- /dev/null
+++ b/tools/perf/util/ui/browser.h
@@ -0,0 +1,46 @@
+#ifndef _PERF_UI_BROWSER_H_
+#define _PERF_UI_BROWSER_H_ 1
+
+#include <stdbool.h>
+#include <newt.h>
+#include <sys/types.h>
+#include "../types.h"
+
+#define HE_COLORSET_TOP		50
+#define HE_COLORSET_MEDIUM	51
+#define HE_COLORSET_NORMAL	52
+#define HE_COLORSET_SELECTED	53
+#define HE_COLORSET_CODE	54
+
+struct ui_browser {
+	newtComponent form, sb;
+	u64	      index, top_idx;
+	void	      *top, *entries;
+	u16	      y, x, width, height;
+	void	      *priv;
+	unsigned int  (*refresh)(struct ui_browser *self);
+	void	      (*write)(struct ui_browser *self, void *entry, int row);
+	void	      (*seek)(struct ui_browser *self, off_t offset, int whence);
+	u32	      nr_entries;
+};
+
+
+int ui_browser__percent_color(double percent, bool current);
+bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row);
+void ui_browser__refresh_dimensions(struct ui_browser *self);
+void ui_browser__reset_index(struct ui_browser *self);
+
+int ui_browser__show(struct ui_browser *self, const char *title,
+		     const char *helpline, ...);
+void ui_browser__hide(struct ui_browser *self);
+int ui_browser__refresh(struct ui_browser *self);
+int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es);
+
+void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
+unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
+
+void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence);
+unsigned int ui_browser__list_head_refresh(struct ui_browser *self);
+
+void ui_browser__init(void);
+#endif /* _PERF_UI_BROWSER_H_ */
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
new file mode 100644
index 0000000..55ff792
--- /dev/null
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -0,0 +1,240 @@
+#include "../browser.h"
+#include "../helpline.h"
+#include "../libslang.h"
+#include "../../hist.h"
+#include "../../sort.h"
+#include "../../symbol.h"
+
+static void ui__error_window(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
+	va_end(ap);
+}
+
+struct annotate_browser {
+	struct ui_browser b;
+	struct rb_root	  entries;
+	struct rb_node	  *curr_hot;
+};
+
+struct objdump_line_rb_node {
+	struct rb_node	rb_node;
+	double		percent;
+	u32		idx;
+};
+
+static inline
+struct objdump_line_rb_node *objdump_line__rb(struct objdump_line *self)
+{
+	return (struct objdump_line_rb_node *)(self + 1);
+}
+
+static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
+{
+	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
+	bool current_entry = ui_browser__is_current_entry(self, row);
+	int width = self->width;
+
+	if (ol->offset != -1) {
+		struct objdump_line_rb_node *olrb = objdump_line__rb(ol);
+		int color = ui_browser__percent_color(olrb->percent, current_entry);
+		SLsmg_set_color(color);
+		slsmg_printf(" %7.2f ", olrb->percent);
+		if (!current_entry)
+			SLsmg_set_color(HE_COLORSET_CODE);
+	} else {
+		int color = ui_browser__percent_color(0, current_entry);
+		SLsmg_set_color(color);
+		slsmg_write_nstring(" ", 9);
+	}
+
+	SLsmg_write_char(':');
+	slsmg_write_nstring(" ", 8);
+	if (!*ol->line)
+		slsmg_write_nstring(" ", width - 18);
+	else
+		slsmg_write_nstring(ol->line, width - 18);
+}
+
+static double objdump_line__calc_percent(struct objdump_line *self,
+					 struct list_head *head,
+					 struct symbol *sym)
+{
+	double percent = 0.0;
+
+	if (self->offset != -1) {
+		int len = sym->end - sym->start;
+		unsigned int hits = 0;
+		struct sym_priv *priv = symbol__priv(sym);
+		struct sym_ext *sym_ext = priv->ext;
+		struct sym_hist *h = priv->hist;
+		s64 offset = self->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(head, self);
+
+
+		while (offset < (s64)len &&
+		       (next == NULL || offset < next->offset)) {
+			if (sym_ext) {
+				percent += sym_ext[offset].percent;
+			} else
+				hits += h->ip[offset];
+
+			++offset;
+		}
+
+		if (sym_ext == NULL && h->sum)
+			percent = 100.0 * hits / h->sum;
+	}
+
+	return percent;
+}
+
+static void objdump__insert_line(struct rb_root *self,
+				 struct objdump_line_rb_node *line)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct objdump_line_rb_node *l;
+
+	while (*p != NULL) {
+		parent = *p;
+		l = rb_entry(parent, struct objdump_line_rb_node, rb_node);
+		if (line->percent < l->percent)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&line->rb_node, parent, p);
+	rb_insert_color(&line->rb_node, self);
+}
+
+static void annotate_browser__set_top(struct annotate_browser *self,
+				      struct rb_node *nd)
+{
+	struct objdump_line_rb_node *rbpos;
+	struct objdump_line *pos;
+	unsigned back;
+
+	ui_browser__refresh_dimensions(&self->b);
+	back = self->b.height / 2;
+	rbpos = rb_entry(nd, struct objdump_line_rb_node, rb_node);
+	pos = ((struct objdump_line *)rbpos) - 1;
+	self->b.top_idx = self->b.index = rbpos->idx;
+
+	while (self->b.top_idx != 0 && back != 0) {
+		pos = list_entry(pos->node.prev, struct objdump_line, node);
+
+		--self->b.top_idx;
+		--back;
+	}
+
+	self->b.top = pos;
+	self->curr_hot = nd;
+}
+
+static int annotate_browser__run(struct annotate_browser *self,
+				 struct newtExitStruct *es)
+{
+	struct rb_node *nd;
+	struct hist_entry *he = self->b.priv;
+
+	if (ui_browser__show(&self->b, he->ms.sym->name,
+			     "<- or ESC: exit, TAB/shift+TAB: cycle thru samples") < 0)
+		return -1;
+
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+
+	nd = self->curr_hot;
+	if (nd) {
+		newtFormAddHotKey(self->b.form, NEWT_KEY_TAB);
+		newtFormAddHotKey(self->b.form, NEWT_KEY_UNTAB);
+	}
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+
+		switch (es->u.key) {
+		case NEWT_KEY_TAB:
+			nd = rb_prev(nd);
+			if (nd == NULL)
+				nd = rb_last(&self->entries);
+			annotate_browser__set_top(self, nd);
+			break;
+		case NEWT_KEY_UNTAB:
+			nd = rb_next(nd);
+			if (nd == NULL)
+				nd = rb_first(&self->entries);
+			annotate_browser__set_top(self, nd);
+			break;
+		default:
+			goto out;
+		}
+	}
+out:
+	ui_browser__hide(&self->b);
+	return 0;
+}
+
+int hist_entry__tui_annotate(struct hist_entry *self)
+{
+	struct newtExitStruct es;
+	struct objdump_line *pos, *n;
+	struct objdump_line_rb_node *rbpos;
+	LIST_HEAD(head);
+	struct annotate_browser browser = {
+		.b = {
+			.entries = &head,
+			.refresh = ui_browser__list_head_refresh,
+			.seek	 = ui_browser__list_head_seek,
+			.write	 = annotate_browser__write,
+			.priv	 = self,
+		},
+	};
+	int ret;
+
+	if (self->ms.sym == NULL)
+		return -1;
+
+	if (self->ms.map->dso->annotate_warned)
+		return -1;
+
+	if (hist_entry__annotate(self, &head, sizeof(*rbpos)) < 0) {
+		ui__error_window(ui_helpline__last_msg);
+		return -1;
+	}
+
+	ui_helpline__push("Press <- or ESC to exit");
+
+	list_for_each_entry(pos, &head, node) {
+		size_t line_len = strlen(pos->line);
+		if (browser.b.width < line_len)
+			browser.b.width = line_len;
+		rbpos = objdump_line__rb(pos);
+		rbpos->idx = browser.b.nr_entries++;
+		rbpos->percent = objdump_line__calc_percent(pos, &head, self->ms.sym);
+		if (rbpos->percent < 0.01)
+			continue;
+		objdump__insert_line(&browser.entries, rbpos);
+	}
+
+	/*
+	 * Position the browser at the hottest line.
+	 */
+	browser.curr_hot = rb_last(&browser.entries);
+	if (browser.curr_hot)
+		annotate_browser__set_top(&browser, browser.curr_hot);
+
+	browser.b.width += 18; /* Percentage */
+	ret = annotate_browser__run(&browser, &es);
+	list_for_each_entry_safe(pos, n, &head, node) {
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
+	return ret;
+}
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
new file mode 100644
index 0000000..dafdf67
--- /dev/null
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -0,0 +1,948 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#undef _GNU_SOURCE
+#include "../libslang.h"
+#include <stdlib.h>
+#include <string.h>
+#include <newt.h>
+#include <linux/rbtree.h>
+
+#include "../../hist.h"
+#include "../../pstack.h"
+#include "../../sort.h"
+#include "../../util.h"
+
+#include "../browser.h"
+#include "../helpline.h"
+#include "../util.h"
+#include "map.h"
+
+struct hist_browser {
+	struct ui_browser   b;
+	struct hists	    *hists;
+	struct hist_entry   *he_selection;
+	struct map_symbol   *selection;
+};
+
+static void hist_browser__refresh_dimensions(struct hist_browser *self)
+{
+	/* 3 == +/- toggle symbol before actual hist_entry rendering */
+	self->b.width = 3 + (hists__sort_list_width(self->hists) +
+			     sizeof("[k]"));
+}
+
+static void hist_browser__reset(struct hist_browser *self)
+{
+	self->b.nr_entries = self->hists->nr_entries;
+	hist_browser__refresh_dimensions(self);
+	ui_browser__reset_index(&self->b);
+}
+
+static char tree__folded_sign(bool unfolded)
+{
+	return unfolded ? '-' : '+';
+}
+
+static char map_symbol__folded(const struct map_symbol *self)
+{
+	return self->has_children ? tree__folded_sign(self->unfolded) : ' ';
+}
+
+static char hist_entry__folded(const struct hist_entry *self)
+{
+	return map_symbol__folded(&self->ms);
+}
+
+static char callchain_list__folded(const struct callchain_list *self)
+{
+	return map_symbol__folded(&self->ms);
+}
+
+static int callchain_node__count_rows_rb_tree(struct callchain_node *self)
+{
+	int n = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
+		struct callchain_list *chain;
+		char folded_sign = ' '; /* No children */
+
+		list_for_each_entry(chain, &child->val, list) {
+			++n;
+			/* We need this because we may not have children */
+			folded_sign = callchain_list__folded(chain);
+			if (folded_sign == '+')
+				break;
+		}
+
+		if (folded_sign == '-') /* Have children and they're unfolded */
+			n += callchain_node__count_rows_rb_tree(child);
+	}
+
+	return n;
+}
+
+static int callchain_node__count_rows(struct callchain_node *node)
+{
+	struct callchain_list *chain;
+	bool unfolded = false;
+	int n = 0;
+
+	list_for_each_entry(chain, &node->val, list) {
+		++n;
+		unfolded = chain->ms.unfolded;
+	}
+
+	if (unfolded)
+		n += callchain_node__count_rows_rb_tree(node);
+
+	return n;
+}
+
+static int callchain__count_rows(struct rb_root *chain)
+{
+	struct rb_node *nd;
+	int n = 0;
+
+	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+		n += callchain_node__count_rows(node);
+	}
+
+	return n;
+}
+
+static bool map_symbol__toggle_fold(struct map_symbol *self)
+{
+	if (!self->has_children)
+		return false;
+
+	self->unfolded = !self->unfolded;
+	return true;
+}
+
+static void callchain_node__init_have_children_rb_tree(struct callchain_node *self)
+{
+	struct rb_node *nd = rb_first(&self->rb_root);
+
+	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
+		struct callchain_list *chain;
+		int first = true;
+
+		list_for_each_entry(chain, &child->val, list) {
+			if (first) {
+				first = false;
+				chain->ms.has_children = chain->list.next != &child->val ||
+							 rb_first(&child->rb_root) != NULL;
+			} else
+				chain->ms.has_children = chain->list.next == &child->val &&
+							 rb_first(&child->rb_root) != NULL;
+		}
+
+		callchain_node__init_have_children_rb_tree(child);
+	}
+}
+
+static void callchain_node__init_have_children(struct callchain_node *self)
+{
+	struct callchain_list *chain;
+
+	list_for_each_entry(chain, &self->val, list)
+		chain->ms.has_children = rb_first(&self->rb_root) != NULL;
+
+	callchain_node__init_have_children_rb_tree(self);
+}
+
+static void callchain__init_have_children(struct rb_root *self)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+		callchain_node__init_have_children(node);
+	}
+}
+
+static void hist_entry__init_have_children(struct hist_entry *self)
+{
+	if (!self->init_have_children) {
+		callchain__init_have_children(&self->sorted_chain);
+		self->init_have_children = true;
+	}
+}
+
+static bool hist_browser__toggle_fold(struct hist_browser *self)
+{
+	if (map_symbol__toggle_fold(self->selection)) {
+		struct hist_entry *he = self->he_selection;
+
+		hist_entry__init_have_children(he);
+		self->hists->nr_entries -= he->nr_rows;
+
+		if (he->ms.unfolded)
+			he->nr_rows = callchain__count_rows(&he->sorted_chain);
+		else
+			he->nr_rows = 0;
+		self->hists->nr_entries += he->nr_rows;
+		self->b.nr_entries = self->hists->nr_entries;
+
+		return true;
+	}
+
+	/* If it doesn't have children, no toggling performed */
+	return false;
+}
+
+static int hist_browser__run(struct hist_browser *self, const char *title,
+			     struct newtExitStruct *es)
+{
+	char str[256], unit;
+	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+	self->b.entries = &self->hists->entries;
+	self->b.nr_entries = self->hists->nr_entries;
+
+	hist_browser__refresh_dimensions(self);
+
+	nr_events = convert_unit(nr_events, &unit);
+	snprintf(str, sizeof(str), "Events: %lu%c                            ",
+		 nr_events, unit);
+	newtDrawRootText(0, 0, str);
+
+	if (ui_browser__show(&self->b, title,
+			     "Press '?' for help on key bindings") < 0)
+		return -1;
+
+	newtFormAddHotKey(self->b.form, 'a');
+	newtFormAddHotKey(self->b.form, '?');
+	newtFormAddHotKey(self->b.form, 'h');
+	newtFormAddHotKey(self->b.form, 'd');
+	newtFormAddHotKey(self->b.form, 'D');
+	newtFormAddHotKey(self->b.form, 't');
+
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		switch (es->u.key) {
+		case 'D': { /* Debug */
+			static int seq;
+			struct hist_entry *h = rb_entry(self->b.top,
+							struct hist_entry, rb_node);
+			ui_helpline__pop();
+			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
+					   seq++, self->b.nr_entries,
+					   self->hists->nr_entries,
+					   self->b.height,
+					   self->b.index,
+					   self->b.top_idx,
+					   h->row_offset, h->nr_rows);
+		}
+			continue;
+		case NEWT_KEY_ENTER:
+			if (hist_browser__toggle_fold(self))
+				break;
+			/* fall thru */
+		default:
+			return 0;
+		}
+	}
+
+	ui_browser__hide(&self->b);
+	return 0;
+}
+
+static char *callchain_list__sym_name(struct callchain_list *self,
+				      char *bf, size_t bfsize)
+{
+	if (self->ms.sym)
+		return self->ms.sym->name;
+
+	snprintf(bf, bfsize, "%#Lx", self->ip);
+	return bf;
+}
+
+#define LEVEL_OFFSET_STEP 3
+
+static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
+						     struct callchain_node *chain_node,
+						     u64 total, int level,
+						     unsigned short row,
+						     off_t *row_offset,
+						     bool *is_current_entry)
+{
+	struct rb_node *node;
+	int first_row = row, width, offset = level * LEVEL_OFFSET_STEP;
+	u64 new_total, remaining;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = chain_node->children_hit;
+	else
+		new_total = total;
+
+	remaining = new_total;
+	node = rb_first(&chain_node->rb_root);
+	while (node) {
+		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
+		struct rb_node *next = rb_next(node);
+		u64 cumul = cumul_hits(child);
+		struct callchain_list *chain;
+		char folded_sign = ' ';
+		int first = true;
+		int extra_offset = 0;
+
+		remaining -= cumul;
+
+		list_for_each_entry(chain, &child->val, list) {
+			char ipstr[BITS_PER_LONG / 4 + 1], *alloc_str;
+			const char *str;
+			int color;
+			bool was_first = first;
+
+			if (first) {
+				first = false;
+				chain->ms.has_children = chain->list.next != &child->val ||
+							 rb_first(&child->rb_root) != NULL;
+			} else {
+				extra_offset = LEVEL_OFFSET_STEP;
+				chain->ms.has_children = chain->list.next == &child->val &&
+							 rb_first(&child->rb_root) != NULL;
+			}
+
+			folded_sign = callchain_list__folded(chain);
+			if (*row_offset != 0) {
+				--*row_offset;
+				goto do_next;
+			}
+
+			alloc_str = NULL;
+			str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+			if (was_first) {
+				double percent = cumul * 100.0 / new_total;
+
+				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
+					str = "Not enough memory!";
+				else
+					str = alloc_str;
+			}
+
+			color = HE_COLORSET_NORMAL;
+			width = self->b.width - (offset + extra_offset + 2);
+			if (ui_browser__is_current_entry(&self->b, row)) {
+				self->selection = &chain->ms;
+				color = HE_COLORSET_SELECTED;
+				*is_current_entry = true;
+			}
+
+			SLsmg_set_color(color);
+			SLsmg_gotorc(self->b.y + row, self->b.x);
+			slsmg_write_nstring(" ", offset + extra_offset);
+			slsmg_printf("%c ", folded_sign);
+			slsmg_write_nstring(str, width);
+			free(alloc_str);
+
+			if (++row == self->b.height)
+				goto out;
+do_next:
+			if (folded_sign == '+')
+				break;
+		}
+
+		if (folded_sign == '-') {
+			const int new_level = level + (extra_offset ? 2 : 1);
+			row += hist_browser__show_callchain_node_rb_tree(self, child, new_total,
+									 new_level, row, row_offset,
+									 is_current_entry);
+		}
+		if (row == self->b.height)
+			goto out;
+		node = next;
+	}
+out:
+	return row - first_row;
+}
+
+static int hist_browser__show_callchain_node(struct hist_browser *self,
+					     struct callchain_node *node,
+					     int level, unsigned short row,
+					     off_t *row_offset,
+					     bool *is_current_entry)
+{
+	struct callchain_list *chain;
+	int first_row = row,
+	     offset = level * LEVEL_OFFSET_STEP,
+	     width = self->b.width - offset;
+	char folded_sign = ' ';
+
+	list_for_each_entry(chain, &node->val, list) {
+		char ipstr[BITS_PER_LONG / 4 + 1], *s;
+		int color;
+		/*
+		 * FIXME: This should be moved to somewhere else,
+		 * probably when the callchain is created, so as not to
+		 * traverse it all over again
+		 */
+		chain->ms.has_children = rb_first(&node->rb_root) != NULL;
+		folded_sign = callchain_list__folded(chain);
+
+		if (*row_offset != 0) {
+			--*row_offset;
+			continue;
+		}
+
+		color = HE_COLORSET_NORMAL;
+		if (ui_browser__is_current_entry(&self->b, row)) {
+			self->selection = &chain->ms;
+			color = HE_COLORSET_SELECTED;
+			*is_current_entry = true;
+		}
+
+		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+		SLsmg_gotorc(self->b.y + row, self->b.x);
+		SLsmg_set_color(color);
+		slsmg_write_nstring(" ", offset);
+		slsmg_printf("%c ", folded_sign);
+		slsmg_write_nstring(s, width - 2);
+
+		if (++row == self->b.height)
+			goto out;
+	}
+
+	if (folded_sign == '-')
+		row += hist_browser__show_callchain_node_rb_tree(self, node,
+								 self->hists->stats.total_period,
+								 level + 1, row,
+								 row_offset,
+								 is_current_entry);
+out:
+	return row - first_row;
+}
+
+static int hist_browser__show_callchain(struct hist_browser *self,
+					struct rb_root *chain,
+					int level, unsigned short row,
+					off_t *row_offset,
+					bool *is_current_entry)
+{
+	struct rb_node *nd;
+	int first_row = row;
+
+	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+
+		row += hist_browser__show_callchain_node(self, node, level,
+							 row, row_offset,
+							 is_current_entry);
+		if (row == self->b.height)
+			break;
+	}
+
+	return row - first_row;
+}
+
+static int hist_browser__show_entry(struct hist_browser *self,
+				    struct hist_entry *entry,
+				    unsigned short row)
+{
+	char s[256];
+	double percent;
+	int printed = 0;
+	int color, width = self->b.width;
+	char folded_sign = ' ';
+	bool current_entry = ui_browser__is_current_entry(&self->b, row);
+	off_t row_offset = entry->row_offset;
+
+	if (current_entry) {
+		self->he_selection = entry;
+		self->selection = &entry->ms;
+	}
+
+	if (symbol_conf.use_callchain) {
+		entry->ms.has_children = !RB_EMPTY_ROOT(&entry->sorted_chain);
+		folded_sign = hist_entry__folded(entry);
+	}
+
+	if (row_offset == 0) {
+		hist_entry__snprintf(entry, s, sizeof(s), self->hists, NULL, false,
+				     0, false, self->hists->stats.total_period);
+		percent = (entry->period * 100.0) / self->hists->stats.total_period;
+
+		color = HE_COLORSET_SELECTED;
+		if (!current_entry) {
+			if (percent >= MIN_RED)
+				color = HE_COLORSET_TOP;
+			else if (percent >= MIN_GREEN)
+				color = HE_COLORSET_MEDIUM;
+			else
+				color = HE_COLORSET_NORMAL;
+		}
+
+		SLsmg_set_color(color);
+		SLsmg_gotorc(self->b.y + row, self->b.x);
+		if (symbol_conf.use_callchain) {
+			slsmg_printf("%c ", folded_sign);
+			width -= 2;
+		}
+		slsmg_write_nstring(s, width);
+		++row;
+		++printed;
+	} else
+		--row_offset;
+
+	if (folded_sign == '-' && row != self->b.height) {
+		printed += hist_browser__show_callchain(self, &entry->sorted_chain,
+							1, row, &row_offset,
+							&current_entry);
+		if (current_entry)
+			self->he_selection = entry;
+	}
+
+	return printed;
+}
+
+static unsigned int hist_browser__refresh(struct ui_browser *self)
+{
+	unsigned row = 0;
+	struct rb_node *nd;
+	struct hist_browser *hb = container_of(self, struct hist_browser, b);
+
+	if (self->top == NULL)
+		self->top = rb_first(&hb->hists->entries);
+
+	for (nd = self->top; nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (h->filtered)
+			continue;
+
+		row += hist_browser__show_entry(hb, h, row);
+		if (row == self->height)
+			break;
+	}
+
+	return row;
+}
+
+static struct rb_node *hists__filter_entries(struct rb_node *nd)
+{
+	while (nd != NULL) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		if (!h->filtered)
+			return nd;
+
+		nd = rb_next(nd);
+	}
+
+	return NULL;
+}
+
+static struct rb_node *hists__filter_prev_entries(struct rb_node *nd)
+{
+	while (nd != NULL) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		if (!h->filtered)
+			return nd;
+
+		nd = rb_prev(nd);
+	}
+
+	return NULL;
+}
+
+static void ui_browser__hists_seek(struct ui_browser *self,
+				   off_t offset, int whence)
+{
+	struct hist_entry *h;
+	struct rb_node *nd;
+	bool first = true;
+
+	switch (whence) {
+	case SEEK_SET:
+		nd = hists__filter_entries(rb_first(self->entries));
+		break;
+	case SEEK_CUR:
+		nd = self->top;
+		goto do_offset;
+	case SEEK_END:
+		nd = hists__filter_prev_entries(rb_last(self->entries));
+		first = false;
+		break;
+	default:
+		return;
+	}
+
+	/*
+	 * Moves not relative to the first visible entry invalidates its
+	 * row_offset:
+	 */
+	h = rb_entry(self->top, struct hist_entry, rb_node);
+	h->row_offset = 0;
+
+	/*
+	 * Here we have to check if nd is expanded (+), if it is we can't go
+	 * the next top level hist_entry, instead we must compute an offset of
+	 * what _not_ to show and not change the first visible entry.
+	 *
+	 * This offset increments when we are going from top to bottom and
+	 * decreases when we're going from bottom to top.
+	 *
+	 * As we don't have backpointers to the top level in the callchains
+	 * structure, we need to always print the whole hist_entry callchain,
+	 * skipping the first ones that are before the first visible entry
+	 * and stop when we printed enough lines to fill the screen.
+	 */
+do_offset:
+	if (offset > 0) {
+		do {
+			h = rb_entry(nd, struct hist_entry, rb_node);
+			if (h->ms.unfolded) {
+				u16 remaining = h->nr_rows - h->row_offset;
+				if (offset > remaining) {
+					offset -= remaining;
+					h->row_offset = 0;
+				} else {
+					h->row_offset += offset;
+					offset = 0;
+					self->top = nd;
+					break;
+				}
+			}
+			nd = hists__filter_entries(rb_next(nd));
+			if (nd == NULL)
+				break;
+			--offset;
+			self->top = nd;
+		} while (offset != 0);
+	} else if (offset < 0) {
+		while (1) {
+			h = rb_entry(nd, struct hist_entry, rb_node);
+			if (h->ms.unfolded) {
+				if (first) {
+					if (-offset > h->row_offset) {
+						offset += h->row_offset;
+						h->row_offset = 0;
+					} else {
+						h->row_offset += offset;
+						offset = 0;
+						self->top = nd;
+						break;
+					}
+				} else {
+					if (-offset > h->nr_rows) {
+						offset += h->nr_rows;
+						h->row_offset = 0;
+					} else {
+						h->row_offset = h->nr_rows + offset;
+						offset = 0;
+						self->top = nd;
+						break;
+					}
+				}
+			}
+
+			nd = hists__filter_prev_entries(rb_prev(nd));
+			if (nd == NULL)
+				break;
+			++offset;
+			self->top = nd;
+			if (offset == 0) {
+				/*
+				 * Last unfiltered hist_entry, check if it is
+				 * unfolded, if it is then we should have
+				 * row_offset at its last entry.
+				 */
+				h = rb_entry(nd, struct hist_entry, rb_node);
+				if (h->ms.unfolded)
+					h->row_offset = h->nr_rows;
+				break;
+			}
+			first = false;
+		}
+	} else {
+		self->top = nd;
+		h = rb_entry(nd, struct hist_entry, rb_node);
+		h->row_offset = 0;
+	}
+}
+
+static struct hist_browser *hist_browser__new(struct hists *hists)
+{
+	struct hist_browser *self = zalloc(sizeof(*self));
+
+	if (self) {
+		self->hists = hists;
+		self->b.refresh = hist_browser__refresh;
+		self->b.seek = ui_browser__hists_seek;
+	}
+
+	return self;
+}
+
+static void hist_browser__delete(struct hist_browser *self)
+{
+	newtFormDestroy(self->b.form);
+	newtPopWindow();
+	free(self);
+}
+
+static struct hist_entry *hist_browser__selected_entry(struct hist_browser *self)
+{
+	return self->he_selection;
+}
+
+static struct thread *hist_browser__selected_thread(struct hist_browser *self)
+{
+	return self->he_selection->thread;
+}
+
+static int hist_browser__title(char *bf, size_t size, const char *ev_name,
+			       const struct dso *dso, const struct thread *thread)
+{
+	int printed = 0;
+
+	if (thread)
+		printed += snprintf(bf + printed, size - printed,
+				    "Thread: %s(%d)",
+				    (thread->comm_set ?  thread->comm : ""),
+				    thread->pid);
+	if (dso)
+		printed += snprintf(bf + printed, size - printed,
+				    "%sDSO: %s", thread ? " " : "",
+				    dso->short_name);
+	return printed ?: snprintf(bf, size, "Event: %s", ev_name);
+}
+
+int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
+{
+	struct hist_browser *browser = hist_browser__new(self);
+	struct pstack *fstack;
+	const struct thread *thread_filter = NULL;
+	const struct dso *dso_filter = NULL;
+	struct newtExitStruct es;
+	char msg[160];
+	int key = -1;
+
+	if (browser == NULL)
+		return -1;
+
+	fstack = pstack__new(2);
+	if (fstack == NULL)
+		goto out;
+
+	ui_helpline__push(helpline);
+
+	hist_browser__title(msg, sizeof(msg), ev_name,
+			    dso_filter, thread_filter);
+
+	while (1) {
+		const struct thread *thread;
+		const struct dso *dso;
+		char *options[16];
+		int nr_options = 0, choice = 0, i,
+		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
+		    browse_map = -2;
+
+		if (hist_browser__run(browser, msg, &es))
+			break;
+
+		thread = hist_browser__selected_thread(browser);
+		dso = browser->selection->map ? browser->selection->map->dso : NULL;
+
+		if (es.reason == NEWT_EXIT_HOTKEY) {
+			key = es.u.key;
+
+			switch (key) {
+			case NEWT_KEY_F1:
+				goto do_help;
+			case NEWT_KEY_TAB:
+			case NEWT_KEY_UNTAB:
+				/*
+				 * Exit the browser, let hists__browser_tree
+				 * go to the next or previous
+				 */
+				goto out_free_stack;
+			default:;
+			}
+
+			switch (key) {
+			case 'a':
+				if (browser->selection->map == NULL &&
+				    browser->selection->map->dso->annotate_warned)
+					continue;
+				goto do_annotate;
+			case 'd':
+				goto zoom_dso;
+			case 't':
+				goto zoom_thread;
+			case 'h':
+			case '?':
+do_help:
+				ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
+						"<-        Zoom out\n"
+						"a         Annotate current symbol\n"
+						"h/?/F1    Show this window\n"
+						"d         Zoom into current DSO\n"
+						"t         Zoom into current Thread\n"
+						"q/CTRL+C  Exit browser");
+				continue;
+			default:;
+			}
+			if (is_exit_key(key)) {
+				if (key == NEWT_KEY_ESCAPE &&
+				    !ui__dialog_yesno("Do you really want to exit?"))
+					continue;
+				break;
+			}
+
+			if (es.u.key == NEWT_KEY_LEFT) {
+				const void *top;
+
+				if (pstack__empty(fstack))
+					continue;
+				top = pstack__pop(fstack);
+				if (top == &dso_filter)
+					goto zoom_out_dso;
+				if (top == &thread_filter)
+					goto zoom_out_thread;
+				continue;
+			}
+		}
+
+		if (browser->selection->sym != NULL &&
+		    !browser->selection->map->dso->annotate_warned &&
+		    asprintf(&options[nr_options], "Annotate %s",
+			     browser->selection->sym->name) > 0)
+			annotate = nr_options++;
+
+		if (thread != NULL &&
+		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
+			     (thread_filter ? "out of" : "into"),
+			     (thread->comm_set ? thread->comm : ""),
+			     thread->pid) > 0)
+			zoom_thread = nr_options++;
+
+		if (dso != NULL &&
+		    asprintf(&options[nr_options], "Zoom %s %s DSO",
+			     (dso_filter ? "out of" : "into"),
+			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
+			zoom_dso = nr_options++;
+
+		if (browser->selection->map != NULL &&
+		    asprintf(&options[nr_options], "Browse map details") > 0)
+			browse_map = nr_options++;
+
+		options[nr_options++] = (char *)"Exit";
+
+		choice = ui__popup_menu(nr_options, options);
+
+		for (i = 0; i < nr_options - 1; ++i)
+			free(options[i]);
+
+		if (choice == nr_options - 1)
+			break;
+
+		if (choice == -1)
+			continue;
+
+		if (choice == annotate) {
+			struct hist_entry *he;
+do_annotate:
+			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
+				browser->selection->map->dso->annotate_warned = 1;
+				ui_helpline__puts("No vmlinux file found, can't "
+						 "annotate with just a "
+						 "kallsyms file");
+				continue;
+			}
+
+			he = hist_browser__selected_entry(browser);
+			if (he == NULL)
+				continue;
+
+			hist_entry__tui_annotate(he);
+		} else if (choice == browse_map)
+			map__browse(browser->selection->map);
+		else if (choice == zoom_dso) {
+zoom_dso:
+			if (dso_filter) {
+				pstack__remove(fstack, &dso_filter);
+zoom_out_dso:
+				ui_helpline__pop();
+				dso_filter = NULL;
+			} else {
+				if (dso == NULL)
+					continue;
+				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
+						   dso->kernel ? "the Kernel" : dso->short_name);
+				dso_filter = dso;
+				pstack__push(fstack, &dso_filter);
+			}
+			hists__filter_by_dso(self, dso_filter);
+			hist_browser__title(msg, sizeof(msg), ev_name,
+					    dso_filter, thread_filter);
+			hist_browser__reset(browser);
+		} else if (choice == zoom_thread) {
+zoom_thread:
+			if (thread_filter) {
+				pstack__remove(fstack, &thread_filter);
+zoom_out_thread:
+				ui_helpline__pop();
+				thread_filter = NULL;
+			} else {
+				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
+						   thread->comm_set ? thread->comm : "",
+						   thread->pid);
+				thread_filter = thread;
+				pstack__push(fstack, &thread_filter);
+			}
+			hists__filter_by_thread(self, thread_filter);
+			hist_browser__title(msg, sizeof(msg), ev_name,
+					    dso_filter, thread_filter);
+			hist_browser__reset(browser);
+		}
+	}
+out_free_stack:
+	pstack__delete(fstack);
+out:
+	hist_browser__delete(browser);
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
+}
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
new file mode 100644
index 0000000..142b825
--- /dev/null
+++ b/tools/perf/util/ui/browsers/map.c
@@ -0,0 +1,161 @@
+#include "../libslang.h"
+#include <elf.h>
+#include <newt.h>
+#include <sys/ttydefaults.h>
+#include <ctype.h>
+#include <string.h>
+#include <linux/bitops.h>
+#include "../../debug.h"
+#include "../../symbol.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "map.h"
+
+static int ui_entry__read(const char *title, char *bf, size_t size, int width)
+{
+	struct newtExitStruct es;
+	newtComponent form, entry;
+	const char *result;
+	int err = -1;
+
+	newtCenteredWindow(width, 1, title);
+	form = newtForm(NULL, NULL, 0);
+	if (form == NULL)
+		return -1;
+
+	entry = newtEntry(0, 0, "0x", width, &result, NEWT_FLAG_SCROLL);
+	if (entry == NULL)
+		goto out_free_form;
+
+	newtFormAddComponent(form, entry);
+	newtFormAddHotKey(form, NEWT_KEY_ENTER);
+	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(form, CTRL('c'));
+	newtFormRun(form, &es);
+
+	if (result != NULL) {
+		strncpy(bf, result, size);
+		err = 0;
+	}
+out_free_form:
+	newtPopWindow();
+	newtFormDestroy(form);
+	return 0;
+}
+
+struct map_browser {
+	struct ui_browser b;
+	struct map	  *map;
+	u16		  namelen;
+	u8		  addrlen;
+};
+
+static void map_browser__write(struct ui_browser *self, void *nd, int row)
+{
+	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+	struct map_browser *mb = container_of(self, struct map_browser, b);
+	bool current_entry = ui_browser__is_current_entry(self, row);
+	int color = ui_browser__percent_color(0, current_entry);
+
+	SLsmg_set_color(color);
+	slsmg_printf("%*llx %*llx %c ",
+		     mb->addrlen, sym->start, mb->addrlen, sym->end,
+		     sym->binding == STB_GLOBAL ? 'g' :
+		     sym->binding == STB_LOCAL  ? 'l' : 'w');
+	slsmg_write_nstring(sym->name, mb->namelen);
+}
+
+/* FIXME uber-kludgy, see comment on cmd_report... */
+static u32 *symbol__browser_index(struct symbol *self)
+{
+	return ((void *)self) - sizeof(struct rb_node) - sizeof(u32);
+}
+
+static int map_browser__search(struct map_browser *self)
+{
+	char target[512];
+	struct symbol *sym;
+	int err = ui_entry__read("Search by name/addr", target, sizeof(target), 40);
+
+	if (err)
+		return err;
+
+	if (target[0] == '0' && tolower(target[1]) == 'x') {
+		u64 addr = strtoull(target, NULL, 16);
+		sym = map__find_symbol(self->map, addr, NULL);
+	} else
+		sym = map__find_symbol_by_name(self->map, target, NULL);
+
+	if (sym != NULL) {
+		u32 *idx = symbol__browser_index(sym);
+
+		self->b.top = &sym->rb_node;
+		self->b.index = self->b.top_idx = *idx;
+	} else
+		ui_helpline__fpush("%s not found!", target);
+
+	return 0;
+}
+
+static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
+{
+	if (ui_browser__show(&self->b, self->map->dso->long_name,
+			     "Press <- or ESC to exit, %s / to search",
+			     verbose ? "" : "restart with -v to use") < 0)
+		return -1;
+
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+	if (verbose)
+		newtFormAddHotKey(self->b.form, '/');
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		if (verbose && es->u.key == '/')
+			map_browser__search(self);
+		else
+			break;
+	}
+
+	ui_browser__hide(&self->b);
+	return 0;
+}
+
+int map__browse(struct map *self)
+{
+	struct map_browser mb = {
+		.b = {
+			.entries = &self->dso->symbols[self->type],
+			.refresh = ui_browser__rb_tree_refresh,
+			.seek	 = ui_browser__rb_tree_seek,
+			.write	 = map_browser__write,
+		},
+		.map = self,
+	};
+	struct newtExitStruct es;
+	struct rb_node *nd;
+	char tmp[BITS_PER_LONG / 4];
+	u64 maxaddr = 0;
+
+	for (nd = rb_first(mb.b.entries); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+
+		if (mb.namelen < pos->namelen)
+			mb.namelen = pos->namelen;
+		if (maxaddr < pos->end)
+			maxaddr = pos->end;
+		if (verbose) {
+			u32 *idx = symbol__browser_index(pos);
+			*idx = mb.b.nr_entries;
+		}
+		++mb.b.nr_entries;
+	}
+
+	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
+	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
+	return map_browser__run(&mb, &es);
+}
diff --git a/tools/perf/util/ui/browsers/map.h b/tools/perf/util/ui/browsers/map.h
new file mode 100644
index 0000000..df8581a
--- /dev/null
+++ b/tools/perf/util/ui/browsers/map.h
@@ -0,0 +1,6 @@
+#ifndef _PERF_UI_MAP_BROWSER_H_
+#define _PERF_UI_MAP_BROWSER_H_ 1
+struct map;
+
+int map__browse(struct map *self);
+#endif /* _PERF_UI_MAP_BROWSER_H_ */
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
new file mode 100644
index 0000000..8d79daa
--- /dev/null
+++ b/tools/perf/util/ui/helpline.c
@@ -0,0 +1,69 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <newt.h>
+
+#include "../debug.h"
+#include "helpline.h"
+
+void ui_helpline__pop(void)
+{
+	newtPopHelpLine();
+}
+
+void ui_helpline__push(const char *msg)
+{
+	newtPushHelpLine(msg);
+}
+
+void ui_helpline__vpush(const char *fmt, va_list ap)
+{
+	char *s;
+
+	if (vasprintf(&s, fmt, ap) < 0)
+		vfprintf(stderr, fmt, ap);
+	else {
+		ui_helpline__push(s);
+		free(s);
+	}
+}
+
+void ui_helpline__fpush(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	ui_helpline__vpush(fmt, ap);
+	va_end(ap);
+}
+
+void ui_helpline__puts(const char *msg)
+{
+	ui_helpline__pop();
+	ui_helpline__push(msg);
+}
+
+void ui_helpline__init(void)
+{
+	ui_helpline__puts(" ");
+}
+
+char ui_helpline__last_msg[1024];
+
+int ui_helpline__show_help(const char *format, va_list ap)
+{
+	int ret;
+	static int backlog;
+
+        ret = vsnprintf(ui_helpline__last_msg + backlog,
+			sizeof(ui_helpline__last_msg) - backlog, format, ap);
+	backlog += ret;
+
+	if (ui_helpline__last_msg[backlog - 1] == '\n') {
+		ui_helpline__puts(ui_helpline__last_msg);
+		newtRefresh();
+		backlog = 0;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
new file mode 100644
index 0000000..ab6028d
--- /dev/null
+++ b/tools/perf/util/ui/helpline.h
@@ -0,0 +1,11 @@
+#ifndef _PERF_UI_HELPLINE_H_
+#define _PERF_UI_HELPLINE_H_ 1
+
+void ui_helpline__init(void);
+void ui_helpline__pop(void);
+void ui_helpline__push(const char *msg);
+void ui_helpline__vpush(const char *fmt, va_list ap);
+void ui_helpline__fpush(const char *fmt, ...);
+void ui_helpline__puts(const char *msg);
+
+#endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/util/ui/libslang.h b/tools/perf/util/ui/libslang.h
new file mode 100644
index 0000000..5623da8
--- /dev/null
+++ b/tools/perf/util/ui/libslang.h
@@ -0,0 +1,27 @@
+#ifndef _PERF_UI_SLANG_H_
+#define _PERF_UI_SLANG_H_ 1
+/*
+ * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
+ * the build if it isn't defined. Use the equivalent one that glibc
+ * has on features.h.
+ */
+#include <features.h>
+#ifndef HAVE_LONG_LONG
+#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
+#endif
+#include <slang.h>
+
+#if SLANG_VERSION < 20104
+#define slsmg_printf(msg, args...) \
+	SLsmg_printf((char *)msg, ##args)
+#define slsmg_write_nstring(msg, len) \
+	SLsmg_write_nstring((char *)msg, len)
+#define sltt_set_color(obj, name, fg, bg) \
+	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
+#else
+#define slsmg_printf SLsmg_printf
+#define slsmg_write_nstring SLsmg_write_nstring
+#define sltt_set_color SLtt_set_color
+#endif
+
+#endif /* _PERF_UI_SLANG_H_ */
diff --git a/tools/perf/util/ui/progress.c b/tools/perf/util/ui/progress.c
new file mode 100644
index 0000000..d7fc399
--- /dev/null
+++ b/tools/perf/util/ui/progress.c
@@ -0,0 +1,60 @@
+#include <stdlib.h>
+#include <newt.h>
+#include "../cache.h"
+#include "progress.h"
+
+struct ui_progress {
+	newtComponent form, scale;
+};
+
+struct ui_progress *ui_progress__new(const char *title, u64 total)
+{
+	struct ui_progress *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		int cols;
+
+		if (use_browser <= 0)
+			return self;
+		newtGetScreenSize(&cols, NULL);
+		cols -= 4;
+		newtCenteredWindow(cols, 1, title);
+		self->form  = newtForm(NULL, NULL, 0);
+		if (self->form == NULL)
+			goto out_free_self;
+		self->scale = newtScale(0, 0, cols, total);
+		if (self->scale == NULL)
+			goto out_free_form;
+		newtFormAddComponent(self->form, self->scale);
+		newtRefresh();
+	}
+
+	return self;
+
+out_free_form:
+	newtFormDestroy(self->form);
+out_free_self:
+	free(self);
+	return NULL;
+}
+
+void ui_progress__update(struct ui_progress *self, u64 curr)
+{
+	/*
+	 * FIXME: We should have a per UI backend way of showing progress,
+	 * stdio will just show a percentage as NN%, etc.
+	 */
+	if (use_browser <= 0)
+		return;
+	newtScaleSet(self->scale, curr);
+	newtRefresh();
+}
+
+void ui_progress__delete(struct ui_progress *self)
+{
+	if (use_browser > 0) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
+	free(self);
+}
diff --git a/tools/perf/util/ui/progress.h b/tools/perf/util/ui/progress.h
new file mode 100644
index 0000000..a3820a0
--- /dev/null
+++ b/tools/perf/util/ui/progress.h
@@ -0,0 +1,11 @@
+#ifndef _PERF_UI_PROGRESS_H_
+#define _PERF_UI_PROGRESS_H_ 1
+
+struct ui_progress;
+
+struct ui_progress *ui_progress__new(const char *title, u64 total);
+void ui_progress__delete(struct ui_progress *self);
+
+void ui_progress__update(struct ui_progress *self, u64 curr);
+
+#endif
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
new file mode 100644
index 0000000..6620850
--- /dev/null
+++ b/tools/perf/util/ui/setup.c
@@ -0,0 +1,42 @@
+#include <newt.h>
+#include <signal.h>
+#include <stdbool.h>
+
+#include "../cache.h"
+#include "../debug.h"
+#include "browser.h"
+#include "helpline.h"
+
+static void newt_suspend(void *d __used)
+{
+	newtSuspend();
+	raise(SIGTSTP);
+	newtResume();
+}
+
+void setup_browser(void)
+{
+	if (!isatty(1) || !use_browser || dump_trace) {
+		use_browser = 0;
+		setup_pager();
+		return;
+	}
+
+	use_browser = 1;
+	newtInit();
+	newtCls();
+	newtSetSuspendCallback(newt_suspend, NULL);
+	ui_helpline__init();
+	ui_browser__init();
+}
+
+void exit_browser(bool wait_for_ok)
+{
+	if (use_browser > 0) {
+		if (wait_for_ok) {
+			char title[] = "Fatal Error", ok[] = "Ok";
+			newtWinMessage(title, ok, ui_helpline__last_msg);
+		}
+		newtFinished();
+	}
+}
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
new file mode 100644
index 0000000..04600e2
--- /dev/null
+++ b/tools/perf/util/ui/util.c
@@ -0,0 +1,114 @@
+#include <newt.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <string.h>
+#include <sys/ttydefaults.h>
+
+#include "../cache.h"
+#include "../debug.h"
+#include "browser.h"
+#include "helpline.h"
+#include "util.h"
+
+newtComponent newt_form__new(void);
+
+static void newt_form__set_exit_keys(newtComponent self)
+{
+	newtFormAddHotKey(self, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(self, 'Q');
+	newtFormAddHotKey(self, 'q');
+	newtFormAddHotKey(self, CTRL('c'));
+}
+
+newtComponent newt_form__new(void)
+{
+	newtComponent self = newtForm(NULL, NULL, 0);
+	if (self)
+		newt_form__set_exit_keys(self);
+	return self;
+}
+
+int ui__popup_menu(int argc, char * const argv[])
+{
+	struct newtExitStruct es;
+	int i, rc = -1, max_len = 5;
+	newtComponent listbox, form = newt_form__new();
+
+	if (form == NULL)
+		return -1;
+
+	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
+	if (listbox == NULL)
+		goto out_destroy_form;
+
+	newtFormAddComponent(form, listbox);
+
+	for (i = 0; i < argc; ++i) {
+		int len = strlen(argv[i]);
+		if (len > max_len)
+			max_len = len;
+		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
+			goto out_destroy_form;
+	}
+
+	newtCenteredWindow(max_len, argc, NULL);
+	newtFormRun(form, &es);
+	rc = newtListboxGetCurrent(listbox) - NULL;
+	if (es.reason == NEWT_EXIT_HOTKEY)
+		rc = -1;
+	newtPopWindow();
+out_destroy_form:
+	newtFormDestroy(form);
+	return rc;
+}
+
+int ui__help_window(const char *text)
+{
+	struct newtExitStruct es;
+	newtComponent tb, form = newt_form__new();
+	int rc = -1;
+	int max_len = 0, nr_lines = 0;
+	const char *t;
+
+	if (form == NULL)
+		return -1;
+
+	t = text;
+	while (1) {
+		const char *sep = strchr(t, '\n');
+		int len;
+
+		if (sep == NULL)
+			sep = strchr(t, '\0');
+		len = sep - t;
+		if (max_len < len)
+			max_len = len;
+		++nr_lines;
+		if (*sep == '\0')
+			break;
+		t = sep + 1;
+	}
+
+	tb = newtTextbox(0, 0, max_len, nr_lines, 0);
+	if (tb == NULL)
+		goto out_destroy_form;
+
+	newtTextboxSetText(tb, text);
+	newtFormAddComponent(form, tb);
+	newtCenteredWindow(max_len, nr_lines, NULL);
+	newtFormRun(form, &es);
+	newtPopWindow();
+	rc = 0;
+out_destroy_form:
+	newtFormDestroy(form);
+	return rc;
+}
+
+bool ui__dialog_yesno(const char *msg)
+{
+	/* newtWinChoice should really be accepting const char pointers... */
+	char yes[] = "Yes", no[] = "No";
+	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
+}
diff --git a/tools/perf/util/ui/util.h b/tools/perf/util/ui/util.h
new file mode 100644
index 0000000..afcbc1d
--- /dev/null
+++ b/tools/perf/util/ui/util.h
@@ -0,0 +1,10 @@
+#ifndef _PERF_UI_UTIL_H_
+#define _PERF_UI_UTIL_H_ 1
+
+#include <stdbool.h>
+
+int ui__popup_menu(int argc, char * const argv[]);
+int ui__help_window(const char *text);
+bool ui__dialog_yesno(const char *msg);
+
+#endif /* _PERF_UI_UTIL_H_ */
