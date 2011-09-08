Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab1IHNeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:34:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58676 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab1IHNeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:34:21 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <laurent.pinchart@ideasonboard.com>, <g.liakhovetski@gmx.de>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 1/8] omap3evm: Enable regulators for camera interface
Date: Thu, 8 Sep 2011 19:03:51 +0530
Message-ID: <1315488831-15998-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Enabled 1v8 and 2v8 regulator output, which is being used by
camera module.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   40 ++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index a1184b3..8333ee4 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -273,6 +273,44 @@ static struct omap_dss_board_info omap3_evm_dss_data = {
 	.default_device	= &omap3_evm_lcd_device,
 };
 
+static struct regulator_consumer_supply omap3evm_vaux3_supply = {
+	.supply         = "cam_1v8",
+};
+
+static struct regulator_consumer_supply omap3evm_vaux4_supply = {
+	.supply         = "cam_2v8",
+};
+
+/* VAUX3 for CAM_1V8 */
+static struct regulator_init_data omap3evm_vaux3 = {
+	.constraints = {
+		.min_uV                 = 1800000,
+		.max_uV                 = 1800000,
+		.apply_uV               = true,
+		.valid_modes_mask       = REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask         = REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+		},
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &omap3evm_vaux3_supply,
+};
+
+/* VAUX4 for CAM_2V8 */
+static struct regulator_init_data omap3evm_vaux4 = {
+	.constraints = {
+		.min_uV                 = 1800000,
+		.max_uV                 = 1800000,
+		.apply_uV               = true,
+		.valid_modes_mask       = REGULATOR_MODE_NORMAL
+			| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask         = REGULATOR_CHANGE_MODE
+			| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &omap3evm_vaux4_supply,
+};
+
 static struct regulator_consumer_supply omap3evm_vmmc1_supply[] = {
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0"),
 };
@@ -499,6 +537,8 @@ static struct twl4030_platform_data omap3evm_twldata = {
 	.vio		= &omap3evm_vio,
 	.vmmc1		= &omap3evm_vmmc1,
 	.vsim		= &omap3evm_vsim,
+	.vaux3          = &omap3evm_vaux3,
+	.vaux4          = &omap3evm_vaux4,
 };
 
 static int __init omap3_evm_i2c_init(void)
-- 
1.7.0.4

