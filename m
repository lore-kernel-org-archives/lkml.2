Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2KWIh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:37:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12413 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2KWIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:37:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 23 Nov 2012 00:37:50 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: max8973: provide enable/disable if external control disabled
Date: Fri, 23 Nov 2012 14:07:42 +0530
Message-ID: <1353659862-3072-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If external control is enabled then do not provide regulator
enable/disable apis.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/max8973-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 140ff9d..3ee2638 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -398,7 +398,7 @@ static int __devinit max8973_probe(struct i2c_client *client,
 	max->desc.uV_step = MAX8973_VOLATGE_STEP;
 	max->desc.n_voltages = MAX8973_BUCK_N_VOLTAGE;
 
-	if (pdata->enable_ext_control) {
+	if (!pdata->enable_ext_control) {
 		max->desc.enable_reg = MAX8973_VOUT;
 		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
 		max8973_dcdc_ops.enable = regulator_enable_regmap;
-- 
1.7.1.1

