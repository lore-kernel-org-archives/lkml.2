Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0LTVvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:51:15 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52284 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020Ab0LTVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:06 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 11/13] sisfb: replace setSISIDXREG with SiS_SetRegANDOR
Date: Mon, 20 Dec 2010 23:50:20 +0200
Message-Id: <1292881822-32630-12-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace setSISIDXREG() with SiS_SetRegANDOR().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   94 +++++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 65bf57f..793216b 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -930,12 +930,12 @@ sisfb_myblank(struct sis_video_info *ivideo, int blank)
 		     (ivideo->sisfb_thismonitor.feature & 0xe0))) {
 
 			if(ivideo->sisvga_engine == SIS_315_VGA) {
-				setSISIDXREG(SISCR, ivideo->SiS_Pr.SiS_MyCR63, 0xbf, cr63);
+				SiS_SetRegANDOR(SISCR, ivideo->SiS_Pr.SiS_MyCR63, 0xbf, cr63);
 			}
 
 			if(!(sisfb_bridgeisslave(ivideo))) {
-				setSISIDXREG(SISSR, 0x01, ~0x20, sr01);
-				setSISIDXREG(SISSR, 0x1f, 0x3f, sr1f);
+				SiS_SetRegANDOR(SISSR, 0x01, ~0x20, sr01);
+				SiS_SetRegANDOR(SISSR, 0x1f, 0x3f, sr1f);
 			}
 		}
 
@@ -965,25 +965,25 @@ sisfb_myblank(struct sis_video_info *ivideo, int blank)
 		    (ivideo->vbflags2 & (VB2_301|VB2_30xBDH|VB2_LVDS))) ||
 		   ((ivideo->sisvga_engine == SIS_315_VGA) &&
 		    ((ivideo->vbflags2 & (VB2_LVDS | VB2_CHRONTEL)) == VB2_LVDS))) {
-			setSISIDXREG(SISSR, 0x11, ~0x0c, sr11);
+			SiS_SetRegANDOR(SISSR, 0x11, ~0x0c, sr11);
 		}
 
 		if(ivideo->sisvga_engine == SIS_300_VGA) {
 			if((ivideo->vbflags2 & VB2_30xB) &&
 			   (!(ivideo->vbflags2 & VB2_30xBDH))) {
-				setSISIDXREG(SISPART1, 0x13, 0x3f, p1_13);
+				SiS_SetRegANDOR(SISPART1, 0x13, 0x3f, p1_13);
 			}
 		} else if(ivideo->sisvga_engine == SIS_315_VGA) {
 			if((ivideo->vbflags2 & VB2_30xB) &&
 			   (!(ivideo->vbflags2 & VB2_30xBDH))) {
-				setSISIDXREG(SISPART2, 0x00, 0x1f, p2_0);
+				SiS_SetRegANDOR(SISPART2, 0x00, 0x1f, p2_0);
 			}
 		}
 
 	} else if(ivideo->currentvbflags & CRT2_VGA) {
 
 		if(ivideo->vbflags2 & VB2_30xB) {
-			setSISIDXREG(SISPART2, 0x00, 0x1f, p2_0);
+			SiS_SetRegANDOR(SISPART2, 0x00, 0x1f, p2_0);
 		}
 
 	}
@@ -1115,14 +1115,14 @@ sisfb_set_pitch(struct sis_video_info *ivideo)
 	/* We need to set pitch for CRT1 if bridge is in slave mode, too */
 	if((ivideo->currentvbflags & VB_DISPTYPE_DISP1) || (isslavemode)) {
 		SiS_SetReg(SISCR, 0x13, (HDisplay1 & 0xFF));
-		setSISIDXREG(SISSR,0x0E,0xF0,(HDisplay1 >> 8));
+		SiS_SetRegANDOR(SISSR, 0x0E, 0xF0, (HDisplay1 >> 8));
 	}
 
 	/* We must not set the pitch for CRT2 if bridge is in slave mode */
 	if((ivideo->currentvbflags & VB_DISPTYPE_DISP2) && (!isslavemode)) {
 		SiS_SetRegOR(SISPART1, ivideo->CRT2_write_enable, 0x01);
 		SiS_SetReg(SISPART1, 0x07, (HDisplay2 & 0xFF));
-		setSISIDXREG(SISPART1,0x09,0xF0,(HDisplay2 >> 8));
+		SiS_SetRegANDOR(SISPART1, 0x09, 0xF0, (HDisplay2 >> 8));
 	}
 }
 
