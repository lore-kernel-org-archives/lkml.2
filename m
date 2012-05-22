Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2EVIYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:24:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61993 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2EVIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:24:37 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc/omap: fix dev_err typo
Date: Tue, 22 May 2012 11:24:22 +0300
Message-Id: <1337675062-22028-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason one of the dev_err invocations is using a wrong
device so fix that.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/omap_remoteproc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index 69425c4..de138e30 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -182,7 +182,7 @@ static int __devinit omap_rproc_probe(struct platform_device *pdev)
 
 	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
-		dev_err(pdev->dev.parent, "dma_set_coherent_mask: %d\n", ret);
+		dev_err(&pdev->dev, "dma_set_coherent_mask: %d\n", ret);
 		return ret;
 	}
 
-- 
1.7.5.4

