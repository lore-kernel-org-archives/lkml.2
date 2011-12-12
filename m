Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1LLPRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:19 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46151 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1LLPRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:15 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] perf report: Document '--call-graph' for optional print_limit argument
Date: Tue, 13 Dec 2011 00:16:50 +0900
Message-Id: <1323703017-6060-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '--call-graph' command line option can receive undocumented
optional print_limit argument. Besides, use strtoul() to parse
the option since its type is u32.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/Documentation/perf-report.txt |    5 +++--
 tools/perf/builtin-report.c              |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index dc85392a5ac7..35af0dc8ccb4 100644
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
index ece7c5d3f504..b2654c9fb5c6 100644
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
1.7.6

