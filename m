Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2KTEdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:33:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58868 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab2KTEde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:33:34 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: wm5102: Update maximum register
Date: Tue, 20 Nov 2012 13:33:18 +0900
Message-Id: <1353385999-10275-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20121120043211.GE4483@opensource.wolfsonmicro.com>
References: <20121120043211.GE4483@opensource.wolfsonmicro.com>
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
index 01b9255..ffeba98 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -2369,12 +2369,14 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
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
 
@@ -2388,7 +2390,7 @@ const struct regmap_config wm5102_i2c_regmap = {
 	.reg_bits = 32,
 	.val_bits = 16,
 
-	.max_register = ARIZONA_DSP1_STATUS_2,
+	.max_register = WM5102_MAX_REGISTER,
 	.readable_reg = wm5102_readable_register,
 	.volatile_reg = wm5102_volatile_register,
 
-- 
1.7.10.4

