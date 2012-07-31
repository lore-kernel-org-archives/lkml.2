Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2GaQjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:39:32 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:21600 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab2GaQj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:39:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,688,1336341600"; 
   d="scan'208";a="168700821"
From: Damien Cassou <damien.cassou@lifl.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/video/fsl-diu-fb.c: use devm_ functions
Date: Tue, 31 Jul 2012 18:39:20 +0200
Message-Id: <1343752762-16861-4-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/fsl-diu-fb.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 458c006..19194c5 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1501,8 +1501,8 @@ static int __devinit fsl_diu_probe(struct platform_device *pdev)
 	unsigned int i;
 	int ret;

-	data = dma_alloc_coherent(&pdev->dev, sizeof(struct fsl_diu_data),
-				  &dma_addr, GFP_DMA | __GFP_ZERO);
+	data = dmam_alloc_coherent(&pdev->dev, sizeof(struct fsl_diu_data),
+				   &dma_addr, GFP_DMA | __GFP_ZERO);
 	if (!data)
 		return -ENOMEM;
 	data->dma_addr = dma_addr;
@@ -1628,9 +1628,6 @@ error:

 	iounmap(data->diu_reg);

-	dma_free_coherent(&pdev->dev, sizeof(struct fsl_diu_data), data,
-			  data->dma_addr);
-
 	return ret;
 }

@@ -1648,9 +1645,6 @@ static int fsl_diu_remove(struct platform_device *pdev)

 	iounmap(data->diu_reg);

-	dma_free_coherent(&pdev->dev, sizeof(struct fsl_diu_data), data,
-			  data->dma_addr);
-
 	return 0;
 }
