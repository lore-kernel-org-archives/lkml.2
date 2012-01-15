Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2AOSWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:22:44 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41642 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751536Ab2AOSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:22:40 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/nZF5fpernAFxP3tjuFLZ4b+W7xez70tUK3qTboD
	G9yZLLYGxOabYE
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/4] staging/xgifb: Use structs and defines from the sis headers
Date: Sun, 15 Jan 2012 19:22:12 +0100
Message-Id: <1326651733-9242-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
References: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the usage of some xgi structs and defines and
replaces them with the _identical_ structs from the sis headers.
Thus the old structs and defines can be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |   88 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_setmode.c  |   22 ++++----
 drivers/staging/xgifb/vb_struct.h   |   12 ++--
 drivers/staging/xgifb/vb_table.h    |   10 ++--
 4 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index c27dbf8..cb2f844 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -811,27 +811,27 @@ static void XGIfb_pre_setmode(struct xgifb_video_info *xgifb_info)
 
 	switch (xgifb_info->display2) {
 	case XGIFB_DISP_CRT:
-		cr30 = (XGI_VB_OUTPUT_CRT2 | XGI_SIMULTANEOUS_VIEW_ENABLE);
-		cr31 |= XGI_DRIVER_MODE;
+		cr30 = (SIS_VB_OUTPUT_CRT2 | SIS_SIMULTANEOUS_VIEW_ENABLE);
+		cr31 |= SIS_DRIVER_MODE;
 		break;
 	case XGIFB_DISP_LCD:
-		cr30 = (XGI_VB_OUTPUT_LCD | XGI_SIMULTANEOUS_VIEW_ENABLE);
-		cr31 |= XGI_DRIVER_MODE;
+		cr30 = (SIS_VB_OUTPUT_LCD | SIS_SIMULTANEOUS_VIEW_ENABLE);
+		cr31 |= SIS_DRIVER_MODE;
 		break;
 	case XGIFB_DISP_TV:
 		if (xgifb_info->TV_type == TVMODE_HIVISION)
-			cr30 = (XGI_VB_OUTPUT_HIVISION
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+			cr30 = (SIS_VB_OUTPUT_HIVISION
+					| SIS_SIMULTANEOUS_VIEW_ENABLE);
 		else if (xgifb_info->TV_plug == TVPLUG_SVIDEO)
-			cr30 = (XGI_VB_OUTPUT_SVIDEO
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+			cr30 = (SIS_VB_OUTPUT_SVIDEO
+					| SIS_SIMULTANEOUS_VIEW_ENABLE);
 		else if (xgifb_info->TV_plug == TVPLUG_COMPOSITE)
-			cr30 = (XGI_VB_OUTPUT_COMPOSITE
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+			cr30 = (SIS_VB_OUTPUT_COMPOSITE
+					| SIS_SIMULTANEOUS_VIEW_ENABLE);
 		else if (xgifb_info->TV_plug == TVPLUG_SCART)
-			cr30 = (XGI_VB_OUTPUT_SCART
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
-		cr31 |= XGI_DRIVER_MODE;
+			cr30 = (SIS_VB_OUTPUT_SCART
+					| SIS_SIMULTANEOUS_VIEW_ENABLE);
+		cr31 |= SIS_DRIVER_MODE;
 
 		if (XGIfb_tvmode == 1 || xgifb_info->TV_type == TVMODE_PAL)
 			cr31 |= 0x01;
@@ -840,7 +840,7 @@ static void XGIfb_pre_setmode(struct xgifb_video_info *xgifb_info)
 		break;
 	default: /* disable CRT2 */
 		cr30 = 0x00;
-		cr31 |= (XGI_DRIVER_MODE | XGI_VB_OUTPUT_DISABLE);
+		cr31 |= (SIS_DRIVER_MODE | SIS_VB_OUTPUT_DISABLE);
 	}
 
 	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR30, cr30);
@@ -854,7 +854,7 @@ static void XGIfb_post_setmode(struct xgifb_video_info *xgifb_info)
 	u8 reg;
 	unsigned char doit = 1;
 	/*
-	xgifb_reg_set(XGISR,IND_XGI_PASSWORD,XGI_PASSWORD);
+	xgifb_reg_set(XGISR,IND_SIS_PASSWORD,SIS_PASSWORD);
 	xgifb_reg_set(XGICR, 0x13, 0x00);
 	xgifb_reg_and_or(XGISR,0x0E, 0xF0, 0x01);
 	*test*
@@ -890,7 +890,7 @@ static void XGIfb_post_setmode(struct xgifb_video_info *xgifb_info)
 		reg |= 0x80;
 	xgifb_reg_set(XGICR, 0x17, reg);
 
-	xgifb_reg_and(XGISR, IND_XGI_RAMDAC_CONTROL, ~0x04);
+	xgifb_reg_and(XGISR, IND_SIS_RAMDAC_CONTROL, ~0x04);
 
 	if (xgifb_info->display2 == XGIFB_DISP_TV &&
 	    xgifb_info->hasVB == HASVB_301) {
@@ -923,7 +923,7 @@ static void XGIfb_post_setmode(struct xgifb_video_info *xgifb_info)
 				break;
 			}
 			xgifb_reg_or(XGIPART1,
-				     IND_XGI_CRT2_WRITE_ENABLE_315,
+				     SIS_CRT2_WENABLE_315,
 				     0x01);
 
 			if (xgifb_info->TV_type == TVMODE_NTSC) {
@@ -1184,7 +1184,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		info->fix.line_length = ((info->var.xres_virtual
 				* info->var.bits_per_pixel) >> 6);
 
-		xgifb_reg_set(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
+		xgifb_reg_set(XGISR, IND_SIS_PASSWORD, SIS_PASSWORD);
 
 		xgifb_reg_set(XGICR, 0x13, (info->fix.line_length & 0x00ff));
 		xgifb_reg_set(XGISR,
@@ -1273,7 +1273,7 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		break;
 	}
 
-	xgifb_reg_set(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
+	xgifb_reg_set(XGISR, IND_SIS_PASSWORD, SIS_PASSWORD);
 
 	xgifb_reg_set(XGICR, 0x0D, base & 0xFF);
 	xgifb_reg_set(XGICR, 0x0C, (base >> 8) & 0xFF);
@@ -1282,7 +1282,7 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	xgifb_reg_and_or(XGISR, 0x37, 0xDF, (base >> 21) & 0x04);
 
 	if (xgifb_info->display2 != XGIFB_DISP_NONE) {
-		xgifb_reg_or(XGIPART1, IND_XGI_CRT2_WRITE_ENABLE_315, 0x01);
+		xgifb_reg_or(XGIPART1, SIS_CRT2_WENABLE_315, 0x01);
 		xgifb_reg_set(XGIPART1, 0x06, (base & 0xFF));
 		xgifb_reg_set(XGIPART1, 0x05, ((base >> 8) & 0xFF));
 		xgifb_reg_set(XGIPART1, 0x04, ((base >> 16) & 0xFF));
@@ -1387,7 +1387,7 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	fix->line_length = xgifb_info->video_linelength;
 	fix->mmio_start = xgifb_info->mmio_base;
 	fix->mmio_len = xgifb_info->mmio_size;
-	fix->accel = FB_ACCEL_XGI_XABRE;
+	fix->accel = FB_ACCEL_SIS_XABRE;
 
 	DEBUGPRN("end of get_fix");
 	return 0;
@@ -1634,9 +1634,9 @@ static int XGIfb_get_dram_size(struct xgifb_video_info *xgifb_info)
 
 	/* xorg driver sets 32MB * 1 channel */
 	if (xgifb_info->chip == XG27)
-		xgifb_reg_set(XGISR, IND_XGI_DRAM_SIZE, 0x51);
+		xgifb_reg_set(XGISR, IND_SIS_DRAM_SIZE, 0x51);
 
-	reg = xgifb_reg_get(XGISR, IND_XGI_DRAM_SIZE);
+	reg = xgifb_reg_get(XGISR, IND_SIS_DRAM_SIZE);
 	switch ((reg & XGI_DRAM_SIZE_MASK) >> 4) {
 	case XGI_DRAM_SIZE_1MB:
 		xgifb_info->video_size = 0x100000;
@@ -1736,7 +1736,7 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 
 	cr32 = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR32);
 
-	if ((cr32 & XGI_CRT1) && !XGIfb_crt1off)
+	if ((cr32 & SIS_CRT1) && !XGIfb_crt1off)
 		XGIfb_crt1off = 0;
 	else {
 		if (cr32 & 0x5F)
@@ -1746,11 +1746,11 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 	}
 
 	if (!xgifb_info->display2_force) {
-		if (cr32 & XGI_VB_TV)
+		if (cr32 & SIS_VB_TV)
 			xgifb_info->display2 = XGIFB_DISP_TV;
-		else if (cr32 & XGI_VB_LCD)
+		else if (cr32 & SIS_VB_LCD)
 			xgifb_info->display2 = XGIFB_DISP_LCD;
-		else if (cr32 & XGI_VB_CRT2)
+		else if (cr32 & SIS_VB_CRT2)
 			xgifb_info->display2 = XGIFB_DISP_CRT;
 		else
 			xgifb_info->display2 = XGIFB_DISP_NONE;
@@ -1759,14 +1759,14 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 	if (XGIfb_tvplug != -1)
 		/* PR/TW: Override with option */
 		xgifb_info->TV_plug = XGIfb_tvplug;
-	else if (cr32 & XGI_VB_HIVISION) {
+	else if (cr32 & SIS_VB_HIVISION) {
 		xgifb_info->TV_type = TVMODE_HIVISION;
 		xgifb_info->TV_plug = TVPLUG_SVIDEO;
-	} else if (cr32 & XGI_VB_SVIDEO)
+	} else if (cr32 & SIS_VB_SVIDEO)
 		xgifb_info->TV_plug = TVPLUG_SVIDEO;
-	else if (cr32 & XGI_VB_COMPOSITE)
+	else if (cr32 & SIS_VB_COMPOSITE)
 		xgifb_info->TV_plug = TVPLUG_COMPOSITE;
-	else if (cr32 & XGI_VB_SCART)
+	else if (cr32 & SIS_VB_SCART)
 		xgifb_info->TV_plug = TVPLUG_SCART;
 
 	if (xgifb_info->TV_type == 0) {
@@ -1811,11 +1811,11 @@ static void XGIfb_get_VB_type(struct xgifb_video_info *xgifb_info)
 
 	if (!XGIfb_has_VB(xgifb_info)) {
 		reg = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR37);
-		switch ((reg & XGI_EXTERNAL_CHIP_MASK) >> 1) {
-		case XGI310_EXTERNAL_CHIP_LVDS:
+		switch ((reg & SIS_EXTERNAL_CHIP_MASK) >> 1) {
+		case SIS_EXTERNAL_CHIP_LVDS:
 			xgifb_info->hasVB = HASVB_LVDS;
 			break;
-		case XGI310_EXTERNAL_CHIP_LVDS_CHRONTEL:
+		case SIS_EXTERNAL_CHIP_LVDS_CHRONTEL:
 			xgifb_info->hasVB = HASVB_LVDS_CHRONTEL;
 			break;
 		default:
@@ -1933,8 +1933,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	XGIRegInit(&xgifb_info->dev_info, (unsigned long)hw_info->pjIOAddress);
 
-	xgifb_reg_set(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
-	reg1 = xgifb_reg_get(XGISR, IND_XGI_PASSWORD);
+	xgifb_reg_set(XGISR, IND_SIS_PASSWORD, SIS_PASSWORD);
+	reg1 = xgifb_reg_get(XGISR, IND_SIS_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
 		printk("\nXGIfb: I/O error!!!");
@@ -1943,7 +1943,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	}
 
 	switch (xgifb_info->chip_id) {
-	case PCI_DEVICE_ID_XG_20:
+	case PCI_DEVICE_ID_XGI_20:
 		xgifb_reg_or(XGICR, Index_CR_GPIO_Reg3, GPIOG_EN);
 		CR48 = xgifb_reg_get(XGICR, Index_CR_GPIO_Reg1);
 		if (CR48&GPIOG_READ)
@@ -1951,16 +1951,16 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		else
 			xgifb_info->chip = XG20;
 		break;
-	case PCI_DEVICE_ID_XG_40:
+	case PCI_DEVICE_ID_XGI_40:
 		xgifb_info->chip = XG40;
 		break;
-	case PCI_DEVICE_ID_XG_41:
+	case PCI_DEVICE_ID_XGI_41:
 		xgifb_info->chip = XG41;
 		break;
-	case PCI_DEVICE_ID_XG_42:
+	case PCI_DEVICE_ID_XGI_42:
 		xgifb_info->chip = XG42;
 		break;
-	case PCI_DEVICE_ID_XG_27:
+	case PCI_DEVICE_ID_XGI_27:
 		xgifb_info->chip = XG27;
 		break;
 	default:
@@ -1979,10 +1979,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
 	xgifb_reg_or(XGISR,
-		     IND_XGI_PCI_ADDRESS_SET,
-		     (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
+		     IND_SIS_PCI_ADDRESS_SET,
+		     (SIS_PCI_ADDR_ENABLE | SIS_MEM_MAP_IO_ENABLE));
 	/* Enable 2D accelerator engine */
-	xgifb_reg_or(XGISR, IND_XGI_MODULE_ENABLE, XGI_ENABLE_2D);
+	xgifb_reg_or(XGISR, IND_SIS_MODULE_ENABLE, SIS_ENABLE_2D);
 
 	hw_info->ulVideoMemorySize = xgifb_info->video_size;
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 67a316c..fad144c 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -61,20 +61,20 @@ static const unsigned short XGINew_VGA_DAC[] = {
 void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 {
 	pVBInfo->SModeIDTable = (struct XGI_StStruct *) XGI330_SModeIDTable;
-	pVBInfo->StandTable = (struct XGI_StandTableStruct *) XGI330_StandTable;
+	pVBInfo->StandTable = (struct SiS_StandTable_S *) XGI330_StandTable;
 	pVBInfo->EModeIDTable = (struct XGI_ExtStruct *) XGI330_EModeIDTable;
 	pVBInfo->RefIndex = (struct XGI_Ext2Struct *) XGI330_RefIndex;
 	pVBInfo->XGINEWUB_CRT1Table
 			= (struct XGI_CRT1TableStruct *) XGI_CRT1Table;
 
-	pVBInfo->MCLKData = (struct XGI_MCLKDataStruct *) XGI340New_MCLKData;
+	pVBInfo->MCLKData = (struct SiS_MCLKData *) XGI340New_MCLKData;
 	pVBInfo->ECLKData = (struct XGI_ECLKDataStruct *) XGI340_ECLKData;
-	pVBInfo->VCLKData = (struct XGI_VCLKDataStruct *) XGI_VCLKData;
-	pVBInfo->VBVCLKData = (struct XGI_VBVCLKDataStruct *) XGI_VBVCLKData;
+	pVBInfo->VCLKData = (struct SiS_VCLKData *) XGI_VCLKData;
+	pVBInfo->VBVCLKData = (struct SiS_VBVCLKData *) XGI_VBVCLKData;
 	pVBInfo->ScreenOffset = XGI330_ScreenOffset;
-	pVBInfo->StResInfo = (struct XGI_StResInfoStruct *) XGI330_StResInfo;
+	pVBInfo->StResInfo = (struct SiS_StResInfo_S *) XGI330_StResInfo;
 	pVBInfo->ModeResInfo
-			= (struct XGI_ModeResInfoStruct *) XGI330_ModeResInfo;
+			= (struct SiS_ModeResInfo_S *) XGI330_ModeResInfo;
 
 	pVBInfo->pOutputSelect = &XGI330_OutputSelect;
 	pVBInfo->pSoftSetting = &XGI330_SoftSetting;
@@ -153,7 +153,7 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 
 	if (ChipType == XG27) {
 		pVBInfo->MCLKData
-			= (struct XGI_MCLKDataStruct *) XGI27New_MCLKData;
+			= (struct SiS_MCLKData *) XGI27New_MCLKData;
 		pVBInfo->CR40 = XGI27_cr41;
 		pVBInfo->pXGINew_CR97 = &XG27_CR97;
 		pVBInfo->pSR36 = &XG27_SR36;
@@ -3918,8 +3918,8 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 {
 	unsigned short tempax = 0, tempbx, modeflag, resinfo;
 
-	struct XGI_LCDDataStruct *LCDPtr = NULL;
-	struct XGI_TVDataStruct *TVPtr = NULL;
+	struct SiS_LCDData *LCDPtr = NULL;
+	struct SiS_TVData *TVPtr = NULL;
 
 	if (ModeNo <= 0x13) {
 		/* si+St_ResInfo */
@@ -3943,7 +3943,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx = 4;
 
 	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-		LCDPtr = (struct XGI_LCDDataStruct *) XGI_GetLcdPtr(tempbx,
+		LCDPtr = (struct SiS_LCDData *) XGI_GetLcdPtr(tempbx,
 				ModeNo, ModeIdIndex, RefreshRateTableIndex,
 				pVBInfo);
 
@@ -4028,7 +4028,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->VBInfo & (SetCRT2ToTV)) {
 		tempbx = 4;
-		TVPtr = (struct XGI_TVDataStruct *) XGI_GetTVPtr(tempbx,
+		TVPtr = (struct SiS_TVData *) XGI_GetTVPtr(tempbx,
 				ModeNo, ModeIdIndex, RefreshRateTableIndex,
 				pVBInfo);
 
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index d70df04..76a17c2 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -351,7 +351,7 @@ struct vb_device_info {
 	unsigned char  *pCRT2Data_4_D;
 	unsigned char  *pCRT2Data_4_E;
 	unsigned char  *pCRT2Data_4_10;
-	struct XGI_MCLKDataStruct  *MCLKData;
+	struct SiS_MCLKData  *MCLKData;
 	struct XGI_ECLKDataStruct  *ECLKData;
 
 	unsigned char   *XGI_TVDelayList;
@@ -381,15 +381,15 @@ struct vb_device_info {
 	struct XGI_TimingVStruct  *TimingV;
 
 	struct XGI_StStruct          *SModeIDTable;
-	struct XGI_StandTableStruct  *StandTable;
+	struct SiS_StandTable_S  *StandTable;
 	struct XGI_ExtStruct         *EModeIDTable;
 	struct XGI_Ext2Struct        *RefIndex;
 	/* XGINew_CRT1TableStruct *CRT1Table; */
 	struct XGI_CRT1TableStruct    *XGINEWUB_CRT1Table;
-	struct XGI_VCLKDataStruct    *VCLKData;
-	struct XGI_VBVCLKDataStruct  *VBVCLKData;
-	struct XGI_StResInfoStruct   *StResInfo;
-	struct XGI_ModeResInfoStruct *ModeResInfo;
+	struct SiS_VCLKData    *VCLKData;
+	struct SiS_VBVCLKData  *VBVCLKData;
+	struct SiS_StResInfo_S   *StResInfo;
+	struct SiS_ModeResInfo_S *ModeResInfo;
 	struct XGI_XG21CRT1Struct	  *UpdateCRT1;
 
 	int ram_type;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index e7946f1..217fb87 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1,5 +1,5 @@
 /* yilin modify for xgi20 */
-static struct XGI_MCLKDataStruct XGI340New_MCLKData[] = {
+static struct SiS_MCLKData XGI340New_MCLKData[] = {
 	{0x16, 0x01, 0x01, 166},
 	{0x19, 0x02, 0x01, 124},
 	{0x7C, 0x08, 0x01, 200},
@@ -10,7 +10,7 @@ static struct XGI_MCLKDataStruct XGI340New_MCLKData[] = {
 	{0x5c, 0x23, 0x01, 166}
 };
 
-static struct XGI_MCLKDataStruct XGI27New_MCLKData[] = {
+static struct SiS_MCLKData XGI27New_MCLKData[] = {
 	{0x5c, 0x23, 0x01, 166},
 	{0x19, 0x02, 0x01, 124},
 	{0x7C, 0x08, 0x80, 200},
@@ -296,7 +296,7 @@ static struct XGI_ExtStruct XGI330_EModeIDTable[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-static struct XGI_StandTableStruct XGI330_StandTable[] = {
+static struct SiS_StandTable_S XGI330_StandTable[] = {
 /* MD_0_200 */
 	{
 		0x28, 0x18, 0x08, 0x0800,
@@ -2729,7 +2729,7 @@ static unsigned char XGI330_ScreenOffset[] = {
 	0x57, 0x48
 };
 
-static struct XGI_StResInfoStruct XGI330_StResInfo[] = {
+static struct SiS_StResInfo_S XGI330_StResInfo[] = {
 	{640, 400},
 	{640, 350},
 	{720, 400},
@@ -2737,7 +2737,7 @@ static struct XGI_StResInfoStruct XGI330_StResInfo[] = {
 	{640, 480}
 };
 
-static struct XGI_ModeResInfoStruct XGI330_ModeResInfo[] = {
+static struct SiS_ModeResInfo_S XGI330_ModeResInfo[] = {
 	{ 320,  200, 8,  8},
 	{ 320,  240, 8,  8},
 	{ 320,  400, 8,  8},
-- 
1.7.3.4

