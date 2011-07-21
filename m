Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1GUKBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:01:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:55870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1GUKBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:01:47 -0400
Date: Thu, 21 Jul 2011 10:01:10 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-7143f168e2aa4bc7f8a8bcfe46d8dc52f7be869a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110627072636.6528.60374.stgit@fedora15>
References: <20110627072636.6528.60374.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobes: Rename probe_* to trace_probe_*
Git-Commit-ID: 7143f168e2aa4bc7f8a8bcfe46d8dc52f7be869a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:01:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7143f168e2aa4bc7f8a8bcfe46d8dc52f7be869a
Gitweb:     http://git.kernel.org/tip/7143f168e2aa4bc7f8a8bcfe46d8dc52f7be869a
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:26:36 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jul 2011 17:44:43 -0400

tracing/kprobes: Rename probe_* to trace_probe_*

Rename probe_* to trace_probe_* for avoiding namespace
confliction. This also fixes improper names of find_probe_event()
and cleanup_all_probes() to find_trace_probe() and
release_all_trace_probes() respectively.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20110627072636.6528.60374.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   43 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7db7b68..14b88ed 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -555,12 +555,12 @@ struct trace_probe {
 	(sizeof(struct probe_arg) * (n)))
 
 
-static __kprobes int probe_is_return(struct trace_probe *tp)
+static __kprobes int trace_probe_is_return(struct trace_probe *tp)
 {
 	return tp->rp.handler != NULL;
 }
 
-static __kprobes const char *probe_symbol(struct trace_probe *tp)
+static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
 {
 	return tp->symbol ? tp->symbol : "unknown";
 }
@@ -671,7 +671,7 @@ static void free_trace_probe(struct trace_probe *tp)
 	kfree(tp);
 }
 
-static struct trace_probe *find_probe_event(const char *event,
+static struct trace_probe *find_trace_probe(const char *event,
 					    const char *group)
 {
 	struct trace_probe *tp;
@@ -686,7 +686,7 @@ static struct trace_probe *find_probe_event(const char *event,
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
 static void unregister_trace_probe(struct trace_probe *tp)
 {
-	if (probe_is_return(tp))
+	if (trace_probe_is_return(tp))
 		unregister_kretprobe(&tp->rp);
 	else
 		unregister_kprobe(&tp->rp.kp);
@@ -703,7 +703,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	mutex_lock(&probe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tp->call.name, tp->call.class->system);
+	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
 	if (old_tp) {
 		/* delete old event */
 		unregister_trace_probe(old_tp);
@@ -716,7 +716,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	}
 
 	tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
-	if (probe_is_return(tp))
+	if (trace_probe_is_return(tp))
 		ret = register_kretprobe(&tp->rp);
 	else
 		ret = register_kprobe(&tp->rp.kp);
@@ -1025,7 +1025,7 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		mutex_lock(&probe_lock);
-		tp = find_probe_event(event, group);
+		tp = find_trace_probe(event, group);
 		if (!tp) {
 			mutex_unlock(&probe_lock);
 			pr_info("Event %s/%s doesn't exist.\n", group, event);
@@ -1144,7 +1144,7 @@ error:
 	return ret;
 }
 
-static void cleanup_all_probes(void)
+static void release_all_trace_probes(void)
 {
 	struct trace_probe *tp;
 
@@ -1181,15 +1181,16 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	struct trace_probe *tp = v;
 	int i;
 
-	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
+	seq_printf(m, "%c", trace_probe_is_return(tp) ? 'r' : 'p');
 	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
 
 	if (!tp->symbol)
 		seq_printf(m, " 0x%p", tp->rp.kp.addr);
 	else if (tp->rp.kp.offset)
-		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
+		seq_printf(m, " %s+%u", trace_probe_symbol(tp),
+			   tp->rp.kp.offset);
 	else
-		seq_printf(m, " %s", probe_symbol(tp));
+		seq_printf(m, " %s", trace_probe_symbol(tp));
 
 	for (i = 0; i < tp->nr_args; i++)
 		seq_printf(m, " %s=%s", tp->args[i].name, tp->args[i].comm);
@@ -1209,7 +1210,7 @@ static int probes_open(struct inode *inode, struct file *file)
 {
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
-		cleanup_all_probes();
+		release_all_trace_probes();
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -1518,7 +1519,7 @@ static int probe_event_enable(struct ftrace_event_call *call)
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
 	tp->flags |= TP_FLAG_TRACE;
-	if (probe_is_return(tp))
+	if (trace_probe_is_return(tp))
 		return enable_kretprobe(&tp->rp);
 	else
 		return enable_kprobe(&tp->rp.kp);
@@ -1530,7 +1531,7 @@ static void probe_event_disable(struct ftrace_event_call *call)
 
 	tp->flags &= ~TP_FLAG_TRACE;
 	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
-		if (probe_is_return(tp))
+		if (trace_probe_is_return(tp))
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
@@ -1598,7 +1599,7 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 
 	const char *fmt, *arg;
 
-	if (!probe_is_return(tp)) {
+	if (!trace_probe_is_return(tp)) {
 		fmt = "(%lx)";
 		arg = "REC->" FIELD_STRING_IP;
 	} else {
@@ -1722,7 +1723,7 @@ static int probe_perf_enable(struct ftrace_event_call *call)
 
 	tp->flags |= TP_FLAG_PROFILE;
 
-	if (probe_is_return(tp))
+	if (trace_probe_is_return(tp))
 		return enable_kretprobe(&tp->rp);
 	else
 		return enable_kprobe(&tp->rp.kp);
@@ -1735,7 +1736,7 @@ static void probe_perf_disable(struct ftrace_event_call *call)
 	tp->flags &= ~TP_FLAG_PROFILE;
 
 	if (!(tp->flags & TP_FLAG_TRACE)) {
-		if (probe_is_return(tp))
+		if (trace_probe_is_return(tp))
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
@@ -1807,7 +1808,7 @@ static int register_probe_event(struct trace_probe *tp)
 
 	/* Initialize ftrace_event_call */
 	INIT_LIST_HEAD(&call->class->fields);
-	if (probe_is_return(tp)) {
+	if (trace_probe_is_return(tp)) {
 		call->event.funcs = &kretprobe_funcs;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
@@ -1899,7 +1900,7 @@ static __init int kprobe_trace_self_tests_init(void)
 		warn++;
 	} else {
 		/* Enable trace point */
-		tp = find_probe_event("testprobe", KPROBE_EVENT_SYSTEM);
+		tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
 			pr_warning("error on getting new probe.\n");
 			warn++;
@@ -1914,7 +1915,7 @@ static __init int kprobe_trace_self_tests_init(void)
 		warn++;
 	} else {
 		/* Enable trace point */
-		tp = find_probe_event("testprobe2", KPROBE_EVENT_SYSTEM);
+		tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
 			pr_warning("error on getting new probe.\n");
 			warn++;
@@ -1940,7 +1941,7 @@ static __init int kprobe_trace_self_tests_init(void)
 	}
 
 end:
-	cleanup_all_probes();
+	release_all_trace_probes();
 	if (warn)
 		pr_cont("NG: Some tests are failed. Please check them.\n");
 	else
