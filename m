Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2GQBPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:15:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45386 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2GQBPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:15:48 -0400
MIME-Version: 1.0
Date: Tue, 17 Jul 2012 09:15:47 +0800
Message-ID: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
Subject: [PATCH] ftrace: using pr_fmt for better printk output
From: Jovi Zhang <bookjovi@gmail.com>
To: rostedt@goodmis.org,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fe42b2f29e5968482b3129c71f81a58a0559cf04 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Tue, 17 Jul 2012 17:10:15 +0800
Subject: [PATCH] ftrace: using pr_fmt for better printk output

There don't have subsystem name output in front ot ftrace related log entry,
so use pr_fmt to enable better printk output, for output subsystem name in
log entry.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 kernel/trace/blktrace.c              |    2 ++
 kernel/trace/ftrace.c                |   10 ++++++----
 kernel/trace/trace.c                 |    5 ++++-
 kernel/trace/trace_events.c          |    2 ++
 kernel/trace/trace_functions_graph.c |    9 ++++++---
 kernel/trace/trace_kprobe.c          |    2 ++
 kernel/trace/trace_mmiotrace.c       |    2 ++
 kernel/trace/trace_probe.c           |    2 ++
 kernel/trace/trace_selftest.c        |    6 +++---
 kernel/trace/trace_syscalls.c        |    9 +++++----
 kernel/trace/trace_uprobe.c          |    2 ++
 11 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..940b5d7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -15,6 +15,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  */
+#define pr_fmt(fmt) "blktrace: " fmt
+
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a008663..c138ad7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -13,6 +13,8 @@
  *  Copyright (C) 2004 William Lee Irwin III
  */

+#define pr_fmt(fmt) "ftrace: " fmt
+
 #include <linux/stop_machine.h>
 #include <linux/clocksource.h>
 #include <linux/kallsyms.h>
@@ -2178,7 +2180,7 @@ ftrace_allocate_pages(unsigned long num_to_init)
 		kfree(pg);
 		pg = start_pg;
 	}
-	pr_info("ftrace: FAILED to allocate memory for functions\n");
+	pr_info("FAILED to allocate memory for functions\n");
 	return NULL;
 }

@@ -2187,12 +2189,12 @@ static int __init
ftrace_dyn_table_alloc(unsigned long num_to_init)
 	int cnt;

 	if (!num_to_init) {
-		pr_info("ftrace: No functions to be traced?\n");
+		pr_info("No functions to be traced?\n");
 		return -1;
 	}

 	cnt = num_to_init / ENTRIES_PER_PAGE;
-	pr_info("ftrace: allocating %ld entries in %d pages\n",
+	pr_info("allocating %ld entries in %d pages\n",
 		num_to_init, cnt + 1);

 	return 0;
@@ -4495,7 +4497,7 @@ static int start_graph_tracing(void)
 	if (!ret) {
 		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 		if (ret)
-			pr_info("ftrace_graph: Couldn't activate tracepoint"
+			pr_info("Couldn't activate tracepoint"
 				" probe to kernel_sched_switch\n");
 	}

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a7fa070..dc06661 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -11,6 +11,9 @@
  *  Copyright (C) 2004-2006 Ingo Molnar
  *  Copyright (C) 2004 William Lee Irwin III
  */
+
+#define pr_fmt(fmt) "trace: " fmt
+
 #include <linux/ring_buffer.h>
 #include <generated/utsrelease.h>
 #include <linux/stacktrace.h>
@@ -1566,7 +1569,7 @@ void trace_printk_init_buffers(void)
 	if (alloc_percpu_trace_buffer())
 		return;

-	pr_info("ftrace: Allocated trace_printk buffers\n");
+	pr_info("Allocated trace_printk buffers\n");

 	buffers_allocated = 1;
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..0abdf37 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -8,6 +8,8 @@
  *
  */

+#define pr_fmt(fmt) "trace_events: " fmt
+
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
diff --git a/kernel/trace/trace_functions_graph.c
b/kernel/trace/trace_functions_graph.c
index a7d2a4c..97ed861 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -6,6 +6,9 @@
  * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
  *
  */
+
+#define pr_fmt(fmt) "function graph tracer: " fmt
+
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
@@ -1401,7 +1404,7 @@ void graph_trace_open(struct trace_iterator *iter)
  out_err_free:
 	kfree(data);
  out_err:
-	pr_warning("function graph tracer: not enough memory\n");
+	pr_warn("not enough memory\n");
 }

 void graph_trace_close(struct trace_iterator *iter)
@@ -1459,12 +1462,12 @@ static __init int init_graph_trace(void)
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);

 	if (!register_ftrace_event(&graph_trace_entry_event)) {
-		pr_warning("Warning: could not register graph trace events\n");
+		pr_warn("Warning: could not register graph trace events\n");
 		return 1;
 	}

 	if (!register_ftrace_event(&graph_trace_ret_event)) {
-		pr_warning("Warning: could not register graph trace events\n");
+		pr_warn("Warning: could not register graph trace events\n");
 		return 1;
 	}

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b31d3d5..7396848 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -17,6 +17,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */

