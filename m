Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab0LTOST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:18:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab0LTOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Du8n3ZPTxtFZJ6/yNfYS1gjUTpHTLlKJn2t4Fqjv4leTwbvQs8Xgext1DEcyTdM0WV
         qJcNzxl3QaXgEjvtCgukrXDwV85FkECEyw0rTdheM1+dvpiT2pXTDBobvhh60GHRyl01
         fEq6eulmdJTvrWBG4WtyevxOzfAP3C+xRzEIc=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] perf-probe: rewrite show_one_line() to make it simpler
Date: Mon, 20 Dec 2010 15:18:01 +0100
Message-Id: <1292854685-8230-3-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 6fa0403..5cc8f6b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -300,28 +300,21 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
 static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
-	const char *color = PERF_COLOR_BLUE;
+	const char *color = show_num ? "" : PERF_COLOR_BLUE;
+	const char *prefix = NULL;
 
-	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
-		goto error;
-	if (!skip) {
-		if (show_num)
-			fprintf(stdout, "%7d  %s", l, buf);
-		else
-			color_fprintf(stdout, color, "         %s", buf);
-	}
-
-	while (strlen(buf) == LINEBUF_SIZE - 1 &&
-	       buf[LINEBUF_SIZE - 2] != '\n') {
+	do {
 		if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
 			goto error;
-		if (!skip) {
-			if (show_num)
-				fprintf(stdout, "%s", buf);
-			else
-				color_fprintf(stdout, color, "%s", buf);
+		if (skip)
+			continue;
+		if (!prefix) {
+			prefix = show_num ? "%7d  " : "         ";
+			fprintf(stdout, prefix, l);
 		}
-	}
+		color_fprintf(stdout, color, "%s", buf);
+
+	} while (strchr(buf, '\n') == NULL);
 
 	return 0;
 error:
-- 
1.7.3.2

