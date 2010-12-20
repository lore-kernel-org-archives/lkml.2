Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0LTVve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:51:34 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52285 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab0LTVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:05 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 09/13] sisfb: replace orSISIDXREG with SiS_SetRegOR
Date: Mon, 20 Dec 2010 23:50:18 +0200
Message-Id: <1292881822-32630-10-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace orSISIDXREG() with SiS_SetRegOR().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   72 +++++++++++++++++++++---------------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 59a567c..0b10f12 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1120,7 +1120,7 @@ sisfb_set_pitch(struct sis_video_info *ivideo)
 
 	/* We must not set the pitch for CRT2 if bridge is in slave mode */
 	if((ivideo->currentvbflags & VB_DISPTYPE_DISP2) && (!isslavemode)) {
-		orSISIDXREG(SISPART1,ivideo->CRT2_write_enable,0x01);
+		SiS_SetRegOR(SISPART1, ivideo->CRT2_write_enable, 0x01);
 		SiS_SetReg(SISPART1, 0x07, (HDisplay2 & 0xFF));
 		setSISIDXREG(SISPART1,0x09,0xF0,(HDisplay2 >> 8));
 	}
@@ -1322,7 +1322,7 @@ static void
 sisfb_set_base_CRT2(struct sis_video_info *ivideo, unsigned int base)
 {
 	if(ivideo->currentvbflags & VB_DISPTYPE_DISP2) {
-		orSISIDXREG(SISPART1, ivideo->CRT2_write_enable, 0x01);
+		SiS_SetRegOR(SISPART1, ivideo->CRT2_write_enable, 0x01);
 		SiS_SetReg(SISPART1, 0x06, (base & 0xFF));
 		SiS_SetReg(SISPART1, 0x05, ((base >> 8) & 0xFF));
 		SiS_SetReg(SISPART1, 0x04, ((base >> 16) & 0xFF));
@@ -2199,7 +2199,7 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
     int i;
 
     sr1F = SiS_GetReg(SISSR, 0x1F);
-    orSISIDXREG(SISSR,0x1F,0x04);
+    SiS_SetRegOR(SISSR, 0x1F, 0x04);
     andSISIDXREG(SISSR,0x1F,0x3F);
     if(sr1F & 0xc0) mustwait = true;
 
@@ -2214,7 +2214,7 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
     cr17 = SiS_GetReg(SISCR, 0x17);
     cr17 &= 0x80;
     if(!cr17) {
-       orSISIDXREG(SISCR,0x17,0x80);
+       SiS_SetRegOR(SISCR, 0x17, 0x80);
        mustwait = true;
        SiS_SetReg(SISSR, 0x00, 0x01);
        SiS_SetReg(SISSR, 0x00, 0x03);
@@ -2232,7 +2232,7 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
        } else {
 	   SiS_SetReg(SISCR, 0x57, 0x5f);
        }
-       orSISIDXREG(SISCR, 0x53, 0x02);
+	SiS_SetRegOR(SISCR, 0x53, 0x02);
 	while ((SiS_GetRegByte(SISINPSTAT)) & 0x01)    break;
 	while (!((SiS_GetRegByte(SISINPSTAT)) & 0x01)) break;
 	if ((SiS_GetRegByte(SISMISCW)) & 0x10) temp = 1;
@@ -2254,7 +2254,7 @@ sisfb_sense_crt1(struct sis_video_info *ivideo)
     }
 
     if((temp) && (temp != 0xffff)) {
-       orSISIDXREG(SISCR,0x32,0x20);
+       SiS_SetRegOR(SISCR, 0x32, 0x20);
     }
 
 #ifdef CONFIG_FB_SIS_315
@@ -2352,7 +2352,7 @@ SiS_SenseLCD(struct sis_video_info *ivideo)
 	SiS_SetReg(SISCR, 0x36, paneltype);
 	cr37 &= 0xf1;
 	setSISIDXREG(SISCR, 0x37, 0x0c, cr37);
-	orSISIDXREG(SISCR, 0x32, 0x08);
+	SiS_SetRegOR(SISCR, 0x32, 0x08);
 
 	ivideo->SiS_Pr.PanelSelfDetected = true;
 }
