Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1I0Nmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:42:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53055 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1I0Nlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:41:42 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
        <tony@atomide.com>, <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <kyungmin.park@samsung.com>, <hverkuil@xs4all.nl>,
        <m.szyprowski@samsung.com>, <g.liakhovetski@gmx.de>,
        <santosh.shilimkar@ti.com>, <khilman@deeprootsystems.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH v2 1/5] omap3evm: Enable regulators for camera interface
Date: Tue, 27 Sep 2011 19:10:44 +0530
Message-ID: <1317130848-21136-2-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com>
References: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com>
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
 arch/arm/mach-omap2/board-omap3evm.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index c452b3f..f63a8fa 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -273,6 +273,25 @@ static struct omap_dss_board_info omap3_evm_dss_data = {
 	.default_device	= &omap3_evm_lcd_device,
 };
 
+static struct regulator_consumer_supply omap3evm_vaux3_supply[] = {
+	REGULATOR_SUPPLY("cam_2v8", NULL),
+};
+
+/* VAUX3 for CAM_2V8 */
+static struct regulator_init_data omap3evm_vaux3 = {
+	.constraints = {
+		.min_uV                 = 2800000,
+		.max_uV                 = 2800000,
+		.apply_uV               = true,
+		.valid_modes_mask       = REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask         = REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+		},
+	.num_consumer_supplies  = ARRAY_SIZE(omap3evm_vaux3_supply),
+	.consumer_supplies      = omap3evm_vaux3_supply,
+};
+
 static struct regulator_consumer_supply omap3evm_vmmc1_supply[] = {
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0"),
 };
@@ -433,6 +452,7 @@ static struct twl4030_keypad_data omap3evm_kp_data = {
 /* ads7846 on SPI */
 static struct regulator_consumer_supply omap3evm_vio_supply[] = {
 	REGULATOR_SUPPLY("vcc", "spi1.0"),
+	REGULATOR_SUPPLY("vio_1v8", NULL),
 };
 
 /* VIO for ads7846 */
@@ -499,6 +519,7 @@ static struct twl4030_platform_data omap3evm_twldata = {
 	.vio		= &omap3evm_vio,
 	.vmmc1		= &omap3evm_vmmc1,
 	.vsim		= &omap3evm_vsim,
+	.vaux3          = &omap3evm_vaux3,
 };
 
 static int __init omap3_evm_i2c_init(void)
@@ -512,6 +533,7 @@ static int __init omap3_evm_i2c_init(void)
 	omap3evm_twldata.vpll2->constraints.apply_uV = true;
 
 	omap3_pmic_init("twl4030", &omap3evm_twldata);
+	/* Bus 2 is used for Camera/Sensor interface */
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
-- 
1.7.0.4

