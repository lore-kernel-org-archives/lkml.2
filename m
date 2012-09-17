Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2IQRSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:18:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:46429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2IQRS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/18] perf hists browser: Fix first column printing
Date: Mon, 17 Sep 2012 14:18:00 -0300
Message-Id: <1347902292-14536-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As a side effect of commit f5951d56a2ab ("perf hists browser: Use
perf_hpp__format functions") perf report TUI got a problem of not
refreshing the first character.

Since the previous patch restores the column width of "overhead" to 7
we can start at column 0 now.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347431706-7839-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 1178317..a21f40b 100644
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
1.7.1

