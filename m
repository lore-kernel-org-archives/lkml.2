Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2ILGn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:43:29 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62072 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2ILGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:43:25 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-2f-50502f091ab6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] perf ui/browser: Fix first column printing
Date: Wed, 12 Sep 2012 15:35:06 +0900
Message-Id: <1347431706-7839-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347431706-7839-1-git-send-email-namhyung@kernel.org>
References: <1347431706-7839-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As a side effect of commit f5951d56a2ab ("perf hists browser: Use
perf_hpp__format functions") perf report TUI got a problem of not
refreshing the first character.

Since the previous patch restores the column width of "overhead" to 7
we can start at column 0 now.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 11783170ac62..a21f40bebbac 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -605,7 +605,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	char s[256];
 	double percent;
 	int i, printed = 0;
-	int width = browser->b.width - 1;
+	int width = browser->b.width;
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
@@ -627,7 +627,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.total_period	= browser->hists->stats.total_period,
 		};
 
-		ui_browser__gotorc(&browser->b, row, 1);
+		ui_browser__gotorc(&browser->b, row, 0);
 
 		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
 			if (!perf_hpp__format[i].cond)
-- 
1.7.11.4

