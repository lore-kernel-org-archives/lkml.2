Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab2J3MGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:06:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab2J3MG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:06:28 -0400
Date: Tue, 30 Oct 2012 05:05:46 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-70cb4e963f77dae90ae2aa3dd9385a43737c469f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351569369-26732-2-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-2-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add a global variable "
 const char *input_name"
Git-Commit-ID: 70cb4e963f77dae90ae2aa3dd9385a43737c469f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:05:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70cb4e963f77dae90ae2aa3dd9385a43737c469f
Gitweb:     http://git.kernel.org/tip/70cb4e963f77dae90ae2aa3dd9385a43737c469f
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 30 Oct 2012 11:56:02 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:45:34 -0200

perf tools: Add a global variable "const char *input_name"

Currently many perf commands annotate/evlist/report/script/lock etc all
support "-i" option to chose a specific perf data, and all of them
create a local "input_name" to save the file name for that perf data.

Since most of these commands need it, we can add a global variable for
it, also it can some other benefits:

1. When calling script browser inside hists/annotation browser, it needs
to know the perf data file name to run that script.

2. For further feature like runtime switching to another perf data file,
this variable can also help.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351569369-26732-2-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |    5 ++---
 tools/perf/builtin-buildid-list.c |    6 ++----
 tools/perf/builtin-evlist.c       |    5 ++---
 tools/perf/builtin-kmem.c         |    5 ++---
 tools/perf/builtin-lock.c         |    2 --
 tools/perf/builtin-report.c       |   13 ++++++-------
 tools/perf/builtin-sched.c        |    5 ++---
 tools/perf/builtin-script.c       |    1 -
 tools/perf/builtin-timechart.c    |    5 ++---
 tools/perf/perf.c                 |    1 +
 tools/perf/perf.h                 |    1 +
 11 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c4bb645..cb23476 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -34,7 +34,6 @@
 
 struct perf_annotate {
 	struct perf_tool tool;
-	char const *input_name;
 	bool	   force, use_tui, use_stdio;
 	bool	   full_paths;
 	bool	   print_line;
@@ -175,7 +174,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
 
-	session = perf_session__new(ann->input_name, O_RDONLY,
+	session = perf_session__new(input_name, O_RDONLY,
 				    ann->force, false, &ann->tool);
 	if (session == NULL)
 		return -ENOMEM;
@@ -260,7 +259,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 	};
 	const struct option options[] = {
-	OPT_STRING('i', "input", &annotate.input_name, "file",
+	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index a0e94ff..a82d99f 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -44,8 +44,7 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	return fprintf(fp, "%s\n", sbuild_id);
 }
 
-static int perf_session__list_build_ids(const char *input_name,
-					bool force, bool with_hits)
+static int perf_session__list_build_ids(bool force, bool with_hits)
 {
 	struct perf_session *session;
 
@@ -81,7 +80,6 @@ int cmd_buildid_list(int argc, const char **argv,
 	bool show_kernel = false;
 	bool with_hits = false;
 	bool force = false;
-	const char *input_name = NULL;
 	const struct option options[] = {
 	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
@@ -101,5 +99,5 @@ int cmd_buildid_list(int argc, const char **argv,
 	if (show_kernel)
 		return sysfs__fprintf_build_id(stdout);
 
-	return perf_session__list_build_ids(input_name, force, with_hits);
+	return perf_session__list_build_ids(force, with_hits);
 }
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 997afb8..c20f1dc 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -48,12 +48,12 @@ static int __if_print(bool *first, const char *field, u64 value)
 
 #define if_print(field) __if_print(&first, #field, pos->attr.field)
 
-static int __cmd_evlist(const char *input_name, struct perf_attr_details *details)
+static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
 	struct perf_evsel *pos;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	session = perf_session__new(file_name, O_RDONLY, 0, false, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -111,7 +111,6 @@ static int __cmd_evlist(const char *input_name, struct perf_attr_details *detail
 int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_attr_details details = { .verbose = false, };
-	const char *input_name = NULL;
 	const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "Input file name"),
 	OPT_BOOLEAN('F', "freq", &details.freq, "Show the sample frequency"),
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 14bf82f..0b4b796 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -477,7 +477,7 @@ static void sort_result(void)
 	__sort_result(&root_caller_stat, &root_caller_sorted, &caller_sort);
 }
 
-static int __cmd_kmem(const char *input_name)
+static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
 	struct perf_session *session;
@@ -743,7 +743,6 @@ static int __cmd_record(int argc, const char **argv)
 int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const default_sort_order = "frag,hit,bytes";
-	const char *input_name = NULL;
 	const struct option kmem_options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
@@ -779,7 +778,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (list_empty(&alloc_sort))
 			setup_sorting(&alloc_sort, default_sort_order);
 
-		return __cmd_kmem(input_name);
+		return __cmd_kmem();
 	} else
 		usage_with_options(kmem_usage, kmem_options);
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6f5f328..4258300 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -335,8 +335,6 @@ alloc_failed:
 	return NULL;
 }
 
-static const char *input_name;
-
 struct trace_lock_handler {
 	int (*acquire_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 90d1162..f07eae7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,7 +40,6 @@
 struct perf_report {
 	struct perf_tool	tool;
 	struct perf_session	*session;
-	char const		*input_name;
 	bool			force, use_tui, use_gtk, use_stdio;
 	bool			hide_unresolved;
 	bool			dont_use_callchains;
@@ -571,7 +570,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.pretty_printing_style	 = "normal",
 	};
 	const struct option options[] = {
-	OPT_STRING('i', "input", &report.input_name, "file",
+	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
@@ -657,13 +656,13 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
-	if (!report.input_name || !strlen(report.input_name)) {
+	if (!input_name || !strlen(input_name)) {
 		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
-			report.input_name = "-";
+			input_name = "-";
 		else
-			report.input_name = "perf.data";
+			input_name = "perf.data";
 	}
-	session = perf_session__new(report.input_name, O_RDONLY,
+	session = perf_session__new(input_name, O_RDONLY,
 				    report.force, false, &report.tool);
 	if (session == NULL)
 		return -ENOMEM;
@@ -694,7 +693,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	}
 
-	if (strcmp(report.input_name, "-") != 0)
+	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else {
 		use_browser = 0;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 30e5336..cc28b85 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -120,7 +120,6 @@ struct trace_sched_handler {
 
 struct perf_sched {
 	struct perf_tool tool;
-	const char	 *input_name;
 	const char	 *sort_order;
 	unsigned long	 nr_tasks;
 	struct task_desc *pid_to_task[MAX_PID];
@@ -1460,7 +1459,7 @@ static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
 	};
 	struct perf_session *session;
 
-	session = perf_session__new(sched->input_name, O_RDONLY, 0, false, &sched->tool);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &sched->tool);
 	if (session == NULL) {
 		pr_debug("No Memory for session\n");
 		return -1;
@@ -1708,7 +1707,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 	const struct option sched_options[] = {
-	OPT_STRING('i', "input", &sched.input_name, "file",
+	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 04ceb07..7c6e4b2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1175,7 +1175,6 @@ static int have_cmd(int argc, const char **argv)
 int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool show_full_info = false;
-	const char *input_name = NULL;
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index f251b61..ab4cf232 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -965,7 +965,7 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static int __cmd_timechart(const char *input_name, const char *output_name)
+static int __cmd_timechart(const char *output_name)
 {
 	struct perf_tool perf_timechart = {
 		.comm		 = process_comm_event,
@@ -1061,7 +1061,6 @@ parse_process(const struct option *opt __maybe_unused, const char *arg,
 int cmd_timechart(int argc, const char **argv,
 		  const char *prefix __maybe_unused)
 {
-	const char *input_name;
 	const char *output_name = "output.svg";
 	const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
@@ -1092,5 +1091,5 @@ int cmd_timechart(int argc, const char **argv,
 
 	setup_pager();
 
-	return __cmd_timechart(input_name, output_name);
+	return __cmd_timechart(output_name);
 }
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index d480d8a..e968373 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -24,6 +24,7 @@ const char perf_more_info_string[] =
 
 int use_browser = -1;
 static int use_pager = -1;
+const char *input_name;
 
 struct cmd_struct {
 	const char *cmd;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index c50985e..469fbf2 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -208,6 +208,7 @@ struct branch_stack {
 	struct branch_entry	entries[0];
 };
 
+extern const char *input_name;
 extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
 
