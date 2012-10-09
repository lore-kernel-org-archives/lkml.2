Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2JIMDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:03:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7522 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab2JIMCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:02:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Oct 2012 05:02:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] mfd: tps65910: Initialize mfd devices after all initialization done
Date: Tue, 9 Oct 2012 16:58:34 +0530
Message-ID: <1349782116-9757-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
References: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sub devices of tps65910 after all initialization like interrupt,
clock etc. is done. This will make sure that require data gets
initialized properly before sub devices probe's get called.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 11adedb..f7f9d3a 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -495,18 +495,10 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = mfd_add_devices(tps65910->dev, -1,
-			      tps65910s, ARRAY_SIZE(tps65910s),
-			      NULL, 0, NULL);
-	if (ret < 0) {
-		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
-		return ret;
-	}
-
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq_base;
-
 	tps65910_irq_init(tps65910, init_data->irq, init_data);
+
 	tps65910_ck32k_init(tps65910, pmic_plat_data);
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
@@ -515,6 +507,14 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 		pm_power_off = tps65910_power_off;
 	}
 
+	ret = mfd_add_devices(tps65910->dev, -1,
+			      tps65910s, ARRAY_SIZE(tps65910s),
+			      NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
+		return ret;
+	}
+
 	return ret;
 }
 
-- 
1.7.1.1

