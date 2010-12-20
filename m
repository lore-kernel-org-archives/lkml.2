Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0LTVvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:51:33 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:54101 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab0LTVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:05 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 08/13] sisfb: replace outSISIDXREG with SiS_SetReg
Date: Mon, 20 Dec 2010 23:50:17 +0200
Message-Id: <1292881822-32630-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace outSISIDXREG() with SiS_SetReg().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |  630 +++++++++++++++++++++---------------------
 1 files changed, 315 insertions(+), 315 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 6ea71b8..59a567c 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1114,14 +1114,14 @@ sisfb_set_pitch(struct sis_video_info *ivideo)
 
 	/* We need to set pitch for CRT1 if bridge is in slave mode, too */
 	if((ivideo->currentvbflags & VB_DISPTYPE_DISP1) || (isslavemode)) {
-		outSISIDXREG(SISCR,0x13,(HDisplay1 & 0xFF));
+		SiS_SetReg(SISCR, 0x13, (HDisplay1 & 0xFF));
 		setSISIDXREG(SISSR,0x0E,0xF0,(HDisplay1 >> 8));
 	}
 
 	/* We must not set the pitch for CRT2 if bridge is in slave mode */
 	if((ivideo->currentvbflags & VB_DISPTYPE_DISP2) && (!isslavemode)) {
 		orSISIDXREG(SISPART1,ivideo->CRT2_write_enable,0x01);
-		outSISIDXREG(SISPART1,0x07,(HDisplay2 & 0xFF));
+		SiS_SetReg(SISPART1, 0x07, (HDisplay2 & 0xFF));
 		setSISIDXREG(SISPART1,0x09,0xF0,(HDisplay2 >> 8));
 	}
 }
@@ -1167,7 +1167,7 @@ sisfb_set_mode(struct sis_video_info *ivideo, int clrscrn)
 	/* >=2.6.12's fbcon clears the screen anyway */
 	modeno |= 0x80;
 
