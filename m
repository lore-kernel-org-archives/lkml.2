Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2FKFPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:15:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48027 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2FKFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:14:59 -0400
Message-ID: <1339391690.6612.1.camel@phoenix>
Subject: [PATCH] regulator: core: Return correct delay time in
 regulator_set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 11 Jun 2012 13:14:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdev->desc->uV_step * abs(new_selector - old_selector) returns uV.
The unit of ramp_delay is mV/us.

Current code multiples 1000 at wrong place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f4c056a..63507a5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2308,7 +2308,7 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	if (rdev->desc->ramp_delay && rdev->desc->uV_step)
 		return DIV_ROUND_UP(rdev->desc->uV_step *
 			abs(new_selector - old_selector),
-			rdev->desc->ramp_delay) * 1000;
+			rdev->desc->ramp_delay * 1000);
 	return 0;
 }
 
-- 
1.7.9.5



