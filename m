Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1C3OeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:34:08 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:45203 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1C3OeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:34:07 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Mar 2011 10:34:06 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAO07k01bdWOb/2dsb2JhbACmSL1rhWoEjQY
X-IronPort-AV: E=Sophos;i="4.63,269,1299452400"; 
   d="scan'208";a="824663685"
From: =?utf-8?q?Javier=20Mu=C3=B1oz=20Mellid?= <jmunhoz@igalia.com>
To: gregkh@suse.de, gewang@siliconmotion.com, boyod.yang@siliconmotion.com.cn,
        wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH] staging: sm7xx: fixed defines
Date: Wed, 30 Mar 2011 16:24:10 +0200
Message-Id: <1301495050-7374-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier M. Mellid <jmunhoz@igalia.com>

Deleted redundant __KERNEL__ define

PM methods (suspend and resume) enabled under CONFIG_PM only

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index d007e4a..0d65971 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -26,10 +26,6 @@
  *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  */
 
-#ifndef __KERNEL__
-#define __KERNEL__
-#endif
-
 #include <linux/io.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
@@ -1019,6 +1015,7 @@ static void __devexit smtcfb_pci_remove(struct pci_dev *pdev)
 	smtc_free_fb_info(sfb);
 }
 
+#ifdef CONFIG_PM
 /* Jason (08/14/2009)
  * suspend function, called when the suspend event is triggered
  */
@@ -1111,6 +1108,7 @@ static int __maybe_unused smtcfb_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+#endif
 
 /* Jason (08/13/2009)
  * pci_driver struct used to wrap the original driver
-- 
1.7.4.1

