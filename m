Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935020Ab2KAQkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:40:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5331 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab2KAQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:40:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 01 Nov 2012 09:40:11 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>, <khali@linux-fr.org>
CC: <ben-linux@fluff.org>, <swarren@nvidia.com>, <olof@lixom.net>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH REPOST] i2c: tegra: set irq name as device name
Date: Thu, 1 Nov 2012 22:08:14 +0530
Message-ID: <1351787894-23477-1-git-send-email-ldewangan@nvidia.com>
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
Acked-by: Jean Delvare <khali@linux-fr.org>
---
Reposting patch in case of it missed.

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