@@ -1314,7 +1314,7 @@ sisfb_set_base_CRT1(struct sis_video_info *ivideo, unsigned int base)
 	SiS_SetReg(SISCR, 0x0C, (base >> 8) & 0xFF);
 	SiS_SetReg(SISSR, 0x0D, (base >> 16) & 0xFF);
 	if(ivideo->sisvga_engine == SIS_315_VGA) {
-		setSISIDXREG(SISSR, 0x37, 0xFE, (base >> 24) & 0x01);
+		SiS_SetRegANDOR(SISSR, 0x37, 0xFE, (base >> 24) & 0x01);
 	}
 }
 
@@ -1327,7 +1327,7 @@ sisfb_set_base_CRT2(struct sis_video_info *ivideo, unsigned int base)
 		SiS_SetReg(SISPART1, 0x05, ((base >> 8) & 0xFF));
 		SiS_SetReg(SISPART1, 0x04, ((base >> 16) & 0xFF));
 		if(ivideo->sisvga_engine == SIS_315_VGA) {
-			setSISIDXREG(SISPART1, 0x02, 0x7F, ((base >> 24) & 0x01) << 7);
+			SiS_SetRegANDOR(SISPART1, 0x02, 0x7F, ((base >> 24) & 0x01) << 7);
 		}
 	}
 }
@@ -2259,11 +2259,11 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
 
 #ifdef CONFIG_FB_SIS_315
     if(ivideo->sisvga_engine == SIS_315_VGA) {
-       setSISIDXREG(SISCR,ivideo->SiS_Pr.SiS_MyCR63,0xBF,cr63);
+	SiS_SetRegANDOR(SISCR, ivideo->SiS_Pr.SiS_MyCR63, 0xBF, cr63);
     }
 #endif
 
-    setSISIDXREG(SISCR,0x17,0x7F,cr17);
+    SiS_SetRegANDOR(SISCR, 0x17, 0x7F, cr17);
 
     SiS_SetReg(SISSR, 0x1F, sr1F);
 }
@@ -2351,7 +2351,7 @@ SiS_SenseLCD(struct sis_video_info *ivideo)
 
 	SiS_SetReg(SISCR, 0x36, paneltype);
 	cr37 &= 0xf1;
-	setSISIDXREG(SISCR, 0x37, 0x0c, cr37);
+	SiS_SetRegANDOR(SISCR, 0x37, 0x0c, cr37);
 	SiS_SetRegOR(SISCR, 0x32, 0x08);
 
 	ivideo->SiS_Pr.PanelSelfDetected = true;
@@ -2368,7 +2368,7 @@ SISDoSense(struct sis_video_info *ivideo, u16 type, u16 test)
           mytest = test;
 	   SiS_SetReg(SISPART4, 0x11, (type & 0x00ff));
           temp = (type >> 8) | (mytest & 0x00ff);
-          setSISIDXREG(SISPART4,0x10,0xe0,temp);
+	  SiS_SetRegANDOR(SISPART4, 0x10, 0xe0, temp);
           SiS_DDC2Delay(&ivideo->SiS_Pr, 0x1500);
           mytest >>= 8;
           mytest &= 0x7f;
