Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2HVGGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:06:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55277 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab2HVGFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:05:39 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 3/3] spi: omap2-mcspi: At remove dont use the runtime_autosuspend calls
Date: Wed, 22 Aug 2012 11:35:14 +0530
Message-ID: <1345615515-26745-4-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
References: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At remove we shouldnt be using the autosuspend timeout as we are
calling pm_runtime_disable immediately after.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 8a5e2c0..1c1dd34 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1244,8 +1244,7 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 	mcspi = spi_master_get_devdata(master);
 	dma_channels = mcspi->dma_channels;
 
-	pm_runtime_mark_last_busy(mcspi->dev);
-	pm_runtime_put_autosuspend(mcspi->dev);
+	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_unregister_master(master);
-- 
1.7.5.4

