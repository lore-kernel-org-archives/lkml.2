Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2CHCFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:05:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56528 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CHCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:05:30 -0500
Message-ID: <1331172324.14592.3.camel@phoenix>
Subject: [PATCH] regulator: max8649: Use DIV_ROUND_UP macro to calculate
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 08 Mar 2012 10:05:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP macro for better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index f724644..824c650 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -101,8 +101,7 @@ static int max8649_set_voltage(struct regulator_dev *rdev,
 			min_uV, max_uV);
 		return -EINVAL;
 	}
-	data = (min_uV - MAX8649_DCDC_VMIN + MAX8649_DCDC_STEP - 1)
-		/ MAX8649_DCDC_STEP;
+	data = DIV_ROUND_UP(min_uV - MAX8649_DCDC_VMIN, MAX8649_DCDC_STEP);
 	mask = MAX8649_VOL_MASK;
 	*selector = data & mask;
 
-- 
1.7.5.4



