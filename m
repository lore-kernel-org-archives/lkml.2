Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0LPPaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:30:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38445 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756513Ab0LPPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:30:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Staticise non-exported functions in mc13892
Date: Thu, 16 Dec 2010 15:29:56 +0000
Message-Id: <1292513396-9874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point exposing functions that aren't used elsewhere to the global
namespace and sparse warns about doing so.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/mc13892-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index ca1d30a..16a0532 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -295,8 +295,8 @@ static struct mc13xxx_regulator mc13892_regulators[] = {
 	MC13892_GPO_DEFINE(PWGT2SPI, POWERMISC, mc13892_pwgtdrv),
 };
 
-int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
-		u32 val)
+static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
+				 u32 val)
 {
 	struct mc13xxx *mc13892 = priv->mc13xxx;
 	int ret;
@@ -496,7 +496,7 @@ static int mc13892_vcam_set_mode(struct regulator_dev *rdev, unsigned int mode)
 	return ret;
 }
 
-unsigned int mc13892_vcam_get_mode(struct regulator_dev *rdev)
+static unsigned int mc13892_vcam_get_mode(struct regulator_dev *rdev)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
-- 
1.7.1

