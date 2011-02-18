Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1BRDIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:08:13 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51848 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab1BRDID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:03 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/29] sh_mobile_sdhi: mfd_cell is now implicitly available to drivers
Date: Thu, 17 Feb 2011 19:07:18 -0800
Message-Id: <1297998456-7615-12-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to explicitly set the cell's platform_data/data_size.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/sh_mobile_sdhi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/sh_mobile_sdhi.c b/drivers/mfd/sh_mobile_sdhi.c
index 0a7df44..b511e74 100644
--- a/drivers/mfd/sh_mobile_sdhi.c
+++ b/drivers/mfd/sh_mobile_sdhi.c
@@ -147,8 +147,6 @@ static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
 
 	memcpy(&priv->cell_mmc, &sh_mobile_sdhi_cell, sizeof(priv->cell_mmc));
 	priv->cell_mmc.driver_data = mmc_data;
-	priv->cell_mmc.platform_data = &priv->cell_mmc;
-	priv->cell_mmc.data_size = sizeof(priv->cell_mmc);
 
 	platform_set_drvdata(pdev, priv);
 
-- 
1.7.2.3

