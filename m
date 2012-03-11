Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2CKThU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 15:37:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50195 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2CKTgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 15:36:35 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] drivers/video/pvr2fb.c: ensure arguments to request_irq and free_irq are compatible
Date: Sun, 11 Mar 2012 20:36:21 +0100
Message-Id: <1331494587-12196-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert calls to free_irq so that the second argument is the same as the
last argument of the corresponding call to request_irq.  Without this
property, free_irq does nothing.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/video/pvr2fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index 3a3fdc6..bcd44c3 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -895,7 +895,7 @@ static int __init pvr2fb_dc_init(void)
 
 #ifdef CONFIG_PVR2_DMA
 	if (request_dma(pvr2dma, "pvr2") != 0) {
-		free_irq(HW_EVENT_VSYNC, 0);
+		free_irq(HW_EVENT_VSYNC, fb_info);
 		return -EBUSY;
 	}
 #endif
@@ -914,7 +914,7 @@ static void __exit pvr2fb_dc_exit(void)
 		currentpar->mmio_base = 0;
 	}
 
-	free_irq(HW_EVENT_VSYNC, 0);
+	free_irq(HW_EVENT_VSYNC, fb_info);
 #ifdef CONFIG_PVR2_DMA
 	free_dma(pvr2dma);
 #endif

