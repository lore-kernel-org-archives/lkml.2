Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab1ESNta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:49:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:35793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921Ab1ESNt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:49:28 -0400
Date: Thu, 19 May 2011 13:48:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-to3kgu04449s64062val8b62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add -d -d and -d -d -d options to show more CPU events
Git-Commit-ID: 2cba3ffb9a9db3874304a1739002d053d53c738b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 May 2011 13:48:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cba3ffb9a9db3874304a1739002d053d53c738b
Gitweb:     http://git.kernel.org/tip/2cba3ffb9a9db3874304a1739002d053d53c738b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 19 May 2011 13:30:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 May 2011 14:29:51 +0200

perf stat: Add -d -d and -d -d -d options to show more CPU events

Print even more detailed statistics if requested via perf stat -d:

       -d:          detailed events, L1 and LLC data cache
    -d -d:     more detailed events, dTLB and iTLB events
 -d -d -d:     very detailed events, adding prefetch events

Full output looks like this now:

 Performance counter stats for '/home/mingo/hackbench 10' (5 runs):

       1703.674707 task-clock                #    8.709 CPUs utilized            ( +-  4.19% )
            49,068 context-switches          #    0.029 M/sec                    ( +- 16.66% )
             8,303 CPU-migrations            #    0.005 M/sec                    ( +- 24.90% )
            17,397 page-faults               #    0.010 M/sec                    ( +-  0.46% )
     2,345,389,239 cycles                    #    1.377 GHz                      ( +-  4.61% ) [55.90%]
     1,884,503,527 stalled-cycles-frontend   #   80.35% frontend cycles idle     ( +-  5.67% ) [50.39%]
       743,919,737 stalled-cycles-backend    #   31.72% backend  cycles idle     ( +-  8.75% ) [49.91%]
     1,314,416,379 instructions              #    0.56  insns per cycle
                                             #    1.43  stalled cycles per insn  ( +-  2.53% ) [60.87%]
       272,592,567 branches                  #  160.003 M/sec                    ( +-  1.74% ) [56.56%]
         3,794,846 branch-misses             #    1.39% of all branches          ( +-  6.59% ) [58.50%]
       449,982,778 L1-dcache-loads           #  264.125 M/sec                    ( +-  2.47% ) [49.88%]
        22,404,961 L1-dcache-load-misses     #    4.98% of all L1-dcache hits    ( +-  6.08% ) [55.05%]
         6,204,750 LLC-loads                 #    3.642 M/sec                    ( +-  8.91% ) [43.75%]
         1,837,411 LLC-load-misses           #    1.078 M/sec                    ( +-  7.27% ) [12.07%]
       411,440,421 L1-icache-loads           #  241.502 M/sec                    ( +-  5.60% ) [36.52%]
        27,556,832 L1-icache-load-misses     #   16.175 M/sec                    ( +-  7.46% ) [46.72%]
       464,067,627 dTLB-loads                #  272.392 M/sec                    ( +-  4.46% ) [54.17%]
        10,765,648 dTLB-load-misses          #    6.319 M/sec                    ( +-  3.18% ) [48.68%]
     1,273,080,386 iTLB-loads                #  747.256 M/sec                    ( +-  3.38% ) [47.53%]
           117,481 iTLB-load-misses          #    0.069 M/sec                    ( +- 14.99% ) [47.01%]
         4,590,653 L1-dcache-prefetches      #    2.695 M/sec                    ( +-  4.49% ) [46.19%]
         1,712,660 L1-dcache-prefetch-misses #    1.005 M/sec                    ( +-  3.75% ) [44.82%]

        0.195622057  seconds time elapsed  ( +-  6.84% )

Also clean up the attribute construction code to be appending, and factor
it out into add_default_attributes().

Tweak the coverage percentage printout a bit, so that it's easier to view it
alongside the +- sttddev colum.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-to3kgu04449s64062val8b62@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |  209 +++++++++++++++++++++++++++++++++------------
 1 files changed, 154 insertions(+), 55 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 602c3c9..a89fc08 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -6,24 +6,28 @@
  *
  * Sample output:
 
-   $ perf stat ~/hackbench 10
-   Time: 0.104
+   $ perf stat ./hackbench 10
 
-    Performance counter stats for '/home/mingo/hackbench':
+  Time: 0.118
 
-       1255.538611  task clock ticks     #      10.143 CPU utilization factor
-             54011  context switches     #       0.043 M/sec
-               385  CPU migrations       #       0.000 M/sec
-             17755  pagefaults           #       0.014 M/sec
-        3808323185  CPU cycles           #    3033.219 M/sec
-        1575111190  instructions         #    1254.530 M/sec
-          17367895  cache references     #      13.833 M/sec
-           7674421  cache misses         #       6.112 M/sec
+  Performance counter stats for './hackbench 10':
 
-    Wall-clock time elapsed:   123.786620 msecs
+       1708.761321 task-clock                #   11.037 CPUs utilized
+            41,190 context-switches          #    0.024 M/sec
+             6,735 CPU-migrations            #    0.004 M/sec
+            17,318 page-faults               #    0.010 M/sec
+     5,205,202,243 cycles                    #    3.046 GHz
+     3,856,436,920 stalled-cycles-frontend   #   74.09% frontend cycles idle
+     1,600,790,871 stalled-cycles-backend    #   30.75% backend  cycles idle
+     2,603,501,247 instructions              #    0.50  insns per cycle
+                                             #    1.48  stalled cycles per insn
+       484,357,498 branches                  #  283.455 M/sec
+         6,388,934 branch-misses             #    1.32% of all branches
+
+        0.154822978  seconds time elapsed
 
  *
- * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ * Copyright (C) 2008-2011, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
  *
  * Improvements and fixes by:
  *
@@ -75,22 +79,10 @@ static struct perf_event_attr default_attrs[] = {
 };
 
 /*
- * Detailed stats:
+ * Detailed stats (-d), covering the L1 and last level data caches:
  */
 static struct perf_event_attr detailed_attrs[] = {
 
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
-
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
-
   { .type = PERF_TYPE_HW_CACHE,
     .config =
 	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
@@ -116,6 +108,69 @@ static struct perf_event_attr detailed_attrs[] = {
 	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
 };
 
+/*
+ * Very detailed stats (-d -d), covering the instruction cache and the TLB caches:
+ */
+static struct perf_event_attr very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+};
+
+/*
+ * Very, very detailed stats (-d -d -d), adding prefetch events:
+ */
+static struct perf_event_attr very_very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
+
+
 struct perf_evlist		*evsel_list;
 
 static bool			system_wide			=  false;
@@ -129,7 +184,7 @@ static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
-static bool			detailed_run			=  false;
+static int			detailed_run			=  0;
 static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
@@ -464,7 +519,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
-	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-24s";
+	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
@@ -584,9 +639,9 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (csv_output)
 		fmt = "%s%.0f%s%s";
 	else if (big_num)
-		fmt = "%s%'18.0f%s%-24s";
+		fmt = "%s%'18.0f%s%-25s";
 	else
-		fmt = "%s%18.0f%s%-24s";
+		fmt = "%s%18.0f%s%-25s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
@@ -616,7 +671,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		if (total && avg) {
 			ratio = total / avg;
-			fprintf(stderr, "\n                                            #   %5.2f  stalled cycles per insn", ratio);
+			fprintf(stderr, "\n                                             #   %5.2f  stalled cycles per insn", ratio);
 		}
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
@@ -704,7 +759,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		avg_enabled = avg_stats(&ps->res_stats[1]);
 		avg_running = avg_stats(&ps->res_stats[2]);
 
-		fprintf(stderr, "  (%.2f%%)", 100 * avg_running / avg_enabled);
+		fprintf(stderr, " [%5.2f%%]", 100 * avg_running / avg_enabled);
 	}
 	fprintf(stderr, "\n");
 }
@@ -854,7 +909,7 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
-	OPT_BOOLEAN('d', "detailed", &detailed_run,
+	OPT_INCR('d', "detailed", &detailed_run,
 		    "detailed run - start a lot of events"),
 	OPT_BOOLEAN('S', "sync", &sync_run,
 		    "call sync() before starting a run"),
@@ -873,6 +928,70 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+/*
+ * Add default attributes, if there were no attributes specified or
+ * if -d/--detailed, -d -d or -d -d -d is used:
+ */
+static int add_default_attributes(void)
+{
+	struct perf_evsel *pos;
+	size_t attr_nr = 0;
+	size_t c;
+
+	/* Set attrs if no event is selected and !null_run: */
+	if (null_run)
+		return 0;
+
+	if (!evsel_list->nr_entries) {
+		for (c = 0; c < ARRAY_SIZE(default_attrs); c++) {
+			pos = perf_evsel__new(default_attrs + c, c + attr_nr);
+			if (pos == NULL)
+				return -1;
+			perf_evlist__add(evsel_list, pos);
+		}
+		attr_nr += c;
+	}
+
+	/* Detailed events get appended to the event list: */
+
+	if (detailed_run <  1)
+		return 0;
+
+	/* Append detailed run extra attributes: */
+	for (c = 0; c < ARRAY_SIZE(detailed_attrs); c++) {
+		pos = perf_evsel__new(detailed_attrs + c, c + attr_nr);
+		if (pos == NULL)
+			return -1;
+		perf_evlist__add(evsel_list, pos);
+	}
+	attr_nr += c;
+
+	if (detailed_run < 2)
+		return 0;
+
+	/* Append very detailed run extra attributes: */
+	for (c = 0; c < ARRAY_SIZE(very_detailed_attrs); c++) {
+		pos = perf_evsel__new(very_detailed_attrs + c, c + attr_nr);
+		if (pos == NULL)
+			return -1;
+		perf_evlist__add(evsel_list, pos);
+	}
+
+	if (detailed_run < 3)
+		return 0;
+
+	/* Append very, very detailed run extra attributes: */
+	for (c = 0; c < ARRAY_SIZE(very_very_detailed_attrs); c++) {
+		pos = perf_evsel__new(very_very_detailed_attrs + c, c + attr_nr);
+		if (pos == NULL)
+			return -1;
+		perf_evlist__add(evsel_list, pos);
+	}
+
+
+	return 0;
+}
+
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_evsel *pos;
@@ -918,28 +1037,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(stat_usage, options);
 	}
 
-	/* Set attrs and nr_counters if no event is selected and !null_run */
-	if (detailed_run) {
-		size_t c;
-
-		for (c = 0; c < ARRAY_SIZE(detailed_attrs); ++c) {
-			pos = perf_evsel__new(&detailed_attrs[c], c);
-			if (pos == NULL)
-				goto out;
-			perf_evlist__add(evsel_list, pos);
-		}
-	}
-	/* Set attrs and nr_counters if no event is selected and !null_run */
-	if (!detailed_run && !null_run && !evsel_list->nr_entries) {
-		size_t c;
-
-		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
-			pos = perf_evsel__new(&default_attrs[c], c);
-			if (pos == NULL)
-				goto out;
-			perf_evlist__add(evsel_list, pos);
-		}
-	}
+	if (add_default_attributes())
+		goto out;
 
 	if (target_pid != -1)
 		target_tid = target_pid;
