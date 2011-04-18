Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1DRTYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:24:40 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48114 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab1DRTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:24:08 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 04/12] staging: xgifb: replace orXGIIDXREG() with xgifb_reg_or()
Date: Mon, 18 Apr 2011 22:14:00 +0300
Message-Id: <1303154048-21989-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace orXGIIDXREG() with xgifb_reg_or().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index d45d5aa..2f2c275 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1188,7 +1188,7 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 	setXGIIDXREG(XGISR, 0x37, 0xDF, (base >> 21) & 0x04);
 
 	if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
-		orXGIIDXREG(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
+		xgifb_reg_or(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
 		xgifb_reg_set(XGIPART1, 0x06, (base & 0xFF));
 		xgifb_reg_set(XGIPART1, 0x05, ((base >> 8) & 0xFF));
 		xgifb_reg_set(XGIPART1, 0x04, ((base >> 16) & 0xFF));
@@ -1821,7 +1821,7 @@ void XGI_Sense30x(void)
 				testvga2_tempcl, testvga2_tempch);
 		if (result) {
 			printk(KERN_INFO "XGIfb: Detected secondary VGA connection\n");
-			orXGIIDXREG(XGICR, 0x32, 0x10);
+			xgifb_reg_or(XGICR, 0x32, 0x10);
 		}
 	}
 
@@ -1831,7 +1831,7 @@ void XGI_Sense30x(void)
 		printk(KERN_INFO "XGIfb: Detected TV connected to SVHS output\n");
 		/* TW: So we can be sure that there IS a SVHS output */
 		xgi_video_info.TV_plug = TVPLUG_SVIDEO;
-		orXGIIDXREG(XGICR, 0x32, 0x02);
+		xgifb_reg_or(XGICR, 0x32, 0x02);
 	}
 
 	if (!result) {
@@ -1841,7 +1841,7 @@ void XGI_Sense30x(void)
 			printk(KERN_INFO "XGIfb: Detected TV connected to CVBS output\n");
 			/* TW: So we can be sure that there IS a CVBS output */
 			xgi_video_info.TV_plug = TVPLUG_COMPOSITE;
-			orXGIIDXREG(XGICR, 0x32, 0x01);
+			xgifb_reg_or(XGICR, 0x32, 0x01);
 		}
 	}
 	XGIDoSense(0, 0, 0, 0);
@@ -1963,7 +1963,7 @@ static void XGIfb_post_setmode(void)
 				break;
 			}
 
-			orXGIIDXREG(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
+			xgifb_reg_or(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
 
 			if (xgi_video_info.TV_type == TVMODE_NTSC) {
 
@@ -1976,7 +1976,7 @@ static void XGIfb_post_setmode(void)
 				} else if (xgi_video_info.TV_plug
 						== TVPLUG_COMPOSITE) {
 
-					orXGIIDXREG(XGIPART2, 0x30, 0x20);
+					xgifb_reg_or(XGIPART2, 0x30, 0x20);
 
 					switch (xgi_video_info.video_width) {
 					case 640:
@@ -2011,7 +2011,7 @@ static void XGIfb_post_setmode(void)
 				} else if (xgi_video_info.TV_plug
 						== TVPLUG_COMPOSITE) {
 
-					orXGIIDXREG(XGIPART2, 0x30, 0x20);
+					xgifb_reg_or(XGIPART2, 0x30, 0x20);
 
 					switch (xgi_video_info.video_width) {
 					case 640:
@@ -2214,7 +2214,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	switch (xgi_video_info.chip_id) {
 	case PCI_DEVICE_ID_XG_20:
-		orXGIIDXREG(XGICR, Index_CR_GPIO_Reg3, GPIOG_EN);
+		xgifb_reg_or(XGICR, Index_CR_GPIO_Reg3, GPIOG_EN);
 		CR48 = xgifb_reg_get(XGICR, Index_CR_GPIO_Reg1);
 		if (CR48&GPIOG_READ)
 			xgi_video_info.chip = XG21;
@@ -2266,9 +2266,9 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
 		/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
-		orXGIIDXREG(XGISR, IND_XGI_PCI_ADDRESS_SET, (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
+		xgifb_reg_or(XGISR, IND_XGI_PCI_ADDRESS_SET, (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
 		/* Enable 2D accelerator engine */
-		orXGIIDXREG(XGISR, IND_XGI_MODULE_ENABLE, XGI_ENABLE_2D);
+		xgifb_reg_or(XGISR, IND_XGI_MODULE_ENABLE, XGI_ENABLE_2D);
 	}
 
 	XGIhw_ext.ulVideoMemorySize = xgi_video_info.video_size;
-- 
1.5.6.5

