Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2JOCeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 22:34:20 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48609 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2JOCeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 22:34:18 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-1f-507b7628c031
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf ui/browser: Fix off-by-two bug on the first column
Date: Mon, 15 Oct 2012 11:33:58 +0900
Message-Id: <1350268438-5066-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <20121014195037.GA244@x4>
References: <20121014195037.GA244@x4>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 5395a04841fc ("perf hists: Separate overhead and baseline
columns") makes the "Overhead" column no more the first one.  So it
resulted in the mis-aligned column in the normal (non-diff) output.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0568536ecf67..fe4430aed635 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -610,6 +610,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
+	bool first = true;
 
 	if (current_entry) {
 		browser->he_selection = entry;
@@ -633,10 +634,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			if (!perf_hpp__format[i].cond)
 				continue;
 
-			if (i) {
+			if (!first) {
 				slsmg_printf("  ");
 				width -= 2;
 			}
+			first = false;
 
 			if (perf_hpp__format[i].color) {
 				hpp.ptr = &percent;
-- 
1.7.11.4