@@ -2443,7 +2443,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
 
     backupP4_0d = SiS_GetReg(SISPART4, 0x0d);
     if(ivideo->vbflags2 & VB2_30xC) {
-       setSISIDXREG(SISPART4,0x0d,~0x07,0x01);
+	SiS_SetRegANDOR(SISPART4, 0x0d, ~0x07, 0x01);
     } else {
        SiS_SetRegOR(SISPART4, 0x0d, 0x04);
     }
@@ -2941,8 +2941,8 @@ sisfb_detect_lcd_type(struct sis_video_info *ivideo)
 	if(ivideo->CRT2LCDType == LCD_UNKNOWN) {
 		/* For broken BIOSes: Assume 1024x768, RGB18 */
 		ivideo->CRT2LCDType = LCD_1024x768;
-		setSISIDXREG(SISCR,0x36,0xf0,0x02);
-		setSISIDXREG(SISCR,0x37,0xee,0x01);
+		SiS_SetRegANDOR(SISCR, 0x36, 0xf0, 0x02);
+		SiS_SetRegANDOR(SISCR, 0x37, 0xee, 0x01);
 		printk(KERN_DEBUG "sisfb: Invalid panel ID (%02x), assuming 1024x768, RGB18\n", reg);
 	}
 
@@ -3660,9 +3660,9 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 	if(ivideo->chip >= SIS_661) {
 #ifdef CONFIG_FB_SIS_315
 	   cr31 &= ~0x01;                          /* Clear PAL flag (now in CR35) */
-	   setSISIDXREG(SISCR, 0x35, ~0x10, cr35); /* Leave overscan bit alone */
+	   SiS_SetRegANDOR(SISCR, 0x35, ~0x10, cr35); /* Leave overscan bit alone */
 	   cr38 &= 0x07;                           /* Use only LCDA and HiVision/YPbPr bits */
-	   setSISIDXREG(SISCR, 0x38, 0xf8, cr38);
+	   SiS_SetRegANDOR(SISCR, 0x38, 0xf8, cr38);
 #endif
 	} else if(ivideo->chip != SIS_300) {
 	   SiS_SetReg(SISCR, tvregnum, cr38);
@@ -3746,9 +3746,9 @@ sisfb_set_TVxposoffset(struct sis_video_info *ivideo, int val)
 			p2_43 = temp & 0xff;
 			p2_42 = (temp & 0xf00) >> 4;
 			SiS_SetReg(SISPART2, 0x1f, p2_1f);
-			setSISIDXREG(SISPART2,0x20,0x0F,p2_20);
-			setSISIDXREG(SISPART2,0x2b,0xF0,p2_2b);
-			setSISIDXREG(SISPART2,0x42,0x0F,p2_42);
+			SiS_SetRegANDOR(SISPART2, 0x20, 0x0F, p2_20);
+			SiS_SetRegANDOR(SISPART2, 0x2b, 0xF0, p2_2b);
+			SiS_SetRegANDOR(SISPART2, 0x42, 0x0F, p2_42);
 			SiS_SetReg(SISPART2, 0x43, p2_43);
 		}
 	}
@@ -3840,7 +3840,7 @@ sisfb_post_setmode(struct sis_video_info *ivideo)
 			crt1isoff = false;
 			reg = 0x80;
 		}
-		setSISIDXREG(SISCR, 0x17, 0x7f, reg);
+		SiS_SetRegANDOR(SISCR, 0x17, 0x7f, reg);
 	}
 #endif
 #ifdef CONFIG_FB_SIS_315
@@ -3854,8 +3854,8 @@ sisfb_post_setmode(struct sis_video_info *ivideo)
 			reg  = 0x00;
 			reg1 = 0x00;
 		}
-		setSISIDXREG(SISCR, ivideo->SiS_Pr.SiS_MyCR63, ~0x40, reg);
-		setSISIDXREG(SISSR, 0x1f, ~0xc0, reg1);
+		SiS_SetRegANDOR(SISCR, ivideo->SiS_Pr.SiS_MyCR63, ~0x40, reg);
+		SiS_SetRegANDOR(SISSR, 0x1f, ~0xc0, reg1);
 	}
 #endif
 
