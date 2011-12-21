Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1LUImo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:42:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1LUIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:42:41 -0500
Date: Wed, 21 Dec 2011 00:42:17 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-6581f6e35f7d0338f699fce660adb48e863f2b59@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1323703017-6060-2-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-2-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Document '--call-graph'
  for optional print_limit argument
Git-Commit-ID: 6581f6e35f7d0338f699fce660adb48e863f2b59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:42:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6581f6e35f7d0338f699fce660adb48e863f2b59
Gitweb:     http://git.kernel.org/tip/6581f6e35f7d0338f699fce660adb48e863f2b59
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 00:16:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:28:13 -0200

perf report: Document '--call-graph' for optional print_limit argument

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
