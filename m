Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850Ab2JZSI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:08:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38757 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965832Ab2JZSI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:08:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Update maximum register
Date: Fri, 26 Oct 2012 19:08:23 +0100
Message-Id: <1351274903-26345-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DSP memories are mapped into the register map, make them readable and
writable by updating max_register appropriately.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index e1dc022..645c0d6 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1855,12 +1855,14 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	}
 }
 
+#define WM5102_MAX_REGISTER 0x1a8fff
+
 const struct regmap_config wm5102_spi_regmap = {
 	.reg_bits = 32,
 	.pad_bits = 16,
 	.val_bits = 16,
 
-	.max_register = ARIZONA_DSP1_STATUS_2,
+	.max_register = WM5102_MAX_REGISTER,
 	.readable_reg = wm5102_readable_register,
 	.volatile_reg = wm5102_volatile_register,
 
@@ -1874,7 +1876,7 @@ const struct regmap_config wm5102_i2c_regmap = {
 	.reg_bits = 32,
 	.val_bits = 16,
 
-	.max_register = ARIZONA_DSP1_STATUS_2,
+	.max_register = WM5102_MAX_REGISTER,
 	.readable_reg = wm5102_readable_register,
 	.volatile_reg = wm5102_volatile_register,
 
-- 
1.7.10.4

