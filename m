Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1LELon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:44:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37637 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab1LELon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:44:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: If a single voltage is set with device tree then set apply_uV
Date: Mon,  5 Dec 2011 11:44:39 +0000
Message-Id: <1323085479-27410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise there is no way in the bindings to configure a fixed voltage
via software. It seems reasonable to assume that if the binding explicitly
specifies a voltage we want to actually use that voltage.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/of_regulator.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index acd7045..b7b3fc3 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -34,6 +34,9 @@ static void of_get_regulation_constraints(struct device_node *np,
 	/* Voltage change possible? */
 	if (constraints->min_uV != constraints->max_uV)
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_VOLTAGE;
+	/* Only one voltage?  Then make sure it's set. */
+	if (constraints->min_uV == constraints->max_uV)
+		constraints->apply_uV = true;
 
 	uV_offset = of_get_property(np, "regulator-microvolt-offset", NULL);
 	if (uV_offset)
-- 
1.7.7.3

