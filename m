Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab1EODZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 23:25:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41683 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854Ab1EODZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 23:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RREC8FVmpZ9hqB6+PCRlKuXRbAu7YK5DV/AiF/ElOxlQc1BPQRRIIHgr2SwUxedfp1
         /T8HEglRvczJDo+N90xWmQJ233mbxn3YSgvRssUILfeqyxMbVmtDJdj8agr2ZynC2MWR
         6OLbLefnxPPhIGTWBSAdtIuy8eYHGMdFz/OBQ=
Subject: [PATCH 1/3] Cleanup:removing extra spaces,redundant code and using
 macros[staging sm7xx]
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 May 2011 08:55:24 +0530
Message-ID: <1305429924.9023.1.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to remove extra spaces,redundant code and using
 ARRAY_SIZE macros.
 Signed-off-by: anish kumar<anish198519851985@gmail.com>

---
 drivers/staging/sm7xx/smtcfb.c |   13 ++++++-------
 drivers/staging/sm7xx/smtcfb.h |    7 +------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 3e2230f..c1b8228 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
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
@@ -812,7 +812,7 @@ static int __init __maybe_unused sm712vga_setup(char *options)
 	smdbg("\nsm712vga_setup = %s\n", options);
 
 	for (index = 0;
-	     index < (sizeof(vesa_mode) / sizeof(struct vesa_mode_table));
+	     index < ARRAY_SIZE(vesa_mode);
 	     index++) {
 		if (strstr(options, vesa_mode[index].mode_index)) {
 			smtc_screen_info.lfb_width = vesa_mode[index].lfb_width;
@@ -846,7 +846,6 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
 	if (err)
 		return err;
-	err = -ENOMEM;
 
 	hw.chipID = ent->device;
 	sprintf(name, "sm%Xfb", hw.chipID);
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





