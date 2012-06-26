Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2FZEA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:00:28 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48179 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713Ab2FZEAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:00:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAM8y6U9bdWOb/2dsb2JhbABEtiyBB4IYAQEFJ1IQIDE8GwcSiA+5JJE3A5UuiSaGW4Jh
X-IronPort-AV: E=Sophos;i="4.77,476,1336341600"; 
   d="scan'208";a="532687857"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 4/4] staging: sm7xxfb: code cleanup on smtcfb_setmode
Date: Tue, 26 Jun 2012 06:00:17 +0200
Message-Id: <1340683217-7986-5-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
References: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

Code cleanup on smtcfb_setmode.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   64 +++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 40e8e0d..08098c6 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -557,55 +557,49 @@ void smtcfb_setmode(struct smtcfb_info *sfb)
 {
 	switch (sfb->fb.var.bits_per_pixel) {
 	case 32:
-		sfb->fb.fix.visual = FB_VISUAL_TRUECOLOR;
-		sfb->fb.fix.line_length = sfb->fb.var.xres * 4;
-		sfb->fb.var.red.length = 8;
+		sfb->fb.fix.visual       = FB_VISUAL_TRUECOLOR;
+		sfb->fb.fix.line_length  = sfb->fb.var.xres * 4;
+		sfb->fb.var.red.length   = 8;
 		sfb->fb.var.green.length = 8;
-		sfb->fb.var.blue.length = 8;
-		sfb->fb.var.red.offset = 16;
+		sfb->fb.var.blue.length  = 8;
+		sfb->fb.var.red.offset   = 16;
 		sfb->fb.var.green.offset = 8;
-		sfb->fb.var.blue.offset = 0;
-
-		break;
-	case 8:
-		sfb->fb.fix.visual = FB_VISUAL_PSEUDOCOLOR;
-		sfb->fb.fix.line_length = sfb->fb.var.xres;
-		sfb->fb.var.red.offset = 5;
-		sfb->fb.var.red.length = 3;
-		sfb->fb.var.green.offset = 2;
-		sfb->fb.var.green.length = 3;
-		sfb->fb.var.blue.offset = 0;
-		sfb->fb.var.blue.length = 2;
+		sfb->fb.var.blue.offset  = 0;
 		break;
 	case 24:
-		sfb->fb.fix.visual = FB_VISUAL_TRUECOLOR;
-		sfb->fb.fix.line_length = sfb->fb.var.xres * 3;
-		sfb->fb.var.red.length = 8;
+		sfb->fb.fix.visual       = FB_VISUAL_TRUECOLOR;
+		sfb->fb.fix.line_length  = sfb->fb.var.xres * 3;
+		sfb->fb.var.red.length   = 8;
 		sfb->fb.var.green.length = 8;
-		sfb->fb.var.blue.length = 8;
-
-		sfb->fb.var.red.offset = 16;
+		sfb->fb.var.blue.length  = 8;
+		sfb->fb.var.red.offset   = 16;
 		sfb->fb.var.green.offset = 8;
-		sfb->fb.var.blue.offset = 0;
-
+		sfb->fb.var.blue.offset  = 0;
+		break;
+	case 8:
+		sfb->fb.fix.visual       = FB_VISUAL_PSEUDOCOLOR;
+		sfb->fb.fix.line_length  = sfb->fb.var.xres;
+		sfb->fb.var.red.length   = 3;
+		sfb->fb.var.green.length = 3;
+		sfb->fb.var.blue.length  = 2;
+		sfb->fb.var.red.offset   = 5;
+		sfb->fb.var.green.offset = 2;
+		sfb->fb.var.blue.offset  = 0;
 		break;
 	case 16:
 	default:
-		sfb->fb.fix.visual = FB_VISUAL_TRUECOLOR;
-		sfb->fb.fix.line_length = sfb->fb.var.xres * 2;
-
-		sfb->fb.var.red.length = 5;
+		sfb->fb.fix.visual       = FB_VISUAL_TRUECOLOR;
+		sfb->fb.fix.line_length  = sfb->fb.var.xres * 2;
+		sfb->fb.var.red.length   = 5;
 		sfb->fb.var.green.length = 6;
-		sfb->fb.var.blue.length = 5;
-
-		sfb->fb.var.red.offset = 11;
+		sfb->fb.var.blue.length  = 5;
+		sfb->fb.var.red.offset   = 11;
 		sfb->fb.var.green.offset = 5;
-		sfb->fb.var.blue.offset = 0;
-
+		sfb->fb.var.blue.offset  = 0;
 		break;
 	}
 
-	sfb->width = sfb->fb.var.xres;
+	sfb->width  = sfb->fb.var.xres;
 	sfb->height = sfb->fb.var.yres;
 	sfb->hz = 60;
 	smtc_set_timing(sfb);
-- 
1.7.10

