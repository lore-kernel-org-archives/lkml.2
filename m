Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1LTTSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:18:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1LTTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] perf report: Document '--call-graph' for optional print_limit argument
Date: Tue, 20 Dec 2011 17:18:04 -0200
Message-Id: <1324408691-28296-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The '--call-graph' command line option can receive undocumented optional
print_limit argument. Besides, use strtoul() to parse the option since
its type is u32.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-2-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    5 +++--
 tools/perf/builtin-report.c              |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index dc85392..35af0dc 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -80,9 +80,10 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min,order]::
+-g [type,min[,limit],order]::
 --call-graph::
-        Display call chains using type, min percent threshold and order.
+        Display call chains using type, min percent threshold, optional print
+	limit and order.
 	type can be either:
 	- flat: single column, linear exposure of call chains.
 	- graph: use a graph tree, displaying absolute overhead rates.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ece7c5d..b2654c9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -407,7 +407,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		goto setup;
 
 	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtod(tok2, &endptr);
+		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
 		tok2 = strtok(NULL, ",");
 		if (!tok2)
 			goto setup;
@@ -485,8 +485,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent, call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold and callchain order. "
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit and callchain order. "
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
 		    "alias for inverted call graph"),
-- 
1.7.8.rc0.35.gee6df