-	outSISIDXREG(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
+	SiS_SetReg(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
 
 	sisfb_pre_setmode(ivideo);
 
@@ -1176,7 +1176,7 @@ sisfb_set_mode(struct sis_video_info *ivideo, int clrscrn)
 		return -EINVAL;
 	}
 
-	outSISIDXREG(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
+	SiS_SetReg(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
 
 	sisfb_post_setmode(ivideo);
 
@@ -1308,11 +1308,11 @@ sisfb_do_set_var(struct fb_var_screeninfo *var, int isactive, struct fb_info *in
 static void
 sisfb_set_base_CRT1(struct sis_video_info *ivideo, unsigned int base)
 {
-	outSISIDXREG(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
+	SiS_SetReg(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
 
-	outSISIDXREG(SISCR, 0x0D, base & 0xFF);
-	outSISIDXREG(SISCR, 0x0C, (base >> 8) & 0xFF);
-	outSISIDXREG(SISSR, 0x0D, (base >> 16) & 0xFF);
+	SiS_SetReg(SISCR, 0x0D, base & 0xFF);
+	SiS_SetReg(SISCR, 0x0C, (base >> 8) & 0xFF);
+	SiS_SetReg(SISSR, 0x0D, (base >> 16) & 0xFF);
 	if(ivideo->sisvga_engine == SIS_315_VGA) {
 		setSISIDXREG(SISSR, 0x37, 0xFE, (base >> 24) & 0x01);
 	}
@@ -1323,9 +1323,9 @@ sisfb_set_base_CRT2(struct sis_video_info *ivideo, unsigned int base)
 {
 	if(ivideo->currentvbflags & VB_DISPTYPE_DISP2) {
 		orSISIDXREG(SISPART1, ivideo->CRT2_write_enable, 0x01);
-		outSISIDXREG(SISPART1, 0x06, (base & 0xFF));
-		outSISIDXREG(SISPART1, 0x05, ((base >> 8) & 0xFF));
-		outSISIDXREG(SISPART1, 0x04, ((base >> 16) & 0xFF));
+		SiS_SetReg(SISPART1, 0x06, (base & 0xFF));
+		SiS_SetReg(SISPART1, 0x05, ((base >> 8) & 0xFF));
+		SiS_SetReg(SISPART1, 0x04, ((base >> 16) & 0xFF));
 		if(ivideo->sisvga_engine == SIS_315_VGA) {
 			setSISIDXREG(SISPART1, 0x02, 0x7F, ((base >> 24) & 0x01) << 7);
 		}
@@ -2216,8 +2216,8 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
     if(!cr17) {
        orSISIDXREG(SISCR,0x17,0x80);
        mustwait = true;
-       outSISIDXREG(SISSR, 0x00, 0x01);
-       outSISIDXREG(SISSR, 0x00, 0x03);
+       SiS_SetReg(SISSR, 0x00, 0x01);
+       SiS_SetReg(SISSR, 0x00, 0x03);
     }
 
     if(mustwait) {
@@ -2228,9 +2228,9 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
     if(ivideo->chip >= SIS_330) {
        andSISIDXREG(SISCR,0x32,~0x20);
        if(ivideo->chip >= SIS_340) {
-          outSISIDXREG(SISCR, 0x57, 0x4a);
+	   SiS_SetReg(SISCR, 0x57, 0x4a);
        } else {
-          outSISIDXREG(SISCR, 0x57, 0x5f);
+	   SiS_SetReg(SISCR, 0x57, 0x5f);
        }
        orSISIDXREG(SISCR, 0x53, 0x02);
 	while ((SiS_GetRegByte(SISINPSTAT)) & 0x01)    break;
@@ -2265,7 +2265,7 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
 
     setSISIDXREG(SISCR,0x17,0x7F,cr17);
 
-    outSISIDXREG(SISSR,0x1F,sr1F);
+    SiS_SetReg(SISSR, 0x1F, sr1F);
 }
 
 /* Determine and detect attached devices on SiS30x */
@@ -2349,7 +2349,7 @@ SiS_SenseLCD(struct sis_video_info *ivideo)
 	else
 		cr37 |= 0xc0;
 
-	outSISIDXREG(SISCR, 0x36, paneltype);
+	SiS_SetReg(SISCR, 0x36, paneltype);
 	cr37 &= 0xf1;
 	setSISIDXREG(SISCR, 0x37, 0x0c, cr37);
 	orSISIDXREG(SISCR, 0x32, 0x08);
@@ -2366,7 +2366,7 @@ SISDoSense(struct sis_video_info *ivideo, u16 type, u16 test)
        result = 0;
        for(i = 0; i < 3; i++) {
           mytest = test;
-          outSISIDXREG(SISPART4,0x11,(type & 0x00ff));
+	   SiS_SetReg(SISPART4, 0x11, (type & 0x00ff));
           temp = (type >> 8) | (mytest & 0x00ff);
           setSISIDXREG(SISPART4,0x10,0xe0,temp);
           SiS_DDC2Delay(&ivideo->SiS_Pr, 0x1500);
@@ -2377,7 +2377,7 @@ SISDoSense(struct sis_video_info *ivideo, u16 type, u16 test)
           temp &= mytest;
           if(temp == mytest) result++;
 #if 1
-	  outSISIDXREG(SISPART4,0x11,0x00);
+	  SiS_SetReg(SISPART4, 0x11, 0x00);
 	  andSISIDXREG(SISPART4,0x10,0xe0);
 	  SiS_DDC2Delay(&ivideo->SiS_Pr, 0x1000);
 #endif
@@ -2450,11 +2450,11 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     SiS_DDC2Delay(&ivideo->SiS_Pr, 0x2000);
 
     backupP2_00 = SiS_GetReg(SISPART2, 0x00);
-    outSISIDXREG(SISPART2,0x00,((backupP2_00 | 0x1c) & 0xfc));
+    SiS_SetReg(SISPART2, 0x00, ((backupP2_00 | 0x1c) & 0xfc));
 
     backupP2_4d = SiS_GetReg(SISPART2, 0x4d);
     if(ivideo->vbflags2 & VB2_SISYPBPRBRIDGE) {
-       outSISIDXREG(SISPART2,0x4d,(backupP2_4d & ~0x10));
+	SiS_SetReg(SISPART2, 0x4d, (backupP2_4d & ~0x10));
     }
 
     if(!(ivideo->vbflags2 & VB2_30xCLV)) {
@@ -2482,7 +2482,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     }
 
     if((ivideo->sisvga_engine == SIS_315_VGA) && (ivideo->vbflags2 & VB2_SISYPBPRBRIDGE)) {
-       outSISIDXREG(SISPART2,0x4d,(backupP2_4d | 0x10));
+       SiS_SetReg(SISPART2, 0x4d, (backupP2_4d | 0x10));
        SiS_DDC2Delay(&ivideo->SiS_Pr, 0x2000);
        if((result = SISDoSense(ivideo, svhs, 0x0604))) {
           if((result = SISDoSense(ivideo, cvbs, 0x0804))) {
@@ -2490,7 +2490,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
 	     orSISIDXREG(SISCR,0x32,0x80);
 	  }
        }
-       outSISIDXREG(SISPART2,0x4d,backupP2_4d);
+       SiS_SetReg(SISPART2, 0x4d, backupP2_4d);
     }
 
     andSISIDXREG(SISCR, 0x32, ~0x03);
@@ -2510,21 +2510,21 @@ SiS_Sense30x(struct sis_video_info *ivideo)
 
     SISDoSense(ivideo, 0, 0);
 
-    outSISIDXREG(SISPART2,0x00,backupP2_00);
-    outSISIDXREG(SISPART4,0x0d,backupP4_0d);
-    outSISIDXREG(SISSR,0x1e,backupSR_1e);
+    SiS_SetReg(SISPART2, 0x00, backupP2_00);
+    SiS_SetReg(SISPART4, 0x0d, backupP4_0d);
+    SiS_SetReg(SISSR, 0x1e, backupSR_1e);
 
     if(ivideo->vbflags2 & VB2_30xCLV) {
 	biosflag = SiS_GetReg(SISPART2, 0x00);
        if(biosflag & 0x20) {
           for(myflag = 2; myflag > 0; myflag--) {
 	     biosflag ^= 0x20;
-	     outSISIDXREG(SISPART2,0x00,biosflag);
+	     SiS_SetReg(SISPART2, 0x00, biosflag);
 	  }
        }
     }
 
-    outSISIDXREG(SISPART2,0x00,backupP2_00);
+    SiS_SetReg(SISPART2, 0x00, backupP2_00);
 }
 
 /* Determine and detect attached TV's on Chrontel */
@@ -2826,9 +2826,9 @@ sisfb_engine_init(struct sis_video_info *ivideo)
 		tq_state |= 0xf0;
 		tq_state &= 0xfc;
 		tq_state |= (u8)(tqueue_pos >> 8);
-		outSISIDXREG(SISSR, IND_SIS_TURBOQUEUE_SET, tq_state);
+		SiS_SetReg(SISSR, IND_SIS_TURBOQUEUE_SET, tq_state);
 
-		outSISIDXREG(SISSR, IND_SIS_TURBOQUEUE_ADR, (u8)(tqueue_pos & 0xff));
+		SiS_SetReg(SISSR, IND_SIS_TURBOQUEUE_ADR, (u8)(tqueue_pos & 0xff));
 
 		ivideo->caps |= TURBO_QUEUE_CAP;
 	}
@@ -2865,8 +2865,8 @@ sisfb_engine_init(struct sis_video_info *ivideo)
 			}
 		}
 
-		outSISIDXREG(SISSR, IND_SIS_CMDQUEUE_THRESHOLD, COMMAND_QUEUE_THRESHOLD);
-		outSISIDXREG(SISSR, IND_SIS_CMDQUEUE_SET, SIS_CMD_QUEUE_RESET);
+		SiS_SetReg(SISSR, IND_SIS_CMDQUEUE_THRESHOLD, COMMAND_QUEUE_THRESHOLD);
+		SiS_SetReg(SISSR, IND_SIS_CMDQUEUE_SET, SIS_CMD_QUEUE_RESET);
 
 		if((ivideo->chip >= XGI_40) && ivideo->modechanged) {
 			/* Must disable dual pipe on XGI_40. Can't do
@@ -2878,7 +2878,7 @@ sisfb_engine_init(struct sis_video_info *ivideo)
 
 				MMIO_OUT32(ivideo->mmio_vbase, Q_WRITE_PTR, 0);
 
-				outSISIDXREG(SISSR, IND_SIS_CMDQUEUE_SET, (temp | SIS_VRAM_CMDQUEUE_ENABLE));
+				SiS_SetReg(SISSR, IND_SIS_CMDQUEUE_SET, (temp | SIS_VRAM_CMDQUEUE_ENABLE));
 
 				tempq = MMIO_IN32(ivideo->mmio_vbase, Q_READ_PTR);
 				MMIO_OUT32(ivideo->mmio_vbase, Q_WRITE_PTR, tempq);
@@ -2895,7 +2895,7 @@ sisfb_engine_init(struct sis_video_info *ivideo)
 
 				sisfb_syncaccel(ivideo);
 
-				outSISIDXREG(SISSR, IND_SIS_CMDQUEUE_SET, SIS_CMD_QUEUE_RESET);
+				SiS_SetReg(SISSR, IND_SIS_CMDQUEUE_SET, SIS_CMD_QUEUE_RESET);
 
 			}
 		}
@@ -2904,7 +2904,7 @@ sisfb_engine_init(struct sis_video_info *ivideo)
 		MMIO_OUT32(ivideo->mmio_vbase, MMIO_QUEUE_WRITEPORT, tempq);
 
 		temp |= (SIS_MMIO_CMD_ENABLE | SIS_CMD_AUTO_CORR);
-		outSISIDXREG(SISSR, IND_SIS_CMDQUEUE_SET, temp);
+		SiS_SetReg(SISSR, IND_SIS_CMDQUEUE_SET, temp);
 
 		tempq = (u32)(ivideo->video_size - ivideo->cmdQueueSize);
 		MMIO_OUT32(ivideo->mmio_vbase, MMIO_QUEUE_PHYBASE, tempq);
@@ -3524,7 +3524,7 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 
 	ivideo->currentvbflags &= (VB_VIDEOBRIDGE | VB_DISPTYPE_DISP2);
 
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	cr31 = SiS_GetReg(SISCR, 0x31);
 	cr31 &= ~0x60;
@@ -3654,8 +3654,8 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 	      cr31 |= (SIS_DRIVER_MODE | SIS_VB_OUTPUT_DISABLE);
 	}
 
-	outSISIDXREG(SISCR, 0x30, cr30);
-	outSISIDXREG(SISCR, 0x33, cr33);
+	SiS_SetReg(SISCR, 0x30, cr30);
+	SiS_SetReg(SISCR, 0x33, cr33);
 
 	if(ivideo->chip >= SIS_661) {
 #ifdef CONFIG_FB_SIS_315
@@ -3665,9 +3665,9 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 	   setSISIDXREG(SISCR, 0x38, 0xf8, cr38);
 #endif
 	} else if(ivideo->chip != SIS_300) {
-	   outSISIDXREG(SISCR, tvregnum, cr38);
+	   SiS_SetReg(SISCR, tvregnum, cr38);
 	}
-	outSISIDXREG(SISCR, 0x31, cr31);
+	SiS_SetReg(SISCR, 0x31, cr31);
 
 	ivideo->SiS_Pr.SiS_UseOEM = ivideo->sisfb_useoem;
 
@@ -3686,7 +3686,7 @@ sisfb_fixup_SR11(struct sis_video_info *ivideo)
 		if(tmpreg & 0x20) {
 			tmpreg = SiS_GetReg(SISSR, 0x3e);
 			tmpreg = (tmpreg + 1) & 0xff;
-			outSISIDXREG(SISSR,0x3e,tmpreg);
+			SiS_SetReg(SISSR, 0x3e, tmpreg);
 			tmpreg = SiS_GetReg(SISSR, 0x11);
 		}
 		if(tmpreg & 0xf0) {
@@ -3716,7 +3716,7 @@ sisfb_set_TVxposoffset(struct sis_video_info *ivideo, int val)
 			case 1:
 				x += val;
 				if(x < 0) x = 0;
-				outSISIDXREG(SISSR,0x05,0x86);
+				SiS_SetReg(SISSR, 0x05, 0x86);
 				SiS_SetCH700x(&ivideo->SiS_Pr, 0x0a, (x & 0xff));
 				SiS_SetCH70xxANDOR(&ivideo->SiS_Pr, 0x08, ((x & 0x0100) >> 7), 0xFD);
 				break;
@@ -3745,11 +3745,11 @@ sisfb_set_TVxposoffset(struct sis_video_info *ivideo, int val)
 			temp += (val * 2);
 			p2_43 = temp & 0xff;
 			p2_42 = (temp & 0xf00) >> 4;
-			outSISIDXREG(SISPART2,0x1f,p2_1f);
+			SiS_SetReg(SISPART2, 0x1f, p2_1f);
 			setSISIDXREG(SISPART2,0x20,0x0F,p2_20);
 			setSISIDXREG(SISPART2,0x2b,0xF0,p2_2b);
 			setSISIDXREG(SISPART2,0x42,0x0F,p2_42);
-			outSISIDXREG(SISPART2,0x43,p2_43);
+			SiS_SetReg(SISPART2, 0x43, p2_43);
 		}
 	}
 }
@@ -3774,7 +3774,7 @@ sisfb_set_TVyposoffset(struct sis_video_info *ivideo, int val)
 			case 1:
 				y -= val;
 				if(y < 0) y = 0;
-				outSISIDXREG(SISSR,0x05,0x86);
+				SiS_SetReg(SISSR, 0x05, 0x86);
 				SiS_SetCH700x(&ivideo->SiS_Pr, 0x0b, (y & 0xff));
 				SiS_SetCH70xxANDOR(&ivideo->SiS_Pr, 0x08, ((y & 0x0100) >> 8), 0xFE);
 				break;
@@ -3798,8 +3798,8 @@ sisfb_set_TVyposoffset(struct sis_video_info *ivideo, int val)
 					p2_02 += 2;
 				}
 			}
-			outSISIDXREG(SISPART2,0x01,p2_01);
-			outSISIDXREG(SISPART2,0x02,p2_02);
+			SiS_SetReg(SISPART2, 0x01, p2_01);
+			SiS_SetReg(SISPART2, 0x02, p2_02);
 		}
 	}
 }
@@ -3816,7 +3816,7 @@ sisfb_post_setmode(struct sis_video_info *ivideo)
 	u8 reg1;
 #endif
 
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 
 #ifdef CONFIG_FB_SIS_315
 	sisfb_fixup_SR11(ivideo);
@@ -4196,8 +4196,8 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 
 	andSISIDXREG(SISSR, 0x15, 0xFB);
 	orSISIDXREG(SISSR, 0x15, 0x04);
-	outSISIDXREG(SISSR, 0x13, 0x00);
-	outSISIDXREG(SISSR, 0x14, 0xBF);
+	SiS_SetReg(SISSR, 0x13, 0x00);
+	SiS_SetReg(SISSR, 0x14, 0xBF);
 
 	for(i = 0; i < 2; i++) {
 		temp = 0x1234;
@@ -4288,8 +4288,8 @@ sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth
 		sr14 = (SiS_DRAMType[k][3] * buswidth) - 1;
 		if(buswidth == 4)      sr14 |= 0x80;
 		else if(buswidth == 2) sr14 |= 0x40;
-		outSISIDXREG(SISSR, 0x13, SiS_DRAMType[k][4]);
-		outSISIDXREG(SISSR, 0x14, sr14);
+		SiS_SetReg(SISSR, 0x13, SiS_DRAMType[k][4]);
+		SiS_SetReg(SISSR, 0x14, sr14);
 
 		BankNumHigh <<= 16;
 		BankNumMid <<= 16;
@@ -4356,7 +4356,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	if(!ivideo->SiS_Pr.UseROM)
 		bios = NULL;
 
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	if(bios) {
 		if(bios[0x52] & 0x80) {
@@ -4386,19 +4386,19 @@ sisfb_post_sis300(struct pci_dev *pdev)
 			v6 = bios[rindex++];
 		}
 	}
-	outSISIDXREG(SISSR, 0x28, v1);
-	outSISIDXREG(SISSR, 0x29, v2);
-	outSISIDXREG(SISSR, 0x2a, v3);
-	outSISIDXREG(SISSR, 0x2e, v4);
-	outSISIDXREG(SISSR, 0x2f, v5);
-	outSISIDXREG(SISSR, 0x30, v6);
+	SiS_SetReg(SISSR, 0x28, v1);
+	SiS_SetReg(SISSR, 0x29, v2);
+	SiS_SetReg(SISSR, 0x2a, v3);
+	SiS_SetReg(SISSR, 0x2e, v4);
+	SiS_SetReg(SISSR, 0x2f, v5);
+	SiS_SetReg(SISSR, 0x30, v6);
 
 	v1 = 0x10;
 	if(bios)
 		v1 = bios[0xa4];
-	outSISIDXREG(SISSR, 0x07, v1);       /* DAC speed */
+	SiS_SetReg(SISSR, 0x07, v1);       /* DAC speed */
 
-	outSISIDXREG(SISSR, 0x11, 0x0f);     /* DDC, power save */
+	SiS_SetReg(SISSR, 0x11, 0x0f);     /* DDC, power save */
 
 	v1 = 0x01; v2 = 0x43; v3 = 0x1e; v4 = 0x2a;
 	v5 = 0x06; v6 = 0x00; v7 = 0x00; v8 = 0x00;
@@ -4415,14 +4415,14 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	}
 	if(ivideo->revision_id >= 0x80)
 		v3 &= 0xfd;
-	outSISIDXREG(SISSR, 0x15, v1);       /* Ram type (assuming 0, BIOS 0xa5 step 8) */
-	outSISIDXREG(SISSR, 0x16, v2);
-	outSISIDXREG(SISSR, 0x17, v3);
-	outSISIDXREG(SISSR, 0x18, v4);
-	outSISIDXREG(SISSR, 0x19, v5);
-	outSISIDXREG(SISSR, 0x1a, v6);
-	outSISIDXREG(SISSR, 0x1b, v7);
-	outSISIDXREG(SISSR, 0x1c, v8);	   /* ---- */
+	SiS_SetReg(SISSR, 0x15, v1);       /* Ram type (assuming 0, BIOS 0xa5 step 8) */
+	SiS_SetReg(SISSR, 0x16, v2);
+	SiS_SetReg(SISSR, 0x17, v3);
+	SiS_SetReg(SISSR, 0x18, v4);
+	SiS_SetReg(SISSR, 0x19, v5);
+	SiS_SetReg(SISSR, 0x1a, v6);
+	SiS_SetReg(SISSR, 0x1b, v7);
+	SiS_SetReg(SISSR, 0x1c, v8);	   /* ---- */
 	andSISIDXREG(SISSR, 0x15 ,0xfb);
 	orSISIDXREG(SISSR, 0x15, 0x04);
 	if(bios) {
@@ -4433,69 +4433,69 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	v1 = 0x04;			   /* DAC pedestal (BIOS 0xe5) */
 	if(ivideo->revision_id >= 0x80)
 		v1 |= 0x01;
-	outSISIDXREG(SISSR, 0x1f, v1);
-	outSISIDXREG(SISSR, 0x20, 0xa4);     /* linear & relocated io & disable a0000 */
+	SiS_SetReg(SISSR, 0x1f, v1);
+	SiS_SetReg(SISSR, 0x20, 0xa4);     /* linear & relocated io & disable a0000 */
 	v1 = 0xf6; v2 = 0x0d; v3 = 0x00;
 	if(bios) {
 		v1 = bios[0xe8];
 		v2 = bios[0xe9];
 		v3 = bios[0xea];
 	}
-	outSISIDXREG(SISSR, 0x23, v1);
-	outSISIDXREG(SISSR, 0x24, v2);
-	outSISIDXREG(SISSR, 0x25, v3);
-	outSISIDXREG(SISSR, 0x21, 0x84);
-	outSISIDXREG(SISSR, 0x22, 0x00);
-	outSISIDXREG(SISCR, 0x37, 0x00);
+	SiS_SetReg(SISSR, 0x23, v1);
+	SiS_SetReg(SISSR, 0x24, v2);
+	SiS_SetReg(SISSR, 0x25, v3);
+	SiS_SetReg(SISSR, 0x21, 0x84);
+	SiS_SetReg(SISSR, 0x22, 0x00);
+	SiS_SetReg(SISCR, 0x37, 0x00);
 	orSISIDXREG(SISPART1, 0x24, 0x01);   /* unlock crt2 */
-	outSISIDXREG(SISPART1, 0x00, 0x00);
+	SiS_SetReg(SISPART1, 0x00, 0x00);
 	v1 = 0x40; v2 = 0x11;
 	if(bios) {
 		v1 = bios[0xec];
 		v2 = bios[0xeb];
 	}
-	outSISIDXREG(SISPART1, 0x02, v1);
+	SiS_SetReg(SISPART1, 0x02, v1);
 
 	if(ivideo->revision_id >= 0x80)
 		v2 &= ~0x01;
 
 	reg = SiS_GetReg(SISPART4, 0x00);
 	if((reg == 1) || (reg == 2)) {
-		outSISIDXREG(SISCR, 0x37, 0x02);
-		outSISIDXREG(SISPART2, 0x00, 0x1c);
+		SiS_SetReg(SISCR, 0x37, 0x02);
+		SiS_SetReg(SISPART2, 0x00, 0x1c);
 		v4 = 0x00; v5 = 0x00; v6 = 0x10;
 		if(ivideo->SiS_Pr.UseROM) {
 			v4 = bios[0xf5];
 			v5 = bios[0xf6];
 			v6 = bios[0xf7];
 		}
-		outSISIDXREG(SISPART4, 0x0d, v4);
-		outSISIDXREG(SISPART4, 0x0e, v5);
-		outSISIDXREG(SISPART4, 0x10, v6);
-		outSISIDXREG(SISPART4, 0x0f, 0x3f);
+		SiS_SetReg(SISPART4, 0x0d, v4);
+		SiS_SetReg(SISPART4, 0x0e, v5);
+		SiS_SetReg(SISPART4, 0x10, v6);
+		SiS_SetReg(SISPART4, 0x0f, 0x3f);
 		reg = SiS_GetReg(SISPART4, 0x01);
 		if(reg >= 0xb0) {
 			reg = SiS_GetReg(SISPART4, 0x23);
 			reg &= 0x20;
 			reg <<= 1;
-			outSISIDXREG(SISPART4, 0x23, reg);
+			SiS_SetReg(SISPART4, 0x23, reg);
 		}
 	} else {
 		v2 &= ~0x10;
 	}
-	outSISIDXREG(SISSR, 0x32, v2);
+	SiS_SetReg(SISSR, 0x32, v2);
 
 	andSISIDXREG(SISPART1, 0x24, 0xfe);  /* Lock CRT2 */
 
 	reg = SiS_GetReg(SISSR, 0x16);
 	reg &= 0xc3;
-	outSISIDXREG(SISCR, 0x35, reg);
-	outSISIDXREG(SISCR, 0x83, 0x00);
+	SiS_SetReg(SISCR, 0x35, reg);
+	SiS_SetReg(SISCR, 0x83, 0x00);
 #if !defined(__i386__) && !defined(__x86_64__)
 	if(sisfb_videoram) {
-		outSISIDXREG(SISSR, 0x13, 0x28);  /* ? */
+		SiS_SetReg(SISSR, 0x13, 0x28);  /* ? */
 		reg = ((sisfb_videoram >> 10) - 1) | 0x40;
-		outSISIDXREG(SISSR, 0x14, reg);
+		SiS_SetReg(SISSR, 0x14, reg);
 	} else {
 #endif
 		/* Need to map max FB size for finding out about RAM size */
@@ -4508,8 +4508,8 @@ sisfb_post_sis300(struct pci_dev *pdev)
 		} else {
 			printk(KERN_DEBUG
 				"sisfb: Failed to map memory for size detection, assuming 8MB\n");
-			outSISIDXREG(SISSR, 0x13, 0x28);  /* ? */
-			outSISIDXREG(SISSR, 0x14, 0x47);  /* 8MB, 64bit default */
+			SiS_SetReg(SISSR, 0x13, 0x28);  /* ? */
+			SiS_SetReg(SISSR, 0x14, 0x47);  /* 8MB, 64bit default */
 		}
 #if !defined(__i386__) && !defined(__x86_64__)
 	}
@@ -4527,8 +4527,8 @@ sisfb_post_sis300(struct pci_dev *pdev)
 			v2 = 0xb2;
 		}
 	}
-	outSISIDXREG(SISSR, 0x21, v1);
-	outSISIDXREG(SISSR, 0x22, v2);
+	SiS_SetReg(SISSR, 0x21, v1);
+	SiS_SetReg(SISSR, 0x22, v2);
 
 	/* Sense CRT1 */
 	sisfb_sense_crt1(ivideo);
@@ -4541,13 +4541,13 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	ivideo->SiS_Pr.VideoMemorySize = 8 << 20;
 	SiSSetMode(&ivideo->SiS_Pr, 0x2e | 0x80);
 
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	/* Display off */
 	orSISIDXREG(SISSR, 0x01, 0x20);
 
 	/* Save mode number in CR34 */
-	outSISIDXREG(SISCR, 0x34, 0x2e);
+	SiS_SetReg(SISCR, 0x34, 0x2e);
 
 	/* Let everyone know what the current mode is */
 	ivideo->modeprechange = 0x2e;
@@ -4670,16 +4670,16 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 
 	if(!ivideo->video_vbase) {
 		printk(KERN_ERR "sisfb: Unable to detect RAM size. Setting default.\n");
-		outSISIDXREG(SISSR, 0x13, 0x35);
-		outSISIDXREG(SISSR, 0x14, 0x41);
+		SiS_SetReg(SISSR, 0x13, 0x35);
+		SiS_SetReg(SISSR, 0x14, 0x41);
 		/* TODO */
 		return;
 	}
 
 	/* Non-interleaving */
-	outSISIDXREG(SISSR, 0x15, 0x00);
+	SiS_SetReg(SISSR, 0x15, 0x00);
 	/* No tiling */
-	outSISIDXREG(SISSR, 0x1c, 0x00);
+	SiS_SetReg(SISSR, 0x1c, 0x00);
 
 	if(ivideo->chip == XGI_20) {
 
@@ -4687,52 +4687,52 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 		reg = SiS_GetReg(SISCR, 0x97);
 		if(!(reg & 0x01)) {	/* Single 32/16 */
 			buswidth = 32;
-			outSISIDXREG(SISSR, 0x13, 0xb1);
-			outSISIDXREG(SISSR, 0x14, 0x52);
+			SiS_SetReg(SISSR, 0x13, 0xb1);
+			SiS_SetReg(SISSR, 0x14, 0x52);
 			sisfb_post_xgi_delay(ivideo, 1);
 			sr14 = 0x02;
 			if(sisfb_post_xgi_rwtest(ivideo, 23, 24, mapsize))
 				goto bail_out;
 
-			outSISIDXREG(SISSR, 0x13, 0x31);
-			outSISIDXREG(SISSR, 0x14, 0x42);
+			SiS_SetReg(SISSR, 0x13, 0x31);
+			SiS_SetReg(SISSR, 0x14, 0x42);
 			sisfb_post_xgi_delay(ivideo, 1);
 			if(sisfb_post_xgi_rwtest(ivideo, 23, 23, mapsize))
 				goto bail_out;
 
 			buswidth = 16;
-			outSISIDXREG(SISSR, 0x13, 0xb1);
-			outSISIDXREG(SISSR, 0x14, 0x41);
+			SiS_SetReg(SISSR, 0x13, 0xb1);
+			SiS_SetReg(SISSR, 0x14, 0x41);
 			sisfb_post_xgi_delay(ivideo, 1);
 			sr14 = 0x01;
 			if(sisfb_post_xgi_rwtest(ivideo, 22, 23, mapsize))
 				goto bail_out;
 			else
-				outSISIDXREG(SISSR, 0x13, 0x31);
+				SiS_SetReg(SISSR, 0x13, 0x31);
 		} else {		/* Dual 16/8 */
 			buswidth = 16;
-			outSISIDXREG(SISSR, 0x13, 0xb1);
-			outSISIDXREG(SISSR, 0x14, 0x41);
+			SiS_SetReg(SISSR, 0x13, 0xb1);
+			SiS_SetReg(SISSR, 0x14, 0x41);
 			sisfb_post_xgi_delay(ivideo, 1);
 			sr14 = 0x01;
 			if(sisfb_post_xgi_rwtest(ivideo, 22, 23, mapsize))
 				goto bail_out;
 
-			outSISIDXREG(SISSR, 0x13, 0x31);
-			outSISIDXREG(SISSR, 0x14, 0x31);
+			SiS_SetReg(SISSR, 0x13, 0x31);
+			SiS_SetReg(SISSR, 0x14, 0x31);
 			sisfb_post_xgi_delay(ivideo, 1);
 			if(sisfb_post_xgi_rwtest(ivideo, 22, 22, mapsize))
 				goto bail_out;
 
 			buswidth = 8;
-			outSISIDXREG(SISSR, 0x13, 0xb1);
-			outSISIDXREG(SISSR, 0x14, 0x30);
+			SiS_SetReg(SISSR, 0x13, 0xb1);
+			SiS_SetReg(SISSR, 0x14, 0x30);
 			sisfb_post_xgi_delay(ivideo, 1);
 			sr14 = 0x00;
 			if(sisfb_post_xgi_rwtest(ivideo, 21, 22, mapsize))
 				goto bail_out;
 			else
-				outSISIDXREG(SISSR, 0x13, 0x31);
+				SiS_SetReg(SISSR, 0x13, 0x31);
 		}
 
 	} else {	/* XGI_40 */
@@ -4747,52 +4747,52 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 			buswidth = 32;
 			if(ivideo->revision_id == 2) {
 				channelab = 2;
-				outSISIDXREG(SISSR, 0x13, 0xa1);
-				outSISIDXREG(SISSR, 0x14, 0x44);
+				SiS_SetReg(SISSR, 0x13, 0xa1);
+				SiS_SetReg(SISSR, 0x14, 0x44);
 				sr14 = 0x04;
 				sisfb_post_xgi_delay(ivideo, 1);
 				if(sisfb_post_xgi_rwtest(ivideo, 23, 24, mapsize))
 					goto bail_out;
 
-				outSISIDXREG(SISSR, 0x13, 0x21);
-				outSISIDXREG(SISSR, 0x14, 0x34);
+				SiS_SetReg(SISSR, 0x13, 0x21);
+				SiS_SetReg(SISSR, 0x14, 0x34);
 				if(sisfb_post_xgi_rwtest(ivideo, 22, 23, mapsize))
 					goto bail_out;
 
 				channelab = 1;
-				outSISIDXREG(SISSR, 0x13, 0xa1);
-				outSISIDXREG(SISSR, 0x14, 0x40);
+				SiS_SetReg(SISSR, 0x13, 0xa1);
+				SiS_SetReg(SISSR, 0x14, 0x40);
 				sr14 = 0x00;
 				if(sisfb_post_xgi_rwtest(ivideo, 22, 23, mapsize))
 					goto bail_out;
 
-				outSISIDXREG(SISSR, 0x13, 0x21);
-				outSISIDXREG(SISSR, 0x14, 0x30);
+				SiS_SetReg(SISSR, 0x13, 0x21);
+				SiS_SetReg(SISSR, 0x14, 0x30);
 			} else {
 				channelab = 3;
-				outSISIDXREG(SISSR, 0x13, 0xa1);
-				outSISIDXREG(SISSR, 0x14, 0x4c);
+				SiS_SetReg(SISSR, 0x13, 0xa1);
+				SiS_SetReg(SISSR, 0x14, 0x4c);
 				sr14 = 0x0c;
 				sisfb_post_xgi_delay(ivideo, 1);
 				if(sisfb_post_xgi_rwtest(ivideo, 23, 25, mapsize))
 					goto bail_out;
 
 				channelab = 2;
-				outSISIDXREG(SISSR, 0x14, 0x48);
+				SiS_SetReg(SISSR, 0x14, 0x48);
 				sisfb_post_xgi_delay(ivideo, 1);
 				sr14 = 0x08;
 				if(sisfb_post_xgi_rwtest(ivideo, 23, 24, mapsize))
 					goto bail_out;
 
-				outSISIDXREG(SISSR, 0x13, 0x21);
-				outSISIDXREG(SISSR, 0x14, 0x3c);
+				SiS_SetReg(SISSR, 0x13, 0x21);
+				SiS_SetReg(SISSR, 0x14, 0x3c);
 				sr14 = 0x0c;
 
 				if(sisfb_post_xgi_rwtest(ivideo, 23, 24, mapsize)) {
 					channelab = 3;
 				} else {
 					channelab = 2;
-					outSISIDXREG(SISSR, 0x14, 0x38);
+					SiS_SetReg(SISSR, 0x14, 0x38);
 					sr14 = 0x08;
 				}
 			}
@@ -4803,26 +4803,26 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 			buswidth = 64;
 			if(ivideo->revision_id == 2) {
 				channelab = 1;
-				outSISIDXREG(SISSR, 0x13, 0xa1);
-				outSISIDXREG(SISSR, 0x14, 0x52);
+				SiS_SetReg(SISSR, 0x13, 0xa1);
+				SiS_SetReg(SISSR, 0x14, 0x52);
 				sisfb_post_xgi_delay(ivideo, 1);
 				sr14 = 0x02;
 				if(sisfb_post_xgi_rwtest(ivideo, 23, 24, mapsize))
 					goto bail_out;
 
-				outSISIDXREG(SISSR, 0x13, 0x21);
-				outSISIDXREG(SISSR, 0x14, 0x42);
+				SiS_SetReg(SISSR, 0x13, 0x21);
+				SiS_SetReg(SISSR, 0x14, 0x42);
 			} else {
 				channelab = 2;
-				outSISIDXREG(SISSR, 0x13, 0xa1);
-				outSISIDXREG(SISSR, 0x14, 0x5a);
+				SiS_SetReg(SISSR, 0x13, 0xa1);
+				SiS_SetReg(SISSR, 0x14, 0x5a);
 				sisfb_post_xgi_delay(ivideo, 1);
 				sr14 = 0x0a;
 				if(sisfb_post_xgi_rwtest(ivideo, 24, 25, mapsize))
 					goto bail_out;
 
-				outSISIDXREG(SISSR, 0x13, 0x21);
-				outSISIDXREG(SISSR, 0x14, 0x4a);
+				SiS_SetReg(SISSR, 0x13, 0x21);
+				SiS_SetReg(SISSR, 0x14, 0x4a);
 			}
 			sisfb_post_xgi_delay(ivideo, 1);
 
@@ -4910,9 +4910,9 @@ sisfb_post_xgi_setclocks(struct sis_video_info *ivideo, u8 regb)
 		v2 = ivideo->bios_abase[0x90 + index + 1];
 		v3 = ivideo->bios_abase[0x90 + index + 2];
 	}
-	outSISIDXREG(SISSR, 0x28, v1);
-	outSISIDXREG(SISSR, 0x29, v2);
-	outSISIDXREG(SISSR, 0x2a, v3);
+	SiS_SetReg(SISSR, 0x28, v1);
+	SiS_SetReg(SISSR, 0x29, v2);
+	SiS_SetReg(SISSR, 0x2a, v3);
 	sisfb_post_xgi_delay(ivideo, 0x43);
 	sisfb_post_xgi_delay(ivideo, 0x43);
 	sisfb_post_xgi_delay(ivideo, 0x43);
@@ -4923,9 +4923,9 @@ sisfb_post_xgi_setclocks(struct sis_video_info *ivideo, u8 regb)
 		v2 = ivideo->bios_abase[0xb8 + index + 1];
 		v3 = ivideo->bios_abase[0xb8 + index + 2];
 	}
-	outSISIDXREG(SISSR, 0x2e, v1);
-	outSISIDXREG(SISSR, 0x2f, v2);
-	outSISIDXREG(SISSR, 0x30, v3);
+	SiS_SetReg(SISSR, 0x2e, v1);
+	SiS_SetReg(SISSR, 0x2f, v2);
+	SiS_SetReg(SISSR, 0x30, v3);
 	sisfb_post_xgi_delay(ivideo, 0x43);
 	sisfb_post_xgi_delay(ivideo, 0x43);
 	sisfb_post_xgi_delay(ivideo, 0x43);
@@ -5006,7 +5006,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	SiS_SetRegByte(SISMISCW, reg);
 
 	/* Unlock SR */
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 	reg = SiS_GetReg(SISSR, 0x05);
 	if(reg != 0xa1)
 		return 0;
@@ -5014,13 +5014,13 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	/* Clear some regs */
 	for(i = 0; i < 0x22; i++) {
 		if(0x06 + i == 0x20) continue;
-		outSISIDXREG(SISSR, 0x06 + i, 0x00);
+		SiS_SetReg(SISSR, 0x06 + i, 0x00);
 	}
 	for(i = 0; i < 0x0b; i++) {
-		outSISIDXREG(SISSR, 0x31 + i, 0x00);
+		SiS_SetReg(SISSR, 0x31 + i, 0x00);
 	}
 	for(i = 0; i < 0x10; i++) {
-		outSISIDXREG(SISCR, 0x30 + i, 0x00);
+		SiS_SetReg(SISCR, 0x30 + i, 0x00);
 	}
 
 	ptr = cs78;
@@ -5028,7 +5028,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		ptr = (const u8 *)&bios[0x78];
 	}
 	for(i = 0; i < 3; i++) {
-		outSISIDXREG(SISSR, 0x23 + i, ptr[i]);
+		SiS_SetReg(SISSR, 0x23 + i, ptr[i]);
 	}
 
 	ptr = cs76;
@@ -5036,7 +5036,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		ptr = (const u8 *)&bios[0x76];
 	}
 	for(i = 0; i < 2; i++) {
-		outSISIDXREG(SISSR, 0x21 + i, ptr[i]);
+		SiS_SetReg(SISSR, 0x21 + i, ptr[i]);
 	}
 
 	v1 = 0x18; v2 = 0x00;
@@ -5044,27 +5044,27 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		v1 = bios[0x74];
 		v2 = bios[0x75];
 	}
-	outSISIDXREG(SISSR, 0x07, v1);
-	outSISIDXREG(SISSR, 0x11, 0x0f);
-	outSISIDXREG(SISSR, 0x1f, v2);
+	SiS_SetReg(SISSR, 0x07, v1);
+	SiS_SetReg(SISSR, 0x11, 0x0f);
+	SiS_SetReg(SISSR, 0x1f, v2);
 	/* PCI linear mode, RelIO enabled, A0000 decoding disabled */
-	outSISIDXREG(SISSR, 0x20, 0x80 | 0x20 | 0x04);
-	outSISIDXREG(SISSR, 0x27, 0x74);
+	SiS_SetReg(SISSR, 0x20, 0x80 | 0x20 | 0x04);
+	SiS_SetReg(SISSR, 0x27, 0x74);
 
 	ptr = cs7b;
 	if(ivideo->haveXGIROM) {
 		ptr = (const u8 *)&bios[0x7b];
 	}
 	for(i = 0; i < 3; i++) {
-		outSISIDXREG(SISSR, 0x31 + i, ptr[i]);
+		SiS_SetReg(SISSR, 0x31 + i, ptr[i]);
 	}
 
 	if(ivideo->chip == XGI_40) {
 		if(ivideo->revision_id == 2) {
 			setSISIDXREG(SISSR, 0x3b, 0x3f, 0xc0);
 		}
-		outSISIDXREG(SISCR, 0x7d, 0xfe);
-		outSISIDXREG(SISCR, 0x7e, 0x0f);
+		SiS_SetReg(SISCR, 0x7d, 0xfe);
+		SiS_SetReg(SISCR, 0x7e, 0x0f);
 	}
 	if(ivideo->revision_id == 0) {	/* 40 *and* 20? */
 		andSISIDXREG(SISCR, 0x58, 0xd7);
@@ -5078,36 +5078,36 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	setSISIDXREG(SISCR, 0x38, 0x1f, reg);
 
 	if(ivideo->chip == XGI_20) {
-		outSISIDXREG(SISSR, 0x36, 0x70);
+		SiS_SetReg(SISSR, 0x36, 0x70);
 	} else {
-		outSISIDXREG(SISVID, 0x00, 0x86);
-		outSISIDXREG(SISVID, 0x32, 0x00);
-		outSISIDXREG(SISVID, 0x30, 0x00);
-		outSISIDXREG(SISVID, 0x32, 0x01);
-		outSISIDXREG(SISVID, 0x30, 0x00);
+		SiS_SetReg(SISVID, 0x00, 0x86);
+		SiS_SetReg(SISVID, 0x32, 0x00);
+		SiS_SetReg(SISVID, 0x30, 0x00);
+		SiS_SetReg(SISVID, 0x32, 0x01);
+		SiS_SetReg(SISVID, 0x30, 0x00);
 		andSISIDXREG(SISVID, 0x2f, 0xdf);
 		andSISIDXREG(SISCAP, 0x00, 0x3f);
 
-		outSISIDXREG(SISPART1, 0x2f, 0x01);
-		outSISIDXREG(SISPART1, 0x00, 0x00);
-		outSISIDXREG(SISPART1, 0x02, bios[0x7e]);
-		outSISIDXREG(SISPART1, 0x2e, 0x08);
+		SiS_SetReg(SISPART1, 0x2f, 0x01);
+		SiS_SetReg(SISPART1, 0x00, 0x00);
+		SiS_SetReg(SISPART1, 0x02, bios[0x7e]);
+		SiS_SetReg(SISPART1, 0x2e, 0x08);
 		andSISIDXREG(SISPART1, 0x35, 0x7f);
 		andSISIDXREG(SISPART1, 0x50, 0xfe);
 
 		reg = SiS_GetReg(SISPART4, 0x00);
 		if(reg == 1 || reg == 2) {
-			outSISIDXREG(SISPART2, 0x00, 0x1c);
-			outSISIDXREG(SISPART4, 0x0d, bios[0x7f]);
-			outSISIDXREG(SISPART4, 0x0e, bios[0x80]);
-			outSISIDXREG(SISPART4, 0x10, bios[0x81]);
+			SiS_SetReg(SISPART2, 0x00, 0x1c);
+			SiS_SetReg(SISPART4, 0x0d, bios[0x7f]);
+			SiS_SetReg(SISPART4, 0x0e, bios[0x80]);
+			SiS_SetReg(SISPART4, 0x10, bios[0x81]);
 			andSISIDXREG(SISPART4, 0x0f, 0x3f);
 
 			reg = SiS_GetReg(SISPART4, 0x01);
 			if((reg & 0xf0) >= 0xb0) {
 				reg = SiS_GetReg(SISPART4, 0x23);
 				if(reg & 0x20) reg |= 0x40;
-				outSISIDXREG(SISPART4, 0x23, reg);
+				SiS_SetReg(SISPART4, 0x23, reg);
 				reg = (reg & 0x20) ? 0x02 : 0x00;
 				setSISIDXREG(SISPART1, 0x1e, 0xfd, reg);
 			}
@@ -5155,7 +5155,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			}
 			setSISIDXREG(SISCR, 0x5f, 0xf0, v2);
 		}
-		outSISIDXREG(SISSR, 0x22, v1);
+		SiS_SetReg(SISSR, 0x22, v1);
 
 		if(ivideo->revision_id == 2) {
 			v1 = SiS_GetReg(SISSR, 0x3b);
@@ -5179,7 +5179,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		v2 = SiS_GetReg(SISCR, 0x5f);
 		if((!(reg & 0x02)) && (v2 & 0x0e))
 			v1 |= 0x08;
-		outSISIDXREG(SISSR, 0x27, v1);
+		SiS_SetReg(SISSR, 0x27, v1);
 
 		if(bios[0x64] & 0x01) {
 			setSISIDXREG(SISCR, 0x5f, 0xf0, bios[0x64]);
@@ -5192,16 +5192,16 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			v1 &= 0xfc;
 			orSISIDXREG(SISCR, 0x5f, 0x08);
 		}
-		outSISIDXREG(SISCR, 0x48, v1);
+		SiS_SetReg(SISCR, 0x48, v1);
 
 		setSISIDXREG(SISCR, 0x47, 0x04, bios[0x4f6] & 0xfb);
 		setSISIDXREG(SISCR, 0x49, 0xf0, bios[0x4f8] & 0x0f);
 		setSISIDXREG(SISCR, 0x4a, 0x60, bios[0x4f9] & 0x9f);
 		setSISIDXREG(SISCR, 0x4b, 0x08, bios[0x4fa] & 0xf7);
 		setSISIDXREG(SISCR, 0x4c, 0x80, bios[0x4fb] & 0x7f);
-		outSISIDXREG(SISCR, 0x70, bios[0x4fc]);
+		SiS_SetReg(SISCR, 0x70, bios[0x4fc]);
 		setSISIDXREG(SISCR, 0x71, 0xf0, bios[0x4fd] & 0x0f);
-		outSISIDXREG(SISCR, 0x74, 0xd0);
+		SiS_SetReg(SISCR, 0x74, 0xd0);
 		setSISIDXREG(SISCR, 0x74, 0xcf, bios[0x4fe] & 0x30);
 		setSISIDXREG(SISCR, 0x75, 0xe0, bios[0x4ff] & 0x1f);
 		setSISIDXREG(SISCR, 0x76, 0xe0, bios[0x500] & 0x1f);
@@ -5210,7 +5210,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			v1 = 0xf0;
 			pci_dev_put(mypdev);
 		}
-		outSISIDXREG(SISCR, 0x77, v1);
+		SiS_SetReg(SISCR, 0x77, v1);
 	}
 
 	/* RAM type */
@@ -5221,14 +5221,14 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	if(ivideo->haveXGIROM) {
 		v1 = bios[0x140 + regb];
 	}
-	outSISIDXREG(SISCR, 0x6d, v1);
+	SiS_SetReg(SISCR, 0x6d, v1);
 
 	ptr = cs128;
 	if(ivideo->haveXGIROM) {
 		ptr = (const u8 *)&bios[0x128];
 	}
 	for(i = 0, j = 0; i < 3; i++, j += 8) {
-		outSISIDXREG(SISCR, 0x68 + i, ptr[j + regb]);
+		SiS_SetReg(SISCR, 0x68 + i, ptr[j + regb]);
 	}
 
 	ptr  = cs31a;
@@ -5252,7 +5252,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			if(regd & 0x01) reg |= 0x04;
 			if(regd & 0x02) reg |= 0x08;
 			regd >>= 2;
-			outSISIDXREG(SISCR, rega, reg);
+			SiS_SetReg(SISCR, rega, reg);
 			reg = SiS_GetReg(SISCR, rega);
 			reg = SiS_GetReg(SISCR, rega);
 			reg += 0x10;
@@ -5281,7 +5281,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 				if(regd & 0x01) reg |= 0x01;
 				if(regd & 0x02) reg |= 0x02;
 				regd >>= 2;
-				outSISIDXREG(SISCR, 0x6f, reg);
+				SiS_SetReg(SISCR, 0x6f, reg);
 				reg = SiS_GetReg(SISCR, 0x6f);
 				reg = SiS_GetReg(SISCR, 0x6f);
 				reg += 0x08;
@@ -5294,7 +5294,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		ptr  = (const u8 *)&bios[0x148];
 	}
 	for(i = 0, j = 0; i < 2; i++, j += 8) {
-		outSISIDXREG(SISCR, 0x80 + i, ptr[j + regb]);
+		SiS_SetReg(SISCR, 0x80 + i, ptr[j + regb]);
 	}
 
 	andSISIDXREG(SISCR, 0x89, 0x8f);
