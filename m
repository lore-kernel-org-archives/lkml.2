Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1HFPb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:31:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39458 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HFPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:31:57 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] Don't use the deprecated function check_region
Date: Sat,  6 Aug 2011 23:29:17 +0800
Message-Id: <1312644557-16772-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  sound/oss/pss.c: In function 'configure_nonsound_components':
  sound/oss/pss.c:676: warning: 'check_region' is deprecated (declared at include/linux/ioport.h:201)

---
 sound/oss/pss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 9b800ce..b8ff41a 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -673,7 +673,7 @@ static void configure_nonsound_components(void)
 
 	if (pss_cdrom_port == -1) {	/* If cdrom port enablation wasn't requested */
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
-	} else if (check_region(pss_cdrom_port, 2)) {
+	} else if (check_mem_region(pss_cdrom_port, 2)) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	} else {
 		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
-- 
1.7.0.4

