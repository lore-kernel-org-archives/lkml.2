Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1E0TZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:25:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55339 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab1E0TZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:25:36 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: twl-regulator: fix n_voltages for twl6030 variable LDOs
Date: Fri, 27 May 2011 12:25:27 -0700
Message-Id: <1306524327-24150-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The n_voltages initializer for the TWL6030_ADJUSTABLE_LDO macro is
off by one, causing the the highest supported voltage to be
unreachable.  Setting the machine constraints to only allow the
highest voltage causes errors:

machine_constraints_voltage: VAUX3_6030: unsupportable voltage constraints
twl_reg twl_reg.39: can't register VAUX3_6030, -22
twl_reg: probe of twl_reg.39 failed with error -22

This patch fixes the off by one error.  Tested by setting
VAUX3_6030 to 3.3V.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/regulator/twl-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 6a29285..afd9c7e 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -520,7 +520,7 @@ static struct regulator_ops twl6030_fixed_resource = {
 	.desc = { \
 		.name = #label, \
 		.id = TWL6030_REG_##label, \
-		.n_voltages = (max_mVolts - min_mVolts)/100, \
+		.n_voltages = (max_mVolts - min_mVolts)/100 + 1, \
 		.ops = &twl6030ldo_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
-- 
1.7.4.1

