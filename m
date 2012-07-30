Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2G3NqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:46:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15425 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab2G3NqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:46:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 30 Jul 2012 06:40:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>
CC: <swarren@nvidia.com>, <broonie@opensource.wolfsonmicro.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: Fix ifdefs for suspend mode
Date: Mon, 30 Jul 2012 19:03:07 +0530
Message-ID: <1343655187-18282-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PM covers runtime only PM.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch will remove the compilation warning if CONFIG_PM_SLEEP
is not enabled.

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

