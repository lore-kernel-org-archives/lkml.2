Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1LCORH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 09:17:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64581 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1LCORD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 09:17:03 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf report: Document '--call-graph' for optional print_limit argument
Date: Sat,  3 Dec 2011 23:16:54 +0900
Message-Id: <1322921814-12338-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '--call-graph' command line option can receive undocumented
optional print_limit argument. Besides, use strtol to parse
the option since its type is u32.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/Documentation/perf-report.txt |    5 +++--
 tools/perf/builtin-report.c              |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 212f24d672e1..12a5bd9b502a 100644
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
index 4d7c8340c326..b0bb79dc6251 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -412,7 +412,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 		goto setup;
 
 	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtod(tok2, &endptr);
+		callchain_param.print_limit = strtol(tok2, &endptr, 0);
 		tok2 = strtok(NULL, ",");
 		if (!tok2)
 			goto setup;
@@ -468,8 +468,8 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent, call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold and callchain order. "
+	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent[,print_limit],call_order",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit and callchain order. "
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &inverted_callchain, "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
-- 
1.7.6

