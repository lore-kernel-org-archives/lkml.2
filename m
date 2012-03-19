Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032933Ab2CSUFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:05:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032761Ab2CSUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:05:04 -0400
Date: Mon, 19 Mar 2012 13:04:46 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-b14ffaca44c60da1c900aa36131ef3d9858001fc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1331887855-874-4-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-4-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add --symbol-filter option
Git-Commit-ID: b14ffaca44c60da1c900aa36131ef3d9858001fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:04:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b14ffaca44c60da1c900aa36131ef3d9858001fc
Gitweb:     http://git.kernel.org/tip/b14ffaca44c60da1c900aa36131ef3d9858001fc
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 16 Mar 2012 17:50:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 16:41:30 -0300

perf report: Add --symbol-filter option

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
 1 files changed, 6 insertions(+), 0 deletions(-)

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
