Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0IGK3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:29:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43077 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756419Ab0IGK3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:29:25 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassi.brar@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Cc: patches@opensource.wolfsonmicro.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi/spi_s3c64xx: Move to subsys_initcall()
Date: Tue,  7 Sep 2010 11:29:17 +0100
Message-Id: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the use of the S3C64xx SPI controller with things like PMICs by
moving the init up to subsys_initcall().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Incidentally I don't seem to see anything in the current SPI tree for
-next - should the tree being used be updated or something?

 drivers/spi/spi_s3c64xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index f72e1c0..6e48ea9 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -1181,7 +1181,7 @@ static int __init s3c64xx_spi_init(void)
 {
 	return platform_driver_probe(&s3c64xx_spi_driver, s3c64xx_spi_probe);
 }
-module_init(s3c64xx_spi_init);
+subsys_initcall(s3c64xx_spi_init);
 
 static void __exit s3c64xx_spi_exit(void)
 {
-- 
1.7.1

