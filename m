Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2CPUEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:04:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab2CPUC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/13] perf report: Add --symbol-filter option
Date: Fri, 16 Mar 2012 17:02:09 -0300
Message-Id: <1331928130-16243-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add new --symbol-filter command line option to set appropriate filter
string.

Its short version is missing as I couldn't find an ideal one and
--filter option of perf record also has no short version.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-4-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8e91c6e..80fb907 100644
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
1.7.9.2.358.g22243

