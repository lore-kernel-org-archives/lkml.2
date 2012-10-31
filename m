Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935747Ab2JaQBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:01:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:47164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935716Ab2JaQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,687,1344236400"; 
   d="scan'208";a="162920069"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/3] perf browser: Don't show scripts menu for 'perf top'
Date: Thu,  1 Nov 2012 00:00:55 +0800
Message-Id: <1351699257-5102-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 'perf top' has no data files to run scripts against. Also add
a is_report_browser() helper function to judge whether the running
browser is for 'perf report'.

Signed-off-by: Feng Tang <feng.tang@intel.com>
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
1.7.9.5

