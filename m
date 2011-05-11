Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1EKSlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:41:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54540 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1EKSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=EhzcEJTy0Bse75YN1LowjdlhWT1VOgw2ewZD3u9dlW7dDcZ3hU3QzwifA0hknYu1gw
         tjWZ/41YYhxNCQ7qgvRTzmfxcf/QXY0lTUwH2Pt2cId32PPlu7wTl0WG97FJsqyT7NBg
         nYThRZQndjWU/8aRxQDU1g/I/+gdcWRw05zJE=
Subject: [patch]: Coding style changes for Staging sm7xx
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-K77a9MDhsXjqzzpozMuM"
Date: Thu, 12 May 2011 00:11:34 +0530
Message-ID: <1305139294.2030.51.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K77a9MDhsXjqzzpozMuM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Greg,

This patch is for staging sm7xx 
(Silicon Motion SM7XX frame buffer device).
Patch contains some coding style changes.

I have compiled and built it against linus tree.

Please find the patch as attachment and checked with checkpatch.

ps:this is my first patch for linux kernel.
Regards,
anish

--=-K77a9MDhsXjqzzpozMuM
Content-Disposition: attachment; filename="0001-Coding-style-changes-to-align-with-linux.patch"
Content-Type: text/x-patch; name="0001-Coding-style-changes-to-align-with-linux.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 1c66ca66cf230dfa610fc1a899c45f4ac3cb6070 Mon Sep 17 00:00:00 2001
From: anish kumar <anish198519851985@gmail.com>
Date: Wed, 11 May 2011 23:12:53 +0530
Subject: [PATCH 1/2] Coding style changes to align with linux

Signed-off-by: anish<anish198519851985@gmail.com>
---
 drivers/staging/sm7xx/smtcfb.c |   43 +++++++++++++++++++--------------------
 drivers/staging/sm7xx/smtcfb.h |    7 +-----
 2 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 3e2230f..d220f1f 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -39,10 +39,10 @@
 #include <linux/pm.h>
 #endif
 
-struct screen_info smtc_screen_info;
-
 #include "smtcfb.h"
 
+struct screen_info smtc_screen_info;
+
 #ifdef DEBUG
 #define smdbg(format, arg...)	printk(KERN_DEBUG format , ## arg)
 #else
