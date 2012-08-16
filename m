Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2HPPTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:19:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59371 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab2HPPTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:19:49 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Remove the call to platform_set_drvdata(pdev, NULL)
Date: Thu, 16 Aug 2012 20:49:30 +0530
Message-ID: <1345130370-18815-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the call of platform_set_drvdata(pdev, NULL) as they are not
needed anymore.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index bc47781..84aeaf0 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1240,7 +1240,6 @@ dma_chnl_free:
 	kfree(mcspi->dma_channels);
 free_master:
 	kfree(master);
-	platform_set_drvdata(pdev, NULL);
 	return status;
 }
 
@@ -1259,7 +1258,6 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 
 	spi_unregister_master(master);
 	kfree(dma_channels);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.5.4