@@ -5311,7 +5311,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		if(regd & 0x01) reg |= 0x01;
 		if(regd & 0x02) reg |= 0x02;
 		regd >>= 2;
-		outSISIDXREG(SISCR, 0x89, reg);
+		SiS_SetReg(SISCR, 0x89, reg);
 		reg = SiS_GetReg(SISCR, 0x89);
 		reg = SiS_GetReg(SISCR, 0x89);
 		reg += 0x10;
@@ -5324,27 +5324,27 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		v3 = bios[0x120 + regb];
 		v4 = bios[0x1ca];
 	}
-	outSISIDXREG(SISCR, 0x45, v1 & 0x0f);
-	outSISIDXREG(SISCR, 0x99, (v1 >> 4) & 0x07);
+	SiS_SetReg(SISCR, 0x45, v1 & 0x0f);
+	SiS_SetReg(SISCR, 0x99, (v1 >> 4) & 0x07);
 	orSISIDXREG(SISCR, 0x40, v1 & 0x80);
-	outSISIDXREG(SISCR, 0x41, v2);
+	SiS_SetReg(SISCR, 0x41, v2);
 
 	ptr  = cs170;
 	if(ivideo->haveXGIROM) {
 		ptr  = (const u8 *)&bios[0x170];
 	}
 	for(i = 0, j = 0; i < 7; i++, j += 8) {
-		outSISIDXREG(SISCR, 0x90 + i, ptr[j + regb]);
+		SiS_SetReg(SISCR, 0x90 + i, ptr[j + regb]);
 	}
 
