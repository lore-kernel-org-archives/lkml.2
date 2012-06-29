Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2F2QTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:19:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab2F2QTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:19:42 -0400
Date: Fri, 29 Jun 2012 09:19:16 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-08942f6d5d992e9486b07653fd87ea8182a22fa0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, mitake@dcl.info.waseda.ac.jp,
        namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1340172486-17805-1-git-send-email-namhyung@kernel.org>
References: <1340172486-17805-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Documentation update
Git-Commit-ID: 08942f6d5d992e9486b07653fd87ea8182a22fa0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 29 Jun 2012 09:19:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08942f6d5d992e9486b07653fd87ea8182a22fa0
Gitweb:     http://git.kernel.org/tip/08942f6d5d992e9486b07653fd87ea8182a22fa0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 20 Jun 2012 15:08:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Jun 2012 13:17:48 -0300

perf bench: Documentation update

The current perf-bench documentation has a couple of typos and even
lacks entire description of mem subsystem. Fix it.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340172486-17805-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-bench.txt |   78 +++++++++++++++++++++++++++++-
 tools/perf/bench/mem-memcpy.c           |    4 +-
 tools/perf/bench/mem-memset.c           |    8 ++--
 tools/perf/builtin-bench.c              |    4 +-
 4 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index a3dbadb..f3c716a 100644
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
index 7155722..d990365 100644
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
index e907918..bf0d5f5 100644
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
index b0e74ab..1f31002 100644
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
