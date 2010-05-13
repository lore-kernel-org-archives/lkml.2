Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0EMDpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:45:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:39331 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0EMDpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:45:43 -0400
Date: Thu, 13 May 2010 12:45:31 +0900
To: greg@kroah.com, pete@sensoray.com, rcohen@snurgle.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: saa7134-go7007: replace dma_sync_single with
 dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100513124613U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 May 2010 12:45:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_sync_single() is deprecated and will be removed soon.

No functional change since dma_sync_single is the wrapper of
dma_sync_single_for_cpu.

saa7134-go7007.c is commented out but anyway let's replace it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/staging/go7007/saa7134-go7007.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/go7007/saa7134-go7007.c b/drivers/staging/go7007/saa7134-go7007.c
index b25d7d2..0d36ce7 100644
--- a/drivers/staging/go7007/saa7134-go7007.c
+++ b/drivers/staging/go7007/saa7134-go7007.c
@@ -242,13 +242,13 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
 		printk(KERN_DEBUG "saa7134-go7007: irq: lost %ld\n",
 				(status >> 16) & 0x0f);
 	if (status & 0x100000) {
-		dma_sync_single(&dev->pci->dev,
-				saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->pci->dev,
+					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
 		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
 	} else {
-		dma_sync_single(&dev->pci->dev,
-				saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->pci->dev,
+					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
 		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
 	}
-- 
1.6.5

