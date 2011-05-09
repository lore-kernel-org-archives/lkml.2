Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1EIJk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:40:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42818 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704Ab1EIJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:40:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Factor out references to rdev in regulator_force_disable()
Date: Mon,  9 May 2011 11:41:02 +0200
Message-Id: <1304934062-22847-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't go looking up the rdev pointer every time, just use a local variable
like everything else.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c5b3c50..58452ac 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1508,13 +1508,14 @@ static int _regulator_force_disable(struct regulator_dev *rdev,
  */
 int regulator_force_disable(struct regulator *regulator)
 {
+	struct regulator_dev *rdev = regulator->rdev;
 	struct regulator_dev *supply_rdev = NULL;
 	int ret;
 
-	mutex_lock(&regulator->rdev->mutex);
+	mutex_lock(&rdev->mutex);
 	regulator->uA_load = 0;
-	ret = _regulator_force_disable(regulator->rdev, &supply_rdev);
-	mutex_unlock(&regulator->rdev->mutex);
+	ret = _regulator_force_disable(rdev, &supply_rdev);
+	mutex_unlock(&rdev->mutex);
 
 	if (supply_rdev)
 		regulator_disable(get_device_regulator(rdev_get_dev(supply_rdev)));
-- 
1.7.4.1

