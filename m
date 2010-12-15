Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0LOOKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:10:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55824 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691Ab0LOOKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:10:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Yong Shen <yong.shen@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Allow modular build of mc13xxx-core
Date: Wed, 15 Dec 2010 14:10:25 +0000
Message-Id: <1292422225-27530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101215140344.GF5723@sirena.org.uk>
References: <20101215140344.GF5723@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the MFD core for this device and the regulator drivers for these
devices can be built modular we should also support modular build of
the shared code for the regulator drivers, otherwise we try to link
built in code against modular code with unfortunate results.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig                  |    2 +-
 drivers/regulator/mc13xxx-regulator-core.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 485a9bc..e1d9436 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -187,7 +187,7 @@ config REGULATOR_PCAP
 	 PCAP2 PMIC.
 
 config REGULATOR_MC13XXX_CORE
-	bool
+	tristate
 
 config REGULATOR_MC13783
 	tristate "Support regulators on Freescale MC13783 PMIC"
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 448e8f4..da46b3c 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -123,6 +123,7 @@ int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
 	}
 	return bestindex;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_get_best_voltage_index);
 
 static int mc13xxx_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 		int max_uV, unsigned *selector)
@@ -185,6 +186,7 @@ struct regulator_ops mc13xxx_regulator_ops = {
 	.set_voltage = mc13xxx_regulator_set_voltage,
 	.get_voltage = mc13xxx_regulator_get_voltage,
 };
+EXPORT_SYMBOL_GPL(mc13xxx_regulator_ops);
 
 int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 	       int max_uV, unsigned *selector)
@@ -202,6 +204,7 @@ int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 	else
 		return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_set_voltage);
 
 int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev)
 {
@@ -213,6 +216,7 @@ int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev)
 
 	return mc13xxx_regulators[id].voltages[0];
 }
+EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_get_voltage);
 
 struct regulator_ops mc13xxx_fixed_regulator_ops = {
 	.enable = mc13xxx_regulator_enable,
@@ -222,6 +226,7 @@ struct regulator_ops mc13xxx_fixed_regulator_ops = {
 	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
 	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
+EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_ops);
 
 int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev)
 {
-- 
1.7.1

