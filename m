Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2FNIBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:01:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46153 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2FNIBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:01:01 -0400
Message-ID: <1339660853.14481.2.camel@phoenix>
Subject: [PATCH] regulator: tps6524x: Fix get_voltage_sel for fixed voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 14 Jun 2012 16:00:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_voltage_sel() should return selector rather than voltage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index b88b3df..1b299aa 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -482,7 +482,7 @@ static int get_voltage_sel(struct regulator_dev *rdev)
 	info	= &supply_info[rdev_get_id(rdev)];
 
 	if (info->flags & FIXED_VOLTAGE)
-		return info->fixed_voltage;
+		return 0;
 
 	ret = read_field(hw, &info->voltage);
 	if (ret < 0)
-- 
1.7.9.5



