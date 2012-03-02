Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2CBBTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:19:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38429 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2CBBTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:19:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.226.9 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330651142.6247.1.camel@phoenix>
Subject: [PATCH] regulator: Simplify the code to get selector in
 isl6271a_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 02 Mar 2012 09:19:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index c1a456c..775f5fd 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -63,23 +63,15 @@ static int isl6271a_set_voltage(struct regulator_dev *dev,
 				unsigned *selector)
 {
 	struct isl_pmic *pmic = rdev_get_drvdata(dev);
-	int vsel, err, data;
+	int err, data;
 
 	if (minuV < ISL6271A_VOLTAGE_MIN || minuV > ISL6271A_VOLTAGE_MAX)
 		return -EINVAL;
 	if (maxuV < ISL6271A_VOLTAGE_MIN || maxuV > ISL6271A_VOLTAGE_MAX)
 		return -EINVAL;
 
-	/* Align to 50000 mV */
-	vsel = minuV - (minuV % ISL6271A_VOLTAGE_STEP);
-
-	/* If the result fell out of [minuV,maxuV] range, put it back */
-	if (vsel < minuV)
-		vsel += ISL6271A_VOLTAGE_STEP;
-
-	/* Convert the microvolts to data for the chip */
-	data = (vsel - ISL6271A_VOLTAGE_MIN) / ISL6271A_VOLTAGE_STEP;
-
+	data = DIV_ROUND_UP(minuV - ISL6271A_VOLTAGE_MIN,
+			    ISL6271A_VOLTAGE_STEP);
 	*selector = data;
 
 	mutex_lock(&pmic->mtx);
-- 
1.7.5.4



