Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab2IKX5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:57:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:42267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2IKXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/18] perf sched: Remove unused thread parameter
Date: Tue, 11 Sep 2012 20:53:06 -0300
Message-Id: <1347407590-30960-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

>From the tracepoint handling routines.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mcqd9mv34z6he0wqiz4a3mh9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 82e8ec2..af11b1a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1372,8 +1372,7 @@ static struct trace_sched_handler *trace_handler;
 static int process_sched_wakeup_event(struct perf_tool *tool __maybe_unused,
 				      struct event_format *event,
 				      struct perf_sample *sample,
-				      struct machine *machine,
-				      struct thread *thread __maybe_unused)
+				      struct machine *machine)
 {
 	void *data = sample->raw_data;
 	struct trace_wakeup_event wakeup_event;
@@ -1489,8 +1488,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 static int process_sched_switch_event(struct perf_tool *tool __maybe_unused,
 				      struct event_format *event,
 				      struct perf_sample *sample,
-				      struct machine *machine,
-				      struct thread *thread __maybe_unused)
+				      struct machine *machine)
 {
 	int this_cpu = sample->cpu, err = 0;
 	void *data = sample->raw_data;
@@ -1524,8 +1522,7 @@ static int process_sched_switch_event(struct perf_tool *tool __maybe_unused,
 static int process_sched_runtime_event(struct perf_tool *tool __maybe_unused,
 				       struct event_format *event,
 				       struct perf_sample *sample,
-				       struct machine *machine,
-				       struct thread *thread __maybe_unused)
+				       struct machine *machine)
 {
 	void *data = sample->raw_data;
 	struct trace_runtime_event runtime_event;
@@ -1545,8 +1542,7 @@ static int process_sched_runtime_event(struct perf_tool *tool __maybe_unused,
 static int process_sched_fork_event(struct perf_tool *tool __maybe_unused,
 				    struct event_format *event,
 				    struct perf_sample *sample,
-				    struct machine *machine __maybe_unused,
-				    struct thread *thread __maybe_unused)
+				    struct machine *machine __maybe_unused)
 {
 	void *data = sample->raw_data;
 	struct trace_fork_event fork_event;
@@ -1568,8 +1564,7 @@ static int process_sched_fork_event(struct perf_tool *tool __maybe_unused,
 static int process_sched_exit_event(struct perf_tool *tool __maybe_unused,
 				    struct event_format *event,
 				    struct perf_sample *sample __maybe_unused,
-				    struct machine *machine __maybe_unused,
-				    struct thread *thread __maybe_unused)
+				    struct machine *machine __maybe_unused)
 {
 	if (verbose)
 		printf("sched_exit event %p\n", event);
@@ -1580,8 +1575,7 @@ static int process_sched_exit_event(struct perf_tool *tool __maybe_unused,
 static int process_sched_migrate_task_event(struct perf_tool *tool __maybe_unused,
 					    struct event_format *event,
 					    struct perf_sample *sample,
-					    struct machine *machine,
-					    struct thread *thread __maybe_unused)
+					    struct machine *machine)
 {
 	void *data = sample->raw_data;
 	struct trace_migrate_task_event migrate_task_event;
@@ -1603,8 +1597,7 @@ static int process_sched_migrate_task_event(struct perf_tool *tool __maybe_unuse
 typedef int (*tracepoint_handler)(struct perf_tool *tool,
 				  struct event_format *tp_format,
 				  struct perf_sample *sample,
-				  struct machine *machine,
-				  struct thread *thread);
+				  struct machine *machine);
 
 static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_unused,
 						 union perf_event *event __maybe_unused,
@@ -1626,7 +1619,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
-		err = f(tool, evsel->tp_format, sample, machine, thread);
+		err = f(tool, evsel->tp_format, sample, machine);
 	}
 
 	return err;
-- 
1.7.9.2.358.g22243

