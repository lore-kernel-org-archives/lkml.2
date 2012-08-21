Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2HUGSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:18:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34000 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab2HUGR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:17:58 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 3/3] spi: omap2-mcspi: At remove dont use the runtime_autosuspend calls
Date: Tue, 21 Aug 2012 11:47:44 +0530
Message-ID: <1345529864-7937-4-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
References: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At remove we shouldnt be using the autosuspend timeout as we are
calling pm_runtime_disable immediately after.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 5642111..f5bf628 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1243,8 +1243,7 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 	mcspi = spi_master_get_devdata(master);
 	dma_channels = mcspi->dma_channels;
 
-	pm_runtime_mark_last_busy(mcspi->dev);
-	pm_runtime_put_autosuspend(mcspi->dev);
+	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_unregister_master(master);
-- 
1.7.5.4

