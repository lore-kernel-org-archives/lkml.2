Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2HSDAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:48688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2HSC5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422052"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/74] sections: Add __visible to kernel/trace/* sections
Date: Sat, 18 Aug 2012 19:56:11 -0700
Message-Id: <1345345030-22211-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/trace/ftrace.c         |    4 ++--
 kernel/trace/trace.h          |    4 ++--
 kernel/trace/trace_branch.c   |    8 ++++----
 kernel/trace/trace_events.c   |    4 ++--
 kernel/trace/trace_syscalls.c |    4 ++--
 kernel/tracepoint.c           |    4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b4f20fb..5028bd3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3866,8 +3866,8 @@ struct notifier_block ftrace_module_nb = {
 	.priority = 0,
 };
 
-extern unsigned long __start_mcount_loc[];
-extern unsigned long __stop_mcount_loc[];
+extern __visible unsigned long __start_mcount_loc[];
+extern __visible unsigned long __stop_mcount_loc[];
 
 void __init ftrace_init(void)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55e1f7f..8c063e7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,8 +836,8 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
-extern const char *__start___trace_bprintk_fmt[];
-extern const char *__stop___trace_bprintk_fmt[];
+extern __visible const char *__start___trace_bprintk_fmt[];
+extern __visible const char *__stop___trace_bprintk_fmt[];
 
 void trace_printk_init_buffers(void);
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 8d3538b..5be6217 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -226,8 +226,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
 }
 EXPORT_SYMBOL(ftrace_likely_update);
 
-extern unsigned long __start_annotated_branch_profile[];
-extern unsigned long __stop_annotated_branch_profile[];
+extern __visible unsigned long __start_annotated_branch_profile[];
+extern __visible unsigned long __stop_annotated_branch_profile[];
 
 static int annotated_branch_stat_headers(struct seq_file *m)
 {
@@ -355,8 +355,8 @@ fs_initcall(init_annotated_branch_stats);
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
 
-extern unsigned long __start_branch_profile[];
-extern unsigned long __stop_branch_profile[];
+extern __visible unsigned long __start_branch_profile[];
+extern __visible unsigned long __stop_branch_profile[];
 
 static int all_branch_stat_headers(struct seq_file *m)
 {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..325c9f0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1435,8 +1435,8 @@ static struct notifier_block trace_module_nb = {
 	.priority = 0,
 };
 
-extern struct ftrace_event_call *__start_ftrace_events[];
-extern struct ftrace_event_call *__stop_ftrace_events[];
+extern __visible struct ftrace_event_call *__start_ftrace_events[];
+extern __visible struct ftrace_event_call *__stop_ftrace_events[];
 
 static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 60e4d78..52f3e15 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -56,8 +56,8 @@ struct ftrace_event_class event_class_syscall_exit = {
 	.raw_init	= init_syscall_trace,
 };
 
-extern struct syscall_metadata *__start_syscalls_metadata[];
-extern struct syscall_metadata *__stop_syscalls_metadata[];
+extern __visible struct syscall_metadata *__start_syscalls_metadata[];
+extern __visible struct syscall_metadata *__stop_syscalls_metadata[];
 
 static struct syscall_metadata **syscalls_metadata;
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d96ba22..ddae1de 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -27,8 +27,8 @@
 #include <linux/sched.h>
 #include <linux/static_key.h>
 
-extern struct tracepoint * const __start___tracepoints_ptrs[];
-extern struct tracepoint * const __stop___tracepoints_ptrs[];
+extern __visible struct tracepoint * const __start___tracepoints_ptrs[];
+extern __visible struct tracepoint * const __stop___tracepoints_ptrs[];
 
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
-- 
1.7.7.6

