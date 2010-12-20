Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0LTVuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:50:07 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52284 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0LTVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:04 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 06/13] sisfb: replace outSISREG with SiS_SetRegByte
Date: Mon, 20 Dec 2010 23:50:15 +0200
Message-Id: <1292881822-32630-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace outSISREG() with SiS_SetRegByte().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 10d190a..fa8f01c 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1388,15 +1388,15 @@ sisfb_setcolreg(unsigned regno, unsigned red, unsigned green, unsigned blue,
 
 	switch(info->var.bits_per_pixel) {
 	case 8:
-		outSISREG(SISDACA, regno);
-		outSISREG(SISDACD, (red >> 10));
-		outSISREG(SISDACD, (green >> 10));
-		outSISREG(SISDACD, (blue >> 10));
+		SiS_SetRegByte(SISDACA, regno);
+		SiS_SetRegByte(SISDACD, (red >> 10));
+		SiS_SetRegByte(SISDACD, (green >> 10));
+		SiS_SetRegByte(SISDACD, (blue >> 10));
 		if(ivideo->currentvbflags & VB_DISPTYPE_DISP2) {
-			outSISREG(SISDAC2A, regno);
-			outSISREG(SISDAC2D, (red >> 8));
-			outSISREG(SISDAC2D, (green >> 8));
-			outSISREG(SISDAC2D, (blue >> 8));
+			SiS_SetRegByte(SISDAC2A, regno);
+			SiS_SetRegByte(SISDAC2D, (red >> 8));
+			SiS_SetRegByte(SISDAC2D, (green >> 8));
+			SiS_SetRegByte(SISDAC2D, (blue >> 8));
 		}
 		break;
 	case 16:
@@ -4999,11 +4999,11 @@ sisfb_post_xgi(struct pci_dev *pdev)
 
 	/* VGA enable */
 	reg = SiS_GetRegByte(SISVGAENABLE) | 0x01;
-	outSISREG(SISVGAENABLE, reg);
+	SiS_SetRegByte(SISVGAENABLE, reg);
 
 	/* Misc */
 	reg = SiS_GetRegByte(SISMISCR) | 0x01;
-	outSISREG(SISMISCW, reg);
+	SiS_SetRegByte(SISMISCW, reg);
 
 	/* Unlock SR */
 	outSISIDXREG(SISSR, 0x05, 0x86);
-- 
1.5.6.5

