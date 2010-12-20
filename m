Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0LTVwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:52:32 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52272 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab0LTVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:03 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 05/13] sisfb: replace inSISREG with SiS_GetRegByte
Date: Mon, 20 Dec 2010 23:50:14 +0200
Message-Id: <1292881822-32630-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace inSISREG() with SiS_GetRegByte().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 436ae46..10d190a 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -768,7 +768,7 @@ sisfbcheckvretracecrt1(struct sis_video_info *ivideo)
 	if(!sisfballowretracecrt1(ivideo))
 		return false;
 
-	if(inSISREG(SISINPSTAT) & 0x08)
+	if (SiS_GetRegByte(SISINPSTAT) & 0x08)
 		return true;
 	else
 		return false;
@@ -783,9 +783,9 @@ sisfbwaitretracecrt1(struct sis_video_info *ivideo)
 		return;
 
 	watchdog = 65536;
-	while((!(inSISREG(SISINPSTAT) & 0x08)) && --watchdog);
+	while ((!(SiS_GetRegByte(SISINPSTAT) & 0x08)) && --watchdog);
 	watchdog = 65536;
-	while((inSISREG(SISINPSTAT) & 0x08) && --watchdog);
+	while ((SiS_GetRegByte(SISINPSTAT) & 0x08) && --watchdog);
 }
 
 static bool
@@ -853,7 +853,7 @@ sisfb_setupvbblankflags(struct sis_video_info *ivideo, u32 *vcount, u32 *hcount)
 			FB_VBLANK_HAVE_VBLANK |
 			FB_VBLANK_HAVE_VCOUNT |
 			FB_VBLANK_HAVE_HCOUNT);
-		reg1 = inSISREG(SISINPSTAT);
+		reg1 = SiS_GetRegByte(SISINPSTAT);
 		if(reg1 & 0x08) ret |= FB_VBLANK_VSYNCING;
 		if(reg1 & 0x01) ret |= FB_VBLANK_VBLANKING;
 		inSISIDXREG(SISCR,0x20,reg1);
@@ -2233,9 +2233,9 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
           outSISIDXREG(SISCR, 0x57, 0x5f);
        }
        orSISIDXREG(SISCR, 0x53, 0x02);
-       while((inSISREG(SISINPSTAT)) & 0x01)    break;
-       while(!((inSISREG(SISINPSTAT)) & 0x01)) break;
-       if((inSISREG(SISMISCW)) & 0x10) temp = 1;
+	while ((SiS_GetRegByte(SISINPSTAT)) & 0x01)    break;
+	while (!((SiS_GetRegByte(SISINPSTAT)) & 0x01)) break;
+	if ((SiS_GetRegByte(SISMISCW)) & 0x10) temp = 1;
        andSISIDXREG(SISCR, 0x53, 0xfd);
        andSISIDXREG(SISCR, 0x57, 0x00);
     }
@@ -4998,11 +4998,11 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	};
 
 	/* VGA enable */
-	reg = inSISREG(SISVGAENABLE) | 0x01;
+	reg = SiS_GetRegByte(SISVGAENABLE) | 0x01;
 	outSISREG(SISVGAENABLE, reg);
 
 	/* Misc */
-	reg = inSISREG(SISMISCR) | 0x01;
+	reg = SiS_GetRegByte(SISMISCR) | 0x01;
 	outSISREG(SISMISCW, reg);
 
 	/* Unlock SR */
-- 
1.5.6.5

