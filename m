Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2GJL15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:27:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5421 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2GJL1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:27:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 10 Jul 2012 04:27:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>, <khali@linux-fr.org>, <ben-linux@fluff.org>
CC: <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/5] i2c: tegra: use clk_disable_unprepare in place of clk_disable
Date: Tue, 10 Jul 2012 16:50:41 +0530
Message-ID: <1341919244-23327-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
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
This is already discussed in patch
[PATCH] i2c: tegra: use clk_disable_unprepare in place of clk_disable
for applying in Wolfram Tree. Resending this as patch series.

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

