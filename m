Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab1KDMs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:48:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1KDMsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:48:55 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <sameo@linux.intel.com>, <nsekhar@ti.com>
CC: <linux-omap@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 2/2] regulator:TPS65910: VDD1/2 voltage selector count
Date: Fri, 4 Nov 2011 18:18:48 +0530
Message-ID: <1320410928-20349-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Count of selector voltage is required for regulator_set_voltage
to work via set_voltage_sel. VDD1/2 currently have it as zero,
so regulator_set_voltage won't work for VDD1/2

Update count (n_voltages) for VDD1/2

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/regulator/tps65910-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index a620e25..81f629f 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -930,6 +930,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 
 		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
 			pmic->desc[i].ops = &tps65910_ops_dcdc;
+			pmic->desc[i].n_voltages = VDD1_2_NUM_VOLTS * 3;
 		} else if (i == TPS65910_REG_VDD3) {
 			if (tps65910_chip_id(tps65910) == TPS65910)
 				pmic->desc[i].ops = &tps65910_ops_vdd3;
-- 
1.6.2.4

