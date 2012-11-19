Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2KSVmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:42:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57432 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2KSVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:42:05 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, mchehab@infradead.org, g.liakhovetski@gmx.de,
        kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] mx2_camera: use GFP_ATOMIC under spin lock.
Date: Mon, 19 Nov 2012 22:36:09 +0100
Message-Id: <1353360969-18515-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using the following semantic patch:

<spml>
@@
@@
spin_lock_irqsave(...);
... when != spin_unlock_irqrestore(...);
* GFP_KERNEL
</spml>

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index e575ae8..516b3a3 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -909,7 +909,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		pcdev->discard_size = icd->user_height * bytesperline;
 		pcdev->discard_buffer = dma_alloc_coherent(ici->v4l2_dev.dev,
 				pcdev->discard_size, &pcdev->discard_buffer_dma,
-				GFP_KERNEL);
+				GFP_ATOMIC);
 		if (!pcdev->discard_buffer)
 			return -ENOMEM;
 
-- 
1.7.10.4

