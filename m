Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1FAWQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:16:37 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:46334 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab1FAWQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:16:35 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1306966564!6739105!29
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dma: at_hdmac.c: use resource_size
Date: Wed, 1 Jun 2011 15:16:09 -0700
User-Agent: KMail/1.9.9
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106011516.09302.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>

---

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 36144f8..6a483ea 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1216,7 +1216,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	atdma->dma_common.cap_mask = pdata->cap_mask;
 	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
 
-	size = io->end - io->start + 1;
+	size = resource_size(io);
 	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
 		err = -EBUSY;
 		goto err_kfree;
@@ -1362,7 +1362,7 @@ static int __exit at_dma_remove(struct platform_device *pdev)
 	atdma->regs = NULL;
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(io->start, io->end - io->start + 1);
+	release_mem_region(io->start, resource_size(io));
 
 	kfree(atdma);
 
