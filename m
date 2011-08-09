Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1HIOff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:35:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36554 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752983Ab1HIOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:35:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Remove unused type and list fields from bus interface
Date: Tue,  9 Aug 2011 10:42:04 +0900
Message-Id: <1312854124-9223-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer enumerate the bus types, we rely on the driver telling us
this on init.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-i2c.c |    1 -
 drivers/base/regmap/regmap-spi.c |    1 -
 include/linux/regmap.h           |    4 ----
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index c2231ff..e6ce82d 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -90,7 +90,6 @@ static int regmap_i2c_read(struct device *dev,
 }
 
 static struct regmap_bus regmap_i2c = {
-	.type = &i2c_bus_type,
 	.write = regmap_i2c_write,
 	.gather_write = regmap_i2c_gather_write,
 	.read = regmap_i2c_read,
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 4deba06..07633bd 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -47,7 +47,6 @@ static int regmap_spi_read(struct device *dev,
 }
 
 static struct regmap_bus regmap_spi = {
-	.type = &spi_bus_type,
 	.write = regmap_spi_write,
 	.gather_write = regmap_spi_gather_write,
 	.read = regmap_spi_read,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4de137b..20a8fbf 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -60,8 +60,6 @@ typedef int (*regmap_hw_read)(struct device *dev,
 /**
  * Description of a hardware bus for the register map infrastructure.
  *
- * @list: Internal use.
- * @type: Bus type, used to identify bus to be used for a device.
  * @write: Write operation.
  * @gather_write: Write operation with split register/value, return -ENOTSUPP
  *                if not implemented  on a given device.
@@ -73,8 +71,6 @@ typedef int (*regmap_hw_read)(struct device *dev,
  *                  a read.
  */
 struct regmap_bus {
-	struct list_head list;
-	struct bus_type *type;
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
 	regmap_hw_read read;
-- 
1.7.5.4

