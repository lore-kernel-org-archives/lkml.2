Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2FTGLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:11:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59022 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2FTGLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:11:33 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-73-4fe16992eb70
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH v2] perf bench: Documentation update
Date: Wed, 20 Jun 2012 15:08:06 +0900
Message-Id: <1340172486-17805-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The current perf-bench documentation has a couple
of typos and even lacks entire description of mem
subsystem. Fix it.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Link: http://lkml.kernel.org/n/tip-exnzkah7sfzevvtsiw1s904e@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-bench.txt |   78 +++++++++++++++++++++++++++++--
 tools/perf/bench/mem-memcpy.c           |    4 +-
 tools/perf/bench/mem-memset.c           |    8 ++--
 tools/perf/builtin-bench.c              |    4 +-
 4 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index a3dbadb26ef5..f3c716a4cad3 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This 'perf bench' command is general framework for benchmark suites.
+This 'perf bench' command is a general framework for benchmark suites.
 
 COMMON OPTIONS
 --------------
@@ -45,14 +45,20 @@ SUBSYSTEM
 'sched'::
 	Scheduler and IPC mechanisms.
 
+'mem'::
+	Memory access performance.
+
+'all'::
+	All benchmark subsystems.
+
 SUITES FOR 'sched'
 ~~~~~~~~~~~~~~~~~~
 *messaging*::
 Suite for evaluating performance of scheduler and IPC mechanisms.
 Based on hackbench by Rusty Russell.
 
-Options of *pipe*
-^^^^^^^^^^^^^^^^^
+Options of *messaging*
+^^^^^^^^^^^^^^^^^^^^^^
 -p::
 --pipe::
 Use pipe() instead of socketpair()
@@ -115,6 +121,72 @@ Example of *pipe*
                 59004 ops/sec
 ---------------------
 
+SUITES FOR 'mem'
+~~~~~~~~~~~~~~~~
+*memcpy*::
+Suite for evaluating performance of simple memory copy in various ways.
+
+Options of *memcpy*
+^^^^^^^^^^^^^^^^^^^
+-l::
+--length::
+Specify length of memory to copy (default: 1MB).
+Available units are B, KB, MB, GB and TB (case insensitive).
+
+-r::
+--routine::
+Specify routine to copy (default: default).
+Available routines are depend on the architecture.
+On x86-64, x86-64-unrolled, x86-64-movsq and x86-64-movsb are supported.
+
+-i::
+--iterations::
+Repeat memcpy invocation this number of times.
+
+-c::
+--clock::
+Use perf's cpu-cycles event instead of gettimeofday syscall.
+
+-o::
+--only-prefault::
+Show only the result with page faults before memcpy.
+
+-n::
+--no-prefault::
+Show only the result without page faults before memcpy.
+
+*memset*::
+Suite for evaluating performance of simple memory set in various ways.
+
+Options of *memset*
+^^^^^^^^^^^^^^^^^^^
+-l::
+--length::
+Specify length of memory to set (default: 1MB).
+Available units are B, KB, MB, GB and TB (case insensitive).
+
+-r::
+--routine::
+Specify routine to set (default: default).
+Available routines are depend on the architecture.
+On x86-64, x86-64-unrolled, x86-64-stosq and x86-64-stosb are supported.
+
+-i::
+--iterations::
+Repeat memset invocation this number of times.
+
+-c::
+--clock::
+Use perf's cpu-cycles event instead of gettimeofday syscall.
+
+-o::
+--only-prefault::
+Show only the result with page faults before memset.
+
+-n::
+--no-prefault::
+Show only the result without page faults before memset.
+
 SEE ALSO
 --------
 linkperf:perf[1]
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 71557225bf92..d990365cafa0 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -32,13 +32,13 @@ static bool		no_prefault;
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
 		    "Specify length of memory to copy. "
-		    "available unit: B, MB, GB (upper and lower)"),
+		    "Available units: B, KB, MB, GB and TB (upper and lower)"),
 	OPT_STRING('r', "routine", &routine, "default",
 		    "Specify routine to copy"),
 	OPT_INTEGER('i', "iterations", &iterations,
 		    "repeat memcpy() invocation this number of times"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
-		    "Use CPU clock for measuring"),
+		    "Use cycles event instead of gettimeofday() for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
 		    "Show only the result with page faults before memcpy()"),
 	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index e9079185bd72..bf0d5f552017 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -31,14 +31,14 @@ static bool		no_prefault;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
-		    "Specify length of memory to copy. "
-		    "available unit: B, MB, GB (upper and lower)"),
+		    "Specify length of memory to set. "
+		    "Available units: B, KB, MB, GB and TB (upper and lower)"),
 	OPT_STRING('r', "routine", &routine, "default",
-		    "Specify routine to copy"),
+		    "Specify routine to set"),
 	OPT_INTEGER('i', "iterations", &iterations,
 		    "repeat memset() invocation this number of times"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
-		    "Use CPU clock for measuring"),
+		    "Use cycles event instead of gettimeofday() for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
 		    "Show only the result with page faults before memset()"),
 	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index b0e74ab2d7a2..1f3100216448 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -33,7 +33,7 @@ struct bench_suite {
 };
 						\
 /* sentinel: easy for help */
-#define suite_all { "all", "test all suite (pseudo suite)", NULL }
+#define suite_all { "all", "Test all benchmark suites", NULL }
 
 static struct bench_suite sched_suites[] = {
 	{ "messaging",
@@ -75,7 +75,7 @@ static struct bench_subsys subsystems[] = {
 	  "memory access performance",
 	  mem_suites },
 	{ "all",		/* sentinel: easy for help */
-	  "test all subsystem (pseudo subsystem)",
+	  "all benchmark subsystem",
 	  NULL },
 	{ NULL,
 	  NULL,
-- 
1.7.10.2

