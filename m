Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HCA6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:58:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15815 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1HCA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:58:06 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-12-4e389d1c20b6
Date: Wed, 03 Aug 2011 09:58:03 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] regulator: max8952: removed unused mutex.
In-reply-to: <4E37FE95.7090808@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com, Liam Girdwood <lrg@ti.com>
Message-id: <1312333083-22615-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <4E37FE95.7090808@ti.com>
X-OriginalArrivalTime: 03 Aug 2011 00:58:07.0232 (UTC)
 FILETIME=[6828A000:01CC5178]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a mutex that is never used in the driver.

Reported-by: Axel Lin
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/regulator/max8952.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index daff7fd..2fa8a81 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -26,7 +26,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/max8952.h>
-#include <linux/mutex.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -47,7 +46,6 @@ enum {
 struct max8952_data {
 	struct i2c_client	*client;
 	struct device		*dev;
-	struct mutex		mutex;
 	struct max8952_platform_data *pdata;
 	struct regulator_dev	*rdev;
 
@@ -208,7 +206,6 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	max8952->client = client;
 	max8952->dev = &client->dev;
 	max8952->pdata = pdata;
-	mutex_init(&max8952->mutex);
 
 	max8952->rdev = regulator_register(&regulator, max8952->dev,
 			&pdata->reg_data, max8952);
-- 
1.7.4.1

