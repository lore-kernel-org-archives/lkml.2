Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1LMJ6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:58:09 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36651 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LMJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:58:06 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v2-rebased] mfd: TPS65910: Make usable even if interrupt unused
Date: Tue, 13 Dec 2011 15:27:53 +0530
Message-ID: <1323770273-21222-1-git-send-email-afzal@ti.com>
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
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Hi Samuel,

I sent this yesterday, but did not reach LKML,
so assumed you also may not have recieved it;
resending.

Regards
Afzal

 drivers/mfd/tps65910.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 6f5b8cf..2fa0178 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -172,15 +172,12 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
-	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
-	if (ret < 0)
-		goto err;
+	tps65910_irq_init(tps65910, init_data->irq, init_data);
 
 	kfree(init_data);
 	return ret;
 
 err:
-	mfd_remove_devices(tps65910->dev);
 	kfree(tps65910);
 	kfree(init_data);
 	return ret;
-- 
1.7.1

