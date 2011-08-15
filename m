Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1HOKps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:45:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51921 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1HOKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:45:46 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/3] regulator: tps65910: verify dcdc regulator ids
Date: Mon, 15 Aug 2011 12:45:27 +0200
Message-Id: <1313405127-2724-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add default case to switches in dcdc voltage functions.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 2c61e48..991dfa4 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -534,6 +534,8 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 		srvsel &= VDDCTRL_SR_SEL_MASK;
 		vselmax = 64;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	/* multiplier 0 == 1 but 2,3 normal */
@@ -688,6 +690,9 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 	case TPS65911_REG_VDDCTRL:
 		vsel = selector;
 		tps65910_reg_write(pmic, TPS65911_VDDCTRL_OP, vsel);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
@@ -762,6 +767,9 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return  volt * 100 * mult;
-- 
1.7.6

