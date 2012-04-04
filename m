Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2DDOiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:38:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2DDOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:38:15 -0400
Message-ID: <1333550289.5856.4.camel@phoenix>
Subject: [PATCH] regulator: rc5t583: Fix off-by-one valid range checking for
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 04 Apr 2012 22:38:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid selector should be 0 ... nsteps-1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index cac8a2a..dc9ebb9 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -131,7 +131,7 @@ static int rc5t583_set_voltage_sel(struct regulator_dev *rdev,
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
 	struct rc5t583_regulator_info *ri = reg->reg_info;
 	int ret;
-	if (selector > ri->nsteps) {
+	if (selector >= ri->nsteps) {
 		dev_err(&rdev->dev, "Invalid selector 0x%02x\n", selector);
 		return -EINVAL;
 	}
-- 
1.7.5.4



