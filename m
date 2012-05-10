Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab2EJJwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:52:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2917 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab2EJJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:52:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 May 2012 02:51:58 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <olof@lixom.net>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] regulator: tps62360: make init_data of platform data to pointer.
Date: Thu, 10 May 2012 15:17:53 +0530
Message-ID: <1336643276-16796-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336643276-16796-1-git-send-email-ldewangan@nvidia.com>
References: <1336643276-16796-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert platform data member regulator_init_data to pointer type.
This will avoid the copy of entire regualator init data into
platform data member when adding dt support and it can be achieve
by simple assignment:
pdata->init_data = of_get_regulator_init_data(dev, dev->of_node);

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Currently there is zero user of this regulator and hence making
this change in header file. This will make the dt support simple.

 drivers/regulator/tps62360-regulator.c |    2 +-
 include/linux/regulator/tps62360.h     |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 97fd98b..3506900 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -408,7 +408,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	}
 
 	config.dev = &client->dev;
-	config.init_data = &pdata->reg_init_data;
+	config.init_data = pdata->reg_init_data;
 	config.driver_data = tps;
 
 	/* Register the regulators */
diff --git a/include/linux/regulator/tps62360.h b/include/linux/regulator/tps62360.h
index 6a5c1b2..5e11d50 100644
--- a/include/linux/regulator/tps62360.h
+++ b/include/linux/regulator/tps62360.h
@@ -26,8 +26,6 @@
 #ifndef __LINUX_REGULATOR_TPS62360_H
 #define __LINUX_REGULATOR_TPS62360_H
 
-#include <linux/regulator/machine.h>
-
 /*
  * struct tps62360_regulator_platform_data - tps62360 regulator platform data.
  *
@@ -44,7 +42,7 @@
  * @vsel1_def_state: Default state of vsel1. 1 if it is high else 0.
  */
 struct tps62360_regulator_platform_data {
-	struct regulator_init_data reg_init_data;
+	struct regulator_init_data *reg_init_data;
 	bool en_force_pwm;
 	bool en_discharge;
 	bool en_internal_pulldn;
-- 
1.7.1.1

