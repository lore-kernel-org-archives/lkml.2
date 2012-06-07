Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2FGHDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:03:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2FGHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:03:29 -0400
Message-ID: <1339052603.5882.4.camel@phoenix>
Subject: [PATCH RFC RESEND 3/3] regulator: da903x: Don't read/write to
 DA9030_INVAL/DA9034_INVAL address
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>
Date: Thu, 07 Jun 2012 15:03:23 +0800
In-Reply-To: <1339052505.5882.2.camel@phoenix>
References: <1339052505.5882.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For fixed voltage, DA9030_LDO13 and DA9034_LDO5, the info->vol_reg is
DA9030_INVAL/DA9034_INVAL.
It does not make sense to read/write to DA9030_INVAL/DA9034_INVAL address.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 1005f5f..36c5b92 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -107,6 +107,9 @@ static int da903x_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 
+	if (rdev->desc->n_voltages == 1)
+		return -EINVAL;
+
 	val = selector << info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
@@ -120,6 +123,9 @@ static int da903x_get_voltage_sel(struct regulator_dev *rdev)
 	uint8_t val, mask;
 	int ret;
 
+	if (rdev->desc->n_voltages == 1)
+		return 0;
+
 	ret = da903x_read(da9034_dev, info->vol_reg, &val);
 	if (ret)
 		return ret;
-- 
1.7.9.5



