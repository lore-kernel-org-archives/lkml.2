Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1IERyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:54:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37054 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752122Ab1IERyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:54:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: Remove redundant owner field from the bus type struct
Date: Mon,  5 Sep 2011 10:54:09 -0700
Message-Id: <1315245250-24292-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer used as users link directly with the bus types so the core
module infrastructure does refcounting for us.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-i2c.c |    1 -
 drivers/base/regmap/regmap-spi.c |    1 -
 include/linux/regmap.h           |    3 ---
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index e7d916d..38621ec 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -93,7 +93,6 @@ static struct regmap_bus regmap_i2c = {
 	.write = regmap_i2c_write,
 	.gather_write = regmap_i2c_gather_write,
 	.read = regmap_i2c_read,
-	.owner = THIS_MODULE,
 };
 
 /**
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index fe831e3..2560658 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -51,7 +51,6 @@ static struct regmap_bus regmap_spi = {
 	.write = regmap_spi_write,
 	.gather_write = regmap_spi_gather_write,
 	.read = regmap_spi_read,
-	.owner = THIS_MODULE,
 	.read_flag_mask = 0x80,
 };
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 449e264..9438a89e 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -85,8 +85,6 @@ typedef int (*regmap_hw_read)(struct device *dev,
  *                if not implemented  on a given device.
  * @read: Read operation.  Data is returned in the buffer used to transmit
  *         data.
- * @owner: Module with the bus implementation, used to pin the implementation
- *         in memory.
  * @read_flag_mask: Mask to be set in the top byte of the register when doing
  *                  a read.
  */
@@ -94,7 +92,6 @@ struct regmap_bus {
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
 	regmap_hw_read read;
-	struct module *owner;
 	u8 read_flag_mask;
 };
 
-- 
1.7.5.4

