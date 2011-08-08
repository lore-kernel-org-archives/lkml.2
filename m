Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1HHLEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:04:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51672 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1HHLEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:04:51 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] sound: don't use the deprecated function check_region
Date: Mon,  8 Aug 2011 19:10:26 +0800
Message-Id: <1312801826-7521-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  sound/oss/pss.c: In function 'configure_nonsound_components':
  sound/oss/pss.c:676: warning: 'check_region' is deprecated (declared at include/linux/ioport.h:201)

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 sound/oss/pss.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 9b800ce..2fc0624 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -673,7 +673,8 @@ static void configure_nonsound_components(void)
 
 	if (pss_cdrom_port == -1) {	/* If cdrom port enablation wasn't requested */
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
-	} else if (check_region(pss_cdrom_port, 2)) {
+	} else if (!request_region(pss_cdrom_port, 2, "PSS CDROM")) {
+		pss_cdrom_port = -1;
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	} else {
 		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
@@ -1232,7 +1233,8 @@ static void __exit cleanup_pss(void)
 		if(pssmpu)
 			unload_pss_mpu(&cfg_mpu);
 		unload_pss(&cfg);
-	}
+	} else if (pss_cdrom_port != -1)
+		release_region(pss_cdrom_port, 2);
 
 	if(!pss_keep_settings)	/* Keep hardware settings if asked */
 	{
-- 
1.7.4.1

