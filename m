Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab2EQAu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:50:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49291 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab2EQAuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:50:54 -0400
Message-ID: <1337215845.5759.1.camel@phoenix>
Subject: [PATCH] regulator: rc5t583: Remove max_uV from struct
 rc5t583_regulator_info
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 17 May 2012 08:50:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been converted to set_voltage_sel and regulator_map_voltage_linear.
regulator_map_voltage_linear will check the voltage falls within specified range.
The max_uV field is not used now, remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 987fa34..1d34e64 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -40,9 +40,6 @@ struct rc5t583_regulator_info {
 	uint8_t			disc_bit;
 	uint8_t			deepsleep_reg;
 
-	/* Chip constraints on regulator behavior */
-	int			max_uV;
-
 	/* Regulator specific turn-on delay  and voltage settling time*/
 	int			enable_uv_per_us;
 	int			change_uv_per_us;
@@ -106,7 +103,6 @@ static struct regulator_ops rc5t583_ops = {
 	.reg_disc_reg	= RC5T583_REG_##_disc_reg,		\
 	.disc_bit	= _disc_bit,				\
 	.deepsleep_reg	= RC5T583_REG_##_id##DAC_DS,		\
-	.max_uV		= _max_mv * 1000,			\
 	.enable_uv_per_us = _enable_mv * 1000,			\
 	.change_uv_per_us = 40 * 1000,				\
 	.deepsleep_id	= RC5T583_DS_##_id,			\
-- 
1.7.5.4



