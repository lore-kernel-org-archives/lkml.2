Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2FZEAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:00:34 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48179 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157Ab2FZEAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:00:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAM8y6U9bdWOb/2dsb2JhbABEtiyBB4IYAQEFJ1IQIDE8GwcSiA+5JJE3A5UukAGCYQ
X-IronPort-AV: E=Sophos;i="4.77,476,1336341600"; 
   d="scan'208";a="532687848"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 3/4] staging: sm7xxfb: delete unnecessary color map allocation
Date: Tue, 26 Jun 2012 06:00:16 +0200
Message-Id: <1340683217-7986-4-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
References: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patchs erases fb_alloc_cmap call in smtc_free_fb_info. In the
future, when needed, the required function to call here should be
fb_dealloc_cmap.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 4ab149b..40e8e0d 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -697,6 +697,14 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 }
 
 /*
+ * free struct smtcfb_info
+ */
+static void smtc_free_fb_info(struct smtcfb_info *sfb)
+{
+	kfree(sfb);
+}
+
+/*
  * Unmap in the memory mapped IO registers
  */
 
@@ -755,14 +763,6 @@ static inline void sm7xx_init_hw(void)
 	outb_p(0x11, 0x3c5);
 }
 
-static void smtc_free_fb_info(struct smtcfb_info *sfb)
-{
-	if (sfb) {
-		fb_alloc_cmap(&sfb->fb.cmap, 0, 0);
-		kfree(sfb);
-	}
-}
-
 /*
  *	sm712vga_setup - process command line options, get vga parameter
  *	@options: string of options
-- 
1.7.10