-	outSISIDXREG(SISCR, 0x59, v3);
+	SiS_SetReg(SISCR, 0x59, v3);
 
 	ptr  = cs1a8;
 	if(ivideo->haveXGIROM) {
 		ptr  = (const u8 *)&bios[0x1a8];
 	}
 	for(i = 0, j = 0; i < 3; i++, j += 8) {
-		outSISIDXREG(SISCR, 0xc3 + i, ptr[j + regb]);
+		SiS_SetReg(SISCR, 0xc3 + i, ptr[j + regb]);
 	}
 
 	ptr  = cs100;
@@ -5352,27 +5352,27 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		ptr  = (const u8 *)&bios[0x100];
 	}
 	for(i = 0, j = 0; i < 2; i++, j += 8) {
-		outSISIDXREG(SISCR, 0x8a + i, ptr[j + regb]);
+		SiS_SetReg(SISCR, 0x8a + i, ptr[j + regb]);
 	}
 
-	outSISIDXREG(SISCR, 0xcf, v4);
+	SiS_SetReg(SISCR, 0xcf, v4);
 
-	outSISIDXREG(SISCR, 0x83, 0x09);
-	outSISIDXREG(SISCR, 0x87, 0x00);
+	SiS_SetReg(SISCR, 0x83, 0x09);
+	SiS_SetReg(SISCR, 0x87, 0x00);
 
 	if(ivideo->chip == XGI_40) {
 		if( (ivideo->revision_id == 1) ||
 		    (ivideo->revision_id == 2) ) {
-			outSISIDXREG(SISCR, 0x8c, 0x87);
+			SiS_SetReg(SISCR, 0x8c, 0x87);
 		}
 	}
 