@@ -2439,13 +2439,13 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     }
 
     backupSR_1e = SiS_GetReg(SISSR, 0x1e);
-    orSISIDXREG(SISSR,0x1e,0x20);
+    SiS_SetRegOR(SISSR, 0x1e, 0x20);
 
     backupP4_0d = SiS_GetReg(SISPART4, 0x0d);
     if(ivideo->vbflags2 & VB2_30xC) {
        setSISIDXREG(SISPART4,0x0d,~0x07,0x01);
     } else {
-       orSISIDXREG(SISPART4,0x0d,0x04);
+       SiS_SetRegOR(SISPART4, 0x0d, 0x04);
     }
     SiS_DDC2Delay(&ivideo->SiS_Pr, 0x2000);
 
@@ -2467,10 +2467,10 @@ SiS_Sense30x(struct sis_video_info *ivideo)
        if(SISDoSense(ivideo, vga2, vga2_c)) {
           if(biosflag & 0x01) {
 	     printk(KERN_INFO "%s %s SCART output\n", stdstr, tvstr);
-	     orSISIDXREG(SISCR, 0x32, 0x04);
+	     SiS_SetRegOR(SISCR, 0x32, 0x04);
 	  } else {
 	     printk(KERN_INFO "%s secondary VGA connection\n", stdstr);
-	     orSISIDXREG(SISCR, 0x32, 0x10);
+	     SiS_SetRegOR(SISCR, 0x32, 0x10);
 	  }
        }
     }
