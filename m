Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1GJKl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:41:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43856 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab1GJKl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:41:28 -0400
Subject: [PATCH v2] regulator: tps65910: Add missing breaks in switch/case
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 18:41:22 +0800
Message-ID: <1310294482.4877.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add a default case in tps65910_list_voltage_dcdc to silence
'volt' may be used uninitialized in this function warning.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: Just found another missing breaks in tps65910_list_voltage_dcdc.
    And also silence the 'volt' may be used uninitialized warning by
    adding a default case.

 drivers/regulator/tps65910-regulator.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 55dd4e6..fe8dc02 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -759,8 +759,12 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
 		volt = VDD1_2_MIN_VOLT +
 				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return  volt * 100 * mult;
@@ -898,9 +902,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
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



