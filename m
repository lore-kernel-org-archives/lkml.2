Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161272Ab2CPUDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:03:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41807 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab2CPUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/13] perf report: Treat an argument as a symbol filter
Date: Fri, 16 Mar 2012 17:02:10 -0300
Message-Id: <1331928130-16243-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As Ingo requested, it'd be better off treating first (and the only)
argument as a symbol filter, so that user doesn't need to input the
symbol on the dialog window on TUI.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 80fb907..c005458 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -715,11 +715,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	} else
 		symbol_conf.exclude_other = false;
 
-	/*
-	 * Any (unrecognized) arguments left?
-	 */
-	if (argc)
-		usage_with_options(report_usage, options);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume that
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(report_usage, options);
+
+		report.symbol_filter_str = argv[0];
+	}
 
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 
-- 
1.7.9.2.358.g22243

