Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab0LTVuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:50:11 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48495 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab0LTVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:05 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 07/13] sisfb: replace inSISIDXREG with SiS_GetReg
Date: Mon, 20 Dec 2010 23:50:16 +0200
Message-Id: <1292881822-32630-8-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace inSISIDXREG() with SiS_GetReg().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |  256 +++++++++++++++++++++---------------------
 1 files changed, 128 insertions(+), 128 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index fa8f01c..6ea71b8 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -737,7 +737,7 @@ sisfb_bridgeisslave(struct sis_video_info *ivideo)
 	if(!(ivideo->vbflags2 & VB2_VIDEOBRIDGE))
 		return false;
 
-	inSISIDXREG(SISPART1,0x00,P1_00);
+	P1_00 = SiS_GetReg(SISPART1, 0x00);
 	if( ((ivideo->sisvga_engine == SIS_300_VGA) && (P1_00 & 0xa0) == 0x20) ||
 	    ((ivideo->sisvga_engine == SIS_315_VGA) && (P1_00 & 0x50) == 0x10) ) {
 		return true;
@@ -751,11 +751,11 @@ sisfballowretracecrt1(struct sis_video_info *ivideo)
 {
 	u8 temp;
 
-	inSISIDXREG(SISCR,0x17,temp);
+	temp = SiS_GetReg(SISCR, 0x17);
 	if(!(temp & 0x80))
 		return false;
 
-	inSISIDXREG(SISSR,0x1f,temp);
+	temp = SiS_GetReg(SISSR, 0x1f);
 	if(temp & 0xc0)
 		return false;
 
@@ -799,7 +799,7 @@ sisfbcheckvretracecrt2(struct sis_video_info *ivideo)
 	default:	  return false;
 	}
 
-	inSISIDXREG(SISPART1, reg, temp);
+	temp = SiS_GetReg(SISPART1, reg);
 	if(temp & 0x02)
 		return true;
 	else
@@ -837,10 +837,10 @@ sisfb_setupvbblankflags(struct sis_video_info *ivideo, u32 *vcount, u32 *hcount)
 			default:
 			case SIS_315_VGA: idx = 0x30; break;
 		}
-		inSISIDXREG(SISPART1,(idx+0),reg1); /* 30 */
-		inSISIDXREG(SISPART1,(idx+1),reg2); /* 31 */
-		inSISIDXREG(SISPART1,(idx+2),reg3); /* 32 */
-		inSISIDXREG(SISPART1,(idx+3),reg4); /* 33 */
+		reg1 = SiS_GetReg(SISPART1, (idx+0)); /* 30 */
+		reg2 = SiS_GetReg(SISPART1, (idx+1)); /* 31 */
+		reg3 = SiS_GetReg(SISPART1, (idx+2)); /* 32 */
+		reg4 = SiS_GetReg(SISPART1, (idx+3)); /* 33 */
 		if(reg1 & 0x01) ret |= FB_VBLANK_VBLANKING;
 		if(reg1 & 0x02) ret |= FB_VBLANK_VSYNCING;
 		if(reg4 & 0x80) ret |= FB_VBLANK_HBLANKING;
@@ -856,10 +856,10 @@ sisfb_setupvbblankflags(struct sis_video_info *ivideo, u32 *vcount, u32 *hcount)
 		reg1 = SiS_GetRegByte(SISINPSTAT);
 		if(reg1 & 0x08) ret |= FB_VBLANK_VSYNCING;
 		if(reg1 & 0x01) ret |= FB_VBLANK_VBLANKING;
-		inSISIDXREG(SISCR,0x20,reg1);
-		inSISIDXREG(SISCR,0x1b,reg1);
-		inSISIDXREG(SISCR,0x1c,reg2);
-		inSISIDXREG(SISCR,0x1d,reg3);
+		reg1 = SiS_GetReg(SISCR, 0x20);
+		reg1 = SiS_GetReg(SISCR, 0x1b);
+		reg2 = SiS_GetReg(SISCR, 0x1c);
+		reg3 = SiS_GetReg(SISCR, 0x1d);
 		(*vcount) = reg2 | ((reg3 & 0x07) << 8);
 		(*hcount) = (reg1 | ((reg3 & 0x10) << 4)) << 3;
 	}
