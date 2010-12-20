Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0LTVwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:52:13 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:54093 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab0LTVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:05 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 10/13] sisfb: replace andSISIDXREG with SiS_SetRegAND
Date: Mon, 20 Dec 2010 23:50:19 +0200
Message-Id: <1292881822-32630-11-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace andSISIDXREG() with SiS_SetRegAND().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   66 +++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 0b10f12..65bf57f 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -2200,14 +2200,14 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
 
     sr1F = SiS_GetReg(SISSR, 0x1F);
     SiS_SetRegOR(SISSR, 0x1F, 0x04);
-    andSISIDXREG(SISSR,0x1F,0x3F);
+    SiS_SetRegAND(SISSR, 0x1F, 0x3F);
     if(sr1F & 0xc0) mustwait = true;
 
 #ifdef CONFIG_FB_SIS_315
     if(ivideo->sisvga_engine == SIS_315_VGA) {
        cr63 = SiS_GetReg(SISCR, ivideo->SiS_Pr.SiS_MyCR63);
        cr63 &= 0x40;
-       andSISIDXREG(SISCR,ivideo->SiS_Pr.SiS_MyCR63,0xBF);
+       SiS_SetRegAND(SISCR, ivideo->SiS_Pr.SiS_MyCR63, 0xBF);
     }
 #endif
 
@@ -2226,7 +2226,7 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
 
 #ifdef CONFIG_FB_SIS_315
     if(ivideo->chip >= SIS_330) {
-       andSISIDXREG(SISCR,0x32,~0x20);
+       SiS_SetRegAND(SISCR, 0x32, ~0x20);
        if(ivideo->chip >= SIS_340) {
 	   SiS_SetReg(SISCR, 0x57, 0x4a);
        } else {
@@ -2236,8 +2236,8 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
 	while ((SiS_GetRegByte(SISINPSTAT)) & 0x01)    break;
 	while (!((SiS_GetRegByte(SISINPSTAT)) & 0x01)) break;
 	if ((SiS_GetRegByte(SISMISCW)) & 0x10) temp = 1;
-       andSISIDXREG(SISCR, 0x53, 0xfd);
-       andSISIDXREG(SISCR, 0x57, 0x00);
+	SiS_SetRegAND(SISCR, 0x53, 0xfd);
+	SiS_SetRegAND(SISCR, 0x57, 0x00);
     }
 #endif
 
@@ -2378,7 +2378,7 @@ SISDoSense(struct sis_video_info *ivideo, u16 type, u16 test)
           if(temp == mytest) result++;
 #if 1
 	  SiS_SetReg(SISPART4, 0x11, 0x00);
-	  andSISIDXREG(SISPART4,0x10,0xe0);
+	  SiS_SetRegAND(SISPART4, 0x10, 0xe0);
 	  SiS_DDC2Delay(&ivideo->SiS_Pr, 0x1000);
 #endif
        }
@@ -2461,7 +2461,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
        SISDoSense(ivideo, 0, 0);
     }
 
-    andSISIDXREG(SISCR, 0x32, ~0x14);
+    SiS_SetRegAND(SISCR, 0x32, ~0x14);
 
     if(vga2_c || vga2) {
        if(SISDoSense(ivideo, vga2, vga2_c)) {
@@ -2475,7 +2475,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
        }
     }
 
-    andSISIDXREG(SISCR, 0x32, 0x3f);
+    SiS_SetRegAND(SISCR, 0x32, 0x3f);
 
     if(ivideo->vbflags2 & VB2_30xCLV) {
        SiS_SetRegOR(SISPART4, 0x0d, 0x04);
@@ -2493,7 +2493,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
        SiS_SetReg(SISPART2, 0x4d, backupP2_4d);
     }
 
-    andSISIDXREG(SISCR, 0x32, ~0x03);
+    SiS_SetRegAND(SISCR, 0x32, ~0x03);
 
     if(!(ivideo->vbflags & TV_YPBPR)) {
        if((result = SISDoSense(ivideo, svhs, svhs_c))) {
@@ -2589,19 +2589,19 @@ SiS_SenseCh(struct sis_video_info *ivideo)
 		printk(KERN_INFO "%s SVIDEO output\n", stdstr);
 		ivideo->vbflags |= TV_SVIDEO;
 		SiS_SetRegOR(SISCR, 0x32, 0x02);
-		andSISIDXREG(SISCR, 0x32, ~0x05);
+		SiS_SetRegAND(SISCR, 0x32, ~0x05);
 	   } else if (temp1 == 0x01) {
 		printk(KERN_INFO "%s CVBS output\n", stdstr);
 		ivideo->vbflags |= TV_AVIDEO;
 		SiS_SetRegOR(SISCR, 0x32, 0x01);
-		andSISIDXREG(SISCR, 0x32, ~0x06);
+		SiS_SetRegAND(SISCR, 0x32, ~0x06);
 	   } else {
 		SiS_SetCH70xxANDOR(&ivideo->SiS_Pr, 0x0e, 0x01, 0xF8);
-		andSISIDXREG(SISCR, 0x32, ~0x07);
+		SiS_SetRegAND(SISCR, 0x32, ~0x07);
 	   }
        } else if(temp1 == 0) {
 	  SiS_SetCH70xxANDOR(&ivideo->SiS_Pr, 0x0e, 0x01, 0xF8);
-	  andSISIDXREG(SISCR, 0x32, ~0x07);
+	  SiS_SetRegAND(SISCR, 0x32, ~0x07);
        }
        /* Set general purpose IO for Chrontel communication */
        SiS_SetChrontelGPIO(&ivideo->SiS_Pr, 0x00);
