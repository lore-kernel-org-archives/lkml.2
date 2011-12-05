Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1LENB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:01:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab1LENBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:01:54 -0500
Date: Mon, 5 Dec 2011 05:00:55 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-c8e6672035e84799e6167e933fafedc8e3256973@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321209008-7004-1-git-send-email-dsahern@gmail.com>
References: <1321209008-7004-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: make -C consistent across commands (for cpu list arg)
Git-Commit-ID: c8e6672035e84799e6167e933fafedc8e3256973
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:01:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8e6672035e84799e6167e933fafedc8e3256973
Gitweb:     http://git.kernel.org/tip/c8e6672035e84799e6167e933fafedc8e3256973
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 13 Nov 2011 11:30:08 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 11:45:53 -0200

perf tools: make -C consistent across commands (for cpu list arg)

Currently the meaning of -C varies by perf command: for perf-top,
perf-stat, perf-record it means cpu list. For perf-report it means comm
list. Then perf-annotate, perf-report and perf-script use -c for cpu
list.

Fix annotate, report and script to use -C for cpu list to be consistent
with top, stat and record. This means report needs to use -c for comm
list which does introduce a backward compatibility change.

v1 -> v2
- update perf-script.txt too

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1321209008-7004-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    2 +-
 tools/perf/Documentation/perf-report.txt   |    4 ++--
 tools/perf/Documentation/perf-script.txt   |    2 +-
 tools/perf/builtin-annotate.c              |    2 +-
 tools/perf/builtin-report.c                |    4 ++--
 tools/perf/builtin-script.c                |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index fe6762e..476029d 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -66,7 +66,7 @@ OPTIONS
 	used. This interfaces starts by centering on the line with more
 	samples, TAB/UNTAB cycles through the lines with more samples.
 
--c::
+-C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
 	CPUs are specified with -: 0-2. Default is to report samples on all
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 212f24d..dc85392 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -39,7 +39,7 @@ OPTIONS
 -T::
 --threads::
 	Show per-thread event counters
--C::
+-c::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
 	file://filename entries.
@@ -128,7 +128,7 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
--c::
+-C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
 	CPUs are specified with -: 0-2. Default is to report samples on all
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index dec87ec..3613b0a 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -182,7 +182,7 @@ OPTIONS
 --hide-call-graph::
         When printing symbols do not display call chain.
 
--c::
+-C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
 	CPUs are specified with -: 0-2. Default is to report samples on all
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c01139f..d449645 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -274,7 +274,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &annotate.full_paths,
 		    "Don't shorten the displayed pathnames"),
-	OPT_STRING('c', "cpu", &annotate.cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('C', "cpu", &annotate.cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		   "Look for files with symbols relative to this directory"),
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index eef8e42..ece7c5d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -492,7 +492,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
-	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only consider symbols in these comms"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
@@ -506,7 +506,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
-	OPT_STRING('c', "cpu", &report.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &report.cpu_list, "cpu",
 		   "list of cpus to profile"),
 	OPT_BOOLEAN('I', "show-info", &report.show_full_info,
 		    "Display extended information about perf.data file"),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5f8afc6..7731a09 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1085,7 +1085,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
-	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
 	OPT_END()
