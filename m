Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2H1WEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:04:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54398 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2H1WEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:04:45 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:04:25 +0300
Message-ID: <CANg8OWKxb_sMXSSpf0iHVn4+a8QF1-b1cKX+jBiWzBYamGNjrw@mail.gmail.com>
Subject: [PATCH 08/13] perf tools: Use __maybe_used for unused variables
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf defines __used to for marking unused variables.
The variable __used is defined to __attribute__((__unused__)), which
contradicts the kernel definition to __attribute__((__used__))
for new gcc versions. On Android), __used is also defined in
system headers and this leads to warnings like:
warning: '__used__' attribute ignored

This patch simply replaces all instances of __used with __maybe_unused
so there will be no such warnings.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/bench/bench.h                 |    2 +-
 tools/perf/bench/mem-memcpy.c            |    2 +-
 tools/perf/bench/mem-memset.c            |    2 +-
 tools/perf/bench/sched-messaging.c       |    2 +-
 tools/perf/bench/sched-pipe.c            |    4 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-bench.c               |    2 +-
 tools/perf/builtin-buildid-cache.c       |    6 +--
 tools/perf/builtin-buildid-list.c        |    2 +-
 tools/perf/builtin-diff.c                |    4 +-
 tools/perf/builtin-evlist.c              |    2 +-
 tools/perf/builtin-help.c                |    2 +-
 tools/perf/builtin-inject.c              |   20 ++++-----
 tools/perf/builtin-kmem.c                |   20 ++++-----
 tools/perf/builtin-kvm.c                 |    2 +-
 tools/perf/builtin-list.c                |    2 +-
 tools/perf/builtin-lock.c                |    4 +-
 tools/perf/builtin-probe.c               |   24 +++++------
 tools/perf/builtin-record.c              |   12 +++---
 tools/perf/builtin-report.c              |   10 ++---
 tools/perf/builtin-sched.c               |   62 +++++++++++++--------------
 tools/perf/builtin-script.c              |   16 +++----
 tools/perf/builtin-stat.c                |   24 +++++------
 tools/perf/builtin-test.c                |    6 +--
 tools/perf/builtin-timechart.c           |   28 ++++++------
 tools/perf/builtin-top.c                 |    6 +--
 tools/perf/ui/browser.c                  |    6 +--
 tools/perf/ui/browsers/annotate.c        |    4 +-
 tools/perf/ui/gtk/browser.c              |    4 +-
 tools/perf/ui/gtk/setup.c                |    2 +-
 tools/perf/ui/gtk/util.c                 |    4 +-
 tools/perf/ui/helpline.c                 |    2 +-
 tools/perf/ui/helpline.h                 |    8 ++--
 tools/perf/ui/tui/setup.c                |    4 +-
 tools/perf/util/alias.c                  |    2 +-
 tools/perf/util/annotate.c               |    6 +--
 tools/perf/util/annotate.h               |   12 +++---
 tools/perf/util/build-id.c               |   10 ++---
 tools/perf/util/cache.h                  |    6 +--
 tools/perf/util/callchain.c              |    6 +--
 tools/perf/util/cgroup.c                 |    4 +-
 tools/perf/util/config.c                 |    4 +-
 tools/perf/util/debug.h                  |    8 ++--
 tools/perf/util/event.c                  |   18 ++++----
 tools/perf/util/header.c                 |   68 +++++++++++++++---------------
 tools/perf/util/help.c                   |    2 +-
 tools/perf/util/hist.c                   |    2 +-
 tools/perf/util/hist.h                   |   30 ++++++-------
 tools/perf/util/include/linux/compiler.h |    2 +-
 tools/perf/util/intlist.c                |    6 +--
 tools/perf/util/map.h                    |    2 +-
 tools/perf/util/parse-events-test.c      |    6 +--
 tools/perf/util/parse-events.c           |    6 +--
 tools/perf/util/parse-events.l           |    2 +-
 tools/perf/util/parse-events.y           |    4 +-
 tools/perf/util/parse-options.c          |    2 +-
 tools/perf/util/perf_regs.h              |    2 +-
 tools/perf/util/pmu.y                    |    6 +--
 tools/perf/util/probe-finder.c           |    4 +-
 tools/perf/util/python.c                 |    6 +--
 tools/perf/util/session.c                |   46 ++++++++++----------
 tools/perf/util/sort.c                   |   10 ++---
 tools/perf/util/symbol-minimal.c         |   24 +++++------
 tools/perf/util/symbol.c                 |    2 +-
 tools/perf/util/symbol.h                 |    6 +--
 tools/perf/util/unwind.c                 |   32 +++++++-------
 tools/perf/util/unwind.h                 |   10 ++---
 tools/perf/util/wrapper.c                |    2 +-
 68 files changed, 330 insertions(+), 330 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index a09bece..d2cd74f 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -3,7 +3,7 @@

 extern int bench_sched_messaging(int argc, const char **argv, const
char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
-extern int bench_mem_memcpy(int argc, const char **argv, const char
*prefix __used);
+extern int bench_mem_memcpy(int argc, const char **argv, const char
*prefix __maybe_unused);
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);

 #define BENCH_FORMAT_DEFAULT_STR    "default"
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 02dad5d..93c83e3 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -177,7 +177,7 @@ static double do_memcpy_gettimeofday(memcpy_t fn,
size_t len, bool prefault)
     } while (0)

 int bench_mem_memcpy(int argc, const char **argv,
-             const char *prefix __used)
+             const char *prefix __maybe_unused)
 {
     int i;
     size_t len;
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 350cc95..c6e4bc5 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -171,7 +171,7 @@ static double do_memset_gettimeofday(memset_t fn,
size_t len, bool prefault)
     } while (0)

 int bench_mem_memset(int argc, const char **argv,
-             const char *prefix __used)
+             const char *prefix __maybe_unused)
 {
     int i;
     size_t len;
diff --git a/tools/perf/bench/sched-messaging.c
b/tools/perf/bench/sched-messaging.c
index d1d1b30..cc1190a 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -267,7 +267,7 @@ static const char * const bench_sched_message_usage[] = {
 };

 int bench_sched_messaging(int argc, const char **argv,
-            const char *prefix __used)
+            const char *prefix __maybe_unused)
 {
     unsigned int i, total_children;
     struct timeval start, stop, diff;
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 0c7454f..0598c8a 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -43,7 +43,7 @@ static const char * const bench_sched_pipe_usage[] = {
 };

 int bench_sched_pipe(int argc, const char **argv,
-             const char *prefix __used)
+             const char *prefix __maybe_unused)
 {
     int pipe_1[2], pipe_2[2];
     int m = 0, i;
@@ -55,7 +55,7 @@ int bench_sched_pipe(int argc, const char **argv,
      * discarding returned value of read(), write()
      * causes error in building environment for perf
      */
-    int __used ret, wait_stat;
+    int __maybe_unused ret, wait_stat;
     pid_t pid, retpid;

     argc = parse_options(argc, argv, options,
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 67522cf..7d85521 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -239,7 +239,7 @@ static const char * const annotate_usage[] = {
     NULL
 };

-int cmd_annotate(int argc, const char **argv, const char *prefix __used)
+int cmd_annotate(int argc, const char **argv, const char *prefix
__maybe_unused)
 {
     struct perf_annotate annotate = {
         .tool = {
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 1f31002..cae9a5f 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -173,7 +173,7 @@ static void all_subsystem(void)
         all_suite(&subsystems[i]);
 }

-int cmd_bench(int argc, const char **argv, const char *prefix __used)
+int cmd_bench(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     int i, j, status = 0;

diff --git a/tools/perf/builtin-buildid-cache.c
b/tools/perf/builtin-buildid-cache.c
index 29ad20e..f6d53d5 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -50,8 +50,8 @@ static int build_id_cache__add_file(const char
*filename, const char *debugdir)
     return err;
 }

-static int build_id_cache__remove_file(const char *filename __used,
-                       const char *debugdir __used)
+static int build_id_cache__remove_file(const char *filename __maybe_unused,
+                       const char *debugdir __maybe_unused)
 {
     u8 build_id[BUILD_ID_SIZE];
     char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -119,7 +119,7 @@ static int __cmd_buildid_cache(void)
     return 0;
 }

-int cmd_buildid_cache(int argc, const char **argv, const char *prefix __used)
+int cmd_buildid_cache(int argc, const char **argv, const char *prefix
__maybe_unused)
 {
     argc = parse_options(argc, argv, buildid_cache_options,
                  buildid_cache_usage, 0);
diff --git a/tools/perf/builtin-buildid-list.c
b/tools/perf/builtin-buildid-list.c
index 7d68428..62e2b2a 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -103,7 +103,7 @@ static int __cmd_buildid_list(void)
     return perf_session__list_build_ids();
 }

-int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
+int cmd_buildid_list(int argc, const char **argv, const char *prefix
__maybe_unused)
 {
     argc = parse_options(argc, argv, options, buildid_list_usage, 0);
     setup_pager();
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d29d350..979609d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -40,7 +40,7 @@ static int hists__add_entry(struct hists *self,
 static int diff__process_sample_event(struct perf_tool *tool,
                       union perf_event *event,
                       struct perf_sample *sample,
-                      struct perf_evsel *evsel __used,
+                      struct perf_evsel *evsel __maybe_unused,
                       struct machine *machine)
 {
     struct perf_diff *_diff = container_of(tool, struct perf_diff, tool);
@@ -213,7 +213,7 @@ static const struct option options[] = {
     OPT_END()
 };

-int cmd_diff(int argc, const char **argv, const char *prefix __used)
+int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     sort_order = diff__default_sort_order;
     argc = parse_options(argc, argv, options, diff_usage, 0);
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 0dd5a05..1fb1641 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -113,7 +113,7 @@ static const char * const evlist_usage[] = {
     NULL
 };

-int cmd_evlist(int argc, const char **argv, const char *prefix __used)
+int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     struct perf_attr_details details = { .verbose = false, };
     const char *input_name = NULL;
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 6d5a8a7..f8da324 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -411,7 +411,7 @@ static void show_html_page(const char *perf_cmd)
     open_html(page_path.buf);
 }

-int cmd_help(int argc, const char **argv, const char *prefix __used)
+int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     const char *alias;

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 64d8ba2..fbefbcf 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -17,9 +17,9 @@
 static char        const *input_name = "-";
 static bool        inject_build_ids;

-static int perf_event__repipe_synth(struct perf_tool *tool __used,
+static int perf_event__repipe_synth(struct perf_tool *tool __maybe_unused,
                     union perf_event *event,
-                    struct machine *machine __used)
+                    struct machine *machine __maybe_unused)
 {
     uint32_t size;
     void *buf = event;
@@ -40,7 +40,7 @@ static int perf_event__repipe_synth(struct perf_tool
*tool __used,

 static int perf_event__repipe_op2_synth(struct perf_tool *tool,
                     union perf_event *event,
-                    struct perf_session *session __used)
+                    struct perf_session *session __maybe_unused)
 {
     return perf_event__repipe_synth(tool, event, NULL);
 }
@@ -52,13 +52,13 @@ static int
perf_event__repipe_event_type_synth(struct perf_tool *tool,
 }

 static int perf_event__repipe_tracing_data_synth(union perf_event *event,
-                         struct perf_session *session __used)
+                         struct perf_session *session __maybe_unused)
 {
     return perf_event__repipe_synth(NULL, event, NULL);
 }

 static int perf_event__repipe_attr(union perf_event *event,
-                   struct perf_evlist **pevlist __used)
+                   struct perf_evlist **pevlist __maybe_unused)
 {
     int ret;
     ret = perf_event__process_attr(event, pevlist);
@@ -70,7 +70,7 @@ static int perf_event__repipe_attr(union perf_event *event,

 static int perf_event__repipe(struct perf_tool *tool,
                   union perf_event *event,
-                  struct perf_sample *sample __used,
+                  struct perf_sample *sample __maybe_unused,
                   struct machine *machine)
 {
     return perf_event__repipe_synth(tool, event, machine);
@@ -78,8 +78,8 @@ static int perf_event__repipe(struct perf_tool *tool,

 static int perf_event__repipe_sample(struct perf_tool *tool,
                      union perf_event *event,
-                  struct perf_sample *sample __used,
-                  struct perf_evsel *evsel __used,
+                  struct perf_sample *sample __maybe_unused,
+                  struct perf_evsel *evsel __maybe_unused,
                   struct machine *machine)
 {
     return perf_event__repipe_synth(tool, event, machine);
@@ -163,7 +163,7 @@ static int dso__inject_build_id(struct dso *self,
struct perf_tool *tool,
 static int perf_event__inject_buildid(struct perf_tool *tool,
                       union perf_event *event,
                       struct perf_sample *sample,
-                      struct perf_evsel *evsel __used,
+                      struct perf_evsel *evsel __maybe_unused,
                       struct machine *machine)
 {
     struct addr_location al;
@@ -267,7 +267,7 @@ static const struct option options[] = {
     OPT_END()
 };

-int cmd_inject(int argc, const char **argv, const char *prefix __used)
+int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     argc = parse_options(argc, argv, options, report_usage, 0);

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc6607b..a6a2602 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -298,7 +298,7 @@ static void perf_evsel__process_kmem_event(struct
perf_evsel *evsel,
     }
 }

-static int process_sample_event(struct perf_tool *tool __used,
+static int process_sample_event(struct perf_tool *tool __maybe_unused,
                 union perf_event *event,
                 struct perf_sample *sample,
                 struct perf_evsel *evsel,
@@ -647,8 +647,8 @@ static int setup_sorting(struct list_head
*sort_list, const char *arg)
     return 0;
 }

-static int parse_sort_opt(const struct option *opt __used,
-              const char *arg, int unset __used)
+static int parse_sort_opt(const struct option *opt __maybe_unused,
+              const char *arg, int unset __maybe_unused)
 {
     if (!arg)
         return -1;
@@ -661,22 +661,22 @@ static int parse_sort_opt(const struct option *opt __used,
     return 0;
 }

-static int parse_caller_opt(const struct option *opt __used,
-              const char *arg __used, int unset __used)
+static int parse_caller_opt(const struct option *opt __maybe_unused,
+              const char *arg __maybe_unused, int unset __maybe_unused)
 {
     caller_flag = (alloc_flag + 1);
     return 0;
 }

-static int parse_alloc_opt(const struct option *opt __used,
-              const char *arg __used, int unset __used)
+static int parse_alloc_opt(const struct option *opt __maybe_unused,
+              const char *arg __maybe_unused, int unset __maybe_unused)
 {
     alloc_flag = (caller_flag + 1);
     return 0;
 }

-static int parse_line_opt(const struct option *opt __used,
-              const char *arg, int unset __used)
+static int parse_line_opt(const struct option *opt __maybe_unused,
+              const char *arg, int unset __maybe_unused)
 {
     int lines;

@@ -746,7 +746,7 @@ static int __cmd_record(int argc, const char **argv)
     return cmd_record(i, rec_argv, NULL);
 }

-int cmd_kmem(int argc, const char **argv, const char *prefix __used)
+int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9fc6e0f..4d2aa2c 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -102,7 +102,7 @@ static int __cmd_buildid_list(int argc, const char **argv)
     return cmd_buildid_list(i, rec_argv, NULL);
 }

-int cmd_kvm(int argc, const char **argv, const char *prefix __used)
+int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     perf_host  = 0;
     perf_guest = 1;
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index bdcff81..1948ece 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -14,7 +14,7 @@
 #include "util/parse-events.h"
 #include "util/cache.h"

-int cmd_list(int argc, const char **argv, const char *prefix __used)
+int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     setup_pager();

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 585aae2..74f59854 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -812,7 +812,7 @@ static void dump_info(void)
         die("Unknown type of information\n");
 }

-static int process_sample_event(struct perf_tool *tool __used,
+static int process_sample_event(struct perf_tool *tool __maybe_unused,
                 union perf_event *event,
                 struct perf_sample *sample,
                 struct perf_evsel *evsel,
@@ -956,7 +956,7 @@ static int __cmd_record(int argc, const char **argv)
     return cmd_record(i, rec_argv, NULL);
 }

-int cmd_lock(int argc, const char **argv, const char *prefix __used)
+int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     unsigned int i;

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e215ae6..118aa89 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -143,8 +143,8 @@ static int parse_probe_event_argv(int argc, const
char **argv)
     return ret;
 }

-static int opt_add_probe_event(const struct option *opt __used,
-                  const char *str, int unset __used)
+static int opt_add_probe_event(const struct option *opt __maybe_unused,
+                  const char *str, int unset __maybe_unused)
 {
     if (str) {
         params.mod_events = true;
@@ -153,8 +153,8 @@ static int opt_add_probe_event(const struct option
*opt __used,
         return 0;
 }

-static int opt_del_probe_event(const struct option *opt __used,
-                   const char *str, int unset __used)
+static int opt_del_probe_event(const struct option *opt __maybe_unused,
+                   const char *str, int unset __maybe_unused)
 {
     if (str) {
         params.mod_events = true;
@@ -166,7 +166,7 @@ static int opt_del_probe_event(const struct option
*opt __used,
 }

 static int opt_set_target(const struct option *opt, const char *str,
-            int unset __used)
+            int unset __maybe_unused)
 {
     int ret = -ENOENT;

@@ -188,8 +188,8 @@ static int opt_set_target(const struct option
*opt, const char *str,
 }

 #ifdef DWARF_SUPPORT
-static int opt_show_lines(const struct option *opt __used,
-              const char *str, int unset __used)
+static int opt_show_lines(const struct option *opt __maybe_unused,
+              const char *str, int unset __maybe_unused)
 {
     int ret = 0;

@@ -209,8 +209,8 @@ static int opt_show_lines(const struct option *opt __used,
     return ret;
 }

-static int opt_show_vars(const struct option *opt __used,
-             const char *str, int unset __used)
+static int opt_show_vars(const struct option *opt __maybe_unused,
+             const char *str, int unset __maybe_unused)
 {
     struct perf_probe_event *pev = &params.events[params.nevents];
     int ret;
@@ -229,8 +229,8 @@ static int opt_show_vars(const struct option *opt __used,
 }
 #endif

-static int opt_set_filter(const struct option *opt __used,
-              const char *str, int unset __used)
+static int opt_set_filter(const struct option *opt __maybe_unused,
+              const char *str, int unset __maybe_unused)
 {
     const char *err;

@@ -327,7 +327,7 @@ static const struct option options[] = {
     OPT_END()
 };

-int cmd_probe(int argc, const char **argv, const char *prefix __used)
+int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     int ret;

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 479ff2a..3fc9bf9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -88,8 +88,8 @@ static void write_output(struct perf_record *rec,
void *buf, size_t size)

 static int process_synthesized_event(struct perf_tool *tool,
                      union perf_event *event,
-                     struct perf_sample *sample __used,
-                     struct machine *machine __used)
+                     struct perf_sample *sample __maybe_unused,
+                     struct machine *machine __maybe_unused)
 {
     struct perf_record *rec = container_of(tool, struct perf_record, tool);
     write_output(rec, event, event->header.size);
@@ -143,7 +143,7 @@ static void sig_handler(int sig)
     signr = sig;
 }

-static void perf_record__sig_exit(int exit_status __used, void *arg)
+static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 {
     struct perf_record *rec = arg;
     int status;
@@ -335,7 +335,7 @@ static int process_buildids(struct perf_record *rec)
                           size, &build_id__mark_dso_hit_ops);
 }

-static void perf_record__exit(int status __used, void *arg)
+static void perf_record__exit(int status __maybe_unused, void *arg)
 {
     struct perf_record *rec = arg;

@@ -767,7 +767,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 #endif /* !NO_LIBUNWIND_SUPPORT */

 static int
-parse_callchain_opt(const struct option *opt __used, const char *arg,
+parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
             int unset)
 {
     struct perf_record *rec = (struct perf_record *)opt->value;
@@ -943,7 +943,7 @@ const struct option record_options[] = {
     OPT_END()
 };

-int cmd_record(int argc, const char **argv, const char *prefix __used)
+int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     int err = -ENOMEM;
     struct perf_evsel *pos;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d618253..90667e8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -223,9 +223,9 @@ static int process_sample_event(struct perf_tool *tool,

 static int process_read_event(struct perf_tool *tool,
                   union perf_event *event,
-                  struct perf_sample *sample __used,
+                  struct perf_sample *sample __maybe_unused,
                   struct perf_evsel *evsel,
-                  struct machine *machine __used)
+                  struct machine *machine __maybe_unused)
 {
     struct perf_report *rep = container_of(tool, struct perf_report, tool);

@@ -287,7 +287,7 @@ static int perf_report__setup_sample_type(struct
perf_report *rep)

 extern volatile int session_done;

-static void sig_handler(int sig __used)
+static void sig_handler(int sig __maybe_unused)
 {
     session_done = 1;
 }
@@ -533,13 +533,13 @@ setup:
 }

 static int
-parse_branch_mode(const struct option *opt __used, const char *str
__used, int unset)
+parse_branch_mode(const struct option *opt __maybe_unused, const char
*str __maybe_unused, int unset)
 {
     sort__branch_mode = !unset;
     return 0;
 }

-int cmd_report(int argc, const char **argv, const char *prefix __used)
+int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     struct perf_session *session;
     struct stat st;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a25a023..3d3cab46 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -299,7 +299,7 @@ add_sched_event_wakeup(struct task_desc *task, u64
timestamp,

 static void
 add_sched_event_sleep(struct task_desc *task, u64 timestamp,
-              u64 task_state __used)
+              u64 task_state __maybe_unused)
 {
     struct sched_atom *event = get_new_event(task, timestamp);

@@ -370,7 +370,7 @@ static void add_cross_task_wakeups(void)
 }

 static void
-process_sched_event(struct task_desc *this_task __used, struct
sched_atom *atom)
+process_sched_event(struct task_desc *this_task __maybe_unused,
struct sched_atom *atom)
 {
     int ret = 0;

@@ -751,7 +751,7 @@ struct trace_sched_handler {

 static void
 replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
-            struct machine *machine __used,
+            struct machine *machine __maybe_unused,
             struct event_format *event, struct perf_sample *sample)
 {
     struct task_desc *waker, *wakee;
@@ -775,11 +775,11 @@ static u64 cpu_last_switched[MAX_CPUS];

 static void
 replay_switch_event(struct trace_switch_event *switch_event,
-            struct machine *machine __used,
+            struct machine *machine __maybe_unused,
             struct event_format *event,
             struct perf_sample *sample)
 {
-    struct task_desc *prev, __used *next;
+    struct task_desc *prev, __maybe_unused *next;
     u64 timestamp0, timestamp = sample->time;
     int cpu = sample->cpu;
     s64 delta;
@@ -923,13 +923,13 @@ static void thread_atoms_insert(struct thread *thread)
 }

 static void
-latency_fork_event(struct trace_fork_event *fork_event __used,
-           struct event_format *event __used)
+latency_fork_event(struct trace_fork_event *fork_event __maybe_unused,
+           struct event_format *event __maybe_unused)
 {
     /* should insert the newcomer */
 }

-__used
+__maybe_unused
 static char sched_out_state(struct trace_switch_event *switch_event)
 {
     const char *str = TASK_STATE_TO_CHAR_STR;
@@ -957,7 +957,7 @@ add_sched_out_event(struct work_atoms *atoms,
 }

 static void
-add_runtime_event(struct work_atoms *atoms, u64 delta, u64 timestamp __used)
+add_runtime_event(struct work_atoms *atoms, u64 delta, u64 timestamp
__maybe_unused)
 {
     struct work_atom *atom;

@@ -1003,7 +1003,7 @@ add_sched_in_event(struct work_atoms *atoms, u64
timestamp)
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
              struct machine *machine,
-             struct event_format *event __used,
+             struct event_format *event __maybe_unused,
              struct perf_sample *sample)
 {
     struct work_atoms *out_events, *in_events;
@@ -1075,7 +1075,7 @@ latency_runtime_event(struct trace_runtime_event
*runtime_event,

 static void
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
-             struct machine *machine, struct event_format *event __used,
+             struct machine *machine, struct event_format *event
__maybe_unused,
              struct perf_sample *sample)
 {
     struct work_atoms *atoms;
@@ -1329,11 +1329,11 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;

 static void
-process_sched_wakeup_event(struct perf_tool *tool __used,
+process_sched_wakeup_event(struct perf_tool *tool __maybe_unused,
                struct event_format *event,
                struct perf_sample *sample,
                struct machine *machine,
-               struct thread *thread __used)
+               struct thread *thread __maybe_unused)
 {
     void *data = sample->raw_data;
     struct trace_wakeup_event wakeup_event;
@@ -1366,10 +1366,10 @@ static char next_shortname2 = '0';
 static void
 map_switch_event(struct trace_switch_event *switch_event,
          struct machine *machine,
-         struct event_format *event __used,
+         struct event_format *event __maybe_unused,
          struct perf_sample *sample)
 {
-    struct thread *sched_out __used, *sched_in;
+    struct thread *sched_out __maybe_unused, *sched_in;
     int new_shortname;
     u64 timestamp0, timestamp = sample->time;
     s64 delta;
@@ -1441,11 +1441,11 @@ map_switch_event(struct trace_switch_event
*switch_event,
 }

 static void
-process_sched_switch_event(struct perf_tool *tool __used,
+process_sched_switch_event(struct perf_tool *tool __maybe_unused,
                struct event_format *event,
                struct perf_sample *sample,
                struct machine *machine,
-               struct thread *thread __used)
+               struct thread *thread __maybe_unused)
 {
     int this_cpu = sample->cpu;
     void *data = sample->raw_data;
@@ -1476,11 +1476,11 @@ process_sched_switch_event(struct perf_tool
*tool __used,
 }

 static void
-process_sched_runtime_event(struct perf_tool *tool __used,
+process_sched_runtime_event(struct perf_tool *tool __maybe_unused,
                 struct event_format *event,
                 struct perf_sample *sample,
                 struct machine *machine,
-                struct thread *thread __used)
+                struct thread *thread __maybe_unused)
 {
     void *data = sample->raw_data;
     struct trace_runtime_event runtime_event;
@@ -1495,11 +1495,11 @@ process_sched_runtime_event(struct perf_tool
*tool __used,
 }

 static void
-process_sched_fork_event(struct perf_tool *tool __used,
+process_sched_fork_event(struct perf_tool *tool __maybe_unused,
              struct event_format *event,
              struct perf_sample *sample,
-             struct machine *machine __used,
-             struct thread *thread __used)
+             struct machine *machine __maybe_unused,
+             struct thread *thread __maybe_unused)
 {
     void *data = sample->raw_data;
     struct trace_fork_event fork_event;
@@ -1516,22 +1516,22 @@ process_sched_fork_event(struct perf_tool *tool __used,
 }

 static void
-process_sched_exit_event(struct perf_tool *tool __used,
+process_sched_exit_event(struct perf_tool *tool __maybe_unused,
              struct event_format *event,
-             struct perf_sample *sample __used,
-             struct machine *machine __used,
-             struct thread *thread __used)
+             struct perf_sample *sample __maybe_unused,
+             struct machine *machine __maybe_unused,
+             struct thread *thread __maybe_unused)
 {
     if (verbose)
         printf("sched_exit event %p\n", event);
 }

 static void
-process_sched_migrate_task_event(struct perf_tool *tool __used,
+process_sched_migrate_task_event(struct perf_tool *tool __maybe_unused,
                  struct event_format *event,
                  struct perf_sample *sample,
                  struct machine *machine,
-                 struct thread *thread __used)
+                 struct thread *thread __maybe_unused)
 {
     void *data = sample->raw_data;
     struct trace_migrate_task_event migrate_task_event;
@@ -1552,8 +1552,8 @@ typedef void (*tracepoint_handler)(struct
perf_tool *tool, struct event_format *
                    struct machine *machine,
                    struct thread *thread);

-static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
-                         union perf_event *event __used,
+static int perf_sched__process_tracepoint_sample(struct perf_tool
*tool __maybe_unused,
+                         union perf_event *event __maybe_unused,
                          struct perf_sample *sample,
                          struct perf_evsel *evsel,
                          struct machine *machine)
@@ -1841,7 +1841,7 @@ static int __cmd_record(int argc, const char **argv)
     return cmd_record(i, rec_argv, NULL);
 }

-int cmd_sched(int argc, const char **argv, const char *prefix __used)
+int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     argc = parse_options(argc, argv, sched_options, sched_usage,
                  PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2d6e3b2..0c248c6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -474,7 +474,7 @@ static int cleanup_scripting(void)

 static const char *input_name;

-static int process_sample_event(struct perf_tool *tool __used,
+static int process_sample_event(struct perf_tool *tool __maybe_unused,
                 union perf_event *event,
                 struct perf_sample *sample,
                 struct perf_evsel *evsel,
@@ -644,8 +644,8 @@ static void list_available_languages(void)
     fprintf(stderr, "\n");
 }

-static int parse_scriptname(const struct option *opt __used,
-                const char *str, int unset __used)
+static int parse_scriptname(const struct option *opt __maybe_unused,
+                const char *str, int unset __maybe_unused)
 {
     char spec[PATH_MAX];
     const char *script, *ext;
@@ -690,8 +690,8 @@ static int parse_scriptname(const struct option *opt __used,
     return 0;
 }

-static int parse_output_fields(const struct option *opt __used,
-                const char *arg, int unset __used)
+static int parse_output_fields(const struct option *opt __maybe_unused,
+                const char *arg, int unset __maybe_unused)
 {
     char *tok;
     int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
@@ -982,8 +982,8 @@ static char *get_script_root(struct dirent
*script_dirent, const char *suffix)
     return script_root;
 }

-static int list_available_scripts(const struct option *opt __used,
-                  const char *s __used, int unset __used)
+static int list_available_scripts(const struct option *opt __maybe_unused,
+                  const char *s __maybe_unused, int unset __maybe_unused)
 {
     struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
     char scripts_path[MAXPATHLEN];
@@ -1167,7 +1167,7 @@ static bool have_cmd(int argc, const char **argv)
     return argc != 0;
 }

-int cmd_script(int argc, const char **argv, const char *prefix __used)
+int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     char *rec_script_path = NULL;
     char *rep_script_path = NULL;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d53d8ab..bc1dad2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -417,7 +417,7 @@ static int read_counter(struct perf_evsel *counter)
     return 0;
 }

-static int run_perf_stat(int argc __used, const char **argv)
+static int run_perf_stat(int argc __maybe_unused, const char **argv)
 {
     unsigned long long t0, t1;
     struct perf_evsel *counter, *first;
@@ -633,7 +633,7 @@ static const char *get_ratio_color(enum grc_type
type, double ratio)
     return color;
 }

-static void print_stalled_cycles_frontend(int cpu, struct perf_evsel
*evsel __used, double avg)
+static void print_stalled_cycles_frontend(int cpu, struct perf_evsel
*evsel __maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -650,7 +650,7 @@ static void print_stalled_cycles_frontend(int cpu,
struct perf_evsel *evsel __us
     fprintf(output, " frontend cycles idle   ");
 }

-static void print_stalled_cycles_backend(int cpu, struct perf_evsel
*evsel __used, double avg)
+static void print_stalled_cycles_backend(int cpu, struct perf_evsel
*evsel __maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -667,7 +667,7 @@ static void print_stalled_cycles_backend(int cpu,
struct perf_evsel *evsel __use
     fprintf(output, " backend  cycles idle   ");
 }

-static void print_branch_misses(int cpu, struct perf_evsel *evsel
__used, double avg)
+static void print_branch_misses(int cpu, struct perf_evsel *evsel
__maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -684,7 +684,7 @@ static void print_branch_misses(int cpu, struct
perf_evsel *evsel __used, double
     fprintf(output, " of all branches        ");
 }

-static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel
__used, double avg)
+static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel
__maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -701,7 +701,7 @@ static void print_l1_dcache_misses(int cpu, struct
perf_evsel *evsel __used, dou
     fprintf(output, " of all L1-dcache hits  ");
 }

-static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel
__used, double avg)
+static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel
__maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -718,7 +718,7 @@ static void print_l1_icache_misses(int cpu, struct
perf_evsel *evsel __used, dou
     fprintf(output, " of all L1-icache hits  ");
 }

-static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel
__used, double avg)
+static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel
__maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -735,7 +735,7 @@ static void print_dtlb_cache_misses(int cpu,
struct perf_evsel *evsel __used, do
     fprintf(output, " of all dTLB cache hits ");
 }

-static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel
__used, double avg)
+static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel
__maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -752,7 +752,7 @@ static void print_itlb_cache_misses(int cpu,
struct perf_evsel *evsel __used, do
     fprintf(output, " of all iTLB cache hits ");
 }

-static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel
__used, double avg)
+static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel
__maybe_unused, double avg)
 {
     double total, ratio = 0.0;
     const char *color;
@@ -1058,8 +1058,8 @@ static const char * const stat_usage[] = {
     NULL
 };

-static int stat__set_big_num(const struct option *opt __used,
-                 const char *s __used, int unset)
+static int stat__set_big_num(const struct option *opt __maybe_unused,
+                 const char *s __maybe_unused, int unset)
 {
     big_num_opt = unset ? 0 : 1;
     return 0;
@@ -1153,7 +1153,7 @@ static int add_default_attributes(void)
     return perf_evlist__add_default_attrs(evsel_list,
very_very_detailed_attrs);
 }

-int cmd_stat(int argc, const char **argv, const char *prefix __used)
+int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     struct perf_evsel *pos;
     int status = -ENOMEM;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 381d5ab..de8e34d 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -18,7 +18,7 @@

 #include <sys/mman.h>

-static int vmlinux_matches_kallsyms_filter(struct map *map __used,
struct symbol *sym)
+static int vmlinux_matches_kallsyms_filter(struct map *map
__maybe_unused, struct symbol *sym)
 {
     bool *visited = symbol__priv(sym);
     *visited = true;
@@ -996,7 +996,7 @@ static u64 mmap_read_self(void *addr)
 /*
  * If the RDPMC instruction faults then signal this back to the test
parent task:
  */
-static void segfault_handler(int sig __used, siginfo_t *info __used,
void *uc __used)
+static void segfault_handler(int sig __maybe_unused, siginfo_t *info
__maybe_unused, void *uc __maybe_unused)
 {
     exit(-1);
 }
@@ -1199,7 +1199,7 @@ static int perf_test__list(int argc, const char **argv)
     return 0;
 }

-int cmd_test(int argc, const char **argv, const char *prefix __used)
+int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     const char * const test_usage[] = {
     "perf test [<options>] [{list
<test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]",
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3b75b2e..39b4827 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -275,28 +275,28 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];

-static int process_comm_event(struct perf_tool *tool __used,
+static int process_comm_event(struct perf_tool *tool __maybe_unused,
                   union perf_event *event,
-                  struct perf_sample *sample __used,
-                  struct machine *machine __used)
+                  struct perf_sample *sample __maybe_unused,
+                  struct machine *machine __maybe_unused)
 {
     pid_set_comm(event->comm.tid, event->comm.comm);
     return 0;
 }

-static int process_fork_event(struct perf_tool *tool __used,
+static int process_fork_event(struct perf_tool *tool __maybe_unused,
                   union perf_event *event,
-                  struct perf_sample *sample __used,
-                  struct machine *machine __used)
+                  struct perf_sample *sample __maybe_unused,
+                  struct machine *machine __maybe_unused)
 {
     pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
     return 0;
 }

-static int process_exit_event(struct perf_tool *tool __used,
+static int process_exit_event(struct perf_tool *tool __maybe_unused,
                   union perf_event *event,
-                  struct perf_sample *sample __used,
-                  struct machine *machine __used)
+                  struct perf_sample *sample __maybe_unused,
+                  struct machine *machine __maybe_unused)
 {
     pid_exit(event->fork.pid, event->fork.time);
     return 0;
@@ -491,11 +491,11 @@ static void sched_switch(int cpu, u64 timestamp,
struct trace_entry *te)
 }


-static int process_sample_event(struct perf_tool *tool __used,
-                union perf_event *event __used,
+static int process_sample_event(struct perf_tool *tool __maybe_unused,
+                union perf_event *event __maybe_unused,
                 struct perf_sample *sample,
                 struct perf_evsel *evsel,
-                struct machine *machine __used)
+                struct machine *machine __maybe_unused)
 {
     struct trace_entry *te;

@@ -1081,7 +1081,7 @@ static int __cmd_record(int argc, const char **argv)
 }

 static int
-parse_process(const struct option *opt __used, const char *arg, int
__used unset)
+parse_process(const struct option *opt __maybe_unused, const char
*arg, int __maybe_unused unset)
 {
     if (arg)
         add_process_filter(arg);
@@ -1106,7 +1106,7 @@ static const struct option options[] = {
 };


-int cmd_timechart(int argc, const char **argv, const char *prefix __used)
+int cmd_timechart(int argc, const char **argv, const char *prefix
__maybe_unused)
 {
     argc = parse_options(argc, argv, options, timechart_usage,
             PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0513aaa..ab0f316 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -95,7 +95,7 @@ static void perf_top__update_print_entries(struct
perf_top *top)
         top->print_entries -= 9;
 }

-static void perf_top__sig_winch(int sig __used, siginfo_t *info
__used, void *arg)
+static void perf_top__sig_winch(int sig __maybe_unused, siginfo_t
*info __maybe_unused, void *arg)
 {
     struct perf_top *top = arg;

@@ -663,7 +663,7 @@ static const char *skip_symbols[] = {
     NULL
 };

-static int symbol_filter(struct map *map __used, struct symbol *sym)
+static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 {
     const char *name = sym->name;
     int i;
@@ -1163,7 +1163,7 @@ static const char * const top_usage[] = {
     NULL
 };

-int cmd_top(int argc, const char **argv, const char *prefix __used)
+int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
     struct perf_evsel *pos;
     int status;
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 1818a53..f771468 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -269,7 +269,7 @@ int ui_browser__show(struct ui_browser *browser,
const char *title,
     return err ? 0 : -1;
 }

-void ui_browser__hide(struct ui_browser *browser __used)
+void ui_browser__hide(struct ui_browser *browser __maybe_unused)
 {
     pthread_mutex_lock(&ui__lock);
     ui_helpline__pop();
@@ -518,7 +518,7 @@ static struct ui_browser__colorset {


 static int ui_browser__color_config(const char *var, const char *value,
-                    void *data __used)
+                    void *data __maybe_unused)
 {
     char *fg = NULL, *bg;
     int i;
@@ -602,7 +602,7 @@ void __ui_browser__vline(struct ui_browser
*browser, unsigned int column,
     SLsmg_set_char_set(0);
 }

-void ui_browser__write_graph(struct ui_browser *browser __used, int graph)
+void ui_browser__write_graph(struct ui_browser *browser
__maybe_unused, int graph)
 {
     SLsmg_set_char_set(1);
     SLsmg_write_char(graph);
diff --git a/tools/perf/ui/browsers/annotate.c
b/tools/perf/ui/browsers/annotate.c
index 67a2703..e792f6f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -54,7 +54,7 @@ static inline struct browser_disasm_line
*disasm_line__browser(struct disasm_lin
     return (struct browser_disasm_line *)(dl + 1);
 }

-static bool disasm_line__filter(struct ui_browser *browser __used, void *entry)
+static bool disasm_line__filter(struct ui_browser *browser
__maybe_unused, void *entry)
 {
     if (annotate_browser__opts.hide_src_code) {
         struct disasm_line *dl = list_entry(entry, struct disasm_line, node);
@@ -928,7 +928,7 @@ static int annotate_config__cmp(const void *name,
const void *cfgp)
     return strcmp(name, cfg->name);
 }

-static int annotate__config(const char *var, const char *value, void
*data __used)
+static int annotate__config(const char *var, const char *value, void
*data __maybe_unused)
 {
     struct annotate__config *cfg;
     const char *name;
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 26b5b65..4cf765b 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -168,8 +168,8 @@ static GtkWidget *perf_gtk__setup_statusbar(void)

 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
                   const char *help,
-                  void (*timer) (void *arg)__used,
-                  void *arg __used, int delay_secs __used)
+                  void (*timer) (void *arg)__maybe_unused,
+                  void *arg __maybe_unused, int delay_secs __maybe_unused)
 {
     struct perf_evsel *pos;
     GtkWidget *vbox;
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index ec1ee26..a043ca0 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -11,7 +11,7 @@ int perf_gtk__init(void)
     return gtk_init_check(NULL, NULL) ? 0 : -1;
 }

-void perf_gtk__exit(bool wait_for_ok __used)
+void perf_gtk__exit(bool wait_for_ok __maybe_unused)
 {
     if (!perf_gtk__is_active_context(pgctx))
         return;
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index b8efb96..8aada5b 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -117,8 +117,8 @@ struct perf_error_ops perf_gtk_eops = {
  *        For now, just add stubs for NO_NEWT=1 build.
  */
 #ifdef NO_NEWT_SUPPORT
-void ui_progress__update(u64 curr __used, u64 total __used,
-             const char *title __used)
+void ui_progress__update(u64 curr __maybe_unused, u64 total __maybe_unused,
+             const char *title __maybe_unused)
 {
 }
 #endif
diff --git a/tools/perf/ui/helpline.c b/tools/perf/ui/helpline.c
index 78ba28a..a49bcf3 100644
--- a/tools/perf/ui/helpline.c
+++ b/tools/perf/ui/helpline.c
@@ -12,7 +12,7 @@ static void nop_helpline__pop(void)
 {
 }

-static void nop_helpline__push(const char *msg __used)
+static void nop_helpline__push(const char *msg __maybe_unused)
 {
 }

diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index a2487f9..2b667ee 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -24,8 +24,8 @@ void ui_helpline__puts(const char *msg);
 extern char ui_helpline__current[512];

 #ifdef NO_NEWT_SUPPORT
-static inline int ui_helpline__show_help(const char *format __used,
-                     va_list ap __used)
+static inline int ui_helpline__show_help(const char *format __maybe_unused,
+                     va_list ap __maybe_unused)
 {
     return 0;
 }
@@ -35,8 +35,8 @@ int ui_helpline__show_help(const char *format, va_list ap);
 #endif /* NO_NEWT_SUPPORT */

 #ifdef NO_GTK2_SUPPORT
-static inline int perf_gtk__show_helpline(const char *format __used,
-                      va_list ap __used)
+static inline int perf_gtk__show_helpline(const char *format __maybe_unused,
+                      va_list ap __maybe_unused)
 {
     return 0;
 }
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 4c936e0..7a29492 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -26,7 +26,7 @@ void ui__refresh_dimensions(bool force)
     }
 }

-static void ui__sigwinch(int sig __used)
+static void ui__sigwinch(int sig __maybe_unused)
 {
     ui__need_resize = 1;
 }
@@ -86,7 +86,7 @@ int ui__getch(int delay_secs)
     return SLkp_getkey();
 }

-static void newt_suspend(void *d __used)
+static void newt_suspend(void *d __maybe_unused)
 {
     newtSuspend();
     raise(SIGTSTP);
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index b8144e8..11b114f 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -3,7 +3,7 @@
 static const char *alias_key;
 static char *alias_val;

-static int alias_lookup_cb(const char *k, const char *v, void *cb __used)
+static int alias_lookup_cb(const char *k, const char *v, void *cb
__maybe_unused)
 {
     if (!prefixcmp(k, "alias.") && !strcmp(k+6, alias_key)) {
         if (!v)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3a282c0..a2a0ecd 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -312,8 +312,8 @@ static struct ins_ops dec_ops = {
     .scnprintf = dec__scnprintf,
 };

-static int nop__scnprintf(struct ins *ins __used, char *bf, size_t size,
-              struct ins_operands *ops __used)
+static int nop__scnprintf(struct ins *ins __maybe_unused, char *bf,
size_t size,
+              struct ins_operands *ops __maybe_unused)
 {
     return scnprintf(bf, size, "%-6.6s", "nop");
 }
@@ -415,7 +415,7 @@ static struct ins *ins__find(const char *name)
     return bsearch(name, instructions, nmemb, sizeof(struct ins), ins__cmp);
 }

-int symbol__annotate_init(struct map *map __used, struct symbol *sym)
+int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym)
 {
     struct annotation *notes = symbol__annotation(sym);
     pthread_mutex_init(&notes->lock, NULL);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 78a5692..d6f1b4b 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -125,7 +125,7 @@ int symbol__alloc_hist(struct symbol *sym);
 void symbol__annotate_zero_histograms(struct symbol *sym);

 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
-int symbol__annotate_init(struct map *map __used, struct symbol *sym);
+int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym);
 int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
                 bool full_paths, int min_pcnt, int max_lines,
                 int context);
@@ -138,11 +138,11 @@ int symbol__tty_annotate(struct symbol *sym,
struct map *map, int evidx,
              int max_lines);

 #ifdef NO_NEWT_SUPPORT
-static inline int symbol__tui_annotate(struct symbol *sym __used,
-                       struct map *map __used,
-                       int evidx __used,
-                       void(*timer)(void *arg) __used,
-                       void *arg __used, int delay_secs __used)
+static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
+                       struct map *map __maybe_unused,
+                       int evidx __maybe_unused,
+                       void(*timer)(void *arg) __maybe_unused,
+                       void *arg __maybe_unused, int delay_secs __maybe_unused)
 {
     return 0;
 }
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index fd9a594..0f51956 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -16,10 +16,10 @@
 #include "session.h"
 #include "tool.h"

-static int build_id__mark_dso_hit(struct perf_tool *tool __used,
+static int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
                   union perf_event *event,
-                  struct perf_sample *sample __used,
-                  struct perf_evsel *evsel __used,
+                  struct perf_sample *sample __maybe_unused,
+                  struct perf_evsel *evsel __maybe_unused,
                   struct machine *machine)
 {
     struct addr_location al;
@@ -41,9 +41,9 @@ static int build_id__mark_dso_hit(struct perf_tool
*tool __used,
     return 0;
 }

-static int perf_event__exit_del_thread(struct perf_tool *tool __used,
+static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
                        union perf_event *event,
-                       struct perf_sample *sample __used,
+                       struct perf_sample *sample __maybe_unused,
                        struct machine *machine)
 {
     struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index cff18c6..ab17694 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -39,7 +39,7 @@ static inline void setup_browser(bool fallback_to_pager)
     if (fallback_to_pager)
         setup_pager();
 }
-static inline void exit_browser(bool wait_for_ok __used) {}
+static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
 #else
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
@@ -49,7 +49,7 @@ static inline int ui__init(void)
 {
     return -1;
 }
-static inline void ui__exit(bool wait_for_ok __used) {}
+static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #else
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
@@ -60,7 +60,7 @@ static inline int perf_gtk__init(void)
 {
     return -1;
 }
-static inline void perf_gtk__exit(bool wait_for_ok __used) {}
+static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
 #else
 int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 3a6bff4..d3b3f5d 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -93,7 +93,7 @@ __sort_chain_flat(struct rb_root *rb_root, struct
callchain_node *node,
  */
 static void
 sort_chain_flat(struct rb_root *rb_root, struct callchain_root *root,
-        u64 min_hit, struct callchain_param *param __used)
+        u64 min_hit, struct callchain_param *param __maybe_unused)
 {
     __sort_chain_flat(rb_root, &root->node, min_hit);
 }
@@ -115,7 +115,7 @@ static void __sort_chain_graph_abs(struct
callchain_node *node,

 static void
 sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_root
*chain_root,
-             u64 min_hit, struct callchain_param *param __used)
+             u64 min_hit, struct callchain_param *param __maybe_unused)
 {
     __sort_chain_graph_abs(&chain_root->node, min_hit);
     rb_root->rb_node = chain_root->node.rb_root.rb_node;
@@ -140,7 +140,7 @@ static void __sort_chain_graph_rel(struct
callchain_node *node,

 static void
 sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_root
*chain_root,
-             u64 min_hit __used, struct callchain_param *param)
+             u64 min_hit __maybe_unused, struct callchain_param *param)
 {
     __sort_chain_graph_rel(&chain_root->node, param->min_percent / 100.0);
     rb_root->rb_node = chain_root->node.rb_root.rb_node;
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index dbe2f16..96bbda1 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -138,8 +138,8 @@ void close_cgroup(struct cgroup_sel *cgrp)
     }
 }

-int parse_cgroups(const struct option *opt __used, const char *str,
-          int unset __used)
+int parse_cgroups(const struct option *opt __maybe_unused, const char *str,
+          int unset __maybe_unused)
 {
     struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
     const char *p, *e, *eos = str + strlen(str);
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 6faa3a1..624ebcd 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -342,13 +342,13 @@ const char *perf_config_dirname(const char
*name, const char *value)
     return value;
 }

-static int perf_default_core_config(const char *var __used, const
char *value __used)
+static int perf_default_core_config(const char *var __maybe_unused,
const char *value __maybe_unused)
 {
     /* Add other config variables here. */
     return 0;
 }

-int perf_default_config(const char *var, const char *value, void *dummy __used)
+int perf_default_config(const char *var, const char *value, void
*dummy __maybe_unused)
 {
     if (!prefixcmp(var, "core."))
         return perf_default_core_config(var, value);
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 05e660c..c6f76ee 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -16,19 +16,19 @@ struct ui_progress;
 struct perf_error_ops;

 #if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
-static inline void ui_progress__update(u64 curr __used, u64 total __used,
-                       const char *title __used) {}
+static inline void ui_progress__update(u64 curr __maybe_unused, u64
total __maybe_unused,
+                       const char *title __maybe_unused) {}

 #define ui__error(format, arg...) ui__warning(format, ##arg)

 static inline int
-perf_error__register(struct perf_error_ops *eops __used)
+perf_error__register(struct perf_error_ops *eops __maybe_unused)
 {
     return 0;
 }

 static inline int
-perf_error__unregister(struct perf_error_ops *eops __used)
+perf_error__unregister(struct perf_error_ops *eops __maybe_unused)
 {
     return 0;
 }
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index aee4ddf..f8a7572 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -497,9 +497,9 @@ size_t perf_event__fprintf_comm(union perf_event
*event, FILE *fp)
     return fprintf(fp, ": %s:%d\n", event->comm.comm, event->comm.tid);
 }

-int perf_event__process_comm(struct perf_tool *tool __used,
+int perf_event__process_comm(struct perf_tool *tool __maybe_unused,
                  union perf_event *event,
-                 struct perf_sample *sample __used,
+                 struct perf_sample *sample __maybe_unused,
                  struct machine *machine)
 {
     struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
@@ -515,10 +515,10 @@ int perf_event__process_comm(struct perf_tool
*tool __used,
     return 0;
 }

-int perf_event__process_lost(struct perf_tool *tool __used,
+int perf_event__process_lost(struct perf_tool *tool __maybe_unused,
                  union perf_event *event,
-                 struct perf_sample *sample __used,
-                 struct machine *machine __used)
+                 struct perf_sample *sample __maybe_unused,
+                 struct machine *machine __maybe_unused)
 {
     dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
             event->lost.id, event->lost.lost);
@@ -538,7 +538,7 @@ static void perf_event__set_kernel_mmap_len(union
perf_event *event,
         maps[MAP__FUNCTION]->end = ~0ULL;
 }

-static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
+static int perf_event__process_kernel_mmap(struct perf_tool *tool
__maybe_unused,
                        union perf_event *event,
                        struct machine *machine)
 {
@@ -640,7 +640,7 @@ size_t perf_event__fprintf_mmap(union perf_event
*event, FILE *fp)

 int perf_event__process_mmap(struct perf_tool *tool,
                  union perf_event *event,
-                 struct perf_sample *sample __used,
+                 struct perf_sample *sample __maybe_unused,
                  struct machine *machine)
 {
     struct thread *thread;
@@ -684,9 +684,9 @@ size_t perf_event__fprintf_task(union perf_event
*event, FILE *fp)
                event->fork.ppid, event->fork.ptid);
 }

-int perf_event__process_task(struct perf_tool *tool __used,
+int perf_event__process_task(struct perf_tool *tool __maybe_unused,
                  union perf_event *event,
-                 struct perf_sample *sample __used,
+                 struct perf_sample *sample __maybe_unused,
                   struct machine *machine)
 {
     struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7f8631f..5748509 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -446,7 +446,7 @@ static bool perf_session__read_build_ids(struct
perf_session *session, bool with
     return ret;
 }

-static int write_tracing_data(int fd, struct perf_header *h __used,
+static int write_tracing_data(int fd, struct perf_header *h __maybe_unused,
                 struct perf_evlist *evlist)
 {
     return read_tracing_data(fd, &evlist->entries);
@@ -454,7 +454,7 @@ static int write_tracing_data(int fd, struct
perf_header *h __used,


 static int write_build_id(int fd, struct perf_header *h,
-              struct perf_evlist *evlist __used)
+              struct perf_evlist *evlist __maybe_unused)
 {
     struct perf_session *session;
     int err;
@@ -475,8 +475,8 @@ static int write_build_id(int fd, struct perf_header *h,
     return 0;
 }

-static int write_hostname(int fd, struct perf_header *h __used,
-              struct perf_evlist *evlist __used)
+static int write_hostname(int fd, struct perf_header *h __maybe_unused,
+              struct perf_evlist *evlist __maybe_unused)
 {
     struct utsname uts;
     int ret;
@@ -488,8 +488,8 @@ static int write_hostname(int fd, struct
perf_header *h __used,
     return do_write_string(fd, uts.nodename);
 }

-static int write_osrelease(int fd, struct perf_header *h __used,
-               struct perf_evlist *evlist __used)
+static int write_osrelease(int fd, struct perf_header *h __maybe_unused,
+               struct perf_evlist *evlist __maybe_unused)
 {
     struct utsname uts;
     int ret;
@@ -501,8 +501,8 @@ static int write_osrelease(int fd, struct
perf_header *h __used,
     return do_write_string(fd, uts.release);
 }

-static int write_arch(int fd, struct perf_header *h __used,
-              struct perf_evlist *evlist __used)
+static int write_arch(int fd, struct perf_header *h __maybe_unused,
+              struct perf_evlist *evlist __maybe_unused)
 {
     struct utsname uts;
     int ret;
@@ -514,14 +514,14 @@ static int write_arch(int fd, struct perf_header
*h __used,
     return do_write_string(fd, uts.machine);
 }

-static int write_version(int fd, struct perf_header *h __used,
-             struct perf_evlist *evlist __used)
+static int write_version(int fd, struct perf_header *h __maybe_unused,
+             struct perf_evlist *evlist __maybe_unused)
 {
     return do_write_string(fd, perf_version_string);
 }

-static int write_cpudesc(int fd, struct perf_header *h __used,
-               struct perf_evlist *evlist __used)
+static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
+               struct perf_evlist *evlist __maybe_unused)
 {
 #ifndef CPUINFO_PROC
 #define CPUINFO_PROC NULL
@@ -579,8 +579,8 @@ done:
     return ret;
 }

-static int write_nrcpus(int fd, struct perf_header *h __used,
-            struct perf_evlist *evlist __used)
+static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
+            struct perf_evlist *evlist __maybe_unused)
 {
     long nr;
     u32 nrc, nra;
@@ -605,7 +605,7 @@ static int write_nrcpus(int fd, struct perf_header
*h __used,
     return do_write(fd, &nra, sizeof(nra));
 }

-static int write_event_desc(int fd, struct perf_header *h __used,
+static int write_event_desc(int fd, struct perf_header *h __maybe_unused,
                 struct perf_evlist *evlist)
 {
     struct perf_evsel *evsel;
@@ -663,8 +663,8 @@ static int write_event_desc(int fd, struct
perf_header *h __used,
     return 0;
 }

-static int write_cmdline(int fd, struct perf_header *h __used,
-             struct perf_evlist *evlist __used)
+static int write_cmdline(int fd, struct perf_header *h __maybe_unused,
+             struct perf_evlist *evlist __maybe_unused)
 {
     char buf[MAXPATHLEN];
     char proc[32];
@@ -832,8 +832,8 @@ static struct cpu_topo *build_cpu_topology(void)
     return tp;
 }

-static int write_cpu_topology(int fd, struct perf_header *h __used,
-              struct perf_evlist *evlist __used)
+static int write_cpu_topology(int fd, struct perf_header *h __maybe_unused,
+              struct perf_evlist *evlist __maybe_unused)
 {
     struct cpu_topo *tp;
     u32 i;
@@ -868,8 +868,8 @@ done:



-static int write_total_mem(int fd, struct perf_header *h __used,
-              struct perf_evlist *evlist __used)
+static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
+              struct perf_evlist *evlist __maybe_unused)
 {
     char *buf = NULL;
     FILE *fp;
@@ -954,8 +954,8 @@ done:
     return ret;
 }

-static int write_numa_topology(int fd, struct perf_header *h __used,
-              struct perf_evlist *evlist __used)
+static int write_numa_topology(int fd, struct perf_header *h __maybe_unused,
+              struct perf_evlist *evlist __maybe_unused)
 {
     char *buf = NULL;
     size_t len = 0;
@@ -1007,13 +1007,13 @@ done:
  * default get_cpuid(): nothing gets recorded
  * actual implementation must be in arch/$(ARCH)/util/header.c
  */
-int __attribute__((weak)) get_cpuid(char *buffer __used, size_t sz __used)
+int __attribute__((weak)) get_cpuid(char *buffer __maybe_unused,
size_t sz __maybe_unused)
 {
     return -1;
 }

-static int write_cpuid(int fd, struct perf_header *h __used,
-               struct perf_evlist *evlist __used)
+static int write_cpuid(int fd, struct perf_header *h __maybe_unused,
+               struct perf_evlist *evlist __maybe_unused)
 {
     char buffer[64];
     int ret;
@@ -1027,8 +1027,8 @@ write_it:
     return do_write_string(fd, buffer);
 }

-static int write_branch_stack(int fd __used, struct perf_header *h __used,
-               struct perf_evlist *evlist __used)
+static int write_branch_stack(int fd __maybe_unused, struct
perf_header *h __maybe_unused,
+               struct perf_evlist *evlist __maybe_unused)
 {
     return 0;
 }
@@ -1253,7 +1253,7 @@ error:
     fprintf(fp, "# event desc: not available or unable to read\n");
 }

-static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
+static void print_total_mem(struct perf_header *h __maybe_unused, int
fd, FILE *fp)
 {
     uint64_t mem;
     ssize_t ret;
@@ -1271,7 +1271,7 @@ error:
     fprintf(fp, "# total memory : unknown\n");
 }

-static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
+static void print_numa_topology(struct perf_header *h __maybe_unused,
int fd, FILE *fp)
 {
     ssize_t ret;
     u32 nr, c, i;
@@ -1331,7 +1331,7 @@ static void print_cpuid(struct perf_header *ph,
int fd, FILE *fp)
     free(str);
 }

-static void print_branch_stack(struct perf_header *ph __used, int fd __used,
+static void print_branch_stack(struct perf_header *ph __maybe_unused,
int fd __maybe_unused,
                    FILE *fp)
 {
     fprintf(fp, "# contains samples with branch stack\n");
@@ -1497,7 +1497,7 @@ static int process_tracing_data(struct
perf_file_section *section __unused,

 static int process_build_id(struct perf_file_section *section,
                 struct perf_header *ph,
-                int feat __unused, int fd, void *data __used)
+                int feat __unused, int fd, void *data __maybe_unused)
 {
     if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
         pr_debug("Failed to read buildids, continuing...\n");
@@ -2394,7 +2394,7 @@ int perf_event__synthesize_tracing_data(struct
perf_tool *tool, int fd,
     union perf_event ev;
     struct tracing_data *tdata;
     ssize_t size = 0, aligned_size = 0, padding;
-    int err __used = 0;
+    int err __maybe_unused = 0;

     /*
      * We are going to store the size of the data followed
@@ -2492,7 +2492,7 @@ int perf_event__synthesize_build_id(struct
perf_tool *tool,
     return err;
 }

-int perf_event__process_build_id(struct perf_tool *tool __used,
+int perf_event__process_build_id(struct perf_tool *tool __maybe_unused,
                  union perf_event *event,
                  struct perf_session *session)
 {
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 4fa764d..8016975 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -332,7 +332,7 @@ const char *help_unknown_cmd(const char *cmd)
     exit(1);
 }

-int cmd_version(int argc __used, const char **argv __used, const char
*prefix __used)
+int cmd_version(int argc __maybe_unused, const char **argv
__maybe_unused, const char *prefix __maybe_unused)
 {
     printf("perf version %s\n", perf_version_string);
     return 0;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b1817f1..c48cb2c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -394,7 +394,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */

-static bool hists__collapse_insert_entry(struct hists *hists __used,
+static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
                      struct rb_root *root,
                      struct hist_entry *he)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2e650ff..991daa9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,20 +119,20 @@ struct perf_evlist;

 #ifdef NO_NEWT_SUPPORT
 static inline
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
-                  const char *help __used,
-                  void(*timer)(void *arg) __used,
-                  void *arg __used,
-                  int refresh __used)
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
+                  const char *help __maybe_unused,
+                  void(*timer)(void *arg) __maybe_unused,
+                  void *arg __maybe_unused,
+                  int refresh __maybe_unused)
 {
     return 0;
 }

-static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
-                       int evidx __used,
-                       void(*timer)(void *arg) __used,
-                       void *arg __used,
-                       int delay_secs __used)
+static inline int hist_entry__tui_annotate(struct hist_entry *self
__maybe_unused,
+                       int evidx __maybe_unused,
+                       void(*timer)(void *arg) __maybe_unused,
+                       void *arg __maybe_unused,
+                       int delay_secs __maybe_unused)
 {
     return 0;
 }
@@ -150,11 +150,11 @@ int perf_evlist__tui_browse_hists(struct
perf_evlist *evlist, const char *help,

 #ifdef NO_GTK2_SUPPORT
 static inline
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __used,
-                  const char *help __used,
-                  void(*timer)(void *arg) __used,
-                  void *arg __used,
-                  int refresh __used)
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
+                  const char *help __maybe_unused,
+                  void(*timer)(void *arg) __maybe_unused,
+                  void *arg __maybe_unused,
+                  int refresh __maybe_unused)
 {
     return 0;
 }
diff --git a/tools/perf/util/include/linux/compiler.h
b/tools/perf/util/include/linux/compiler.h
index ce2367b..0a8b0c5 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -9,7 +9,7 @@
 #define __attribute_const__
 #endif

-#define __used        __attribute__((__unused__))
+#define __maybe_unused        __attribute__((__unused__))
 #define __packed    __attribute__((__packed__))

 #ifndef __force
diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index fd530dc..ccb84d6 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -11,7 +11,7 @@

 #include "intlist.h"

-static struct rb_node *intlist__node_new(struct rblist *rblist __used,
+static struct rb_node *intlist__node_new(struct rblist *rblist __maybe_unused,
                      const void *entry)
 {
     int i = (int)((long)entry);
@@ -31,7 +31,7 @@ static void int_node__delete(struct int_node *ilist)
     free(ilist);
 }

-static void intlist__node_delete(struct rblist *rblist __used,
+static void intlist__node_delete(struct rblist *rblist __maybe_unused,
                  struct rb_node *rb_node)
 {
     struct int_node *node = container_of(rb_node, struct int_node, rb_node);
@@ -52,7 +52,7 @@ int intlist__add(struct intlist *ilist, int i)
     return rblist__add_node(&ilist->rblist, (void *)((long)i));
 }

-void intlist__remove(struct intlist *ilist __used, struct int_node *node)
+void intlist__remove(struct intlist *ilist __maybe_unused, struct
int_node *node)
 {
     int_node__delete(node);
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 25ab4cd..d2250fc 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -96,7 +96,7 @@ static inline u64 map__unmap_ip(struct map *map, u64 ip)
     return ip + map->start - map->pgoff;
 }

-static inline u64 identity__map_ip(struct map *map __used, u64 ip)
+static inline u64 identity__map_ip(struct map *map __maybe_unused, u64 ip)
 {
     return ip;
 }
diff --git a/tools/perf/util/parse-events-test.c
b/tools/perf/util/parse-events-test.c
index bf055ce..a7b05c0 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -568,7 +568,7 @@ static int test__group2(struct perf_evlist *evlist)
     return 0;
 }

-static int test__group3(struct perf_evlist *evlist __used)
+static int test__group3(struct perf_evlist *evlist __maybe_unused)
 {
     struct perf_evsel *evsel, *leader;

@@ -647,7 +647,7 @@ static int test__group3(struct perf_evlist *evlist __used)
     return 0;
 }

-static int test__group4(struct perf_evlist *evlist __used)
+static int test__group4(struct perf_evlist *evlist __maybe_unused)
 {
     struct perf_evsel *evsel, *leader;

@@ -683,7 +683,7 @@ static int test__group4(struct perf_evlist *evlist __used)
     return 0;
 }

-static int test__group5(struct perf_evlist *evlist __used)
+static int test__group5(struct perf_evlist *evlist __maybe_unused)
 {
     struct perf_evsel *evsel, *leader;

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 925784a..2747601 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -795,7 +795,7 @@ int parse_events_terms(struct list_head *terms,
const char *str)
     return ret;
 }

-int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
+int parse_events(struct perf_evlist *evlist, const char *str, int
unset __maybe_unused)
 {
     struct parse_events_data__events data = {
         .list = LIST_HEAD_INIT(data.list),
@@ -821,14 +821,14 @@ int parse_events(struct perf_evlist *evlist,
const char *str, int unset __used)
 }

 int parse_events_option(const struct option *opt, const char *str,
-            int unset __used)
+            int unset __maybe_unused)
 {
     struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
     return parse_events(evlist, str, unset);
 }

 int parse_filter(const struct option *opt, const char *str,
-         int unset __used)
+         int unset __maybe_unused)
 {
     struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
     struct perf_evsel *last = NULL;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 73d123b..9127e31b 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -178,7 +178,7 @@ r{num_raw_hex}        { return raw(yyscanner); }

 %%

-int parse_events_wrap(void *scanner __used)
+int parse_events_wrap(void *scanner __maybe_unused)
 {
     return 1;
 }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 66850f8..58aa946 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -375,7 +375,7 @@ sep_slash_dc: '/' | ':' |

 %%

-void parse_events_error(void *data __used, void *scanner __used,
-            char const *msg __used)
+void parse_events_error(void *data __maybe_unused, void *scanner
__maybe_unused,
+            char const *msg __maybe_unused)
 {
 }
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 594f8fa..0e84432 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -557,7 +557,7 @@ int parse_options_usage(const char * const *usagestr,
 }


-int parse_opt_verbosity_cb(const struct option *opt, const char *arg __used,
+int parse_opt_verbosity_cb(const struct option *opt, const char *arg
__maybe_unused,
                int unset)
 {
     int *target = opt->value;
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 9bd6c4e..316dbe7 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -6,7 +6,7 @@
 #else
 #define PERF_REGS_MASK    0

-static inline const char *perf_reg_name(int id __used)
+static inline const char *perf_reg_name(int id __maybe_unused)
 {
     return NULL;
 }
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index 20ea77e..ec89804 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -86,8 +86,8 @@ PP_VALUE

 %%

-void perf_pmu_error(struct list_head *list __used,
-            char *name __used,
-            char const *msg __used)
+void perf_pmu_error(struct list_head *list __maybe_unused,
+            char *name __maybe_unused,
+            char const *msg __maybe_unused)
 {
 }
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d448984..526ba56 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -207,7 +207,7 @@ static int
debuginfo__init_online_kernel_dwarf(struct debuginfo *self,
 #else
 /* With older elfutils, this just support kernel module... */
 static int debuginfo__init_online_kernel_dwarf(struct debuginfo *self,
-                           Dwarf_Addr addr __used)
+                           Dwarf_Addr addr __maybe_unused)
 {
     const char *path = kernel_get_module_path("kernel");

@@ -1419,7 +1419,7 @@ static int line_range_add_line(const char *src,
unsigned int lineno,
 }

 static int line_range_walk_cb(const char *fname, int lineno,
-                  Dwarf_Addr addr __used,
+                  Dwarf_Addr addr __maybe_unused,
                   void *data)
 {
     struct line_finder *lf = data;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 27187f0..894b76a 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -672,7 +672,7 @@ struct pyrf_evlist {
 };

 static int pyrf_evlist__init(struct pyrf_evlist *pevlist,
-                 PyObject *args, PyObject *kwargs __used)
+                 PyObject *args, PyObject *kwargs __maybe_unused)
 {
     PyObject *pcpus = NULL, *pthreads = NULL;
     struct cpu_map *cpus;
@@ -733,7 +733,7 @@ static PyObject *pyrf_evlist__poll(struct
pyrf_evlist *pevlist,
 }

 static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
-                     PyObject *args __used, PyObject *kwargs __used)
+                     PyObject *args __maybe_unused, PyObject *kwargs
__maybe_unused)
 {
     struct perf_evlist *evlist = &pevlist->evlist;
         PyObject *list = PyList_New(0);
@@ -765,7 +765,7 @@ free_list:


 static PyObject *pyrf_evlist__add(struct pyrf_evlist *pevlist,
-                  PyObject *args, PyObject *kwargs __used)
+                  PyObject *args, PyObject *kwargs __maybe_unused)
 {
     struct perf_evlist *evlist = &pevlist->evlist;
     PyObject *pevsel;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d6d571b..71e984d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -394,49 +394,49 @@ int machine__resolve_callchain(struct machine *machine,

 }

-static int process_event_synth_tracing_data_stub(union perf_event
*event __used,
-                         struct perf_session *session __used)
+static int process_event_synth_tracing_data_stub(union perf_event
*event __maybe_unused,
+                         struct perf_session *session __maybe_unused)
 {
     dump_printf(": unhandled!\n");
     return 0;
 }

-static int process_event_synth_attr_stub(union perf_event *event __used,
-                     struct perf_evlist **pevlist __used)
+static int process_event_synth_attr_stub(union perf_event *event
__maybe_unused,
+                     struct perf_evlist **pevlist __maybe_unused)
 {
     dump_printf(": unhandled!\n");
     return 0;
 }

-static int process_event_sample_stub(struct perf_tool *tool __used,
-                     union perf_event *event __used,
-                     struct perf_sample *sample __used,
-                     struct perf_evsel *evsel __used,
-                     struct machine *machine __used)
+static int process_event_sample_stub(struct perf_tool *tool __maybe_unused,
+                     union perf_event *event __maybe_unused,
+                     struct perf_sample *sample __maybe_unused,
+                     struct perf_evsel *evsel __maybe_unused,
+                     struct machine *machine __maybe_unused)
 {
     dump_printf(": unhandled!\n");
     return 0;
 }

-static int process_event_stub(struct perf_tool *tool __used,
-                  union perf_event *event __used,
-                  struct perf_sample *sample __used,
-                  struct machine *machine __used)
+static int process_event_stub(struct perf_tool *tool __maybe_unused,
+                  union perf_event *event __maybe_unused,
+                  struct perf_sample *sample __maybe_unused,
+                  struct machine *machine __maybe_unused)
 {
     dump_printf(": unhandled!\n");
     return 0;
 }

-static int process_finished_round_stub(struct perf_tool *tool __used,
-                       union perf_event *event __used,
-                       struct perf_session *perf_session __used)
+static int process_finished_round_stub(struct perf_tool *tool __maybe_unused,
+                       union perf_event *event __maybe_unused,
+                       struct perf_session *perf_session __maybe_unused)
 {
     dump_printf(": unhandled!\n");
     return 0;
 }

-static int process_event_type_stub(struct perf_tool *tool __used,
-                   union perf_event *event __used)
+static int process_event_type_stub(struct perf_tool *tool __maybe_unused,
+                   union perf_event *event __maybe_unused)
 {
     dump_printf(": unhandled!\n");
     return 0;
@@ -513,7 +513,7 @@ static void swap_sample_id_all(union perf_event
*event, void *data)
 }

 static void perf_event__all64_swap(union perf_event *event,
-                   bool sample_id_all __used)
+                   bool sample_id_all __maybe_unused)
 {
     struct perf_event_header *hdr = &event->header;
     mem_bswap_64(hdr + 1, event->header.size - sizeof(*hdr));
@@ -624,7 +624,7 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 }

 static void perf_event__hdr_attr_swap(union perf_event *event,
-                      bool sample_id_all __used)
+                      bool sample_id_all __maybe_unused)
 {
     size_t size;

@@ -636,14 +636,14 @@ static void perf_event__hdr_attr_swap(union
perf_event *event,
 }

 static void perf_event__event_type_swap(union perf_event *event,
-                    bool sample_id_all __used)
+                    bool sample_id_all __maybe_unused)
 {
     event->event_type.event_type.event_id =
         bswap_64(event->event_type.event_type.event_id);
 }

 static void perf_event__tracing_data_swap(union perf_event *event,
-                      bool sample_id_all __used)
+                      bool sample_id_all __maybe_unused)
 {
     event->tracing_data.size = bswap_32(event->tracing_data.size);
 }
@@ -779,7 +779,7 @@ static void flush_sample_queue(struct perf_session *s,
  *      etc...
  */
 static int process_finished_round(struct perf_tool *tool,
-                  union perf_event *event __used,
+                  union perf_event *event __maybe_unused,
                   struct perf_session *session)
 {
     flush_sample_queue(session, tool);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0f5a0a4..b40b670 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -172,7 +172,7 @@ static int hist_entry__dso_snprintf(struct
hist_entry *self, char *bf,

 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
                      u64 ip, char level, char *bf, size_t size,
-                     unsigned int width __used)
+                     unsigned int width __maybe_unused)
 {
     size_t ret = 0;

@@ -207,7 +207,7 @@ struct sort_entry sort_dso = {
 };

 static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-                    size_t size, unsigned int width __used)
+                    size_t size, unsigned int width __maybe_unused)
 {
     return _hist_entry__sym_snprintf(self->ms.map, self->ms.sym, self->ip,
                      self->level, bf, size, width);
@@ -250,7 +250,7 @@ sort__srcline_cmp(struct hist_entry *left, struct
hist_entry *right)
 }

 static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
-                   size_t size, unsigned int width __used)
+                   size_t size, unsigned int width __maybe_unused)
 {
     FILE *fp;
     char cmd[PATH_MAX + 2], *path = self->srcline, *nl;
@@ -399,7 +399,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct
hist_entry *right)
 }

 static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
-                    size_t size, unsigned int width __used)
+                    size_t size, unsigned int width __maybe_unused)
 {
     struct addr_map_symbol *from = &self->branch_info->from;
     return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
@@ -408,7 +408,7 @@ static int hist_entry__sym_from_snprintf(struct
hist_entry *self, char *bf,
 }

 static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
-                    size_t size, unsigned int width __used)
+                    size_t size, unsigned int width __maybe_unused)
 {
     struct addr_map_symbol *to = &self->branch_info->to;
     return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 6738ea1..42225da 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -69,8 +69,8 @@ static int read_build_id(void *note_data, size_t
note_len, void *bf,
     return -1;
 }

-int filename__read_debuglink(const char *filename __used,
-                 char *debuglink __used, size_t size __used)
+int filename__read_debuglink(const char *filename __maybe_unused,
+                 char *debuglink __maybe_unused, size_t size __maybe_unused)
 {
     return -1;
 }
@@ -241,7 +241,7 @@ out:
     return ret;
 }

-int symsrc__init(struct symsrc *ss, struct dso *dso __used, const char *name,
+int symsrc__init(struct symsrc *ss, struct dso *dso __maybe_unused,
const char *name,
              enum dso_binary_type type)
 {
     int fd = open(name, O_RDONLY);
@@ -260,13 +260,13 @@ out_close:
     return -1;
 }

-bool symsrc__possibly_runtime(struct symsrc *ss __used)
+bool symsrc__possibly_runtime(struct symsrc *ss __maybe_unused)
 {
     /* Assume all sym sources could be a runtime image. */
     return true;
 }

-bool symsrc__has_symtab(struct symsrc *ss __used)
+bool symsrc__has_symtab(struct symsrc *ss __maybe_unused)
 {
     return false;
 }
@@ -277,17 +277,17 @@ void symsrc__destroy(struct symsrc *ss)
     close(ss->fd);
 }

-int dso__synthesize_plt_symbols(struct dso *dso __used,
-                struct symsrc *ss __used,
-                struct map *map __used,
-                symbol_filter_t filter __used)
+int dso__synthesize_plt_symbols(struct dso *dso __maybe_unused,
+                struct symsrc *ss __maybe_unused,
+                struct map *map __maybe_unused,
+                symbol_filter_t filter __maybe_unused)
 {
     return 0;
 }

-int dso__load_sym(struct dso *dso, struct map *map __used, struct symsrc *ss,
-          struct symsrc *runtime_ss __used,
-          symbol_filter_t filter __used, int kmodule __used)
+int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
struct symsrc *ss,
+          struct symsrc *runtime_ss __maybe_unused,
+          symbol_filter_t filter __maybe_unused, int kmodule __maybe_unused)
 {
     unsigned char *build_id[BUILD_ID_SIZE];

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ba85d4f..b70a401 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1755,7 +1755,7 @@ struct process_args {
 };

 static int symbol__in_kernel(void *arg, const char *name,
-                 char type __used, u64 start)
+                 char type __maybe_unused, u64 start)
 {
     struct process_args *args = arg;

diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d3b330c..9437d65 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -23,14 +23,14 @@
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);

-static inline char *bfd_demangle(void __used *v, const char *c, int i)
+static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
 {
     return cplus_demangle(c, i);
 }
 #else
 #ifdef NO_DEMANGLE
-static inline char *bfd_demangle(void __used *v, const char __used *c,
-                 int __used i)
+static inline char *bfd_demangle(void __maybe_unused *v, const char
__maybe_unused *c,
+                 int __maybe_unused i)
 {
     return NULL;
 }
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 00a42aa..de4b4d4 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -307,32 +307,32 @@ find_proc_info(unw_addr_space_t as, unw_word_t
ip, unw_proc_info_t *pi,
                      need_unwind_info, arg);
 }

-static int access_fpreg(unw_addr_space_t __used as, unw_regnum_t __used num,
-            unw_fpreg_t __used *val, int __used __write,
-            void __used *arg)
+static int access_fpreg(unw_addr_space_t __maybe_unused as,
unw_regnum_t __maybe_unused num,
+            unw_fpreg_t __maybe_unused *val, int __maybe_unused __write,
+            void __maybe_unused *arg)
 {
     pr_err("unwind: access_fpreg unsupported\n");
     return -UNW_EINVAL;
 }

-static int get_dyn_info_list_addr(unw_addr_space_t __used as,
-                  unw_word_t __used *dil_addr,
-                  void __used *arg)
+static int get_dyn_info_list_addr(unw_addr_space_t __maybe_unused as,
+                  unw_word_t __maybe_unused *dil_addr,
+                  void __maybe_unused *arg)
 {
     return -UNW_ENOINFO;
 }

-static int resume(unw_addr_space_t __used as, unw_cursor_t __used *cu,
-          void __used *arg)
+static int resume(unw_addr_space_t __maybe_unused as, unw_cursor_t
__maybe_unused *cu,
+          void __maybe_unused *arg)
 {
     pr_err("unwind: resume unsupported\n");
     return -UNW_EINVAL;
 }

 static int
-get_proc_name(unw_addr_space_t __used as, unw_word_t __used addr,
-        char __used *bufp, size_t __used buf_len,
-        unw_word_t __used *offp, void __used *arg)
+get_proc_name(unw_addr_space_t __maybe_unused as, unw_word_t
__maybe_unused addr,
+        char __maybe_unused *bufp, size_t __maybe_unused buf_len,
+        unw_word_t __maybe_unused *offp, void __maybe_unused *arg)
 {
     pr_err("unwind: get_proc_name unsupported\n");
     return -UNW_EINVAL;
@@ -377,7 +377,7 @@ static int reg_value(unw_word_t *valp, struct
regs_dump *regs, int id,
     return 0;
 }

-static int access_mem(unw_addr_space_t __used as,
+static int access_mem(unw_addr_space_t __maybe_unused as,
               unw_word_t addr, unw_word_t *valp,
               int __write, void *arg)
 {
@@ -422,7 +422,7 @@ static int access_mem(unw_addr_space_t __used as,
     return 0;
 }

-static int access_reg(unw_addr_space_t __used as,
+static int access_reg(unw_addr_space_t __maybe_unused as,
               unw_regnum_t regnum, unw_word_t *valp,
               int __write, void *arg)
 {
@@ -454,9 +454,9 @@ static int access_reg(unw_addr_space_t __used as,
     return 0;
 }

-static void put_unwind_info(unw_addr_space_t __used as,
-                unw_proc_info_t *pi __used,
-                void *arg __used)
+static void put_unwind_info(unw_addr_space_t __maybe_unused as,
+                unw_proc_info_t *pi __maybe_unused,
+                void *arg __maybe_unused)
 {
     pr_debug("unwind: put_unwind_info called\n");
 }
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index 919bd6a..eec477d 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -22,11 +22,11 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 int unwind__arch_reg_id(int regnum);
 #else
 static inline int
-unwind__get_entries(unwind_entry_cb_t cb __used, void *arg __used,
-            struct machine *machine __used,
-            struct thread *thread __used,
-            u64 sample_uregs __used,
-            struct perf_sample *data __used)
+unwind__get_entries(unwind_entry_cb_t cb __maybe_unused, void *arg
__maybe_unused,
+            struct machine *machine __maybe_unused,
+            struct thread *thread __maybe_unused,
+            u64 sample_uregs __maybe_unused,
+            struct perf_sample *data __maybe_unused)
 {
     return 0;
 }
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 73e900e..1ff1b0c 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -7,7 +7,7 @@
  * There's no pack memory to release - but stay close to the Git
  * version so wrap this away:
  */
-static inline void release_pack_memory(size_t size __used, int flag __used)
+static inline void release_pack_memory(size_t size __maybe_unused,
int flag __maybe_unused)
 {
 }

--
1.7.9.5
