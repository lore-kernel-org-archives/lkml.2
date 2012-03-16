Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2CPIvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:51:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51371 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161311Ab2CPIuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:50:40 -0400
X-AuditID: 9c930179-b7b27ae000000e38-d6-4f62feda9efd
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/5] perf report: Add --symbol-filter option
Date: Fri, 16 Mar 2012 17:50:54 +0900
Message-Id: <1331887855-874-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
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
 tools/perf/builtin-report.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8e91c6eba18a..80fb90741b64 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -50,6 +50,7 @@ struct perf_report {
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
+	const char		*symbol_filter_str;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -400,6 +401,9 @@ static int __cmd_report(struct perf_report *rep)
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		struct hists *hists = &pos->hists;
 
+		if (pos->idx == 0)
+			hists->symbol_filter_str = rep->symbol_filter_str;
+
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
 		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
@@ -591,6 +595,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
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

