Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3AJCdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:33:20 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46046 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3AJCdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:33:18 -0500
Message-ID: <1357785186.28668.1.camel@phoenix>
Subject: [PATCH RFT] regulator: lp8788-buck: Silence build warning
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 10:33:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver use id as array index, thus add bounder checking for id.

This patch fixes below build warning:
drivers/regulator/lp8788-buck.c: In function 'lp8788_buck_probe':
drivers/regulator/lp8788-buck.c:490:8: warning: array subscript is above array bounds [-Warray-bounds]
drivers/regulator/lp8788-buck.c:489:63: warning: array subscript is above array bounds [-Warray-bounds]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Fengguang,
My toolchain does not show the warning you mentioned,
can you test if this patch indeed silence the build warning?

Thanks,
Axel
 drivers/regulator/lp8788-buck.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 1161949..ef845c7 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -474,7 +474,7 @@ static int lp8788_init_dvs(struct platform_device *pdev,
 	u8 default_dvs_mode[] = { LP8788_BUCK1_DVS_I2C, LP8788_BUCK2_DVS_I2C };
 
 	/* no dvs for buck3, 4 */
-	if (id == BUCK3 || id == BUCK4)
+	if (id > BUCK2)
 		return 0;
 
 	/* no dvs platform data, then dvs will be selected by I2C registers */
@@ -505,6 +505,9 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	int ret;
 
+	if (id >= LP8788_NUM_BUCKS)
+		return -EINVAL;
+
 	buck = devm_kzalloc(&pdev->dev, sizeof(struct lp8788_buck), GFP_KERNEL);
 	if (!buck)
 		return -ENOMEM;
-- 
1.7.9.5



