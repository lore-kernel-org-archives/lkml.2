Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1K0TmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:42:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36432 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752358Ab1K0TmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:42:17 -0500
Message-ID: <1322422935.27199.3.camel@Joe-Laptop>
Subject: [trivial PATCH] omap24xxcam-dma: Fix logical test
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@nokia.com>
Date: Sun, 27 Nov 2011 11:42:15 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Likely misuse of & vs &&.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/omap24xxcam-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap24xxcam-dma.c b/drivers/media/video/omap24xxcam-dma.c
index 1d54b86..3ea38a8 100644
--- a/drivers/media/video/omap24xxcam-dma.c
+++ b/drivers/media/video/omap24xxcam-dma.c
@@ -506,7 +506,7 @@ int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
 	unsigned long flags;
 	struct sgdma_state *sg_state;
 
-	if ((sglen < 0) || ((sglen > 0) & !sglist))
+	if ((sglen < 0) || ((sglen > 0) && !sglist))
 		return -EINVAL;
 
 	spin_lock_irqsave(&sgdma->lock, flags);


