Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1DRTYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:24:15 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48113 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab1DRTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:24:10 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 02/12] staging: xgifb: replace inXGIIDXREG() with xgifb_reg_get()
Date: Mon, 18 Apr 2011 22:13:58 +0300
Message-Id: <1303154048-21989-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace inXGIIDXREG() with xgifb_reg_get().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   72 +++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index d790eb3..fc7a042 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -102,36 +102,36 @@ static void dumpVGAReg(void)
 	*/
 
 	for (i = 0; i < 0x4f; i++) {
-		inXGIIDXREG(XGISR, i, reg);
+		reg = xgifb_reg_get(XGISR, i);
 		printk("\no 3c4 %x", i);
 		printk("\ni 3c5 => %x", reg);
 	}
 
 	for (i = 0; i < 0xF0; i++) {
-		inXGIIDXREG(XGICR, i, reg);
+		reg = xgifb_reg_get(XGICR, i);
 		printk("\no 3d4 %x", i);
 		printk("\ni 3d5 => %x", reg);
 	}
 	/*
 	outXGIIDXREG(XGIPART1,0x2F,1);
 	for (i=1; i < 0x50; i++) {
-		inXGIIDXREG(XGIPART1, i, reg);
+		reg = xgifb_reg_get(XGIPART1, i);
 		printk("\no d004 %x", i);
 		printk("\ni d005 => %x", reg);
 	}
 
 	for (i=0; i < 0x50; i++) {
-		 inXGIIDXREG(XGIPART2, i, reg);
+		 reg = xgifb_reg_get(XGIPART2, i);
 		 printk("\no d010 %x", i);
 		 printk("\ni d011 => %x", reg);
 	}
 	for (i=0; i < 0x50; i++) {
-		inXGIIDXREG(XGIPART3, i, reg);
+		reg = xgifb_reg_get(XGIPART3, i);
 		printk("\no d012 %x",i);
 		printk("\ni d013 => %x",reg);
 	}
 	for (i=0; i < 0x50; i++) {
-		inXGIIDXREG(XGIPART4, i, reg);
+		reg = xgifb_reg_get(XGIPART4, i);
 		printk("\no d014 %x",i);
 		printk("\ni d015 => %x",reg);
 	}
@@ -569,7 +569,7 @@ static int XGIfb_GetXG21LVDSData(void)
 	unsigned char *pData;
 	int i, j, k;
 
-	inXGIIDXREG(XGISR, 0x1e, tmp);
+	tmp = xgifb_reg_get(XGISR, 0x1e);
 	outXGIIDXREG(XGISR, 0x1e, tmp | 4);
 
 	pData = xgi_video_info.mmio_vbase + 0x20000;
@@ -1112,7 +1112,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			xgi_video_info.XGI310_AccelDepth = 0x00000000;
 			xgi_video_info.video_cmap_len = 256;
 #if defined(__powerpc__)
-			inXGIIDXREG(XGICR, 0x4D, cr_data);
+			cr_data = xgifb_reg_get(XGICR, 0x4D);
 			outXGIIDXREG(XGICR, 0x4D, (cr_data & 0xE0));
 #endif
 			break;
@@ -1120,7 +1120,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			xgi_video_info.DstColor = 0x8000;
 			xgi_video_info.XGI310_AccelDepth = 0x00010000;
 #if defined(__powerpc__)
-			inXGIIDXREG(XGICR, 0x4D, cr_data);
+			cr_data = xgifb_reg_get(XGICR, 0x4D);
 			outXGIIDXREG(XGICR, 0x4D, ((cr_data & 0xE0) | 0x0B));
 #endif
 			xgi_video_info.video_cmap_len = 16;
@@ -1130,7 +1130,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			xgi_video_info.XGI310_AccelDepth = 0x00020000;
 			xgi_video_info.video_cmap_len = 16;
 #if defined(__powerpc__)
-			inXGIIDXREG(XGICR, 0x4D, cr_data);
+			cr_data = xgifb_reg_get(XGICR, 0x4D);
 			outXGIIDXREG(XGICR, 0x4D, ((cr_data & 0xE0) | 0x15));
 #endif
 			break;
@@ -1460,7 +1460,7 @@ static int XGIfb_blank(int blank, struct fb_info *info)
 {
 	u8 reg;
 
-	inXGIIDXREG(XGICR, 0x17, reg);
+	reg = xgifb_reg_get(XGICR, 0x17);
 
 	if (blank > 0)
 		reg &= 0x7f;
@@ -1539,7 +1539,7 @@ static int XGIfb_get_dram_size(void)
 	if (xgi_video_info.chip == XG27)
 		outXGIIDXREG(XGISR, IND_XGI_DRAM_SIZE, 0x51);
 
-	inXGIIDXREG(XGISR, IND_XGI_DRAM_SIZE, reg);
+	reg = xgifb_reg_get(XGISR, IND_XGI_DRAM_SIZE);
 	switch ((reg & XGI_DRAM_SIZE_MASK) >> 4) {
 	case XGI_DRAM_SIZE_1MB:
 		xgi_video_info.video_size = 0x100000;
@@ -1636,7 +1636,7 @@ static void XGIfb_detect_VB(void)
 		break;
 	}
 
-	inXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR32, cr32);
+	cr32 = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR32);
 
 	if ((cr32 & XGI_CRT1) && !XGIfb_crt1off)
 		XGIfb_crt1off = 0;
@@ -1673,7 +1673,7 @@ static void XGIfb_detect_VB(void)
 		xgi_video_info.TV_plug = TVPLUG_SCART;
 
 	if (xgi_video_info.TV_type == 0) {
-		inXGIIDXREG(XGICR, 0x38, temp);
+		temp = xgifb_reg_get(XGICR, 0x38);
 		if (temp & 0x10)
 			xgi_video_info.TV_type = TVMODE_PAL;
 		else
@@ -1694,7 +1694,7 @@ static void XGIfb_get_VB_type(void)
 	u8 reg;
 
 	if (!XGIfb_has_VB()) {
-		inXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR37, reg);
+		reg = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR37);
 		switch ((reg & XGI_EXTERNAL_CHIP_MASK) >> 1) {
 		case XGI310_EXTERNAL_CHIP_LVDS:
 			xgi_video_info.hasVB = HASVB_LVDS;
@@ -1712,7 +1712,7 @@ static int XGIfb_has_VB(void)
 {
 	u8 vb_chipid;
 
-	inXGIIDXREG(XGIPART4, 0x00, vb_chipid);
+	vb_chipid = xgifb_reg_get(XGIPART4, 0x00);
 	switch (vb_chipid) {
 	case 0x01:
 		xgi_video_info.hasVB = HASVB_301;
@@ -1740,7 +1740,7 @@ int XGIDoSense(int tempbl, int tempbh, int tempcl, int tempch)
 	for (i = 0; i < 10; i++)
 		XGI_LongWait(&XGI_Pr);
 	tempch &= 0x7f;
-	inXGIIDXREG(XGIPART4, 0x03, temp);
+	temp = xgifb_reg_get(XGIPART4, 0x03);
 	temp ^= 0x0e;
 	temp &= tempch;
 	return temp;
@@ -1757,7 +1757,7 @@ void XGI_Sense30x(void)
 	u8 testvga2_tempcl, testvga2_tempch;
 	int myflag, result;
 
-	inXGIIDXREG(XGIPART4, 0x0d, backupP4_0d);
+	backupP4_0d = xgifb_reg_get(XGIPART4, 0x0d);
 	outXGIIDXREG(XGIPART4, 0x0d, (backupP4_0d | 0x04));
 
 	testvga2_tempbh = 0x00;
@@ -1786,7 +1786,7 @@ void XGI_Sense30x(void)
 	}
 	if (XGIhw_ext.ujVBChipID != VB_CHIP_301LV && XGIhw_ext.ujVBChipID
 			!= VB_CHIP_302LV) {
-		inXGIIDXREG(XGIPART4, 0x01, myflag);
+		myflag = xgifb_reg_get(XGIPART4, 0x01);
 		if (myflag & 0x04) {
 			testvga2_tempbh = 0x00;
 			testvga2_tempbl = 0xfd;
@@ -1855,7 +1855,7 @@ static void XGIfb_pre_setmode(void)
 {
 	u8 cr30 = 0, cr31 = 0;
 
-	inXGIIDXREG(XGICR, 0x31, cr31);
+	cr31 = xgifb_reg_get(XGICR, 0x31);
 	cr31 &= ~0x60;
 
 	switch (xgi_video_info.disp_state & DISPTYPE_DISP2) {
@@ -1920,7 +1920,7 @@ static void XGIfb_post_setmode(void)
 
 	/* TW: We can't switch off CRT1 if bridge is in slave mode */
 	if (xgi_video_info.hasVB != HASVB_NONE) {
-		inXGIIDXREG(XGIPART1, 0x00, reg);
+		reg = xgifb_reg_get(XGIPART1, 0x00);
 
 		if ((reg & 0x50) == 0x10)
 			doit = 0;
@@ -1929,7 +1929,7 @@ static void XGIfb_post_setmode(void)
 		XGIfb_crt1off = 0;
 	}
 
