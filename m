Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab2C3KWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:22:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38500 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790Ab2C3KUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:20:35 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 2/6] spi: omap2-mcspi: make it behave as a module
Date: Fri, 30 Mar 2012 15:50:18 +0530
Message-ID: <1333102822-17171-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
References: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
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
index 7785091..26dd79f 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1098,7 +1098,7 @@ static const struct of_device_id omap_mcspi_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, omap_mcspi_of_match);
 
-static int __init omap2_mcspi_probe(struct platform_device *pdev)
+static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct omap2_mcspi_platform_config *pdata;
@@ -1245,7 +1245,7 @@ free_master:
 	return status;
 }
 
-static int __exit omap2_mcspi_remove(struct platform_device *pdev)
+static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct omap2_mcspi	*mcspi;
@@ -1320,13 +1320,14 @@ static struct platform_driver omap2_mcspi_driver = {
 		.pm =		&omap2_mcspi_pm_ops,
 		.of_match_table = omap_mcspi_of_match,
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

