Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab2KER1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:27:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44901 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab2KERSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/32] perf browser: Don't show scripts menu for 'perf top'
Date: Mon,  5 Nov 2012 14:17:43 -0300
Message-Id: <1352135893-7564-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

As 'perf top' has no data files to run scripts against. Also add a
is_report_browser() helper function to judge whether the running browser
is for 'perf report'.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351699257-5102-1-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index fe62284..082078a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1127,6 +1127,12 @@ static inline void free_popup_options(char **options, int n)
 	}
 }
 
+/* Check whether the browser is for 'top' or 'report' */
+static inline bool is_report_browser(void *timer)
+{
+	return timer == NULL;
+}
+
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
@@ -1214,7 +1220,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			}
 			continue;
 		case 'r':
-			goto do_scripts;
+			if (is_report_browser(timer))
+				goto do_scripts;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1233,7 +1241,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
-					"r             Run available scripts\n"
+					"r             Run available scripts('perf report' only)\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
-- 
1.7.9.2.358.g22243