@@ -2633,21 +2633,21 @@ SiS_SenseCh(struct sis_video_info *ivideo)
 	     printk(KERN_INFO "%s CVBS output\n", stdstr);
 	     ivideo->vbflags |= TV_AVIDEO;
 	     SiS_SetRegOR(SISCR, 0x32, 0x01);
-	     andSISIDXREG(SISCR, 0x32, ~0x06);
+	     SiS_SetRegAND(SISCR, 0x32, ~0x06);
 	     break;
 	case 0x02:
 	     printk(KERN_INFO "%s SVIDEO output\n", stdstr);
 	     ivideo->vbflags |= TV_SVIDEO;
 	     SiS_SetRegOR(SISCR, 0x32, 0x02);
-	     andSISIDXREG(SISCR, 0x32, ~0x05);
+	     SiS_SetRegAND(SISCR, 0x32, ~0x05);
 	     break;
 	case 0x04:
 	     printk(KERN_INFO "%s SCART output\n", stdstr);
 	     SiS_SetRegOR(SISCR, 0x32, 0x04);
-	     andSISIDXREG(SISCR, 0x32, ~0x03);
+	     SiS_SetRegAND(SISCR, 0x32, ~0x03);
 	     break;
 	default:
-	     andSISIDXREG(SISCR, 0x32, ~0x07);
+	     SiS_SetRegAND(SISCR, 0x32, ~0x07);
 	}
 #endif
     }
@@ -3690,7 +3690,7 @@ sisfb_fixup_SR11(struct sis_video_info *ivideo)
 			tmpreg = SiS_GetReg(SISSR, 0x11);
 		}
 		if(tmpreg & 0xf0) {
-			andSISIDXREG(SISSR,0x11,0x0f);
+			SiS_SetRegAND(SISSR, 0x11, 0x0f);
 		}
 	}
 }
@@ -3871,7 +3871,7 @@ sisfb_post_setmode(struct sis_video_info *ivideo)
 		}
 	}
 