@@ -4830,7 +4830,7 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 	}
 
 bail_out:
-	setSISIDXREG(SISSR, 0x14, 0xf0, sr14);
+	SiS_SetRegANDOR(SISSR, 0x14, 0xf0, sr14);
 	sisfb_post_xgi_delay(ivideo, 1);
 
 	j = (ivideo->chip == XGI_20) ? 5 : 9;
@@ -4840,7 +4840,7 @@ bail_out:
 
 		reg = (ivideo->chip == XGI_20) ?
 				dramsr13[(i * 5) + 4] : dramsr13_4[(i * 5) + 4];
-		setSISIDXREG(SISSR, 0x13, 0x80, reg);
+		SiS_SetRegANDOR(SISSR, 0x13, 0x80, reg);
 		sisfb_post_xgi_delay(ivideo, 50);
 
 		ranksize = (ivideo->chip == XGI_20) ?
@@ -4865,7 +4865,7 @@ bail_out:
 
 		if(!reg) continue;
 
-		setSISIDXREG(SISSR, 0x14, 0x0f, (reg & 0xf0));
+		SiS_SetRegANDOR(SISSR, 0x14, 0x0f, (reg & 0xf0));
 		sisfb_post_xgi_delay(ivideo, 1);
 
 		if(sisfb_post_xgi_rwtest(ivideo, j, ((reg >> 4) + channelab - 2 + 20), mapsize))
@@ -5061,7 +5061,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 
 	if(ivideo->chip == XGI_40) {
 		if(ivideo->revision_id == 2) {
-			setSISIDXREG(SISSR, 0x3b, 0x3f, 0xc0);
+			SiS_SetRegANDOR(SISSR, 0x3b, 0x3f, 0xc0);
 		}
 		SiS_SetReg(SISCR, 0x7d, 0xfe);
 		SiS_SetReg(SISCR, 0x7e, 0x0f);
@@ -5070,12 +5070,12 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetRegAND(SISCR, 0x58, 0xd7);
 		reg = SiS_GetReg(SISCR, 0xcb);
 		if(reg & 0x20) {
-			setSISIDXREG(SISCR, 0x58, 0xd7, (reg & 0x10) ? 0x08 : 0x20); /* =0x28 Z7 ? */
+			SiS_SetRegANDOR(SISCR, 0x58, 0xd7, (reg & 0x10) ? 0x08 : 0x20); /* =0x28 Z7 ? */
 		}
 	}
 
 	reg = (ivideo->chip == XGI_40) ? 0x20 : 0x00;
-	setSISIDXREG(SISCR, 0x38, 0x1f, reg);
+	SiS_SetRegANDOR(SISCR, 0x38, 0x1f, reg);
 
 	if(ivideo->chip == XGI_20) {
 		SiS_SetReg(SISSR, 0x36, 0x70);
@@ -5109,7 +5109,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 				if(reg & 0x20) reg |= 0x40;
 				SiS_SetReg(SISPART4, 0x23, reg);
 				reg = (reg & 0x20) ? 0x02 : 0x00;
-				setSISIDXREG(SISPART1, 0x1e, 0xfd, reg);
+				SiS_SetRegANDOR(SISPART1, 0x1e, 0xfd, reg);
 			}
 		}
 
@@ -5153,7 +5153,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 					v2 |= 0x08;
 				}
 			}
-			setSISIDXREG(SISCR, 0x5f, 0xf0, v2);
+			SiS_SetRegANDOR(SISCR, 0x5f, 0xf0, v2);
 		}
 		SiS_SetReg(SISSR, 0x22, v1);
 
@@ -5162,14 +5162,14 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			v2 = SiS_GetReg(SISSR, 0x3a);
 			regd = bios[0x90 + 3] | (bios[0x90 + 4] << 8);
 			if( (!(v1 & 0x02)) && (v2 & 0x30) && (regd < 0xcf) )
