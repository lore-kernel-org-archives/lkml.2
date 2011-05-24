Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1EXPOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:14:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50878 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755449Ab1EXPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:14:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Use _cansleep() for WM8994 regulator GPIOs
Date: Tue, 24 May 2011 23:14:40 +0800
Message-Id: <1306250080-8165-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994 regulator driver is perfectly happy if the GPIO used to enable
the regulator sleeps so call the appropriate GPIO API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 35b2958..1a6a690 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -43,7 +43,7 @@ static int wm8994_ldo_enable(struct regulator_dev *rdev)
 	if (!ldo->enable)
 		return 0;
 
-	gpio_set_value(ldo->enable, 1);
+	gpio_set_value_cansleep(ldo->enable, 1);
 	ldo->is_enabled = true;
 
 	return 0;
@@ -57,7 +57,7 @@ static int wm8994_ldo_disable(struct regulator_dev *rdev)
 	if (!ldo->enable)
 		return -EINVAL;
 
-	gpio_set_value(ldo->enable, 0);
+	gpio_set_value_cansleep(ldo->enable, 0);
 	ldo->is_enabled = false;
 
 	return 0;
-- 
1.7.5.1

