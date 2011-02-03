Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1BCEM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:12:28 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40968 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1BCEM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:12:27 -0500
Date: Wed, 2 Feb 2011 20:12:24 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/19] sh_mobile_sdhi: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110202201224.607e2006@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

