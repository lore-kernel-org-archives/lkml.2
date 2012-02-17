Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2BQOwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:52:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2BQOwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:52:17 -0500
From: Bernhard Walle <walle@corscience.de>
To: dwmw2@infradead.org
Cc: Artem.Bityutskiy@linux.intel.com, vimal.newwork@gmail.com,
        tony@atomide.com, s-ghorai@ti.com, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: omap2: Release memory region in .remove function
Date: Fri, 17 Feb 2012 15:49:32 +0100
Message-Id: <1329490172-8043-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.9.1
X-Provags-ID: V02:K0:oFooETUqHshyLaXowCnuzGnNFCPXInd5n4kEmcjpxpQ
 9hzx6yG1GBeihtWHItZi3f5RBPMPG7p0aLmf/P7GnxuWqfBT+F
 Eq2/tADrvKFilwibE4ePwFpXBSkktXqSiioXupnQLB1psxMicm
 4Bu0gfOUZ937a4k6KbZ3bFT26D5KwmzBItKI1Snggk18Es9pYw
 zHsXqT/18kQHTQNSbJMxono0xtWT5GiBXSOhhr6u3icFeDqHRC
 w+mJxdCQhGANlocUH0mlXqCHVr4vEf6jToUlJ6S+ejghcM2QYQ
 9BIuhD6V8+Bf+PS7ZqmsG06a2SKM2uUtmvxVXf3LY7gy4rMlT/
 OtvsjTGws3vSZEH/yHIxh0QygbW8Y8VaRTKOZRpVpwamkVnm1v
 BmFZOcY6/QR8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the driver is compiled as module, it's not possible to unload and
reload the driver again:

    omap2-nand: probe of omap2-nand.0 failed with error -16

This patch fixes the problem because it releases the memory region, so
that it can be requested again.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/mtd/nand/omap2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index b3a883e..7dfcf68 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1132,6 +1132,7 @@ static int omap_nand_remove(struct platform_device *pdev)
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
 	iounmap(info->nand.IO_ADDR_R);
+	release_mem_region(info->phys_base, NAND_IO_SIZE);
 	kfree(&info->mtd);
 	return 0;
 }
-- 
1.7.9.1

