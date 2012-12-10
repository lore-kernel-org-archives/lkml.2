Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2LJMuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:50:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49382 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab2LJMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:50:11 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        amit.kachhap@gmail.com, Thomas Abraham <thomas.abraham@linaro.org>,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 2/4] regulator: s5m8767: Fix to read the first DVS register.
Date: Mon, 10 Dec 2012 18:19:40 +0530
Message-Id: <1355143782-15133-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
References: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the DVS register read function to select correct DVS1
register. This change is required because the GPIO select pin is 000 in
unintialized state and hence selects the DVS1 register.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/regulator/s5m8767.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index df0b094..7ed7591 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -272,17 +272,17 @@ static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 		reg = S5M8767_REG_BUCK1CTRL2;
 		break;
 	case S5M8767_BUCK2:
-		reg = S5M8767_REG_BUCK2DVS2;
+		reg = S5M8767_REG_BUCK2DVS1;
 		if (s5m8767->buck2_gpiodvs)
 			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK3:
-		reg = S5M8767_REG_BUCK3DVS2;
+		reg = S5M8767_REG_BUCK3DVS1;
 		if (s5m8767->buck3_gpiodvs)
 			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK4:
-		reg = S5M8767_REG_BUCK4DVS2;
+		reg = S5M8767_REG_BUCK4DVS1;
 		if (s5m8767->buck4_gpiodvs)
 			reg += s5m8767->buck_gpioindex;
 		break;
-- 
1.7.1

