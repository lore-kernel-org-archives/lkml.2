Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2CPIvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:51:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56722 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab2CPIuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:50:40 -0400
X-AuditID: 9c930179-b7b27ae000000e38-db-4f62fedb4763
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] perf report: Treat an argument as a symbol filter
Date: Fri, 16 Mar 2012 17:50:55 +0900
Message-Id: <1331887855-874-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Ingo requested, it'd be better off treating first (and the only)
argument as a symbol filter, so that user doesn't need to input the
symbol on the dialog window on TUI.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-report.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 80fb90741b64..c00545806bb7 100644
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
1.7.9

