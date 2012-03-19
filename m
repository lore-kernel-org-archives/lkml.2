Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab2CSCp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:45:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48567 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab2CSCpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:45:24 -0400
X-AuditID: 9c930197-b7c59ae000000e75-14-4f669dc234d8
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf ui browser: Clean lines inside of the input window
Date: Mon, 19 Mar 2012 11:46:20 +0900
Message-Id: <1332125180-23041-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120316194039.GO9528@infradead.org>
References: <20120316194039.GO9528@infradead.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Arnaldo pointed out, it should be cleared to prevent the window
from displaying overlapped strings on the region.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/util.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 360f43fd5400..ad4374a16bb0 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -108,9 +108,13 @@ int ui_browser__input_window(const char *title, const char *text, char *input,
 	max_len -= 2;
 	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
 				   nr_lines, max_len, 1);
-	y += nr_lines + 1;
-	SLsmg_set_color(0);
-	SLsmg_draw_box(y - 1, x + 1, 3, max_len - 2);
+	y += nr_lines;
+	len = 5;
+	while (len--) {
+		SLsmg_gotorc(y + len - 1, x);
+		SLsmg_write_nstring((char *)" ", max_len);
+	}
+	SLsmg_draw_box(y++, x + 1, 3, max_len - 2);
 
 	SLsmg_gotorc(y + 3, x);
 	SLsmg_write_nstring((char *)exit_msg, max_len);
-- 
1.7.9

