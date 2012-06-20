Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2FTM4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:56:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15185 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2FTM4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:56:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 05:53:29 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pgaikwad@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: use clk_disable_unprepare in place of clk_disable
Date: Wed, 20 Jun 2012 18:26:00 +0530
Message-ID: <1340196960-3002-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_disable_unprepare() inplace of clk_disable().
This was missed as part of moving clock enable/disable to
prepare/unprepare for using the common clock framework.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 00cdc10..d071cf0 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -696,7 +696,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add I2C adapter\n");
-		clk_disable(i2c_dev->i2c_clk);
+		clk_disable_unprepare(i2c_dev->i2c_clk);
 		return ret;
 	}
 
-- 
1.7.1.1

