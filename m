Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2CGLLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:11:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17882 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2CGLLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:11:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Mar 2012 03:11:38 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] regulator: tps65910: Configure correct value for VDDCTRL vout reg
Date: Wed,  7 Mar 2012 16:39:05 +0530
Message-Id: <1331118545-26514-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per datasheet, the voltage output is defined as
from SEL[6:0] = 3 to 64 (dec)
Vout= (SEL[6:0] × 12.5 mV + 562.5 mV)

The list_voltage returns the vout as
    600mV +  selector * 12.5mV

and so equivalent VSEL is selector + 3.
Adding 3 on selector when configuring VSEL register for
VDDCTRL output.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 15b5f1e..8de2835 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -715,7 +715,7 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 		tps65910_reg_write(pmic, TPS65910_VDD2_OP, vsel);
 		break;
 	case TPS65911_REG_VDDCTRL:
-		vsel = selector;
+		vsel = selector + 3;
 		tps65910_reg_write(pmic, TPS65911_VDDCTRL_OP, vsel);
 	}
 
-- 
1.7.1.1

