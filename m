Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2KMOHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:07:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2440 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2KMOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:07:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Nov 2012 06:06:57 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 RESEND 1/4] mfd: tps65910: Initialize mfd devices after all initialization done
Date: Tue, 13 Nov 2012 19:33:56 +0530
Message-ID: <1352815439-26040-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sub devices of tps65910 after all initialization like interrupt,
clock etc. is done. This will make sure that require data gets
initialized properly before sub devices probe's get called.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Changes from V:
- Rearrange patches so that this patch become first in place of third of
  series.
- Added Reviewed by: Mark as it is already revieved in patch V1.

Changes from V2:
- None.

 drivers/mfd/tps65910.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 0d79ce2..27fbbe5 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -279,14 +279,6 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
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
 
@@ -299,6 +291,14 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
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

