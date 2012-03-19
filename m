Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032669Ab2CSTO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:14:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40442 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab2CSTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:13:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf ui browser: Clean lines inside of the input window
Date: Mon, 19 Mar 2012 16:12:46 -0300
Message-Id: <1332184368-1655-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1332184368-1655-1-git-send-email-acme@infradead.org>
References: <1332184368-1655-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As Arnaldo pointed out, it should be cleared to prevent the window from
displaying overlapped strings on the region.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1332125180-23041-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/util.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 360f43f..ad4374a 100644
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
1.7.9.2.358.g22243

