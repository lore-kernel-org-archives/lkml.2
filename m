Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab2CTKa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:30:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52318 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab2CTKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:30:09 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 1/3] spi: omap2-mcspi: make it behave as a module
Date: Tue, 20 Mar 2012 15:59:47 +0530
Message-ID: <1332239389-1897-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
References: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

move probe away from __init section and use
platform_driver_register() instead of
platform_driver_probe().

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 0b0dfb7..5f4419e 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1080,7 +1080,7 @@ static int omap_mcspi_runtime_resume(struct device *dev)
 }
 
 
-static int __init omap2_mcspi_probe(struct platform_device *pdev)
+static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct omap2_mcspi_platform_config *pdata = pdev->dev.platform_data;
@@ -1212,7 +1212,7 @@ free_master:
 	return status;
 }
 
-static int __exit omap2_mcspi_remove(struct platform_device *pdev)
+static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct omap2_mcspi	*mcspi;
@@ -1287,13 +1287,14 @@ static struct platform_driver omap2_mcspi_driver = {
 		.owner =	THIS_MODULE,
 		.pm =		&omap2_mcspi_pm_ops
 	},
-	.remove =	__exit_p(omap2_mcspi_remove),
+	.probe =	omap2_mcspi_probe,
+	.remove =	__devexit_p(omap2_mcspi_remove),
 };
 
 
 static int __init omap2_mcspi_init(void)
 {
-	return platform_driver_probe(&omap2_mcspi_driver, omap2_mcspi_probe);
+	return platform_driver_register(&omap2_mcspi_driver);
 }
 subsys_initcall(omap2_mcspi_init);
 
-- 
1.7.1

