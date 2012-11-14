Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2KNGhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:37:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2KNGhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:37:45 -0500
Date: Tue, 13 Nov 2012 22:37:07 -0800
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-c77d8d7030128e61e206658815b96a6befed9d06@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351699257-5102-1-git-send-email-feng.tang@intel.com>
References: <1351699257-5102-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf browser: Don't show scripts menu for '
 perf top'
Git-Commit-ID: c77d8d7030128e61e206658815b96a6befed9d06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:37:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c77d8d7030128e61e206658815b96a6befed9d06
Gitweb:     http://git.kernel.org/tip/c77d8d7030128e61e206658815b96a6befed9d06
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 1 Nov 2012 00:00:55 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 16:14:19 -0200

perf browser: Don't show scripts menu for 'perf top'

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
 1 files changed, 10 insertions(+), 2 deletions(-)

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
