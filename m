Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab2FRLMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:12:44 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60062 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751561Ab2FRLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjBAsBRhAlAiYCAlcHEogPpXKSBYEgj0CBEgOVJJJf
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339245"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 6/8] Staging: xgifb: Remove printk usage.
Date: Mon, 18 Jun 2012 13:12:04 +0200
Message-Id: <27b5e3abac7e0a998852b8b2ba8fe53767946bbc.1340016625.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace meaninful printks with pr_debug and remove useless ones.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   36 ++++++++++-----------------
 drivers/staging/xgifb/vb_init.c     |   47 ++---------------------------------
 2 files changed, 15 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 58cddb4..df6ef46 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -69,37 +69,37 @@ static void dumpVGAReg(void)
 
 	for (i = 0; i < 0x4f; i++) {
 		reg = xgifb_reg_get(XGISR, i);
-		printk("\no 3c4 %x", i);
-		printk("\ni 3c5 => %x", reg);
+		pr_debug("\no 3c4 %x", i);
+		pr_debug("\ni 3c5 => %x", reg);
 	}
 
 	for (i = 0; i < 0xF0; i++) {
 		reg = xgifb_reg_get(XGICR, i);
-		printk("\no 3d4 %x", i);
-		printk("\ni 3d5 => %x", reg);
+		pr_debug("\no 3d4 %x", i);
+		pr_debug("\ni 3d5 => %x", reg);
 	}
 	/*
 	xgifb_reg_set(XGIPART1,0x2F,1);
 	for (i=1; i < 0x50; i++) {
 		reg = xgifb_reg_get(XGIPART1, i);
-		printk("\no d004 %x", i);
-		printk("\ni d005 => %x", reg);
+		pr_debug("\no d004 %x", i);
+		pr_debug("\ni d005 => %x", reg);
 	}
 
 	for (i=0; i < 0x50; i++) {
 		 reg = xgifb_reg_get(XGIPART2, i);
-		 printk("\no d010 %x", i);
-		 printk("\ni d011 => %x", reg);
+		 pr_debug("\no d010 %x", i);
+		 pr_debug("\ni d011 => %x", reg);
 	}
 	for (i=0; i < 0x50; i++) {
 		reg = xgifb_reg_get(XGIPART3, i);
-		printk("\no d012 %x",i);
-		printk("\ni d013 => %x",reg);
+		pr_debug("\no d012 %x",i);
+		pr_debug("\ni d013 => %x",reg);
 	}
 	for (i=0; i < 0x50; i++) {
 		reg = xgifb_reg_get(XGIPART4, i);
-		printk("\no d014 %x",i);
-		printk("\ni d015 => %x",reg);
+		pr_debug("\no d014 %x",i);
+		pr_debug("\ni d015 => %x",reg);
 	}
 	*/
 }
@@ -1040,8 +1040,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	int old_mode;
 	/* unsigned char reg, reg1; */
 
-	/* printk(KERN_DEBUG "XGIfb:var->yres=%d, var->upper_margin=%d, var->lower_margin=%d, var->vsync_len=%d\n", var->yres, var->upper_margin, var->lower_margin, var->vsync_len); */
-
 	info->var.xres_virtual = var->xres_virtual;
 	info->var.yres_virtual = var->yres_virtual;
 	info->var.bits_per_pixel = var->bits_per_pixel;
@@ -1194,8 +1192,6 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	struct xgifb_video_info *xgifb_info = info->par;
 	unsigned int base;
 
-	/* printk("Inside pan_var"); */
-
 	base = var->yoffset * info->var.xres_virtual + var->xoffset;
 
 	/* calculate base bpp dep. */
@@ -1229,7 +1225,6 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var, struct fb_info *info)
 				 0x7F,
 				 ((base >> 24) & 0x01) << 7);
 	}
-	/* printk("End of pan_var"); */
 	return 0;
 }
 
