Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2HRMiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:38:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12476 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2HRMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:38:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 18 Aug 2012 05:38:08 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] i2c: tegra: protect suspend/resume callbacks with CONFIG_PM_SLEEP
Date: Sat, 18 Aug 2012 17:49:58 +0530
Message-ID: <1345292398-10609-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_PM doesn't actually enable any of the PM callbacks, it
only allows to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
This means if CONFIG_PM is used to protect system sleep callbacks
then it may end up unreferenced if only runtime PM is enabled.
Hence protecting sleep callbacks with CONFIG_PM_SLEEP.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch will remove the compilation warning if CONFIG_PM_SLEEP
is not enabled.

Change from V1 ->V2:
provide more details in description as per Mark's response.

 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 66eb53f..9a08c57 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -712,7 +712,7 @@ static int __devexit tegra_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tegra_i2c_suspend(struct device *dev)
 {
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
-- 
1.7.1.1

