Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2FRGDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:03:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47682 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2FRGDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:03:22 -0400
Message-ID: <1339999396.18659.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: core: Change the unit of ramp_delay from
 mV/uS to uV/uS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 18 Jun 2012 14:03:16 +0800
In-Reply-To: <1339999142.18659.1.camel@phoenix>
References: <1339999142.18659.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it possible to set ramp_delay with 0.xxx mV/uS without
truncation issue.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is on top of the patch I sent earlier:
http://www.kernelhub.org/?msg=85659&p=2

Axel
 .../devicetree/bindings/regulator/regulator.txt    |    2 +-
 drivers/regulator/core.c                           |    4 ++--
 include/linux/regulator/driver.h                   |    2 +-
 include/linux/regulator/machine.h                  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index d0a7b12..bec5d57 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -10,7 +10,7 @@ Optional properties:
 - regulator-always-on: boolean, regulator should never be disabled
 - regulator-boot-on: bootloader/firmware enabled regulator
 - <name>-supply: phandle to the parent supply/regulator node
-- regulator-ramp-delay: ramp delay for regulator(in mV/uS)
+- regulator-ramp-delay: ramp delay for regulator(in uV/uS)
 
 Example:
 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bf0306f..81a0ecf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2328,11 +2328,11 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	if (rdev->desc->uV_step) {
 		return DIV_ROUND_UP(rdev->desc->uV_step *
 				    abs(new_selector - old_selector),
-				    ramp_delay * 1000);
+				    ramp_delay);
 	} else if (rdev->desc->volt_table) {
 		return DIV_ROUND_UP(abs(rdev->desc->volt_table[new_selector] -
 					rdev->desc->volt_table[old_selector]),
-				    ramp_delay * 1000);
+				    ramp_delay);
 	} else {
 		rdev_warn(rdev, "Unsupported voltage mapping settings\n");
 	}
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index ddc155d..84f999ed 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -173,7 +173,7 @@ enum regulator_type {
  *
  * @min_uV: Voltage given by the lowest selector (if linear mapping)
  * @uV_step: Voltage increase with each selector (if linear mapping)
- * @ramp_delay: Time to settle down after voltage change (unit: mV/us)
+ * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
  * @volt_table: Voltage mapping table (if table based mapping)
  *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 5f37ad3..40dd0a3 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -92,7 +92,7 @@ struct regulator_state {
  *                 mode.
  * @initial_state: Suspend state to set by default.
  * @initial_mode: Mode to set at startup.
- * @ramp_delay: Time to settle down after voltage change (unit: mV/us)
+ * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
  */
 struct regulation_constraints {
 
-- 
1.7.9.5



