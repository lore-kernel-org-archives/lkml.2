Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2BWI1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:27:37 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2BWI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:27:29 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-d2-4f45f86d580e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] perf annotate: Print asm code as blue when source code is displayed
Date: Thu, 23 Feb 2012 17:46:20 +0900
Message-Id: <1329986784-4916-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print unselected asm code lines as blue. This is what we do now
for --stdio.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/browsers/annotate.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 295a9c93f945..76caae95df39 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -69,14 +69,17 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	if (!self->navkeypressed)
 		width += 1;
 
+	if (!ab->hide_src_code && ol->offset != -1)
+		if (!current_entry || (self->use_navkeypressed &&
+				       !self->navkeypressed))
+			ui_browser__set_color(self, HE_COLORSET_CODE);
+
 	if (!*ol->line)
 		slsmg_write_nstring(" ", width - 18);
 	else
 		slsmg_write_nstring(ol->line, width - 18);
 
-	if (!current_entry)
-		ui_browser__set_color(self, HE_COLORSET_CODE);
-	else
+	if (current_entry)
 		ab->selection = ol;
 }
 
-- 
1.7.9

