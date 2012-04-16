Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab2DPHGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:06:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9726 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2DPHGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:06:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Apr 2012 00:06:47 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        paul.gortmaker@windriver.com
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1] mfd: rc5t583: Fix build error
Date: Mon, 16 Apr 2012 12:22:59 +0530
Message-Id: <1334559179-30341-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing following build error:
ERROR: "rc5t583_ext_power_req_config" [drivers/regulator/rc5t583-regulator.ko] undefined!
ERROR: "rc5t583_update" [drivers/regulator/rc5t583-regulator.ko] undefined!
ERROR: "rc5t583_set_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
ERROR: "rc5t583_clear_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
ERROR: "rc5t583_read" [drivers/regulator/rc5t583-regulator.ko] undefined!
make[1]: *** [__modpost] Error 1

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The above build error is reported by Paul.
The error is appearing when MFD_RC5T583 is selcted as y and
REGULATOR_RC5T583 is selected as module.
in this case, mfd driver should actually export the public API.

 drivers/mfd/rc5t583.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 99ef944..a2aa6d9 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -96,6 +96,7 @@ int rc5t583_read(struct device *dev, uint8_t reg, uint8_t *val)
 		*val = (uint8_t)ival;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(rc5t583_read);
 
 int rc5t583_set_bits(struct device *dev, unsigned int reg,
 			unsigned int bit_mask)
@@ -103,6 +104,8 @@ int rc5t583_set_bits(struct device *dev, unsigned int reg,
 	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
 	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, bit_mask);
 }
+EXPORT_SYMBOL_GPL(rc5t583_set_bits);
+
 
 int rc5t583_clear_bits(struct device *dev, unsigned int reg,
 			unsigned int bit_mask)
@@ -110,6 +113,7 @@ int rc5t583_clear_bits(struct device *dev, unsigned int reg,
 	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
 	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, 0);
 }
+EXPORT_SYMBOL_GPL(rc5t583_clear_bits);
 
 int rc5t583_update(struct device *dev, unsigned int reg,
 		unsigned int val, unsigned int mask)
@@ -117,6 +121,7 @@ int rc5t583_update(struct device *dev, unsigned int reg,
 	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
 	return regmap_update_bits(rc5t583->regmap, reg, mask, val);
 }
+EXPORT_SYMBOL_GPL(rc5t583_update);
 
 static int __rc5t583_set_ext_pwrreq1_control(struct device *dev,
 	int id, int ext_pwr, int slots)
@@ -197,6 +202,7 @@ int rc5t583_ext_power_req_config(struct device *dev, int ds_id,
 			ds_id, ext_pwr_req);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rc5t583_ext_power_req_config);
 
 static int rc5t583_clear_ext_power_req(struct rc5t583 *rc5t583,
 	struct rc5t583_platform_data *pdata)
-- 
1.7.1.1

