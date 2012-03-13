Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab2CMIDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:03:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2CMIDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:03:07 -0400
Message-ID: <1331625781.3932.3.camel@phoenix>
Subject: [PATCH] regulator: max8925: Use DIV_ROUND_UP in
 max8925_set_dvm_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 13 Mar 2012 16:03:01 +0800
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
 drivers/regulator/max8925-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index cc290d3..eb045f1 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -140,7 +140,7 @@ static int max8925_set_dvm_voltage(struct regulator_dev *rdev, int uV)
 	if (uV < SD1_DVM_VMIN || uV > SD1_DVM_VMAX)
 		return -EINVAL;
 
-	data = (uV - SD1_DVM_VMIN + SD1_DVM_STEP - 1) / SD1_DVM_STEP;
+	data = DIV_ROUND_UP(uV - SD1_DVM_VMIN, SD1_DVM_STEP);
 	data <<= SD1_DVM_SHIFT;
 	mask = 3 << SD1_DVM_SHIFT;
 
-- 
1.7.5.4



