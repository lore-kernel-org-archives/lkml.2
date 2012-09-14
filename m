Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2INGD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:03:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2INGDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:03:24 -0400
Date: Thu, 13 Sep 2012 23:03:02 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mcqd9mv34z6he0wqiz4a3mh9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Remove unused thread parameter
Git-Commit-ID: 4218e6734197f3842fc9b6362f12973918d913aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:03:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4218e6734197f3842fc9b6362f12973918d913aa
Gitweb:     http://git.kernel.org/tip/4218e6734197f3842fc9b6362f12973918d913aa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Sep 2012 13:18:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 13:18:47 -0300

perf sched: Remove unused thread parameter

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
 1 files changed, 8 insertions(+), 15 deletions(-)

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