-	andSISIDXREG(SISSR, IND_SIS_RAMDAC_CONTROL, ~0x04);
+	SiS_SetRegAND(SISSR, IND_SIS_RAMDAC_CONTROL, ~0x04);
 
 	if(ivideo->currentvbflags & CRT2_TV) {
 		if(ivideo->vbflags2 & VB2_SISBRIDGE) {
@@ -4194,7 +4194,7 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 	unsigned char reg;
 	int i, j;
 
-	andSISIDXREG(SISSR, 0x15, 0xFB);
+	SiS_SetRegAND(SISSR, 0x15, 0xFB);
 	SiS_SetRegOR(SISSR, 0x15, 0x04);
 	SiS_SetReg(SISSR, 0x13, 0x00);
 	SiS_SetReg(SISSR, 0x14, 0xBF);
@@ -4208,7 +4208,7 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 			SiS_SetRegOR(SISSR, 0x3c, 0x01);
 			reg = SiS_GetReg(SISSR, 0x05);
 			reg = SiS_GetReg(SISSR, 0x05);
-			andSISIDXREG(SISSR, 0x3c, 0xfe);
+			SiS_SetRegAND(SISSR, 0x3c, 0xfe);
 			reg = SiS_GetReg(SISSR, 0x05);
 			reg = SiS_GetReg(SISSR, 0x05);
 			temp++;
@@ -4283,7 +4283,7 @@ sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth
 		PhysicalAdrHalfPage = (PageCapacity / 2 + PhysicalAdrHigh) % PageCapacity;
 		PhysicalAdrOtherPage = PageCapacity * SiS_DRAMType[k][2] + PhysicalAdrHigh;
 
-		andSISIDXREG(SISSR, 0x15, 0xFB); /* Test */
+		SiS_SetRegAND(SISSR, 0x15, 0xFB); /* Test */
 		SiS_SetRegOR(SISSR, 0x15, 0x04);  /* Test */
 		sr14 = (SiS_DRAMType[k][3] * buswidth) - 1;
 		if(buswidth == 4)      sr14 |= 0x80;
@@ -4423,7 +4423,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	SiS_SetReg(SISSR, 0x1a, v6);
 	SiS_SetReg(SISSR, 0x1b, v7);
 	SiS_SetReg(SISSR, 0x1c, v8);	   /* ---- */
-	andSISIDXREG(SISSR, 0x15 ,0xfb);
+	SiS_SetRegAND(SISSR, 0x15, 0xfb);
 	SiS_SetRegOR(SISSR, 0x15, 0x04);
 	if(bios) {
 		if(bios[0x53] & 0x02) {
@@ -4485,7 +4485,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	}
 	SiS_SetReg(SISSR, 0x32, v2);
 
-	andSISIDXREG(SISPART1, 0x24, 0xfe);  /* Lock CRT2 */
+	SiS_SetRegAND(SISPART1, 0x24, 0xfe);  /* Lock CRT2 */
 
 	reg = SiS_GetReg(SISSR, 0x16);
 	reg &= 0xc3;
@@ -5067,7 +5067,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISCR, 0x7e, 0x0f);
 	}
 	if(ivideo->revision_id == 0) {	/* 40 *and* 20? */
-		andSISIDXREG(SISCR, 0x58, 0xd7);
+		SiS_SetRegAND(SISCR, 0x58, 0xd7);
 		reg = SiS_GetReg(SISCR, 0xcb);
 		if(reg & 0x20) {
 			setSISIDXREG(SISCR, 0x58, 0xd7, (reg & 0x10) ? 0x08 : 0x20); /* =0x28 Z7 ? */
@@ -5085,15 +5085,15 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISVID, 0x30, 0x00);
 		SiS_SetReg(SISVID, 0x32, 0x01);
 		SiS_SetReg(SISVID, 0x30, 0x00);
-		andSISIDXREG(SISVID, 0x2f, 0xdf);
-		andSISIDXREG(SISCAP, 0x00, 0x3f);
+		SiS_SetRegAND(SISVID, 0x2f, 0xdf);
+		SiS_SetRegAND(SISCAP, 0x00, 0x3f);
 
 		SiS_SetReg(SISPART1, 0x2f, 0x01);
 		SiS_SetReg(SISPART1, 0x00, 0x00);
 		SiS_SetReg(SISPART1, 0x02, bios[0x7e]);
 		SiS_SetReg(SISPART1, 0x2e, 0x08);
-		andSISIDXREG(SISPART1, 0x35, 0x7f);
-		andSISIDXREG(SISPART1, 0x50, 0xfe);
+		SiS_SetRegAND(SISPART1, 0x35, 0x7f);
+		SiS_SetRegAND(SISPART1, 0x50, 0xfe);
 
 		reg = SiS_GetReg(SISPART4, 0x00);
 		if(reg == 1 || reg == 2) {
@@ -5101,7 +5101,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			SiS_SetReg(SISPART4, 0x0d, bios[0x7f]);
 			SiS_SetReg(SISPART4, 0x0e, bios[0x80]);
 			SiS_SetReg(SISPART4, 0x10, bios[0x81]);
-			andSISIDXREG(SISPART4, 0x0f, 0x3f);
+			SiS_SetRegAND(SISPART4, 0x0f, 0x3f);
 
 			reg = SiS_GetReg(SISPART4, 0x01);
 			if((reg & 0xf0) >= 0xb0) {
@@ -5259,7 +5259,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		}
 	}
 
-	andSISIDXREG(SISCR, 0x6e, 0xfc);
+	SiS_SetRegAND(SISCR, 0x6e, 0xfc);
 
 	ptr  = NULL;
 	if(ivideo->haveXGIROM) {
@@ -5297,7 +5297,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISCR, 0x80 + i, ptr[j + regb]);
 	}
 
-	andSISIDXREG(SISCR, 0x89, 0x8f);
+	SiS_SetRegAND(SISCR, 0x89, 0x8f);
 
 	ptr  = cs45a;
 	if(ivideo->haveXGIROM) {
@@ -5660,7 +5660,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISSR, 0x05, 0x86);
 
 		/* Disable read-cache */
-		andSISIDXREG(SISSR, 0x21, 0xdf);
+		SiS_SetRegAND(SISSR, 0x21, 0xdf);
 		sisfb_post_xgi_ramsize(ivideo);
 		/* Enable read-cache */
 		SiS_SetRegOR(SISSR, 0x21, 0x20);
-- 
1.5.6.5