@@ -2478,7 +2478,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     andSISIDXREG(SISCR, 0x32, 0x3f);
 
     if(ivideo->vbflags2 & VB2_30xCLV) {
-       orSISIDXREG(SISPART4,0x0d,0x04);
+       SiS_SetRegOR(SISPART4, 0x0d, 0x04);
     }
 
     if((ivideo->sisvga_engine == SIS_315_VGA) && (ivideo->vbflags2 & VB2_SISYPBPRBRIDGE)) {
@@ -2487,7 +2487,7 @@ SiS_Sense30x(struct sis_video_info *ivideo)
        if((result = SISDoSense(ivideo, svhs, 0x0604))) {
           if((result = SISDoSense(ivideo, cvbs, 0x0804))) {
 	     printk(KERN_INFO "%s %s YPbPr component output\n", stdstr, tvstr);
-	     orSISIDXREG(SISCR,0x32,0x80);
+	     SiS_SetRegOR(SISCR, 0x32, 0x80);
 	  }
        }
        SiS_SetReg(SISPART2, 0x4d, backupP2_4d);
@@ -2498,12 +2498,12 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     if(!(ivideo->vbflags & TV_YPBPR)) {
        if((result = SISDoSense(ivideo, svhs, svhs_c))) {
           printk(KERN_INFO "%s %s SVIDEO output\n", stdstr, tvstr);
-          orSISIDXREG(SISCR, 0x32, 0x02);
+	   SiS_SetRegOR(SISCR, 0x32, 0x02);
        }
        if((biosflag & 0x02) || (!result)) {
           if(SISDoSense(ivideo, cvbs, cvbs_c)) {
 	     printk(KERN_INFO "%s %s COMPOSITE output\n", stdstr, tvstr);
-	     orSISIDXREG(SISCR, 0x32, 0x01);
+	     SiS_SetRegOR(SISCR, 0x32, 0x01);
           }
        }
     }
@@ -2588,12 +2588,12 @@ SiS_SenseCh(struct sis_video_info *ivideo)
 	   if(temp1 == 0x02) {
 		printk(KERN_INFO "%s SVIDEO output\n", stdstr);
 		ivideo->vbflags |= TV_SVIDEO;
-		orSISIDXREG(SISCR, 0x32, 0x02);
+		SiS_SetRegOR(SISCR, 0x32, 0x02);
 		andSISIDXREG(SISCR, 0x32, ~0x05);
 	   } else if (temp1 == 0x01) {
 		printk(KERN_INFO "%s CVBS output\n", stdstr);
 		ivideo->vbflags |= TV_AVIDEO;
-		orSISIDXREG(SISCR, 0x32, 0x01);
+		SiS_SetRegOR(SISCR, 0x32, 0x01);
 		andSISIDXREG(SISCR, 0x32, ~0x06);
 	   } else {
 		SiS_SetCH70xxANDOR(&ivideo->SiS_Pr, 0x0e, 0x01, 0xF8);
@@ -2632,18 +2632,18 @@ SiS_SenseCh(struct sis_video_info *ivideo)
 	case 0x01:
 	     printk(KERN_INFO "%s CVBS output\n", stdstr);
 	     ivideo->vbflags |= TV_AVIDEO;
-	     orSISIDXREG(SISCR, 0x32, 0x01);
+	     SiS_SetRegOR(SISCR, 0x32, 0x01);
 	     andSISIDXREG(SISCR, 0x32, ~0x06);
 	     break;
 	case 0x02:
 	     printk(KERN_INFO "%s SVIDEO output\n", stdstr);
 	     ivideo->vbflags |= TV_SVIDEO;
-	     orSISIDXREG(SISCR, 0x32, 0x02);
+	     SiS_SetRegOR(SISCR, 0x32, 0x02);
 	     andSISIDXREG(SISCR, 0x32, ~0x05);
 	     break;
 	case 0x04:
 	     printk(KERN_INFO "%s SCART output\n", stdstr);
-	     orSISIDXREG(SISCR, 0x32, 0x04);
+	     SiS_SetRegOR(SISCR, 0x32, 0x04);
 	     andSISIDXREG(SISCR, 0x32, ~0x03);
 	     break;
 	default:
@@ -4195,7 +4195,7 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 	int i, j;
 
 	andSISIDXREG(SISSR, 0x15, 0xFB);
-	orSISIDXREG(SISSR, 0x15, 0x04);
+	SiS_SetRegOR(SISSR, 0x15, 0x04);
 	SiS_SetReg(SISSR, 0x13, 0x00);
 	SiS_SetReg(SISSR, 0x14, 0xBF);
 
@@ -4205,7 +4205,7 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 			writew(temp, FBAddress);
 			if(readw(FBAddress) == temp)
 				break;
-			orSISIDXREG(SISSR, 0x3c, 0x01);
+			SiS_SetRegOR(SISSR, 0x3c, 0x01);
 			reg = SiS_GetReg(SISSR, 0x05);
 			reg = SiS_GetReg(SISSR, 0x05);
 			andSISIDXREG(SISSR, 0x3c, 0xfe);
@@ -4284,7 +4284,7 @@ sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth
 		PhysicalAdrOtherPage = PageCapacity * SiS_DRAMType[k][2] + PhysicalAdrHigh;
 
 		andSISIDXREG(SISSR, 0x15, 0xFB); /* Test */
-		orSISIDXREG(SISSR, 0x15, 0x04);  /* Test */
+		SiS_SetRegOR(SISSR, 0x15, 0x04);  /* Test */
 		sr14 = (SiS_DRAMType[k][3] * buswidth) - 1;
 		if(buswidth == 4)      sr14 |= 0x80;
 		else if(buswidth == 2) sr14 |= 0x40;
@@ -4424,10 +4424,10 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	SiS_SetReg(SISSR, 0x1b, v7);
 	SiS_SetReg(SISSR, 0x1c, v8);	   /* ---- */
 	andSISIDXREG(SISSR, 0x15 ,0xfb);
-	orSISIDXREG(SISSR, 0x15, 0x04);
+	SiS_SetRegOR(SISSR, 0x15, 0x04);
 	if(bios) {
 		if(bios[0x53] & 0x02) {
-			orSISIDXREG(SISSR, 0x19, 0x20);
+			SiS_SetRegOR(SISSR, 0x19, 0x20);
 		}
 	}
 	v1 = 0x04;			   /* DAC pedestal (BIOS 0xe5) */
@@ -4447,7 +4447,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	SiS_SetReg(SISSR, 0x21, 0x84);
 	SiS_SetReg(SISSR, 0x22, 0x00);
 	SiS_SetReg(SISCR, 0x37, 0x00);
-	orSISIDXREG(SISPART1, 0x24, 0x01);   /* unlock crt2 */
+	SiS_SetRegOR(SISPART1, 0x24, 0x01);   /* unlock crt2 */
 	SiS_SetReg(SISPART1, 0x00, 0x00);
 	v1 = 0x40; v2 = 0x11;
 	if(bios) {
@@ -4544,7 +4544,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	/* Display off */
-	orSISIDXREG(SISSR, 0x01, 0x20);
+	SiS_SetRegOR(SISSR, 0x01, 0x20);
 
 	/* Save mode number in CR34 */
 	SiS_SetReg(SISCR, 0x34, 0x2e);
@@ -4662,7 +4662,7 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 	 * - if running on non-x86, there usually is no VGA window
 	 *   at a0000.
 	 */
-	orSISIDXREG(SISSR, 0x20, (0x80 | 0x04));
+	SiS_SetRegOR(SISSR, 0x20, (0x80 | 0x04));
 
 	/* Need to map max FB size for finding out about RAM size */
 	mapsize = ivideo->video_size;
@@ -5190,7 +5190,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		regd = (regd >> 20) & 0x0f;
 		if(regd == 1) {
 			v1 &= 0xfc;
-			orSISIDXREG(SISCR, 0x5f, 0x08);
+			SiS_SetRegOR(SISCR, 0x5f, 0x08);
 		}
 		SiS_SetReg(SISCR, 0x48, v1);
 
@@ -5326,7 +5326,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	}
 	SiS_SetReg(SISCR, 0x45, v1 & 0x0f);
 	SiS_SetReg(SISCR, 0x99, (v1 >> 4) & 0x07);
-	orSISIDXREG(SISCR, 0x40, v1 & 0x80);
+	SiS_SetRegOR(SISCR, 0x40, v1 & 0x80);
 	SiS_SetReg(SISCR, 0x41, v2);
 
 	ptr  = cs170;
@@ -5663,7 +5663,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		andSISIDXREG(SISSR, 0x21, 0xdf);
 		sisfb_post_xgi_ramsize(ivideo);
 		/* Enable read-cache */
-		orSISIDXREG(SISSR, 0x21, 0x20);
+		SiS_SetRegOR(SISSR, 0x21, 0x20);
 
 	}
 
@@ -5682,13 +5682,13 @@ sisfb_post_xgi(struct pci_dev *pdev)
 
 	/* Sense CRT1 */
 	if(ivideo->chip == XGI_20) {
-		orSISIDXREG(SISCR, 0x32, 0x20);
+		SiS_SetRegOR(SISCR, 0x32, 0x20);
 	} else {
 		reg = SiS_GetReg(SISPART4, 0x00);
 		if((reg == 1) || (reg == 2)) {
 			sisfb_sense_crt1(ivideo);
 		} else {
-			orSISIDXREG(SISCR, 0x32, 0x20);
+			SiS_SetRegOR(SISCR, 0x32, 0x20);
 		}
 	}
 
@@ -5702,7 +5702,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	SiS_SetReg(SISSR, 0x05, 0x86);
 
 	/* Display off */
-	orSISIDXREG(SISSR, 0x01, 0x20);
+	SiS_SetRegOR(SISSR, 0x01, 0x20);
 
 	/* Save mode number in CR34 */
 	SiS_SetReg(SISCR, 0x34, 0x2e);
@@ -6066,9 +6066,9 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if((ivideo->sisfb_mode_idx < 0) ||
 	   ((sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni]) != 0xFF)) {
 		/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
-		orSISIDXREG(SISSR, IND_SIS_PCI_ADDRESS_SET, (SIS_PCI_ADDR_ENABLE | SIS_MEM_MAP_IO_ENABLE));
+		SiS_SetRegOR(SISSR, IND_SIS_PCI_ADDRESS_SET, (SIS_PCI_ADDR_ENABLE | SIS_MEM_MAP_IO_ENABLE));
 		/* Enable 2D accelerator engine */
-		orSISIDXREG(SISSR, IND_SIS_MODULE_ENABLE, SIS_ENABLE_2D);
+		SiS_SetRegOR(SISSR, IND_SIS_MODULE_ENABLE, SIS_ENABLE_2D);
 	}
 
 	if(sisfb_pdc != 0xff) {
-- 
1.5.6.5

