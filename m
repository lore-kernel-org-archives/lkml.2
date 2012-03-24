Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2CXBhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:37:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2CXBhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:37:38 -0400
Message-ID: <1332553050.14114.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: tps6586x: Fix list minimal voltage setting
 for LDO0
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 24 Mar 2012 09:37:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet, LDO0 has minimal voltage 1.2V rather than 1.25V.

Table 3-39. VLDO0[2:0] Settings
VLDOx[2:0] VOUT (V) VLDOx[2:0] VOUT (V)
000        1.20     100        2.70
001        1.50     101        2.85
010        1.80     110        3.10
011        2.50     111        3.30

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 29b615c..cfc1f16 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -79,6 +79,11 @@ static int tps6586x_ldo_list_voltage(struct regulator_dev *rdev,
 				     unsigned selector)
 {
 	struct tps6586x_regulator *info = rdev_get_drvdata(rdev);
+	int rid = rdev_get_id(rdev);
+
+	/* LDO0 has minimal voltage 1.2V rather than 1.25V */
+	if ((rid == TPS6586X_ID_LDO_0) && (selector == 0))
+		return (info->voltages[0] - 50) * 1000;
 
 	return info->voltages[selector] * 1000;
 }
-- 
1.7.5.4



