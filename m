Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1GPL0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1GPLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:54 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=u60RenMhrCcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ckedD-iNhdlPpmHyalIA:9 a=YdPsxwTZaj4udcakOxYA:7 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112253.574581708@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 09/20] tracing/kprobes: Rename probe_* to trace_probe_*
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-kprobes-Rename-probe_-to-trace_probe_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.7.5.4


