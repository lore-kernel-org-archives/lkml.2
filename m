Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1HHKhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:37:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51138 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1HHKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:37:48 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] sound: don't use the deprecated function check_region
Date: Mon,  8 Aug 2011 18:43:15 +0800
Message-Id: <1312800195-7374-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  sound/oss/pss.c: In function 'configure_nonsound_components':
  sound/oss/pss.c:676: warning: 'check_region' is deprecated (declared at include/linux/ioport.h:201)

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 sound/oss/pss.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 9b800ce..55bfea6 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -673,7 +673,7 @@ static void configure_nonsound_components(void)
 
 	if (pss_cdrom_port == -1) {	/* If cdrom port enablation wasn't requested */
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
-	} else if (check_region(pss_cdrom_port, 2)) {
+	} else if (!request_region(pss_cdrom_port, 2, "PSS CDROM")) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	} else {
 		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
@@ -1223,8 +1223,7 @@ static int __init init_pss(void)
 
 static void __exit cleanup_pss(void)
 {
-	if(!pss_no_sound)
-	{
+	if (!pss_no_sound) {
 		if(fw_load && pss_synth)
 			vfree(pss_synth);
 		if(pssmss)
@@ -1232,10 +1231,10 @@ static void __exit cleanup_pss(void)
 		if(pssmpu)
 			unload_pss_mpu(&cfg_mpu);
 		unload_pss(&cfg);
-	}
+	} else
+		release_region(pss_cdrom_port, 2);
 
-	if(!pss_keep_settings)	/* Keep hardware settings if asked */
-	{
+	if (!pss_keep_settings)	{ /* Keep hardware settings if asked */
 		disable_all_emulations();
 		printk(KERN_INFO "Resetting PSS sound card configurations.\n");
 	}
-- 
1.7.4.1

