Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1KSEjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:39:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62747 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab1KSEiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:38:52 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 25/25] Staging: comedi: fix printk issue in pcl818.c
Date: Sat, 19 Nov 2011 10:06:57 +0530
Message-Id: <1321677417-2415-25-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl818.c file that fixes up a printk
warning found by the checkpatch.pl tool.
Removed an unnecessary printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcl818.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index bad7ee4..7344a53 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1841,34 +1841,26 @@ no_rtc:
 		if (dma < 1)
 			goto no_dma;	/* DMA disabled */
 		if (((1 << dma) & this_board->DMAbits) == 0) {
-			printk(", DMA is out of allowed range, FAIL!\n");
+			printk(KERN_ERR "DMA is out of allowed range, FAIL!\n");
 			return -EINVAL;	/* Bad DMA */
 		}
 		ret = request_dma(dma, "pcl818");
-		if (ret) {
-			printk(", unable to allocate DMA %u, FAIL!\n", dma);
+		if (ret)
 			return -EBUSY;	/* DMA isn't free */
-		}
 		devpriv->dma = dma;
-		printk(", dma=%u", dma);
 		pages = 2;	/* we need 16KB */
 		devpriv->dmabuf[0] = __get_dma_pages(GFP_KERNEL, pages);
-		if (!devpriv->dmabuf[0]) {
-			printk(", unable to allocate DMA buffer, FAIL!\n");
+		if (!devpriv->dmabuf[0])
 			/* maybe experiment with try_to_free_pages() will help .... */
 			return -EBUSY;	/* no buffer :-( */
-		}
 		devpriv->dmapages[0] = pages;
 		devpriv->hwdmaptr[0] = virt_to_bus((void *)devpriv->dmabuf[0]);
 		devpriv->hwdmasize[0] = (1 << pages) * PAGE_SIZE;
 		/* printk("%d %d %ld, ",devpriv->dmapages[0],devpriv->hwdmasize[0],PAGE_SIZE); */
 		if (devpriv->dma_rtc == 0) {	/*  we must do duble buff :-( */
 			devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL, pages);
-			if (!devpriv->dmabuf[1]) {
-				printk
-				    (", unable to allocate DMA buffer, FAIL!\n");
+			if (!devpriv->dmabuf[1])
 				return -EBUSY;
-			}
 			devpriv->dmapages[1] = pages;
 			devpriv->hwdmaptr[1] =
 			    virt_to_bus((void *)devpriv->dmabuf[1]);
-- 
1.7.0.4

