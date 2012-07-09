Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2GIO3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:29:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38106 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2GIO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:29:23 -0400
Message-ID: <1341844140.8153.1.camel@phoenix>
Subject: [PATCH] mfd: Guard max77686_pmic_dt_match with CONFIG_OF
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 22:29:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build warning if CONFIG_OF is not set.

  CC      drivers/mfd/max77686.o
drivers/mfd/max77686.c:37:42: warning: 'max77686_pmic_dt_match' defined but not used [-Wunused-variable]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max77686.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 3e31d05..c03e12b 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -34,11 +34,6 @@
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
-static struct of_device_id __devinitdata max77686_pmic_dt_match[] = {
-	{.compatible = "maxim,max77686",        .data = 0},
-	{},
-};
-
 static struct mfd_cell max77686_devs[] = {
 	{ .name = "max77686-pmic", },
 	{ .name = "max77686-rtc", },
@@ -50,6 +45,11 @@ static struct regmap_config max77686_regmap_config = {
 };
 
 #ifdef CONFIG_OF
+static struct of_device_id __devinitdata max77686_pmic_dt_match[] = {
+	{.compatible = "maxim,max77686",        .data = 0},
+	{},
+};
+
 static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
 								  *dev)
 {
-- 
1.7.9.5



