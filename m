Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2JEJDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:03:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2JEJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:03:29 -0400
Date: Fri, 5 Oct 2012 02:03:01 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-41724e4cf6c443d2dc575669b8555f0e2ae427a9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349354994-17853-5-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Removing hists pair argument from output path
Git-Commit-ID: 41724e4cf6c443d2dc575669b8555f0e2ae427a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:03:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41724e4cf6c443d2dc575669b8555f0e2ae427a9
Gitweb:     http://git.kernel.org/tip/41724e4cf6c443d2dc575669b8555f0e2ae427a9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 4 Oct 2012 21:49:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:29:45 -0300

perf tools: Removing hists pair argument from output path

The hists pointer is now part of the 'struct hist_entry'.

And since the overhead and baseline columns are split now, there's no
reason to pass it through the output path.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-5-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c   |    3 +--
 tools/perf/builtin-report.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/ui/hist.c        |    9 +++++----
 tools/perf/ui/stdio/hist.c  |   10 +++-------
 tools/perf/util/hist.h      |    4 ++--
 6 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 5cb577a..413c65a1b 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -214,8 +214,7 @@ static int __cmd_diff(void)
 		first = false;
 
 		hists__match(&evsel_old->hists, &evsel->hists);
-		hists__fprintf(&evsel->hists, &evsel_old->hists,
-			       true, 0, 0, stdout);
+		hists__fprintf(&evsel->hists, true, 0, 0, stdout);
 	}
 
 out_delete:
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6748cac..95e7ea8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -320,7 +320,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		const char *evname = perf_evsel__name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
-		hists__fprintf(hists, NULL, true, 0, 0, stdout);
+		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3571158..ff6db80 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -316,7 +316,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->winsize.ws_row - 3);
 	putchar('\n');
-	hists__fprintf(&top->sym_evsel->hists, NULL, false,
+	hists__fprintf(&top->sym_evsel->hists, false,
 		       top->winsize.ws_row - 4 - printed, win_width, stdout);
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 532a601..6b0138e 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -228,16 +228,17 @@ static int hpp__width_delta(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	struct hists *pair_hists = hpp->ptr;
+	struct hist_entry *pair = he->pair;
+	struct hists *pair_hists = pair ? pair->hists : NULL;
 	u64 old_total, new_total;
 	double old_percent = 0, new_percent = 0;
 	double diff;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
 	char buf[32] = " ";
 
-	old_total = pair_hists->stats.total_period;
-	if (old_total > 0 && he->pair)
-		old_percent = 100.0 * he->pair->period / old_total;
+	old_total = pair_hists ? pair_hists->stats.total_period : 0;
+	if (old_total > 0 && pair)
+		old_percent = 100.0 * pair->period / old_total;
 
 	new_total = hpp->total_period;
 	if (new_total > 0)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 0aa6776..1340c93 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -307,8 +307,7 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 }
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
-			       struct hists *hists, struct hists *pair_hists,
-			       u64 total_period, FILE *fp)
+			       struct hists *hists, u64 total_period, FILE *fp)
 {
 	char bf[512];
 	int ret;
@@ -316,7 +315,6 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.buf		= bf,
 		.size		= size,
 		.total_period	= total_period,
-		.ptr		= pair_hists,
 	};
 	bool color = !symbol_conf.field_sep;
 
@@ -335,8 +333,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	return ret;
 }
 
-size_t hists__fprintf(struct hists *hists, struct hists *pair,
-		      bool show_header, int max_rows,
+size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, FILE *fp)
 {
 	struct sort_entry *se;
@@ -351,7 +348,6 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
-		.ptr	= pair,
 	};
 	bool first = true;
 
@@ -453,7 +449,7 @@ print_entries:
 		if (h->filtered)
 			continue;
 
-		ret += hist_entry__fprintf(h, max_cols, hists, pair,
+		ret += hist_entry__fprintf(h, max_cols, hists,
 					   total_period, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b1a2b9d..b83a226 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,8 +98,8 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
-size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_header, int max_rows, int max_cols, FILE *fp);
+size_t hists__fprintf(struct hists *self, bool show_header, int max_rows,
+		      int max_cols, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
