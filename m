Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1GFDlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:41:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41025 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1GFDlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:41:18 -0400
Subject: [PATCH] regulator: db8500-prcmu: small fixes
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sundar Iyer <sundar.iyer@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 11:41:12 +0800
Message-ID: <1309923672.26847.9.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small cleanups for better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/db8500-prcmu.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index e5f7b8f..2bb8f45 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -266,7 +266,7 @@ static struct regulator_ops db8500_regulator_switch_ops = {
  * Regulator information
  */
 static struct db8500_regulator_info
-		db8500_regulator_info[DB8500_NUM_REGULATORS] = {
+db8500_regulator_info[DB8500_NUM_REGULATORS] = {
 	[DB8500_REGULATOR_VAPE] = {
 		.desc = {
 			.name	= "db8500-vape",
@@ -492,11 +492,9 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 				info->desc.name, err);
 
 			/* if failing, unregister all earlier regulators */
-			i--;
-			while (i >= 0) {
+			while (--i >= 0) {
 				info = &db8500_regulator_info[i];
 				regulator_unregister(info->rdev);
-				i--;
 			}
 			return err;
 		}
@@ -536,13 +534,7 @@ static struct platform_driver db8500_regulator_driver = {
 
 static int __init db8500_regulator_init(void)
 {
-	int ret;
-
-	ret = platform_driver_register(&db8500_regulator_driver);
-	if (ret < 0)
-		return -ENODEV;
-
-	return 0;
+	return platform_driver_register(&db8500_regulator_driver);
 }
 
 static void __exit db8500_regulator_exit(void)
-- 
1.7.4.1



