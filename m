Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1GJNoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 09:44:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1GJNoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 09:44:19 -0400
Subject: [PATCH v3] regulator: tps65910: Add missing breaks in switch/case
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 21:44:09 +0800
Message-ID: <1310305449.2477.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add a default case in tps65910_list_voltage_dcdc to silence
'volt' may be used uninitialized in this function warning.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
v2: Just found another missing breaks in tps65910_list_voltage_dcdc.
   And also silence the 'volt' may be used uninitialized warning by
   adding a default case.
v3: Base on Mark's comment to add a BUG()

 drivers/regulator/tps65910-regulator.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 55dd4e6..425aab3 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -759,8 +759,13 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
 		volt = VDD1_2_MIN_VOLT +
 				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
+		break;
+	default:
+		BUG();
+		return -EINVAL;
 	}
 
 	return  volt * 100 * mult;
@@ -898,9 +903,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	case TPS65910:
 		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
 		info = tps65910_regs;
+		break;
 	case TPS65911:
 		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
 		info = tps65911_regs;
+		break;
 	default:
 		pr_err("Invalid tps chip version\n");
 		return -ENODEV;
-- 
1.7.4.1