@@ -1342,12 +1337,10 @@ static int XGIfb_set_par(struct fb_info *info)
 {
 	int err;
 
-	/* printk("XGIfb: inside set_par\n"); */
 	err = XGIfb_do_set_var(&info->var, 1, info);
 	if (err)
 		return err;
 	XGIfb_get_fix(&info->fix, -1, info);
-	/* printk("XGIfb: end of set_par\n"); */
 	return 0;
 }
 
@@ -1501,8 +1494,6 @@ static int XGIfb_pan_display(struct fb_var_screeninfo *var,
 {
 	int err;
 
-	/* printk("\nInside pan_display:\n"); */
-
 	if (var->xoffset > (info->var.xres_virtual - info->var.xres))
 		return -EINVAL;
 	if (var->yoffset > (info->var.yres_virtual - info->var.yres))
@@ -1529,7 +1520,6 @@ static int XGIfb_pan_display(struct fb_var_screeninfo *var,
 	else
 		info->var.vmode &= ~FB_VMODE_YWRAP;
 
-	/* printk("End of pan_display\n"); */
 	return 0;
 }
 
@@ -1986,7 +1976,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		/* else if (reg >= 0xB0) {
 			hw_info->ujVBChipID = VB_CHIP_301B;
 			reg1 = xgifb_reg_get(XGIPART4, 0x23);
-			printk("XGIfb: XGI301B bridge detected\n");
+			pr_debug("XGIfb: XGI301B bridge detected\n");
 		} */
 		else {
 			hw_info->ujVBChipID = VB_CHIP_301;
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index a3d54b7..64d1311 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1318,22 +1318,17 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	/* Newdebugcode(0x99); */
 
 	if (pVBInfo->FBAddr == NULL) {
-		printk("\n pVBInfo->FBAddr == 0 ");
+		pr_debug("pVBInfo->FBAddr == 0\n");
 		return 0;
 	}
-	printk("1");
 	if (pVBInfo->BaseAddr == 0) {
-		printk("\npVBInfo->BaseAddr == 0 ");
+		pr_debug("pVBInfo->BaseAddr == 0\n");
 		return 0;
 	}
-	printk("2");
 
 	outb(0x67, (pVBInfo->BaseAddr + 0x12)); /* 3c2 <- 67 ,ynlai */
 
 	pVBInfo->ISXPDOS = 0;
-	printk("3");
-
-	printk("4");
 
 	/* VBIOSVersion[4] = 0x0; */
 
@@ -1356,7 +1351,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	pVBInfo->Part3Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_12;
 	pVBInfo->Part4Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14;
 	pVBInfo->Part5Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14 + 2;
-	printk("5");
 
 	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
 		/* Run XGI_GetVBType before InitTo330Pointer */
@@ -1368,7 +1362,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 	/* 1.Openkey */
 	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
-	printk("6");
 
 	/* GetXG21Sense (GPIO) */
 	if (HwDeviceExtension->jChipType == XG21)
@@ -1377,8 +1370,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	if (HwDeviceExtension->jChipType == XG27)
 		XGINew_GetXG27Sense(HwDeviceExtension, pVBInfo);
 
-	printk("7");
-
 	/* 2.Reset Extended register */
 
 	for (i = 0x06; i < 0x20; i++)
@@ -1390,11 +1381,8 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	/* for(i = 0x06; i <= 0x27; i++) */
 	/* xgifb_reg_set(pVBInfo->P3c4, i, 0); */
 
-	printk("8");
-
 	for (i = 0x31; i <= 0x3B; i++)
 		xgifb_reg_set(pVBInfo->P3c4, i, 0);
-	printk("9");
 
 	/* [Hsuan] 2004/08/20 Auto over driver for XG42 */
 	if (HwDeviceExtension->jChipType == XG42)
@@ -1406,8 +1394,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	for (i = 0x79; i <= 0x7C; i++)
 		xgifb_reg_set(pVBInfo->P3d4, i, 0); /* shampoo 0208 */
 
-	printk("10");
-
 	if (HwDeviceExtension->jChipType >= XG20)
 		xgifb_reg_set(pVBInfo->P3d4, 0x97, pVBInfo->XGINew_CR97);
 
@@ -1416,8 +1402,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	pVBInfo->ram_type = XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 	*/
 
-	printk("11");
-
 	/* 4.SetDefExt1Regs begin */
 	xgifb_reg_set(pVBInfo->P3c4, 0x07, XGI330_SR07);
 	if (HwDeviceExtension->jChipType == XG27) {
@@ -1437,8 +1421,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	/* SR11 = 0x0F; */
 	/* xgifb_reg_set(pVBInfo->P3c4, 0x11, SR11); */
 
-	printk("12");
-
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		u32 Temp;
 
@@ -1484,8 +1466,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		}
 		*/
 
-		printk("13");
-
 		/* Set AGP customize registers (in SetDefAGPRegs) Start */
 		for (i = 0x47; i <= 0x4C; i++)
 			xgifb_reg_set(pVBInfo->P3d4,
@@ -1514,14 +1494,12 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 		if (Temp == 1)
 			xgifb_reg_set(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
-		printk("14");
 	} /* != XG20 */
 
 	/* Set PCI */
 	xgifb_reg_set(pVBInfo->P3c4, 0x23, XGI330_SR23);
 	xgifb_reg_set(pVBInfo->P3c4, 0x24, XGI330_SR24);
 	xgifb_reg_set(pVBInfo->P3c4, 0x25, XGI330_SR25);
-	printk("15");
 
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		/* Set VB */
@@ -1536,8 +1514,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		xgifb_reg_set(pVBInfo->Part1Port,
 			      0x02, XGI330_CRT2Data_1_2);
 
-		printk("16");
-
 		xgifb_reg_set(pVBInfo->Part1Port, 0x2E, 0x08); /* use VB */
 	} /* != XG20 */
 
@@ -1557,7 +1533,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		xgifb_reg_set(pVBInfo->P3c4, 0x32, XGI330_SR32);
 	}
 	xgifb_reg_set(pVBInfo->P3c4, 0x33, XGI330_SR33);
-	printk("17");
 
 	/*
 	 SetPowerConsume (HwDeviceExtension, pVBInfo->P3c4);	*/
@@ -1578,18 +1553,11 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 			XGI_LockCRT2(HwDeviceExtension, pVBInfo);
 		}
 	} /* != XG20 */