@@ -1961,7 +1961,7 @@ sisfb_get_dram_size(struct sis_video_info *ivideo)
 	switch(ivideo->chip) {
 #ifdef CONFIG_FB_SIS_300
 	case SIS_300:
-		inSISIDXREG(SISSR, 0x14, reg);
+		reg = SiS_GetReg(SISSR, 0x14);
 		ivideo->video_size = ((reg & 0x3F) + 1) << 20;
 		break;
 	case SIS_540:
@@ -1977,7 +1977,7 @@ sisfb_get_dram_size(struct sis_video_info *ivideo)
 	case SIS_315H:
 	case SIS_315PRO:
 	case SIS_315:
-		inSISIDXREG(SISSR, 0x14, reg);
+		reg = SiS_GetReg(SISSR, 0x14);
 		ivideo->video_size = (1 << ((reg & 0xf0) >> 4)) << 20;
 		switch((reg >> 2) & 0x03) {
 		case 0x01:
@@ -1989,31 +1989,31 @@ sisfb_get_dram_size(struct sis_video_info *ivideo)
 		}
 		break;
 	case SIS_330:
-		inSISIDXREG(SISSR, 0x14, reg);
+		reg = SiS_GetReg(SISSR, 0x14);
 		ivideo->video_size = (1 << ((reg & 0xf0) >> 4)) << 20;
 		if(reg & 0x0c) ivideo->video_size <<= 1;
 		break;
 	case SIS_550:
 	case SIS_650:
 	case SIS_740:
-		inSISIDXREG(SISSR, 0x14, reg);
+		reg = SiS_GetReg(SISSR, 0x14);
 		ivideo->video_size = (((reg & 0x3f) + 1) << 2) << 20;
 		break;
 	case SIS_661:
 	case SIS_741:
-		inSISIDXREG(SISCR, 0x79, reg);
+		reg = SiS_GetReg(SISCR, 0x79);
 		ivideo->video_size = (1 << ((reg & 0xf0) >> 4)) << 20;
 		break;
 	case SIS_660:
 	case SIS_760:
 	case SIS_761:
-		inSISIDXREG(SISCR, 0x79, reg);
+		reg = SiS_GetReg(SISCR, 0x79);
 		reg = (reg & 0xf0) >> 4;
 		if(reg)	{
 			ivideo->video_size = (1 << reg) << 20;
 			ivideo->UMAsize = ivideo->video_size;
 		}
-		inSISIDXREG(SISCR, 0x78, reg);
+		reg = SiS_GetReg(SISCR, 0x78);
 		reg &= 0x30;
 		if(reg) {
 			if(reg == 0x10) {
@@ -2027,7 +2027,7 @@ sisfb_get_dram_size(struct sis_video_info *ivideo)
 	case SIS_340:
 	case XGI_20:
 	case XGI_40:
-		inSISIDXREG(SISSR, 0x14, reg);
+		reg = SiS_GetReg(SISSR, 0x14);
 		ivideo->video_size = (1 << ((reg & 0xf0) >> 4)) << 20;
 		if(ivideo->chip != XGI_20) {
 			reg = (reg & 0x0c) >> 2;
@@ -2061,11 +2061,11 @@ sisfb_detect_VB_connect(struct sis_video_info *ivideo)
 
 #ifdef CONFIG_FB_SIS_300
 	if(ivideo->sisvga_engine == SIS_300_VGA) {
-		inSISIDXREG(SISSR, 0x17, temp);
+		temp = SiS_GetReg(SISSR, 0x17);
 		if((temp & 0x0F) && (ivideo->chip != SIS_300)) {
 			/* PAL/NTSC is stored on SR16 on such machines */
 			if(!(ivideo->vbflags & (TV_PAL | TV_NTSC | TV_PALM | TV_PALN))) {
-				inSISIDXREG(SISSR, 0x16, temp);
+				temp = SiS_GetReg(SISSR, 0x16);
 				if(temp & 0x20)
 					ivideo->vbflags |= TV_PAL;
 				else
@@ -2075,7 +2075,7 @@ sisfb_detect_VB_connect(struct sis_video_info *ivideo)
 	}
 #endif
 
-	inSISIDXREG(SISCR, 0x32, cr32);
+	cr32 = SiS_GetReg(SISCR, 0x32);
 
 	if(cr32 & SIS_CRT1) {
 		ivideo->sisfb_crt1off = 0;
@@ -2151,15 +2151,15 @@ sisfb_detect_VB_connect(struct sis_video_info *ivideo)
 	    }
 	    if(!(ivideo->vbflags & (TV_PAL | TV_NTSC | TV_PALM | TV_PALN | TV_NTSCJ))) {
 		if(ivideo->sisvga_engine == SIS_300_VGA) {
-			inSISIDXREG(SISSR, 0x38, temp);
+			temp = SiS_GetReg(SISSR, 0x38);
 			if(temp & 0x01) ivideo->vbflags |= TV_PAL;
 			else		ivideo->vbflags |= TV_NTSC;
 		} else if((ivideo->chip <= SIS_315PRO) || (ivideo->chip >= SIS_330)) {
-			inSISIDXREG(SISSR, 0x38, temp);
+			temp = SiS_GetReg(SISSR, 0x38);
 			if(temp & 0x01) ivideo->vbflags |= TV_PAL;
 			else		ivideo->vbflags |= TV_NTSC;
 		} else {
-			inSISIDXREG(SISCR, 0x79, temp);
+			temp = SiS_GetReg(SISCR, 0x79);
 			if(temp & 0x20)	ivideo->vbflags |= TV_PAL;
 			else		ivideo->vbflags |= TV_NTSC;
 		}
@@ -2198,20 +2198,20 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
     u16 temp = 0xffff;
     int i;
 
-    inSISIDXREG(SISSR,0x1F,sr1F);
+    sr1F = SiS_GetReg(SISSR, 0x1F);
     orSISIDXREG(SISSR,0x1F,0x04);
     andSISIDXREG(SISSR,0x1F,0x3F);
     if(sr1F & 0xc0) mustwait = true;
 
 #ifdef CONFIG_FB_SIS_315
     if(ivideo->sisvga_engine == SIS_315_VGA) {
-       inSISIDXREG(SISCR,ivideo->SiS_Pr.SiS_MyCR63,cr63);
+       cr63 = SiS_GetReg(SISCR, ivideo->SiS_Pr.SiS_MyCR63);
        cr63 &= 0x40;
        andSISIDXREG(SISCR,ivideo->SiS_Pr.SiS_MyCR63,0xBF);
     }
 #endif
 
-    inSISIDXREG(SISCR,0x17,cr17);
+    cr17 = SiS_GetReg(SISCR, 0x17);
     cr17 &= 0x80;
     if(!cr17) {
        orSISIDXREG(SISCR,0x17,0x80);
@@ -2286,7 +2286,7 @@ SiS_SenseLCD(struct sis_video_info *ivideo)
 		return;
 
 	/* If LCD already set up by BIOS, skip it */
-	inSISIDXREG(SISCR, 0x32, reg);
+	reg = SiS_GetReg(SISCR, 0x32);
 	if(reg & 0x08)
 		return;
 
@@ -2372,7 +2372,7 @@ SISDoSense(struct sis_video_info *ivideo, u16 type, u16 test)
           SiS_DDC2Delay(&ivideo->SiS_Pr, 0x1500);
           mytest >>= 8;
           mytest &= 0x7f;
-          inSISIDXREG(SISPART4,0x03,temp);
+	   temp = SiS_GetReg(SISPART4, 0x03);
           temp ^= 0x0e;
           temp &= mytest;
           if(temp == mytest) result++;
@@ -2400,7 +2400,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
 
     if(ivideo->vbflags2 & VB2_301) {
        svhs = 0x00b9; cvbs = 0x00b3; vga2 = 0x00d1;
-       inSISIDXREG(SISPART4,0x01,myflag);
+       myflag = SiS_GetReg(SISPART4, 0x01);
        if(myflag & 0x04) {
 	  svhs = 0x00dd; cvbs = 0x00ee; vga2 = 0x00fd;
        }
@@ -2430,7 +2430,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     }
 
     if(ivideo->chip == SIS_300) {
-       inSISIDXREG(SISSR,0x3b,myflag);
+       myflag = SiS_GetReg(SISSR, 0x3b);
        if(!(myflag & 0x01)) vga2 = vga2_c = 0;
     }
 
@@ -2438,10 +2438,10 @@ SiS_Sense30x(struct sis_video_info *ivideo)
        vga2 = vga2_c = 0;
     }
 
-    inSISIDXREG(SISSR,0x1e,backupSR_1e);
+    backupSR_1e = SiS_GetReg(SISSR, 0x1e);
     orSISIDXREG(SISSR,0x1e,0x20);
 
-    inSISIDXREG(SISPART4,0x0d,backupP4_0d);
+    backupP4_0d = SiS_GetReg(SISPART4, 0x0d);
     if(ivideo->vbflags2 & VB2_30xC) {
        setSISIDXREG(SISPART4,0x0d,~0x07,0x01);
     } else {
@@ -2449,10 +2449,10 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     }
     SiS_DDC2Delay(&ivideo->SiS_Pr, 0x2000);
 
-    inSISIDXREG(SISPART2,0x00,backupP2_00);
+    backupP2_00 = SiS_GetReg(SISPART2, 0x00);
     outSISIDXREG(SISPART2,0x00,((backupP2_00 | 0x1c) & 0xfc));
 
-    inSISIDXREG(SISPART2,0x4d,backupP2_4d);
+    backupP2_4d = SiS_GetReg(SISPART2, 0x4d);
     if(ivideo->vbflags2 & VB2_SISYPBPRBRIDGE) {
        outSISIDXREG(SISPART2,0x4d,(backupP2_4d & ~0x10));
     }
@@ -2515,7 +2515,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     outSISIDXREG(SISSR,0x1e,backupSR_1e);
 
     if(ivideo->vbflags2 & VB2_30xCLV) {
-       inSISIDXREG(SISPART2,0x00,biosflag);
+	biosflag = SiS_GetReg(SISPART2, 0x00);
        if(biosflag & 0x20) {
           for(myflag = 2; myflag > 0; myflag--) {
 	     biosflag ^= 0x20;
@@ -2665,10 +2665,10 @@ sisfb_get_VB_type(struct sis_video_info *ivideo)
 	if(ivideo->chip == XGI_20)
 		return;
 
-	inSISIDXREG(SISPART4, 0x00, vb_chipid);
+	vb_chipid = SiS_GetReg(SISPART4, 0x00);
 	switch(vb_chipid) {
 	case 0x01:
-		inSISIDXREG(SISPART4, 0x01, reg);
+		reg = SiS_GetReg(SISPART4, 0x01);
 		if(reg < 0xb0) {
 			ivideo->vbflags |= VB_301;	/* Deprecated */
 			ivideo->vbflags2 |= VB2_301;
@@ -2676,7 +2676,7 @@ sisfb_get_VB_type(struct sis_video_info *ivideo)
 		} else if(reg < 0xc0) {
 			ivideo->vbflags |= VB_301B;	/* Deprecated */
 			ivideo->vbflags2 |= VB2_301B;
-			inSISIDXREG(SISPART4,0x23,reg);
+			reg = SiS_GetReg(SISPART4, 0x23);
 			if(!(reg & 0x02)) {
 			   ivideo->vbflags |= VB_30xBDH;	/* Deprecated */
 			   ivideo->vbflags2 |= VB2_30xBDH;
@@ -2693,7 +2693,7 @@ sisfb_get_VB_type(struct sis_video_info *ivideo)
 			ivideo->vbflags2 |= VB2_301LV;
 			printk(KERN_INFO "%s SiS301LV %s\n", stdstr, bridgestr);
 		} else if(reg <= 0xe1) {
-			inSISIDXREG(SISPART4,0x39,reg);
+			reg = SiS_GetReg(SISPART4, 0x39);
 			if(reg == 0xff) {
 			   ivideo->vbflags |= VB_302LV;	/* Deprecated */
 			   ivideo->vbflags2 |= VB2_302LV;
@@ -2718,7 +2718,7 @@ sisfb_get_VB_type(struct sis_video_info *ivideo)
 	}
 
 	if((!(ivideo->vbflags2 & VB2_VIDEOBRIDGE)) && (ivideo->chip != SIS_300)) {
-		inSISIDXREG(SISCR, 0x37, reg);
+		reg = SiS_GetReg(SISCR, 0x37);
 		reg &= SIS_EXTERNAL_CHIP_MASK;
 		reg >>= 1;
 		if(ivideo->sisvga_engine == SIS_300_VGA) {
@@ -2759,7 +2759,7 @@ sisfb_get_VB_type(struct sis_video_info *ivideo)
 #endif
 		} else if(ivideo->chip >= SIS_661) {
 #ifdef CONFIG_FB_SIS_315
-			inSISIDXREG(SISCR, 0x38, reg);
+			reg = SiS_GetReg(SISCR, 0x38);
 			reg >>= 5;
 			switch(reg) {
 			   case 0x02:
@@ -2822,7 +2822,7 @@ sisfb_engine_init(struct sis_video_info *ivideo)
 
 		tqueue_pos = (ivideo->video_size - ivideo->cmdQueueSize) / (64 * 1024);
 
-		inSISIDXREG(SISSR, IND_SIS_TURBOQUEUE_SET, tq_state);
+		tq_state = SiS_GetReg(SISSR, IND_SIS_TURBOQUEUE_SET);
 		tq_state |= 0xf0;
 		tq_state &= 0xfc;
 		tq_state |= (u8)(tqueue_pos >> 8);
@@ -2922,7 +2922,7 @@ sisfb_detect_lcd_type(struct sis_video_info *ivideo)
 	u8 reg;
 	int i;
 
-	inSISIDXREG(SISCR, 0x36, reg);
+	reg = SiS_GetReg(SISCR, 0x36);
 	reg &= 0x0f;
 	if(ivideo->sisvga_engine == SIS_300_VGA) {
 		ivideo->CRT2LCDType = sis300paneltype[reg];
@@ -2980,10 +2980,10 @@ sisfb_save_pdc_emi(struct sis_video_info *ivideo)
 	if(ivideo->sisvga_engine == SIS_300_VGA) {
 		if(ivideo->vbflags2 & (VB2_LVDS | VB2_30xBDH)) {
 			int tmp;
-			inSISIDXREG(SISCR,0x30,tmp);
+			tmp = SiS_GetReg(SISCR, 0x30);
 			if(tmp & 0x20) {
 				/* Currently on LCD? If yes, read current pdc */
-				inSISIDXREG(SISPART1,0x13,ivideo->detectedpdc);
+				ivideo->detectedpdc = SiS_GetReg(SISPART1, 0x13);
 				ivideo->detectedpdc &= 0x3c;
 				if(ivideo->SiS_Pr.PDC == -1) {
 					/* Let option override detection */
@@ -3007,7 +3007,7 @@ sisfb_save_pdc_emi(struct sis_video_info *ivideo)
 		/* Try to find about LCDA */
 		if(ivideo->vbflags2 & VB2_SISLCDABRIDGE) {
 			int tmp;
-			inSISIDXREG(SISPART1,0x13,tmp);
+			tmp = SiS_GetReg(SISPART1, 0x13);
 			if(tmp & 0x04) {
 				ivideo->SiS_Pr.SiS_UseLCDA = true;
 				ivideo->detectedlcda = 0x03;
@@ -3017,16 +3017,16 @@ sisfb_save_pdc_emi(struct sis_video_info *ivideo)
 		/* Save PDC */
 		if(ivideo->vbflags2 & VB2_SISLVDSBRIDGE) {
 			int tmp;
-			inSISIDXREG(SISCR,0x30,tmp);
+			tmp = SiS_GetReg(SISCR, 0x30);
 			if((tmp & 0x20) || (ivideo->detectedlcda != 0xff)) {
 				/* Currently on LCD? If yes, read current pdc */
 				u8 pdc;
-				inSISIDXREG(SISPART1,0x2D,pdc);
+				pdc = SiS_GetReg(SISPART1, 0x2D);
 				ivideo->detectedpdc  = (pdc & 0x0f) << 1;
 				ivideo->detectedpdca = (pdc & 0xf0) >> 3;
-				inSISIDXREG(SISPART1,0x35,pdc);
+				pdc = SiS_GetReg(SISPART1, 0x35);
 				ivideo->detectedpdc |= ((pdc >> 7) & 0x01);
-				inSISIDXREG(SISPART1,0x20,pdc);
+				pdc = SiS_GetReg(SISPART1, 0x20);
 				ivideo->detectedpdca |= ((pdc >> 6) & 0x01);
 				if(ivideo->newrom) {
 					/* New ROM invalidates other PDC resp. */
@@ -3060,10 +3060,10 @@ sisfb_save_pdc_emi(struct sis_video_info *ivideo)
 
 			/* Save EMI */
 			if(ivideo->vbflags2 & VB2_SISEMIBRIDGE) {
-				inSISIDXREG(SISPART4,0x30,ivideo->SiS_Pr.EMI_30);
-				inSISIDXREG(SISPART4,0x31,ivideo->SiS_Pr.EMI_31);
-				inSISIDXREG(SISPART4,0x32,ivideo->SiS_Pr.EMI_32);
-				inSISIDXREG(SISPART4,0x33,ivideo->SiS_Pr.EMI_33);
+				ivideo->SiS_Pr.EMI_30 = SiS_GetReg(SISPART4, 0x30);
+				ivideo->SiS_Pr.EMI_31 = SiS_GetReg(SISPART4, 0x31);
+				ivideo->SiS_Pr.EMI_32 = SiS_GetReg(SISPART4, 0x32);
+				ivideo->SiS_Pr.EMI_33 = SiS_GetReg(SISPART4, 0x33);
 				ivideo->SiS_Pr.HaveEMI = true;
 				if((tmp & 0x20) || (ivideo->detectedlcda != 0xff)) {
 					ivideo->SiS_Pr.HaveEMILCD = true;
@@ -3488,8 +3488,8 @@ sisfb_check_engine_and_sync(struct sis_video_info *ivideo)
 	 * ivideo->accel here, as this might have
 	 * been changed before this is called.
 	 */
-	inSISIDXREG(SISSR, IND_SIS_PCI_ADDRESS_SET, cr30);
-	inSISIDXREG(SISSR, IND_SIS_MODULE_ENABLE, cr31);
+	cr30 = SiS_GetReg(SISSR, IND_SIS_PCI_ADDRESS_SET);
+	cr31 = SiS_GetReg(SISSR, IND_SIS_MODULE_ENABLE);
 	/* MMIO and 2D/3D engine enabled? */
 	if((cr30 & SIS_MEM_MAP_IO_ENABLE) && (cr31 & 0x42)) {
 #ifdef CONFIG_FB_SIS_300
@@ -3507,7 +3507,7 @@ sisfb_check_engine_and_sync(struct sis_video_info *ivideo)
 			 * enabled, and that the queue
 			 * is not in the state of "reset"
 			 */
-			inSISIDXREG(SISSR, 0x26, cr30);
+			cr30 = SiS_GetReg(SISSR, 0x26);
 			if((cr30 & 0xe0) && (!(cr30 & 0x01))) {
 				sisfb_syncaccel(ivideo);
 			}
@@ -3526,7 +3526,7 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 
 	outSISIDXREG(SISSR, 0x05, 0x86);
 
-	inSISIDXREG(SISCR, 0x31, cr31);
+	cr31 = SiS_GetReg(SISCR, 0x31);
 	cr31 &= ~0x60;
 	cr31 |= 0x04;
 
@@ -3535,11 +3535,11 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 #ifdef CONFIG_FB_SIS_315
 	if(ivideo->sisvga_engine == SIS_315_VGA) {
 	   if(ivideo->chip >= SIS_661) {
-	      inSISIDXREG(SISCR, 0x38, cr38);
+	      cr38 = SiS_GetReg(SISCR, 0x38);
 	      cr38 &= ~0x07;  /* Clear LCDA/DualEdge and YPbPr bits */
 	   } else {
 	      tvregnum = 0x38;
-	      inSISIDXREG(SISCR, tvregnum, cr38);
+	      cr38 = SiS_GetReg(SISCR, tvregnum);
 	      cr38 &= ~0x3b;  /* Clear LCDA/DualEdge and YPbPr bits */
 	   }
 	}
@@ -3547,7 +3547,7 @@ sisfb_pre_setmode(struct sis_video_info *ivideo)
 #ifdef CONFIG_FB_SIS_300
 	if(ivideo->sisvga_engine == SIS_300_VGA) {
 	   tvregnum = 0x35;
-	   inSISIDXREG(SISCR, tvregnum, cr38);
+	   cr38 = SiS_GetReg(SISCR, tvregnum);
 	}
 #endif
 
@@ -3682,12 +3682,12 @@ sisfb_fixup_SR11(struct sis_video_info *ivideo)
 	u8  tmpreg;
 
 	if(ivideo->chip >= SIS_661) {
-		inSISIDXREG(SISSR,0x11,tmpreg);
+		tmpreg = SiS_GetReg(SISSR, 0x11);
 		if(tmpreg & 0x20) {
-			inSISIDXREG(SISSR,0x3e,tmpreg);
+			tmpreg = SiS_GetReg(SISSR, 0x3e);
 			tmpreg = (tmpreg + 1) & 0xff;
 			outSISIDXREG(SISSR,0x3e,tmpreg);
-			inSISIDXREG(SISSR,0x11,tmpreg);
+			tmpreg = SiS_GetReg(SISSR, 0x11);
 		}
 		if(tmpreg & 0xf0) {
 			andSISIDXREG(SISSR,0x11,0x0f);
@@ -3875,13 +3875,13 @@ sisfb_post_setmode(struct sis_video_info *ivideo)
 
 	if(ivideo->currentvbflags & CRT2_TV) {
 		if(ivideo->vbflags2 & VB2_SISBRIDGE) {
-			inSISIDXREG(SISPART2,0x1f,ivideo->p2_1f);
-			inSISIDXREG(SISPART2,0x20,ivideo->p2_20);
-			inSISIDXREG(SISPART2,0x2b,ivideo->p2_2b);
-			inSISIDXREG(SISPART2,0x42,ivideo->p2_42);
-			inSISIDXREG(SISPART2,0x43,ivideo->p2_43);
-			inSISIDXREG(SISPART2,0x01,ivideo->p2_01);
-			inSISIDXREG(SISPART2,0x02,ivideo->p2_02);
+			ivideo->p2_1f = SiS_GetReg(SISPART2, 0x1f);
+			ivideo->p2_20 = SiS_GetReg(SISPART2, 0x20);
+			ivideo->p2_2b = SiS_GetReg(SISPART2, 0x2b);
+			ivideo->p2_42 = SiS_GetReg(SISPART2, 0x42);
+			ivideo->p2_43 = SiS_GetReg(SISPART2, 0x43);
+			ivideo->p2_01 = SiS_GetReg(SISPART2, 0x01);
+			ivideo->p2_02 = SiS_GetReg(SISPART2, 0x02);
 		} else if(ivideo->vbflags2 & VB2_CHRONTEL) {
 			if(ivideo->chronteltype == 1) {
 				ivideo->tvx = SiS_GetCH700x(&ivideo->SiS_Pr, 0x0a);
@@ -4206,11 +4206,11 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 			if(readw(FBAddress) == temp)
 				break;
 			orSISIDXREG(SISSR, 0x3c, 0x01);
-			inSISIDXREG(SISSR, 0x05, reg);
-			inSISIDXREG(SISSR, 0x05, reg);
+			reg = SiS_GetReg(SISSR, 0x05);
+			reg = SiS_GetReg(SISSR, 0x05);
 			andSISIDXREG(SISSR, 0x3c, 0xfe);
-			inSISIDXREG(SISSR, 0x05, reg);
-			inSISIDXREG(SISSR, 0x05, reg);
+			reg = SiS_GetReg(SISSR, 0x05);
+			reg = SiS_GetReg(SISSR, 0x05);
 			temp++;
 		}
 	}
@@ -4220,7 +4220,7 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 	writel(0x89ABCDEFL, (FBAddress + 8));
 	writel(0xCDEF0123L, (FBAddress + 12));
 
-	inSISIDXREG(SISSR, 0x3b, reg);
+	reg = SiS_GetReg(SISSR, 0x3b);
 	if(reg & 0x01) {
 		if(readl((FBAddress + 12)) == 0xCDEF0123L)
 			return 4;	/* Channel A 128bit */
@@ -4362,7 +4362,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 		if(bios[0x52] & 0x80) {
 			memtype = bios[0x52];
 		} else {
-			inSISIDXREG(SISSR, 0x3a, memtype);
+			memtype = SiS_GetReg(SISSR, 0x3a);
 		}
 		memtype &= 0x07;
 	}
@@ -4459,7 +4459,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	if(ivideo->revision_id >= 0x80)
 		v2 &= ~0x01;
 
-	inSISIDXREG(SISPART4, 0x00, reg);
+	reg = SiS_GetReg(SISPART4, 0x00);
 	if((reg == 1) || (reg == 2)) {
 		outSISIDXREG(SISCR, 0x37, 0x02);
 		outSISIDXREG(SISPART2, 0x00, 0x1c);
@@ -4473,9 +4473,9 @@ sisfb_post_sis300(struct pci_dev *pdev)
 		outSISIDXREG(SISPART4, 0x0e, v5);
 		outSISIDXREG(SISPART4, 0x10, v6);
 		outSISIDXREG(SISPART4, 0x0f, 0x3f);
-		inSISIDXREG(SISPART4, 0x01, reg);
+		reg = SiS_GetReg(SISPART4, 0x01);
 		if(reg >= 0xb0) {
-			inSISIDXREG(SISPART4, 0x23, reg);
+			reg = SiS_GetReg(SISPART4, 0x23);
 			reg &= 0x20;
 			reg <<= 1;
 			outSISIDXREG(SISPART4, 0x23, reg);
@@ -4487,7 +4487,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 
 	andSISIDXREG(SISPART1, 0x24, 0xfe);  /* Lock CRT2 */
 
-	inSISIDXREG(SISSR, 0x16, reg);
+	reg = SiS_GetReg(SISSR, 0x16);
 	reg &= 0xc3;
 	outSISIDXREG(SISCR, 0x35, reg);
 	outSISIDXREG(SISCR, 0x83, 0x00);
@@ -4518,7 +4518,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 		v1 = bios[0xe6];
 		v2 = bios[0xe7];
 	} else {
-		inSISIDXREG(SISSR, 0x3a, reg);
+		reg = SiS_GetReg(SISSR, 0x3a);
 		if((reg & 0x30) == 0x30) {
 			v1 = 0x04; /* PCI */
 			v2 = 0x92;
@@ -4570,7 +4570,7 @@ sisfb_post_xgi_delay(struct sis_video_info *ivideo, int delay)
 	u8 reg;
 
 	for(i = 0; i <= (delay * 10 * 36); i++) {
-		inSISIDXREG(SISSR, 0x05, reg);
+		reg = SiS_GetReg(SISSR, 0x05);
 		reg++;
 	}
 }
@@ -4684,7 +4684,7 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 	if(ivideo->chip == XGI_20) {
 
 		channelab = 1;
-		inSISIDXREG(SISCR, 0x97, reg);
+		reg = SiS_GetReg(SISCR, 0x97);
 		if(!(reg & 0x01)) {	/* Single 32/16 */
 			buswidth = 32;
 			outSISIDXREG(SISSR, 0x13, 0xb1);
@@ -4737,9 +4737,9 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 
 	} else {	/* XGI_40 */
 
-		inSISIDXREG(SISCR, 0x97, reg);
+		reg = SiS_GetReg(SISCR, 0x97);
 		if(!(reg & 0x10)) {
-			inSISIDXREG(SISSR, 0x39, reg);
+			reg = SiS_GetReg(SISSR, 0x39);
 			reg >>= 1;
 		}
 
@@ -4846,7 +4846,7 @@ bail_out:
 		ranksize = (ivideo->chip == XGI_20) ?
 				dramsr13[(i * 5) + 3] : dramsr13_4[(i * 5) + 3];
 
-		inSISIDXREG(SISSR, 0x13, reg);
+		reg = SiS_GetReg(SISSR, 0x13);
 		if(reg & 0x80) ranksize <<= 1;
 
 		if(ivideo->chip == XGI_20) {
@@ -5007,7 +5007,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 
 	/* Unlock SR */
 	outSISIDXREG(SISSR, 0x05, 0x86);
-	inSISIDXREG(SISSR, 0x05, reg);
+	reg = SiS_GetReg(SISSR, 0x05);
 	if(reg != 0xa1)
 		return 0;
 
@@ -5068,7 +5068,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	}
 	if(ivideo->revision_id == 0) {	/* 40 *and* 20? */
 		andSISIDXREG(SISCR, 0x58, 0xd7);
-		inSISIDXREG(SISCR, 0xcb, reg);
+		reg = SiS_GetReg(SISCR, 0xcb);
 		if(reg & 0x20) {
 			setSISIDXREG(SISCR, 0x58, 0xd7, (reg & 0x10) ? 0x08 : 0x20); /* =0x28 Z7 ? */
 		}
@@ -5095,7 +5095,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		andSISIDXREG(SISPART1, 0x35, 0x7f);
 		andSISIDXREG(SISPART1, 0x50, 0xfe);
 
-		inSISIDXREG(SISPART4, 0x00, reg);
+		reg = SiS_GetReg(SISPART4, 0x00);
 		if(reg == 1 || reg == 2) {
 			outSISIDXREG(SISPART2, 0x00, 0x1c);
 			outSISIDXREG(SISPART4, 0x0d, bios[0x7f]);
@@ -5103,9 +5103,9 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			outSISIDXREG(SISPART4, 0x10, bios[0x81]);
 			andSISIDXREG(SISPART4, 0x0f, 0x3f);
 
-			inSISIDXREG(SISPART4, 0x01, reg);
+			reg = SiS_GetReg(SISPART4, 0x01);
 			if((reg & 0xf0) >= 0xb0) {
-				inSISIDXREG(SISPART4, 0x23, reg);
+				reg = SiS_GetReg(SISPART4, 0x23);
 				if(reg & 0x20) reg |= 0x40;
 				outSISIDXREG(SISPART4, 0x23, reg);
 				reg = (reg & 0x20) ? 0x02 : 0x00;
@@ -5115,12 +5115,12 @@ sisfb_post_xgi(struct pci_dev *pdev)
 
 		v1 = bios[0x77];
 
-		inSISIDXREG(SISSR, 0x3b, reg);
+		reg = SiS_GetReg(SISSR, 0x3b);
 		if(reg & 0x02) {
-			inSISIDXREG(SISSR, 0x3a, reg);
+			reg = SiS_GetReg(SISSR, 0x3a);
 			v2 = (reg & 0x30) >> 3;
 			if(!(v2 & 0x04)) v2 ^= 0x02;
-			inSISIDXREG(SISSR, 0x39, reg);
+			reg = SiS_GetReg(SISSR, 0x39);
 			if(reg & 0x80) v2 |= 0x80;
 			v2 |= 0x01;
 
@@ -5158,8 +5158,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		outSISIDXREG(SISSR, 0x22, v1);
 
 		if(ivideo->revision_id == 2) {
-			inSISIDXREG(SISSR, 0x3b, v1);
-			inSISIDXREG(SISSR, 0x3a, v2);
+			v1 = SiS_GetReg(SISSR, 0x3b);
+			v2 = SiS_GetReg(SISSR, 0x3a);
 			regd = bios[0x90 + 3] | (bios[0x90 + 4] << 8);
 			if( (!(v1 & 0x02)) && (v2 & 0x30) && (regd < 0xcf) )
 				setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
@@ -5175,8 +5175,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		}
 
 		v1 = 0x30;
-		inSISIDXREG(SISSR, 0x3b, reg);
-		inSISIDXREG(SISCR, 0x5f, v2);
+		reg = SiS_GetReg(SISSR, 0x3b);
+		v2 = SiS_GetReg(SISCR, 0x5f);
 		if((!(reg & 0x02)) && (v2 & 0x0e))
 			v1 |= 0x08;
 		outSISIDXREG(SISSR, 0x27, v1);
@@ -5253,8 +5253,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			if(regd & 0x02) reg |= 0x08;
 			regd >>= 2;
 			outSISIDXREG(SISCR, rega, reg);
-			inSISIDXREG(SISCR, rega, reg);
-			inSISIDXREG(SISCR, rega, reg);
+			reg = SiS_GetReg(SISCR, rega);
+			reg = SiS_GetReg(SISCR, rega);
 			reg += 0x10;
 		}
 	}
@@ -5282,8 +5282,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 				if(regd & 0x02) reg |= 0x02;
 				regd >>= 2;
 				outSISIDXREG(SISCR, 0x6f, reg);
-				inSISIDXREG(SISCR, 0x6f, reg);
-				inSISIDXREG(SISCR, 0x6f, reg);
+				reg = SiS_GetReg(SISCR, 0x6f);
+				reg = SiS_GetReg(SISCR, 0x6f);
 				reg += 0x08;
 			}
 		}
@@ -5312,8 +5312,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		if(regd & 0x02) reg |= 0x02;
 		regd >>= 2;
 		outSISIDXREG(SISCR, 0x89, reg);
-		inSISIDXREG(SISCR, 0x89, reg);
-		inSISIDXREG(SISCR, 0x89, reg);
+		reg = SiS_GetReg(SISCR, 0x89);
+		reg = SiS_GetReg(SISCR, 0x89);
 		reg += 0x10;
 	}
 
@@ -5383,15 +5383,15 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	if(!(ramtype & 0x80)) {
 		if(ivideo->chip == XGI_20) {
 			outSISIDXREG(SISCR, 0x97, v1);
-			inSISIDXREG(SISCR, 0x97, reg);
+			reg = SiS_GetReg(SISCR, 0x97);
 			if(reg & 0x10) {
 				ramtype = (reg & 0x01) << 1;
 			}
 		} else {
-			inSISIDXREG(SISSR, 0x39, reg);
+			reg = SiS_GetReg(SISSR, 0x39);
 			ramtype = reg & 0x02;
 			if(!(ramtype)) {
-				inSISIDXREG(SISSR, 0x3a, reg);
+				reg = SiS_GetReg(SISSR, 0x3a);
 				ramtype = (reg >> 1) & 0x01;
 			}
 		}
@@ -5418,15 +5418,15 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		} else {
 			outSISIDXREG(SISCR, 0x82, 0x88);
 			outSISIDXREG(SISCR, 0x86, 0x00);
-			inSISIDXREG(SISCR, 0x86, reg);
+			reg = SiS_GetReg(SISCR, 0x86);
 			outSISIDXREG(SISCR, 0x86, 0x88);
-			inSISIDXREG(SISCR, 0x86, reg);
+			reg = SiS_GetReg(SISCR, 0x86);
 			outSISIDXREG(SISCR, 0x86, bios[regb + 0x168]);
 			outSISIDXREG(SISCR, 0x82, 0x77);
 			outSISIDXREG(SISCR, 0x85, 0x00);
-			inSISIDXREG(SISCR, 0x85, reg);
+			reg = SiS_GetReg(SISCR, 0x85);
 			outSISIDXREG(SISCR, 0x85, 0x88);
-			inSISIDXREG(SISCR, 0x85, reg);
+			reg = SiS_GetReg(SISCR, 0x85);
 			outSISIDXREG(SISCR, 0x85, bios[regb + 0x160]);
 			outSISIDXREG(SISCR, 0x82, bios[regb + 0x158]);
 		}
@@ -5487,9 +5487,9 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	case 1:
 		outSISIDXREG(SISCR, 0x82, 0x77);
 		outSISIDXREG(SISCR, 0x86, 0x00);
-		inSISIDXREG(SISCR, 0x86, reg);
+		reg = SiS_GetReg(SISCR, 0x86);
 		outSISIDXREG(SISCR, 0x86, 0x88);
-		inSISIDXREG(SISCR, 0x86, reg);
+		reg = SiS_GetReg(SISCR, 0x86);
 		v1 = cs168[regb]; v2 = cs160[regb]; v3 = cs158[regb];
 		if(ivideo->haveXGIROM) {
 			v1 = bios[regb + 0x168];
@@ -5499,9 +5499,9 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		outSISIDXREG(SISCR, 0x86, v1);
 		outSISIDXREG(SISCR, 0x82, 0x77);
 		outSISIDXREG(SISCR, 0x85, 0x00);
-		inSISIDXREG(SISCR, 0x85, reg);
+		reg = SiS_GetReg(SISCR, 0x85);
 		outSISIDXREG(SISCR, 0x85, 0x88);
-		inSISIDXREG(SISCR, 0x85, reg);
+		reg = SiS_GetReg(SISCR, 0x85);
 		outSISIDXREG(SISCR, 0x85, v2);
 		outSISIDXREG(SISCR, 0x82, v3);
 		outSISIDXREG(SISCR, 0x98, 0x01);
@@ -5552,13 +5552,13 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		} else {
 			outSISIDXREG(SISCR, 0x82, 0x88);
 			outSISIDXREG(SISCR, 0x86, 0x00);
-			inSISIDXREG(SISCR, 0x86, reg);
+			reg = SiS_GetReg(SISCR, 0x86);
 			outSISIDXREG(SISCR, 0x86, 0x88);
 			outSISIDXREG(SISCR, 0x82, 0x77);
 			outSISIDXREG(SISCR, 0x85, 0x00);
-			inSISIDXREG(SISCR, 0x85, reg);
+			reg = SiS_GetReg(SISCR, 0x85);
 			outSISIDXREG(SISCR, 0x85, 0x88);
-			inSISIDXREG(SISCR, 0x85, reg);
+			reg = SiS_GetReg(SISCR, 0x85);
 			v1 = cs160[regb]; v2 = cs158[regb];
 			if(ivideo->haveXGIROM) {
 				v1 = bios[regb + 0x160];
@@ -5670,11 +5670,11 @@ sisfb_post_xgi(struct pci_dev *pdev)
 #if 0
 	printk(KERN_DEBUG "-----------------\n");
 	for(i = 0; i < 0xff; i++) {
-		inSISIDXREG(SISCR, i, reg);
+		reg = SiS_GetReg(SISCR, i);
 		printk(KERN_DEBUG "CR%02x(%x) = 0x%02x\n", i, SISCR, reg);
 	}
 	for(i = 0; i < 0x40; i++) {
-		inSISIDXREG(SISSR, i, reg);
+		reg = SiS_GetReg(SISSR, i);
 		printk(KERN_DEBUG "SR%02x(%x) = 0x%02x\n", i, SISSR, reg);
 	}
 	printk(KERN_DEBUG "-----------------\n");
@@ -5684,7 +5684,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	if(ivideo->chip == XGI_20) {
 		orSISIDXREG(SISCR, 0x32, 0x20);
 	} else {
-		inSISIDXREG(SISPART4, 0x00, reg);
+		reg = SiS_GetReg(SISPART4, 0x00);
 		if((reg == 1) || (reg == 2)) {
 			sisfb_sense_crt1(ivideo);
 		} else {
@@ -5711,8 +5711,8 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	ivideo->modeprechange = 0x2e;
 
 	if(ivideo->chip == XGI_40) {
-		inSISIDXREG(SISCR, 0xca, reg);
-		inSISIDXREG(SISCR, 0xcc, v1);
+		reg = SiS_GetReg(SISCR, 0xca);
+		v1 = SiS_GetReg(SISCR, 0xcc);
 		if((reg & 0x10) && (!(v1 & 0x04))) {
 			printk(KERN_ERR
 				"sisfb: Please connect power to the card.\n");
@@ -5969,7 +5969,7 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Find out about current video mode */
 	ivideo->modeprechange = 0x03;
-	inSISIDXREG(SISCR, 0x34, reg);
+	reg = SiS_GetReg(SISCR, 0x34);
 	if(reg & 0x7f) {
 		ivideo->modeprechange = reg & 0x7f;
 	} else if(ivideo->sisvga_enabled) {
-- 
1.5.6.5

