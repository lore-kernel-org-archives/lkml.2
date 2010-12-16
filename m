Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0LPROO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:14:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47851 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0LPROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:14:11 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 3/3] spi: mpc512x_psc_spi: move probe-routine to __init
Date: Thu, 16 Dec 2010 18:13:59 +0100
Message-Id: <1292519639-21859-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de>
References: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since of_probe_platform_driver(), this SoC-device can be moved from
__devinit to __init because it is not hotpluggable.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/mpc512x_psc_spi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/mpc512x_psc_spi.c b/drivers/spi/mpc512x_psc_spi.c
index 77d9e7e..c672144 100644
--- a/drivers/spi/mpc512x_psc_spi.c
+++ b/drivers/spi/mpc512x_psc_spi.c
@@ -507,7 +507,7 @@ static int __devexit mpc512x_psc_spi_do_remove(struct device *dev)
 	return 0;
 }
 
-static int __devinit mpc512x_psc_spi_of_probe(struct platform_device *op,
+static int __init mpc512x_psc_spi_of_probe(struct platform_device *op,
 					      const struct of_device_id *match)
 {
 	const u32 *regaddr_p;
@@ -539,7 +539,7 @@ static int __devinit mpc512x_psc_spi_of_probe(struct platform_device *op,
 				irq_of_parse_and_map(op->dev.of_node, 0), id);
 }
 
-static int __devexit mpc512x_psc_spi_of_remove(struct platform_device *op)
+static int __exit mpc512x_psc_spi_of_remove(struct platform_device *op)
 {
 	return mpc512x_psc_spi_do_remove(&op->dev);
 }
@@ -552,8 +552,7 @@ static struct of_device_id mpc512x_psc_spi_of_match[] = {
 MODULE_DEVICE_TABLE(of, mpc512x_psc_spi_of_match);
 
 static struct of_platform_driver mpc512x_psc_spi_of_driver = {
-	.probe = mpc512x_psc_spi_of_probe,
-	.remove = __devexit_p(mpc512x_psc_spi_of_remove),
+	.remove = __exit_p(mpc512x_psc_spi_of_remove),
 	.driver = {
 		.name = "mpc512x-psc-spi",
 		.owner = THIS_MODULE,
@@ -563,7 +562,8 @@ static struct of_platform_driver mpc512x_psc_spi_of_driver = {
 
 static int __init mpc512x_psc_spi_init(void)
 {
-	return of_register_platform_driver(&mpc512x_psc_spi_of_driver);
+	return of_probe_platform_driver(&mpc512x_psc_spi_of_driver,
+					mpc512x_psc_spi_of_probe);
 }
 module_init(mpc512x_psc_spi_init);
 
-- 
1.7.2.3

