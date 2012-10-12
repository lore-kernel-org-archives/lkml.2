Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab2JLRuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:50:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18168 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab2JLRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:50:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Oct 2012 10:38:41 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>
CC: <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: set irq name as device name
Date: Fri, 12 Oct 2012 23:19:32 +0530
Message-ID: <1350064172-32417-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When watching the irqs name of tegra i2c, all instances
irq name shows as tegra_i2c.

Passing the device name properly to have the irq names with
instance like tegra-i2c.0, tegra-i2c.1 etc.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index f981ac4..dcea77b 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -742,7 +742,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	}
 
 	ret = devm_request_irq(&pdev->dev, i2c_dev->irq,
-			tegra_i2c_isr, 0, pdev->name, i2c_dev);
+			tegra_i2c_isr, 0, dev_name(&pdev->dev), i2c_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %i\n", i2c_dev->irq);
 		return ret;
-- 
1.7.1.1

