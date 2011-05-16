Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab1EPPt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:49:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49474 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab1EPPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vUpcn6yAchCyczw8UeD/LbV71d3WPU6hKUXJjX8gNr6X62T2iyRGXIBIv57AomDHep
         nx9RaJnlfv8IfpGsKqtbE5nTZnrv4aIfEwMXzC3BcixF3zkinY/RNxrPc/FKw3eu0aG9
         YkXYnP71maELApf4ZqL8EzFC4mdjZ6NK0XL4Q=
Subject: [PATCH 1/3] Cleanup:removing extra spaces,redundant code and using
 macros[staging sm7xx]
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn,
        anish198519851985@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:19:16 +0530
Message-ID: <1305560956.6690.20.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please ignore previous 3 patches as mentioned in my previous mail.

Thanks,
anish

This patch is to remove extra spaces,redundant code and using
 ARRAY_SIZE macros.
 Signed-off-by: anish kumar<anish198519851985@gmail.com>

---
 drivers/staging/sm7xx/smtcfb.c |    7 +++----
 drivers/staging/sm7xx/smtcfb.h |    7 +------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 94cb4e8..1aca0cb 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -128,7 +128,7 @@ u16 smtc_ChipIDs[] = {
 	0x720
 };
 
-#define numSMTCchipIDs (sizeof(smtc_ChipIDs) / sizeof(u16))
+#define numSMTCchipIDs ARRAY_SIZE(smtc_ChipIDs)
 
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
@@ -842,7 +842,7 @@ static int __init sm712vga_setup(char *options)
 	smdbg("\nsm712vga_setup = %s\n", options);
 
 	for (index = 0;
-	     index < (sizeof(vesa_mode) / sizeof(struct vesa_mode_table));
+	     index < ARRAY_SIZE(vesa_mode);
 	     index++) {
 		if (strstr(options, vesa_mode[index].mode_index)) {
 			smtc_screen_info.lfb_width = vesa_mode[index].lfb_width;
@@ -876,7 +876,6 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
 	if (err)
 		return err;
-	err = -ENOMEM;
 
 	hw.chipID = ent->device;
 	sprintf(name, "sm%Xfb", hw.chipID);
@@ -1006,7 +1005,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
- failed:
+failed:
 	printk(KERN_INFO "Silicon Motion, Inc.  primary display init fail\n");
 
 	smtc_unmap_smem(sfb);
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