-	outSISIDXREG(SISSR, 0x17, 0x00);
-	outSISIDXREG(SISSR, 0x1a, 0x87);
+	SiS_SetReg(SISSR, 0x17, 0x00);
+	SiS_SetReg(SISSR, 0x1a, 0x87);
 
 	if(ivideo->chip == XGI_20) {
-		outSISIDXREG(SISSR, 0x15, 0x00);
-		outSISIDXREG(SISSR, 0x1c, 0x00);
+		SiS_SetReg(SISSR, 0x15, 0x00);
+		SiS_SetReg(SISSR, 0x1c, 0x00);
 	}
 
 	ramtype = 0x00; v1 = 0x10;
@@ -5382,7 +5382,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	}
 	if(!(ramtype & 0x80)) {
 		if(ivideo->chip == XGI_20) {
-			outSISIDXREG(SISCR, 0x97, v1);
+			SiS_SetReg(SISCR, 0x97, v1);
 			reg = SiS_GetReg(SISCR, 0x97);
 			if(reg & 0x10) {
 				ramtype = (reg & 0x01) << 1;
@@ -5412,55 +5412,55 @@ sisfb_post_xgi(struct pci_dev *pdev)
 				v2 = bios[regb + 0x160];
 				v3 = bios[regb + 0x168];
 			}
-			outSISIDXREG(SISCR, 0x82, v1);
-			outSISIDXREG(SISCR, 0x85, v2);
-			outSISIDXREG(SISCR, 0x86, v3);
+			SiS_SetReg(SISCR, 0x82, v1);
+			SiS_SetReg(SISCR, 0x85, v2);
+			SiS_SetReg(SISCR, 0x86, v3);
 		} else {
-			outSISIDXREG(SISCR, 0x82, 0x88);
-			outSISIDXREG(SISCR, 0x86, 0x00);
+			SiS_SetReg(SISCR, 0x82, 0x88);
+			SiS_SetReg(SISCR, 0x86, 0x00);
 			reg = SiS_GetReg(SISCR, 0x86);
-			outSISIDXREG(SISCR, 0x86, 0x88);
+			SiS_SetReg(SISCR, 0x86, 0x88);
 			reg = SiS_GetReg(SISCR, 0x86);
-			outSISIDXREG(SISCR, 0x86, bios[regb + 0x168]);
-			outSISIDXREG(SISCR, 0x82, 0x77);
-			outSISIDXREG(SISCR, 0x85, 0x00);
+			SiS_SetReg(SISCR, 0x86, bios[regb + 0x168]);
+			SiS_SetReg(SISCR, 0x82, 0x77);
+			SiS_SetReg(SISCR, 0x85, 0x00);
 			reg = SiS_GetReg(SISCR, 0x85);
-			outSISIDXREG(SISCR, 0x85, 0x88);
+			SiS_SetReg(SISCR, 0x85, 0x88);
 			reg = SiS_GetReg(SISCR, 0x85);
-			outSISIDXREG(SISCR, 0x85, bios[regb + 0x160]);
-			outSISIDXREG(SISCR, 0x82, bios[regb + 0x158]);
+			SiS_SetReg(SISCR, 0x85, bios[regb + 0x160]);
+			SiS_SetReg(SISCR, 0x82, bios[regb + 0x158]);
 		}
 		if(ivideo->chip == XGI_40) {
-			outSISIDXREG(SISCR, 0x97, 0x00);
+			SiS_SetReg(SISCR, 0x97, 0x00);
 		}
-		outSISIDXREG(SISCR, 0x98, 0x01);
-		outSISIDXREG(SISCR, 0x9a, 0x02);
+		SiS_SetReg(SISCR, 0x98, 0x01);
+		SiS_SetReg(SISCR, 0x9a, 0x02);
 
-		outSISIDXREG(SISSR, 0x18, 0x01);
+		SiS_SetReg(SISSR, 0x18, 0x01);
 		if((ivideo->chip == XGI_20) ||
 		   (ivideo->revision_id == 2)) {
-			outSISIDXREG(SISSR, 0x19, 0x40);
+			SiS_SetReg(SISSR, 0x19, 0x40);
 		} else {
-			outSISIDXREG(SISSR, 0x19, 0x20);
+			SiS_SetReg(SISSR, 0x19, 0x20);
 		}
-		outSISIDXREG(SISSR, 0x16, 0x00);
-		outSISIDXREG(SISSR, 0x16, 0x80);
+		SiS_SetReg(SISSR, 0x16, 0x00);
+		SiS_SetReg(SISSR, 0x16, 0x80);
 		if((ivideo->chip == XGI_20) || (bios[0x1cb] != 0x0c)) {
 			sisfb_post_xgi_delay(ivideo, 0x43);
 			sisfb_post_xgi_delay(ivideo, 0x43);
 			sisfb_post_xgi_delay(ivideo, 0x43);
-			outSISIDXREG(SISSR, 0x18, 0x00);
+			SiS_SetReg(SISSR, 0x18, 0x00);
 			if((ivideo->chip == XGI_20) ||
 			   (ivideo->revision_id == 2)) {
-				outSISIDXREG(SISSR, 0x19, 0x40);
+				SiS_SetReg(SISSR, 0x19, 0x40);
 			} else {
-				outSISIDXREG(SISSR, 0x19, 0x20);
+				SiS_SetReg(SISSR, 0x19, 0x20);
 			}
 		} else if((ivideo->chip == XGI_40) && (bios[0x1cb] == 0x0c)) {
-			/* outSISIDXREG(SISSR, 0x16, 0x0c); */ /* ? */
+			/* SiS_SetReg(SISSR, 0x16, 0x0c); */ /* ? */
 		}
-		outSISIDXREG(SISSR, 0x16, 0x00);
-		outSISIDXREG(SISSR, 0x16, 0x80);
+		SiS_SetReg(SISSR, 0x16, 0x00);
+		SiS_SetReg(SISSR, 0x16, 0x80);
 		sisfb_post_xgi_delay(ivideo, 4);
 		v1 = 0x31; v2 = 0x03; v3 = 0x83; v4 = 0x03; v5 = 0x83;
 		if(ivideo->haveXGIROM) {
@@ -5471,24 +5471,24 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			v4 = bios[index + 2];
 			v5 = bios[index + 3];
 		}
-		outSISIDXREG(SISSR, 0x18, v1);
-		outSISIDXREG(SISSR, 0x19, ((ivideo->chip == XGI_20) ? 0x02 : 0x01));
-		outSISIDXREG(SISSR, 0x16, v2);
-		outSISIDXREG(SISSR, 0x16, v3);
+		SiS_SetReg(SISSR, 0x18, v1);
+		SiS_SetReg(SISSR, 0x19, ((ivideo->chip == XGI_20) ? 0x02 : 0x01));
+		SiS_SetReg(SISSR, 0x16, v2);
+		SiS_SetReg(SISSR, 0x16, v3);
 		sisfb_post_xgi_delay(ivideo, 0x43);
-		outSISIDXREG(SISSR, 0x1b, 0x03);
+		SiS_SetReg(SISSR, 0x1b, 0x03);
 		sisfb_post_xgi_delay(ivideo, 0x22);
-		outSISIDXREG(SISSR, 0x18, v1);
-		outSISIDXREG(SISSR, 0x19, 0x00);
-		outSISIDXREG(SISSR, 0x16, v4);
-		outSISIDXREG(SISSR, 0x16, v5);
-		outSISIDXREG(SISSR, 0x1b, 0x00);
+		SiS_SetReg(SISSR, 0x18, v1);
+		SiS_SetReg(SISSR, 0x19, 0x00);
+		SiS_SetReg(SISSR, 0x16, v4);
+		SiS_SetReg(SISSR, 0x16, v5);
+		SiS_SetReg(SISSR, 0x1b, 0x00);
 		break;
 	case 1:
-		outSISIDXREG(SISCR, 0x82, 0x77);
-		outSISIDXREG(SISCR, 0x86, 0x00);
+		SiS_SetReg(SISCR, 0x82, 0x77);
+		SiS_SetReg(SISCR, 0x86, 0x00);
 		reg = SiS_GetReg(SISCR, 0x86);
-		outSISIDXREG(SISCR, 0x86, 0x88);
+		SiS_SetReg(SISCR, 0x86, 0x88);
 		reg = SiS_GetReg(SISCR, 0x86);
 		v1 = cs168[regb]; v2 = cs160[regb]; v3 = cs158[regb];
 		if(ivideo->haveXGIROM) {
@@ -5496,49 +5496,49 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			v2 = bios[regb + 0x160];
 			v3 = bios[regb + 0x158];
 		}
-		outSISIDXREG(SISCR, 0x86, v1);
-		outSISIDXREG(SISCR, 0x82, 0x77);
-		outSISIDXREG(SISCR, 0x85, 0x00);
+		SiS_SetReg(SISCR, 0x86, v1);
+		SiS_SetReg(SISCR, 0x82, 0x77);
+		SiS_SetReg(SISCR, 0x85, 0x00);
 		reg = SiS_GetReg(SISCR, 0x85);
-		outSISIDXREG(SISCR, 0x85, 0x88);
+		SiS_SetReg(SISCR, 0x85, 0x88);
 		reg = SiS_GetReg(SISCR, 0x85);
-		outSISIDXREG(SISCR, 0x85, v2);
-		outSISIDXREG(SISCR, 0x82, v3);
-		outSISIDXREG(SISCR, 0x98, 0x01);
-		outSISIDXREG(SISCR, 0x9a, 0x02);
+		SiS_SetReg(SISCR, 0x85, v2);
+		SiS_SetReg(SISCR, 0x82, v3);
+		SiS_SetReg(SISCR, 0x98, 0x01);
+		SiS_SetReg(SISCR, 0x9a, 0x02);
 
-		outSISIDXREG(SISSR, 0x28, 0x64);
-		outSISIDXREG(SISSR, 0x29, 0x63);
+		SiS_SetReg(SISSR, 0x28, 0x64);
+		SiS_SetReg(SISSR, 0x29, 0x63);
 		sisfb_post_xgi_delay(ivideo, 15);
-		outSISIDXREG(SISSR, 0x18, 0x00);
-		outSISIDXREG(SISSR, 0x19, 0x20);
-		outSISIDXREG(SISSR, 0x16, 0x00);
-		outSISIDXREG(SISSR, 0x16, 0x80);
-		outSISIDXREG(SISSR, 0x18, 0xc5);
-		outSISIDXREG(SISSR, 0x19, 0x23);
-		outSISIDXREG(SISSR, 0x16, 0x00);
-		outSISIDXREG(SISSR, 0x16, 0x80);
+		SiS_SetReg(SISSR, 0x18, 0x00);
+		SiS_SetReg(SISSR, 0x19, 0x20);
+		SiS_SetReg(SISSR, 0x16, 0x00);
+		SiS_SetReg(SISSR, 0x16, 0x80);
+		SiS_SetReg(SISSR, 0x18, 0xc5);
+		SiS_SetReg(SISSR, 0x19, 0x23);
+		SiS_SetReg(SISSR, 0x16, 0x00);
+		SiS_SetReg(SISSR, 0x16, 0x80);
 		sisfb_post_xgi_delay(ivideo, 1);
-		outSISIDXREG(SISCR, 0x97,0x11);
+		SiS_SetReg(SISCR, 0x97, 0x11);
 		sisfb_post_xgi_setclocks(ivideo, regb);
 		sisfb_post_xgi_delay(ivideo, 0x46);
-		outSISIDXREG(SISSR, 0x18, 0xc5);
-		outSISIDXREG(SISSR, 0x19, 0x23);
-		outSISIDXREG(SISSR, 0x16, 0x00);
-		outSISIDXREG(SISSR, 0x16, 0x80);
+		SiS_SetReg(SISSR, 0x18, 0xc5);
+		SiS_SetReg(SISSR, 0x19, 0x23);
+		SiS_SetReg(SISSR, 0x16, 0x00);
+		SiS_SetReg(SISSR, 0x16, 0x80);
 		sisfb_post_xgi_delay(ivideo, 1);
-		outSISIDXREG(SISSR, 0x1b, 0x04);
+		SiS_SetReg(SISSR, 0x1b, 0x04);
 		sisfb_post_xgi_delay(ivideo, 1);
-		outSISIDXREG(SISSR, 0x1b, 0x00);
+		SiS_SetReg(SISSR, 0x1b, 0x00);
 		sisfb_post_xgi_delay(ivideo, 1);
 		v1 = 0x31;
 		if(ivideo->haveXGIROM) {
 			v1 = bios[0xf0];
 		}
-		outSISIDXREG(SISSR, 0x18, v1);
-		outSISIDXREG(SISSR, 0x19, 0x06);
-		outSISIDXREG(SISSR, 0x16, 0x04);
-		outSISIDXREG(SISSR, 0x16, 0x84);
+		SiS_SetReg(SISSR, 0x18, v1);
+		SiS_SetReg(SISSR, 0x19, 0x06);
+		SiS_SetReg(SISSR, 0x16, 0x04);
+		SiS_SetReg(SISSR, 0x16, 0x84);
 		sisfb_post_xgi_delay(ivideo, 1);
 		break;
 	default:
@@ -5546,85 +5546,85 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		if((ivideo->chip == XGI_40) &&
 		   ((ivideo->revision_id == 1) ||
 		    (ivideo->revision_id == 2))) {
-			outSISIDXREG(SISCR, 0x82, bios[regb + 0x158]);
-			outSISIDXREG(SISCR, 0x85, bios[regb + 0x160]);
-			outSISIDXREG(SISCR, 0x86, bios[regb + 0x168]);
+			SiS_SetReg(SISCR, 0x82, bios[regb + 0x158]);
+			SiS_SetReg(SISCR, 0x85, bios[regb + 0x160]);
+			SiS_SetReg(SISCR, 0x86, bios[regb + 0x168]);
 		} else {
-			outSISIDXREG(SISCR, 0x82, 0x88);
-			outSISIDXREG(SISCR, 0x86, 0x00);
+			SiS_SetReg(SISCR, 0x82, 0x88);
+			SiS_SetReg(SISCR, 0x86, 0x00);
 			reg = SiS_GetReg(SISCR, 0x86);
-			outSISIDXREG(SISCR, 0x86, 0x88);
-			outSISIDXREG(SISCR, 0x82, 0x77);
-			outSISIDXREG(SISCR, 0x85, 0x00);
+			SiS_SetReg(SISCR, 0x86, 0x88);
+			SiS_SetReg(SISCR, 0x82, 0x77);
+			SiS_SetReg(SISCR, 0x85, 0x00);
 			reg = SiS_GetReg(SISCR, 0x85);
-			outSISIDXREG(SISCR, 0x85, 0x88);
+			SiS_SetReg(SISCR, 0x85, 0x88);
 			reg = SiS_GetReg(SISCR, 0x85);
 			v1 = cs160[regb]; v2 = cs158[regb];
 			if(ivideo->haveXGIROM) {
 				v1 = bios[regb + 0x160];
 				v2 = bios[regb + 0x158];
 			}
-			outSISIDXREG(SISCR, 0x85, v1);
-			outSISIDXREG(SISCR, 0x82, v2);
+			SiS_SetReg(SISCR, 0x85, v1);
+			SiS_SetReg(SISCR, 0x82, v2);
 		}
 		if(ivideo->chip == XGI_40) {
-			outSISIDXREG(SISCR, 0x97, 0x11);
+			SiS_SetReg(SISCR, 0x97, 0x11);
 		}
 		if((ivideo->chip == XGI_40) && (ivideo->revision_id == 2)) {
-			outSISIDXREG(SISCR, 0x98, 0x01);
+			SiS_SetReg(SISCR, 0x98, 0x01);
 		} else {
-			outSISIDXREG(SISCR, 0x98, 0x03);
+			SiS_SetReg(SISCR, 0x98, 0x03);
 		}
-		outSISIDXREG(SISCR, 0x9a, 0x02);
+		SiS_SetReg(SISCR, 0x9a, 0x02);
 
 		if(ivideo->chip == XGI_40) {
-			outSISIDXREG(SISSR, 0x18, 0x01);
+			SiS_SetReg(SISSR, 0x18, 0x01);
 		} else {
-			outSISIDXREG(SISSR, 0x18, 0x00);
+			SiS_SetReg(SISSR, 0x18, 0x00);
 		}
-		outSISIDXREG(SISSR, 0x19, 0x40);
-		outSISIDXREG(SISSR, 0x16, 0x00);
-		outSISIDXREG(SISSR, 0x16, 0x80);
+		SiS_SetReg(SISSR, 0x19, 0x40);
+		SiS_SetReg(SISSR, 0x16, 0x00);
+		SiS_SetReg(SISSR, 0x16, 0x80);
 		if((ivideo->chip == XGI_40) && (bios[0x1cb] != 0x0c)) {
 			sisfb_post_xgi_delay(ivideo, 0x43);
 			sisfb_post_xgi_delay(ivideo, 0x43);
 			sisfb_post_xgi_delay(ivideo, 0x43);
-			outSISIDXREG(SISSR, 0x18, 0x00);
-			outSISIDXREG(SISSR, 0x19, 0x40);
-			outSISIDXREG(SISSR, 0x16, 0x00);
-			outSISIDXREG(SISSR, 0x16, 0x80);
+			SiS_SetReg(SISSR, 0x18, 0x00);
+			SiS_SetReg(SISSR, 0x19, 0x40);
+			SiS_SetReg(SISSR, 0x16, 0x00);
+			SiS_SetReg(SISSR, 0x16, 0x80);
 		}
 		sisfb_post_xgi_delay(ivideo, 4);
 		v1 = 0x31;
 		if(ivideo->haveXGIROM) {
 			v1 = bios[0xf0];
 		}
-		outSISIDXREG(SISSR, 0x18, v1);
-		outSISIDXREG(SISSR, 0x19, 0x01);
+		SiS_SetReg(SISSR, 0x18, v1);
+		SiS_SetReg(SISSR, 0x19, 0x01);
 		if(ivideo->chip == XGI_40) {
-			outSISIDXREG(SISSR, 0x16, bios[0x53e]);
-			outSISIDXREG(SISSR, 0x16, bios[0x53f]);
+			SiS_SetReg(SISSR, 0x16, bios[0x53e]);
+			SiS_SetReg(SISSR, 0x16, bios[0x53f]);
 		} else {
-			outSISIDXREG(SISSR, 0x16, 0x05);
-			outSISIDXREG(SISSR, 0x16, 0x85);
+			SiS_SetReg(SISSR, 0x16, 0x05);
+			SiS_SetReg(SISSR, 0x16, 0x85);
 		}
 		sisfb_post_xgi_delay(ivideo, 0x43);
 		if(ivideo->chip == XGI_40) {
-			outSISIDXREG(SISSR, 0x1b, 0x01);
+			SiS_SetReg(SISSR, 0x1b, 0x01);
 		} else {
-			outSISIDXREG(SISSR, 0x1b, 0x03);
+			SiS_SetReg(SISSR, 0x1b, 0x03);
 		}
 		sisfb_post_xgi_delay(ivideo, 0x22);
-		outSISIDXREG(SISSR, 0x18, v1);
-		outSISIDXREG(SISSR, 0x19, 0x00);
+		SiS_SetReg(SISSR, 0x18, v1);
+		SiS_SetReg(SISSR, 0x19, 0x00);
 		if(ivideo->chip == XGI_40) {
-			outSISIDXREG(SISSR, 0x16, bios[0x540]);
-			outSISIDXREG(SISSR, 0x16, bios[0x541]);
+			SiS_SetReg(SISSR, 0x16, bios[0x540]);
+			SiS_SetReg(SISSR, 0x16, bios[0x541]);
 		} else {
-			outSISIDXREG(SISSR, 0x16, 0x05);
-			outSISIDXREG(SISSR, 0x16, 0x85);
+			SiS_SetReg(SISSR, 0x16, 0x05);
+			SiS_SetReg(SISSR, 0x16, 0x85);
 		}
-		outSISIDXREG(SISSR, 0x1b, 0x00);
+		SiS_SetReg(SISSR, 0x1b, 0x00);
 	}
 
 	regb = 0;	/* ! */
