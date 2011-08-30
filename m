Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1H3QHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:07:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52364 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1H3QHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:07:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/3 v2] regulator: tps65910: verify dcdc regulator ids
Date: Tue, 30 Aug 2011 18:07:06 +0200
Message-Id: <1314720426-23007-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313405127-2724-3-git-send-email-jhovold@gmail.com>
References: <1313405127-2724-3-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add default case to switches in dcdc voltage functions.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 66d2d60..633ecd4 100644
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
-- 
1.7.6

