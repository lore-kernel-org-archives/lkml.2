Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab2CVSjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:39:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52582 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263Ab2CVSjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:39:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
Date: Thu, 22 Mar 2012 18:39:00 +0000
Message-Id: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PM also covers runtime only PM.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tps65090.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index a66d4df..ac7e8b1 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -334,7 +334,7 @@ static int __devexit tps65090_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tps65090_i2c_suspend(struct i2c_client *client, pm_message_t state)
 {
 	if (client->irq)
@@ -363,7 +363,7 @@ static struct i2c_driver tps65090_driver = {
 	},
 	.probe		= tps65090_i2c_probe,
 	.remove		= __devexit_p(tps65090_i2c_remove),
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= tps65090_i2c_suspend,
 	.resume		= tps65090_i2c_resume,
 #endif
-- 
1.7.9.1