-				setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
+				SiS_SetRegANDOR(SISCR, 0x5f, 0xf1, 0x01);
 
 			if((mypdev = pci_get_device(0x10de, 0x01e0, NULL))) {
 				/* TODO: set CR5f &0xf1 | 0x01 for version 6570
 				 * of nforce 2 ROM
 				 */
 				if(0)
-					setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
+					SiS_SetRegANDOR(SISCR, 0x5f, 0xf1, 0x01);
 				pci_dev_put(mypdev);
 			}
 		}
@@ -5182,7 +5182,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISSR, 0x27, v1);
 
 		if(bios[0x64] & 0x01) {
-			setSISIDXREG(SISCR, 0x5f, 0xf0, bios[0x64]);
+			SiS_SetRegANDOR(SISCR, 0x5f, 0xf0, bios[0x64]);
 		}
 
 		v1 = bios[0x4f7];
@@ -5194,17 +5194,17 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		}
 		SiS_SetReg(SISCR, 0x48, v1);
 
-		setSISIDXREG(SISCR, 0x47, 0x04, bios[0x4f6] & 0xfb);
-		setSISIDXREG(SISCR, 0x49, 0xf0, bios[0x4f8] & 0x0f);
-		setSISIDXREG(SISCR, 0x4a, 0x60, bios[0x4f9] & 0x9f);
-		setSISIDXREG(SISCR, 0x4b, 0x08, bios[0x4fa] & 0xf7);
-		setSISIDXREG(SISCR, 0x4c, 0x80, bios[0x4fb] & 0x7f);
+		SiS_SetRegANDOR(SISCR, 0x47, 0x04, bios[0x4f6] & 0xfb);
+		SiS_SetRegANDOR(SISCR, 0x49, 0xf0, bios[0x4f8] & 0x0f);
+		SiS_SetRegANDOR(SISCR, 0x4a, 0x60, bios[0x4f9] & 0x9f);
+		SiS_SetRegANDOR(SISCR, 0x4b, 0x08, bios[0x4fa] & 0xf7);
+		SiS_SetRegANDOR(SISCR, 0x4c, 0x80, bios[0x4fb] & 0x7f);
 		SiS_SetReg(SISCR, 0x70, bios[0x4fc]);
-		setSISIDXREG(SISCR, 0x71, 0xf0, bios[0x4fd] & 0x0f);
+		SiS_SetRegANDOR(SISCR, 0x71, 0xf0, bios[0x4fd] & 0x0f);
 		SiS_SetReg(SISCR, 0x74, 0xd0);
-		setSISIDXREG(SISCR, 0x74, 0xcf, bios[0x4fe] & 0x30);
-		setSISIDXREG(SISCR, 0x75, 0xe0, bios[0x4ff] & 0x1f);
-		setSISIDXREG(SISCR, 0x76, 0xe0, bios[0x500] & 0x1f);
+		SiS_SetRegANDOR(SISCR, 0x74, 0xcf, bios[0x4fe] & 0x30);
+		SiS_SetRegANDOR(SISCR, 0x75, 0xe0, bios[0x4ff] & 0x1f);
+		SiS_SetRegANDOR(SISCR, 0x76, 0xe0, bios[0x500] & 0x1f);
 		v1 = bios[0x501];
 		if((mypdev = pci_get_device(0x8086, 0x2530, NULL))) {
 			v1 = 0xf0;
@@ -5267,7 +5267,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		ptr  = (const u8 *)&bios[index];
 	}
 	for(i = 0; i < 4; i++) {
-		setSISIDXREG(SISCR, 0x6e, 0xfc, i);
+		SiS_SetRegANDOR(SISCR, 0x6e, 0xfc, i);
 		reg = 0x00;
 		for(j = 0; j < 2; j++) {
 			regd = 0;
-- 
1.5.6.5