@@ -5632,7 +5632,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	if(ivideo->haveXGIROM) {
 		v1 = bios[0x110 + regb];
 	}
-	outSISIDXREG(SISSR, 0x1b, v1);
+	SiS_SetReg(SISSR, 0x1b, v1);
 
 	/* RAM size */
 	v1 = 0x00; v2 = 0x00;
@@ -5644,8 +5644,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	regd = 1 << regb;
 	if((v1 & 0x40) && (v2 & regd) && ivideo->haveXGIROM) {
 
-		outSISIDXREG(SISSR, 0x13, bios[regb + 0xe0]);
-		outSISIDXREG(SISSR, 0x14, bios[regb + 0xe0 + 8]);
+		SiS_SetReg(SISSR, 0x13, bios[regb + 0xe0]);
+		SiS_SetReg(SISSR, 0x14, bios[regb + 0xe0 + 8]);
 
 	} else {
 
@@ -5657,7 +5657,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		ivideo->SiS_Pr.VideoMemorySize = 8 << 20;
 		SiSSetMode(&ivideo->SiS_Pr, 0x2e | 0x80);
 
-		outSISIDXREG(SISSR, 0x05, 0x86);
+		SiS_SetReg(SISSR, 0x05, 0x86);
 
 		/* Disable read-cache */
 		andSISIDXREG(SISSR, 0x21, 0xdf);
@@ -5699,13 +5699,13 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	ivideo->curFSTN = ivideo->curDSTN = 0;
 	SiSSetMode(&ivideo->SiS_Pr, 0x2e | 0x80);
 
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	/* Display off */
 	orSISIDXREG(SISSR, 0x01, 0x20);
 
 	/* Save mode number in CR34 */
-	outSISIDXREG(SISCR, 0x34, 0x2e);
+	SiS_SetReg(SISCR, 0x34, 0x2e);
 
 	/* Let everyone know what the current mode is */
 	ivideo->modeprechange = 0x2e;
@@ -5955,7 +5955,7 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 #endif
 
-	outSISIDXREG(SISSR, 0x05, 0x86);
+	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	if( (!ivideo->sisvga_enabled)
 #if !defined(__i386__) && !defined(__x86_64__)
@@ -5963,7 +5963,7 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 						   ) {
 		for(i = 0x30; i <= 0x3f; i++) {
-			outSISIDXREG(SISCR, i, 0x00);
+			SiS_SetReg(SISCR, i, 0x00);
 		}
 	}
 
-- 
1.5.6.5

