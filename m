Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2ISPPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:15:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2ISPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:15:18 -0400
Date: Wed, 19 Sep 2012 08:15:00 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-67d2591656df7a76d4cabca04f1cbe1c7d1c9b3a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1347431706-7839-2-git-send-email-namhyung@kernel.org>
References: <1347431706-7839-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Fix first column printing
Git-Commit-ID: 67d2591656df7a76d4cabca04f1cbe1c7d1c9b3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:15:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67d2591656df7a76d4cabca04f1cbe1c7d1c9b3a
Gitweb:     http://git.kernel.org/tip/67d2591656df7a76d4cabca04f1cbe1c7d1c9b3a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 12 Sep 2012 15:35:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Sep 2012 15:50:14 -0300

perf hists browser: Fix first column printing

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