-	printk("18");
-
-	printk("181");
-
-	printk("182");
 
 	XGI_SenseCRT1(pVBInfo);
 
-	printk("183");
 	/* XGINew_DetectMonitor(HwDeviceExtension); */
 	if (HwDeviceExtension->jChipType == XG21) {
-		printk("186");
 
 		xgifb_reg_and_or(pVBInfo->P3d4,
 				 0x32,
@@ -1597,7 +1565,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 				 Monitor1Sense); /* Z9 default has CRT */
 		temp = GetXG21FPBits(pVBInfo);
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~0x01, temp);
-		printk("187");
 
 	}
 	if (HwDeviceExtension->jChipType == XG27) {
@@ -1608,7 +1575,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		temp = GetXG27FPBits(pVBInfo);
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~0x03, temp);
 	}
-	printk("19");
 
 	pVBInfo->ram_type = XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 
@@ -1616,11 +1582,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 					 pVBInfo->P3d4,
 					 pVBInfo);
 
-	printk("20");
 	XGINew_SetDRAMSize_340(xgifb_info, HwDeviceExtension, pVBInfo);
-	printk("21");
-
-	printk("22");
 
 	/* SetDefExt2Regs begin */
 	/*
@@ -1651,16 +1613,11 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x21, pVBInfo->SR21);
 
-	printk("23");
-
 	XGINew_ChkSenseStatus(HwDeviceExtension, pVBInfo);
 	XGINew_SetModeScratch(HwDeviceExtension, pVBInfo);
 
-	printk("24");
-
 	xgifb_reg_set(pVBInfo->P3d4, 0x8c, 0x87);
 	xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x31);
-	printk("25");
 
 	return 1;
 } /* end of init */
-- 
1.7.9.5