-	inXGIIDXREG(XGICR, 0x17, reg);
+	reg = xgifb_reg_get(XGICR, 0x17);
 	if ((XGIfb_crt1off) && (doit))
 		reg &= ~0x80;
 	else
@@ -1941,7 +1941,7 @@ static void XGIfb_post_setmode(void)
 	if ((xgi_video_info.disp_state & DISPTYPE_TV) && (xgi_video_info.hasVB
 			== HASVB_301)) {
 
-		inXGIIDXREG(XGIPART4, 0x01, reg);
+		reg = xgifb_reg_get(XGIPART4, 0x01);
 
 		if (reg < 0xB0) { /* Set filter for XGI301 */
 
@@ -2204,7 +2204,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	XGIRegInit(&XGI_Pr, (unsigned long)XGIhw_ext.pjIOAddress);
 
 	outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
-	inXGIIDXREG(XGISR, IND_XGI_PASSWORD, reg1);
+	reg1 = xgifb_reg_get(XGISR, IND_XGI_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
 		printk("\nXGIfb: I/O error!!!");
@@ -2215,7 +2215,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	switch (xgi_video_info.chip_id) {
 	case PCI_DEVICE_ID_XG_20:
 		orXGIIDXREG(XGICR, Index_CR_GPIO_Reg3, GPIOG_EN);
-		inXGIIDXREG(XGICR, Index_CR_GPIO_Reg1, CR48);
+		CR48 = xgifb_reg_get(XGICR, Index_CR_GPIO_Reg1);
 		if (CR48&GPIOG_READ)
 			xgi_video_info.chip = XG21;
 		else
@@ -2313,7 +2313,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		if ((xgi_video_info.chip == XG20) || (xgi_video_info.chip == XG27)) {
 			xgi_video_info.hasVB = HASVB_NONE;
 		} else if (xgi_video_info.chip == XG21) {
-			inXGIIDXREG(XGICR, 0x38, CR38);
+			CR38 = xgifb_reg_get(XGICR, 0x38);
 			if ((CR38&0xE0) == 0xC0) {
 				xgi_video_info.disp_state = DISPTYPE_LCD;
 				if (!XGIfb_GetXG21LVDSData()) {
@@ -2340,7 +2340,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		switch (xgi_video_info.hasVB) {
 		case HASVB_301:
-			inXGIIDXREG(XGIPART4, 0x01, reg);
+			reg = xgifb_reg_get(XGIPART4, 0x01);
 			if (reg >= 0xE0) {
 				XGIhw_ext.ujVBChipID = VB_CHIP_302LV;
 				printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
@@ -2350,7 +2350,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			}
 			/* else if (reg >= 0xB0) {
 				XGIhw_ext.ujVBChipID = VB_CHIP_301B;
-				inXGIIDXREG(XGIPART4, 0x23, reg1);
+				reg1 = xgifb_reg_get(XGIPART4, 0x23);
 				printk("XGIfb: XGI301B bridge detected\n");
 			} */
 			else {
@@ -2359,7 +2359,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			}
 			break;
 		case HASVB_302:
-			inXGIIDXREG(XGIPART4, 0x01, reg);
+			reg = xgifb_reg_get(XGIPART4, 0x01);
 			if (reg >= 0xE0) {
 				XGIhw_ext.ujVBChipID = VB_CHIP_302LV;
 				printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
@@ -2367,7 +2367,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 				XGIhw_ext.ujVBChipID = VB_CHIP_301LV;
 				printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
 			} else if (reg >= 0xB0) {
-				inXGIIDXREG(XGIPART4, 0x23, reg1);
+				reg1 = xgifb_reg_get(XGIPART4, 0x23);
 
 				XGIhw_ext.ujVBChipID = VB_CHIP_302B;
 
@@ -2411,7 +2411,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		if (xgi_video_info.disp_state & DISPTYPE_LCD) {
 			if (!enable_dstn) {
-				inXGIIDXREG(XGICR, IND_XGI_LCD_PANEL, reg);
+				reg = xgifb_reg_get(XGICR, IND_XGI_LCD_PANEL);
 				reg &= 0x0f;
 				XGIhw_ext.ulCRT2LCDType = XGI310paneltype[reg];
 
@@ -2431,21 +2431,21 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 				(XGIhw_ext.ujVBChipID == VB_CHIP_301LV) ||
 				(XGIhw_ext.ujVBChipID == VB_CHIP_302LV)) {
 			int tmp;
-			inXGIIDXREG(XGICR, 0x34, tmp);
+			tmp = xgifb_reg_get(XGICR, 0x34);
 			if (tmp <= 0x13) {
 				/* Currently on LCDA? (Some BIOSes leave CR38) */
-				inXGIIDXREG(XGICR, 0x38, tmp);
+				tmp = xgifb_reg_get(XGICR, 0x38);
 				if ((tmp & 0x03) == 0x03) {
 					/* XGI_Pr.XGI_UseLCDA = 1; */
 				} else {
 					/* Currently on LCDA? (Some newer BIOSes set D0 in CR35) */
-					inXGIIDXREG(XGICR, 0x35, tmp);
+					tmp = xgifb_reg_get(XGICR, 0x35);
 					if (tmp & 0x01) {
 						/* XGI_Pr.XGI_UseLCDA = 1; */
 					} else {
-						inXGIIDXREG(XGICR, 0x30, tmp);
+						tmp = xgifb_reg_get(XGICR, 0x30);
 						if (tmp & 0x20) {
-							inXGIIDXREG(XGIPART1, 0x13, tmp);
+							tmp = xgifb_reg_get(XGIPART1, 0x13);
 							if (tmp & 0x04) {
 								/* XGI_Pr.XGI_UseLCDA = 1; */
 							}
-- 
1.5.6.5

