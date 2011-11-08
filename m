Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1KHNYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:24:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52233 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1KHNYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:24:10 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <sameo@linux.intel.com>, <nsekhar@ti.com>
CC: <linux-omap@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH RESEND v2 1/2] mfd: TPS65910: Make usable even if interrupt unused
Date: Tue, 8 Nov 2011 18:54:03 +0530
Message-ID: <1320758643-29138-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65910 can be used even if interrupt is unused.
Hence let probe succeed in case interrupt can't be
configured and let Kernel only to complain about it

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
v2: Remove driver simplification that should not have been done

 drivers/mfd/tps65910.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 25d5d72..f3c9be4 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -187,15 +187,11 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
-	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
-	if (ret < 0)
-		goto err2;
+	tps65910_irq_init(tps65910, init_data->irq, init_data);
 
 	kfree(init_data);
 	return ret;
 
-err2:
-	mfd_remove_devices(tps65910->dev);
 err:
 	kfree(tps65910);
 	kfree(init_data);
-- 
1.7.0.4