+#define pr_fmt(fmt) "trace_kprobe: " fmt
+
 #include <linux/module.h>
 #include <linux/uaccess.h>

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fd3c8aa..56d1a03 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2008 Pekka Paalanen <pq@iki.fi>
  */

+#define pr_fmt(fmt) "trace_mmiotrace: " fmt
+
 #define DEBUG 1

 #include <linux/kernel.h>
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index daa9980..0a7ebad 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -22,6 +22,8 @@
  * Author:     Srikar Dronamraju
  */

+#define pr_fmt(fmt) "trace_probe: " fmt
+
 #include "trace_probe.h"

 const char *reserved_field_names[] = {
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..634f5af 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -94,7 +94,7 @@ static int trace_test_buffer(struct trace_array *tr,
unsigned long *count)

 static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 {
-	printk(KERN_WARNING "Failed to init %s tracer, init returned %d\n",
+	pr_warn("Failed to init %s tracer, init returned %d\n",
 		trace->name, init_ret);
 }
 #ifdef CONFIG_FUNCTION_TRACER
@@ -236,7 +236,7 @@ static int trace_selftest_ops(int cnt)
 	/* Add a dynamic probe */
 	dyn_ops = kzalloc(sizeof(*dyn_ops), GFP_KERNEL);
 	if (!dyn_ops) {
-		printk("MEMORY ERROR ");
+		pr_err("MEMORY ERROR ");
 		goto out;
 	}

@@ -471,7 +471,7 @@ static int trace_graph_entry_watchdog(struct
ftrace_graph_ent *trace)
 	/* This is harmlessly racy, we want to approximately detect a hang */
 	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
 		ftrace_graph_stop();
-		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
+		pr_warn("BUG: Function graph tracer hang!\n");
 		if (ftrace_dump_on_oops)
 			__ftrace_dump(false, DUMP_ALL);
 		return 0;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 96fc733..8163e89 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,3 +1,6 @@
+
+#define pr_fmt(fmt) "trace_syscalls: " fmt
+
 #include <trace/syscall.h>
 #include <trace/events/syscalls.h>
 #include <linux/slab.h>
@@ -546,8 +549,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 	if (!sys_perf_refcount_enter)
 		ret = register_trace_sys_enter(perf_syscall_enter, NULL);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+		pr_info("Could not activate syscall entry trace point");
 	} else {
 		set_bit(num, enabled_perf_enter_syscalls);
 		sys_perf_refcount_enter++;
@@ -622,8 +624,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 	if (!sys_perf_refcount_exit)
 		ret = register_trace_sys_exit(perf_syscall_exit, NULL);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall exit trace point");
+		pr_info("Could not activate syscall exit trace point");
 	} else {
 		set_bit(num, enabled_perf_exit_syscalls);
 		sys_perf_refcount_exit++;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2b36ac6..a677f36 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -18,6 +18,8 @@
  * Author:	Srikar Dronamraju <srikar@linux.vnet.ibm.com>
  */

+#define pr_fmt(fmt) "trace_uprobe: " fmt
+
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/uprobes.h>
-- 
1.7.9.7