@@ -99,17 +99,17 @@ struct vesa_mode_table	{
 static struct vesa_mode_table vesa_mode[] = {
 	{"0x301", 640,  480,  8},
 	{"0x303", 800,  600,  8},
-	{"0x305", 1024, 768,	8},
+	{"0x305", 1024, 768,  8},
 	{"0x307", 1280, 1024, 8},
 
 	{"0x311", 640,  480,  16},
 	{"0x314", 800,  600,  16},
-	{"0x317", 1024, 768,	16},
+	{"0x317", 1024, 768,  16},
 	{"0x31A", 1280, 1024, 16},
 
 	{"0x312", 640,  480,  24},
 	{"0x315", 800,  600,  24},
-	{"0x318", 1024, 768,	24},
+	{"0x318", 1024, 768,  24},
 	{"0x31B", 1280, 1024, 24},
 };
 
@@ -125,7 +125,7 @@ u16 smtc_ChipIDs[] = {
 	0x720
 };
 
-#define numSMTCchipIDs (sizeof(smtc_ChipIDs) / sizeof(u16))
+#define numSMTCchipIDs ARRAY_SIZE(smtc_ChipIDs)
 
 static void sm712_set_timing(struct smtcfb_info *sfb,
 			     struct par_info *ppar_info)
@@ -684,7 +684,7 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 {
 	struct smtcfb_info *sfb;
 
-	sfb = kzalloc(sizeof(struct smtcfb_info), GFP_KERNEL);
+	sfb = kzalloc(sizeof(*sfb), GFP_KERNEL);
 
 	if (!sfb)
 		return NULL;
@@ -812,7 +812,7 @@ static int __init __maybe_unused sm712vga_setup(char *options)
 	smdbg("\nsm712vga_setup = %s\n", options);
 
 	for (index = 0;
-	     index < (sizeof(vesa_mode) / sizeof(struct vesa_mode_table));
+	     index < ARRAY_SIZE(vesa_mode);
 	     index++) {
 		if (strstr(options, vesa_mode[index].mode_index)) {
 			smtc_screen_info.lfb_width = vesa_mode[index].lfb_width;
@@ -840,13 +840,12 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	int err;
 	unsigned long pFramebufferPhysical;
 
-	printk(KERN_INFO
+	dev_info(&pdev->dev,
 		"Silicon Motion display driver " SMTC_LINUX_FB_VERSION "\n");
 
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
 	if (err)
-		return err;
-	err = -ENOMEM;
+		goto out;
 
 	hw.chipID = ent->device;
 	sprintf(name, "sm%Xfb", hw.chipID);
@@ -903,13 +902,13 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		if (sfb->fb.var.bits_per_pixel == 32) {
 			smtc_VRAMBaseAddress += 0x800000;
 			hw.m_pLFB += 0x800000;
-			printk(KERN_INFO
+			dev_info(&pdev->dev,
 				"\nsmtc_VRAMBaseAddress=%p hw.m_pLFB=%p\n",
 					smtc_VRAMBaseAddress, hw.m_pLFB);
 		}
 #endif
 		if (!smtc_RegBaseAddress) {
-			printk(KERN_INFO
+			dev_info(&pdev->dev,
 				"%s: unable to map memory mapped IO\n",
 				sfb->fb.fix.id);
 			err = -ENOMEM;
@@ -944,7 +943,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		smtc_seqw(0x6b, 0x02);
 		break;
 	default:
-		printk(KERN_INFO
+		dev_info(&pdev->dev,
 		"No valid Silicon Motion display chip was detected!\n");
 
 		goto failed_fb;
@@ -969,15 +968,14 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (err < 0)
 		goto failed;
 
-	printk(KERN_INFO "Silicon Motion SM%X Rev%X primary display mode"
-			"%dx%d-%d Init Complete.\n", hw.chipID, hw.chipRevID,
-			sfb->fb.var.xres, sfb->fb.var.yres,
-			sfb->fb.var.bits_per_pixel);
+	dev_info(&pdev->dev, "Silicon Motion SM%X Rev%X primary display mode"
+	"%dx%d-%d Init Complete.\n", hw.chipID, hw.chipRevID,
+	sfb->fb.var.xres, sfb->fb.var.yres, sfb->fb.var.bits_per_pixel);
 
 	return 0;
 
- failed:
-	printk(KERN_INFO "Silicon Motion, Inc.  primary display init fail\n");
+failed:
+	dev_info(&pdev->dev, "Silicon Motion,Inc. primary display init fail\n");
 
 	smtc_unmap_smem(sfb);
 	smtc_unmap_mmio(sfb);
@@ -986,7 +984,8 @@ failed_fb:
 
 failed_free:
 	pci_disable_device(pdev);
-
+out:
+	dev_err(&pdev->dev, "pci_enable_device failed\n");
 	return err;
 }
 
@@ -1139,6 +1138,6 @@ static void __exit smtcfb_exit(void)
 module_init(smtcfb_init);
 module_exit(smtcfb_exit);
 
-MODULE_AUTHOR("Siliconmotion ");
+MODULE_AUTHOR("Siliconmotion");
 MODULE_DESCRIPTION("Framebuffer driver for SMI Graphic Cards");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/sm7xx/smtcfb.h b/drivers/staging/sm7xx/smtcfb.h
index 0c11383..c5e6989 100644
--- a/drivers/staging/sm7xx/smtcfb.h
+++ b/drivers/staging/sm7xx/smtcfb.h
@@ -30,11 +30,6 @@
 #define SCREEN_Y_RES      600
 #define SCREEN_BPP        16
 
-#ifndef FIELD_OFFSET
-#define FIELD_OFSFET(type, field) \
-	((unsigned long) (PUCHAR) & (((type *)0)->field))
-#endif
-
 /*Assume SM712 graphics chip has 4MB VRAM */
 #define SM712_VIDEOMEMORYSIZE	  0x00400000
 /*Assume SM722 graphics chip has 8MB VRAM */
@@ -790,4 +785,4 @@ struct ModeInit VGAMode[] = {
 	 },
 };
 
-#define numVGAModes		(sizeof(VGAMode) / sizeof(struct ModeInit))
+#define numVGAModes		ARRAY_SIZE(VGAMode)
-- 
1.7.0.4


--=-K77a9MDhsXjqzzpozMuM--

