Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1JJQVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:21:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43107 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1JJQVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:21:11 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <lrg@ti.com>, <b-cousson@ti.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH v2 1/5] regulator: twl: Remove hardcoded board constraints from driver
Date: Mon, 10 Oct 2011 21:49:34 +0530
Message-ID: <1318263578-7407-2-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318263578-7407-1-git-send-email-rnayak@ti.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the hardcoded .valid_modes_mask and .valid_ops_mask for
each regulator from the twl driver and let the boards pass it.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/twl-regulator.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index ee8747f..f696287 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1027,14 +1027,6 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 	/* copy the features into regulator data */
 	info->features = (unsigned long)initdata->driver_data;
 
-	/* Constrain board-specific capabilities according to what
-	 * this driver and the chip itself can actually do.
-	 */
-	c = &initdata->constraints;
-	c->valid_modes_mask &= REGULATOR_MODE_NORMAL | REGULATOR_MODE_STANDBY;
-	c->valid_ops_mask &= REGULATOR_CHANGE_VOLTAGE
-				| REGULATOR_CHANGE_MODE
-				| REGULATOR_CHANGE_STATUS;
 	switch (pdev->id) {
 	case TWL4030_REG_VIO:
 	case TWL4030_REG_VDD1:
-- 
1.7.1

