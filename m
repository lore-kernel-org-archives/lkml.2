Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898Ab2COAjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:39:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54823 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643Ab2COAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:39:05 -0400
X-AuditID: 9c930197-b7c59ae000000e75-ec-4f613a25baf7
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf report: Add --symbol-filter option
Date: Thu, 15 Mar 2012 09:39:09 +0900
Message-Id: <1331771949-27205-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120313152417.GA12193@elte.hu>
References: <20120313152417.GA12193@elte.hu>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new --symbol-filter command line option to set appropriate
filter string. Its short version is missing as I couldn't find
an ideal one and --filter option of perf record also has no
short version.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-report.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 62c4a11bcf3e..8784d5c77110 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -499,6 +499,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		   "only consider symbols in these comms"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
+	OPT_STRING(0, "symbol-filter", &report.symbol_filter_str, "filter",
+		   "only show symbols that (partially) match with this filter"),
 	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
 		   "width[,width...]",
 		   "don't try to adjust column width, use these fixed values"),
-- 
1.7.9

