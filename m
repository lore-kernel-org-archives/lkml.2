Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1HHHu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:50:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48375 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960Ab1HHHu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:50:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Add precious registers to the driver interface
Date: Mon,  8 Aug 2011 15:44:31 +0900
Message-Id: <1312785872-19629-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices are sensitive to reads on their registers, especially for
things like clear on read interrupt status registers. Avoid creating
problems with these with things like debugfs by allowing drivers to tell
the core about them. If a register is marked as precious then the core
will not internally generate any reads of it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index aef2b36..c878a4b 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -33,6 +33,9 @@ struct spi_device;
  *                     can be read from.
  * @volatile_register: Optional callback returning true if the register
  *                     value can't be cached.
+ * @precious_register: Optional callback returning true if the rgister
+ *                     should not be read outside of a call from the driver
+ *                     (eg, a clear on read interrupt status register).
  */
 struct regmap_config {
 	int reg_bits;
@@ -42,6 +45,7 @@ struct regmap_config {
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
+	bool (*precious_reg)(struct device *dev, unsigned int reg);
 };
 
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
-- 
1.7.5.4

