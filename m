Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2EGJDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:03:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60731 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966Ab2EGJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:03:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/7] mfd: tps65090: Fix ifdefs for suspend mode
Date: Mon,  7 May 2012 10:03:17 +0100
Message-Id: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PM also covers runtime only PM.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/mfd/tps65090.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 47f802b..4d60556 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -323,7 +323,7 @@ static int __devexit tps65090_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tps65090_i2c_suspend(struct i2c_client *client, pm_message_t state)
 {
 	if (client->irq)
@@ -352,7 +352,7 @@ static struct i2c_driver tps65090_driver = {
 	},
 	.probe		= tps65090_i2c_probe,
 	.remove		= __devexit_p(tps65090_i2c_remove),
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= tps65090_i2c_suspend,
 	.resume		= tps65090_i2c_resume,
 #endif
-- 
1.7.10

