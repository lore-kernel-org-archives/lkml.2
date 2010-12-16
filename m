Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0LPRON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:14:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0LPROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:14:11 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 2/3] spi: mpc52xx_psc_spi: fix section mismatch warning
Date: Thu, 16 Dec 2010 18:13:58 +0100
Message-Id: <1292519639-21859-3-git-send-email-w.sang@pengutronix.de>
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

Done by using of_probe_platform_driver() instead of
of_register_platform_driver().

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/mpc52xx_psc_spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index 983fbbf..4bf6d37 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -509,7 +509,6 @@ static const struct of_device_id mpc52xx_psc_spi_of_match[] = {
 MODULE_DEVICE_TABLE(of, mpc52xx_psc_spi_of_match);
 
 static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
-	.probe = mpc52xx_psc_spi_of_probe,
 	.remove = __exit_p(mpc52xx_psc_spi_of_remove),
 	.driver = {
 		.name = "mpc52xx-psc-spi",
@@ -520,7 +519,8 @@ static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
 
 static int __init mpc52xx_psc_spi_init(void)
 {
-	return of_register_platform_driver(&mpc52xx_psc_spi_of_driver);
+	return of_probe_platform_driver(&mpc52xx_psc_spi_of_driver,
+					mpc52xx_psc_spi_of_probe);
 }
 module_init(mpc52xx_psc_spi_init);
 
-- 
1.7.2.3

