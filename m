Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab2GENI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:08:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43909 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2GENGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/9] ARM: ux500: Remove AB8500 regulator register initialisation information
Date: Thu,  5 Jul 2012 14:06:06 +0100
Message-Id: <1341493572-29735-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to initialise the AB8500's regulator registers, as
most of this work is already carried out by framework features, so
we can safely remove all traces from platform code.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  176 -------------------------
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 -
 arch/arm/mach-ux500/board-mop500.c            |    2 -
 include/linux/mfd/abx500/ab8500.h             |    3 -
 4 files changed, 183 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 52426a4..ff43788 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -106,182 +106,6 @@ static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 	REGULATOR_SUPPLY("vsmps2", "mcde.0"),
 };
 
-/* ab8500 regulator register initialization */
-struct ab8500_regulator_reg_init
-ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
-	/*
-	 * VanaRequestCtrl          = HP/LP depending on VxRequest
-	 * VextSupply1RequestCtrl   = HP/LP depending on VxRequest
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2, 0x00),
-	/*
-	 * VextSupply2RequestCtrl   = HP/LP depending on VxRequest
-	 * VextSupply3RequestCtrl   = HP/LP depending on VxRequest
-	 * Vaux1RequestCtrl         = HP/LP depending on VxRequest
-	 * Vaux2RequestCtrl         = HP/LP depending on VxRequest
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL3, 0x00),
-	/*
-	 * Vaux3RequestCtrl         = HP/LP depending on VxRequest
-	 * SwHPReq                  = Control through SWValid disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4, 0x00),
-	/*
-	 * VanaSysClkReq1HPValid    = disabled
-	 * Vaux1SysClkReq1HPValid   = disabled
-	 * Vaux2SysClkReq1HPValid   = disabled
-	 * Vaux3SysClkReq1HPValid   = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x00),
-	/*
-	 * VextSupply1SysClkReq1HPValid = disabled
-	 * VextSupply2SysClkReq1HPValid = disabled
-	 * VextSupply3SysClkReq1HPValid = SysClkReq1 controlled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID2, 0x40),
-	/*
-	 * VanaHwHPReq1Valid        = disabled
-	 * Vaux1HwHPreq1Valid       = disabled
-	 * Vaux2HwHPReq1Valid       = disabled
-	 * Vaux3HwHPReqValid        = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID1, 0x00),
-	/*
-	 * VextSupply1HwHPReq1Valid = disabled
-	 * VextSupply2HwHPReq1Valid = disabled
-	 * VextSupply3HwHPReq1Valid = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID2, 0x00),
-	/*
-	 * VanaHwHPReq2Valid        = disabled
-	 * Vaux1HwHPReq2Valid       = disabled
-	 * Vaux2HwHPReq2Valid       = disabled
-	 * Vaux3HwHPReq2Valid       = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID1, 0x00),
-	/*
-	 * VextSupply1HwHPReq2Valid = disabled
-	 * VextSupply2HwHPReq2Valid = disabled
-	 * VextSupply3HwHPReq2Valid = HWReq2 controlled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID2, 0x04),
-	/*
-	 * VanaSwHPReqValid         = disabled
-	 * Vaux1SwHPReqValid        = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID1, 0x00),
-	/*
-	 * Vaux2SwHPReqValid        = disabled
-	 * Vaux3SwHPReqValid        = disabled
-	 * VextSupply1SwHPReqValid  = disabled
-	 * VextSupply2SwHPReqValid  = disabled
-	 * VextSupply3SwHPReqValid  = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID2, 0x00),
-	/*
-	 * SysClkReq2Valid1         = SysClkReq2 controlled
-	 * SysClkReq3Valid1         = disabled
-	 * SysClkReq4Valid1         = SysClkReq4 controlled
-	 * SysClkReq5Valid1         = disabled
-	 * SysClkReq6Valid1         = SysClkReq6 controlled
-	 * SysClkReq7Valid1         = disabled
-	 * SysClkReq8Valid1         = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID1, 0x2a),
-	/*
-	 * SysClkReq2Valid2         = disabled
-	 * SysClkReq3Valid2         = disabled
-	 * SysClkReq4Valid2         = disabled
-	 * SysClkReq5Valid2         = disabled
-	 * SysClkReq6Valid2         = SysClkReq6 controlled
-	 * SysClkReq7Valid2         = disabled
-	 * SysClkReq8Valid2         = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID2, 0x20),
-	/*
-	 * VTVoutEna                = disabled
-	 * Vintcore12Ena            = disabled
-	 * Vintcore12Sel            = 1.25 V
-	 * Vintcore12LP             = inactive (HP)
-	 * VTVoutLP                 = inactive (HP)
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUMISC1, 0x10),
-	/*
-	 * VaudioEna                = disabled
-	 * VdmicEna                 = disabled
-	 * Vamic1Ena                = disabled
-	 * Vamic2Ena                = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUDIOSUPPLY, 0x00),
-	/*
-	 * Vamic1_dzout             = high-Z when Vamic1 is disabled
-	 * Vamic2_dzout             = high-Z when Vamic2 is disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC, 0x00),
-	/*
-	 * VPll                     = Hw controlled
-	 * VanaRegu                 = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VPLLVANAREGU, 0x02),
-	/*
-	 * VrefDDREna               = disabled
-	 * VrefDDRSleepMode         = inactive (no pulldown)
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VREFDDR, 0x00),
-	/*
-	 * VextSupply1Regu          = HW control
-	 * VextSupply2Regu          = HW control
-	 * VextSupply3Regu          = HW control
-	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
-	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU, 0x2a),
-	/*
-	 * Vaux1Regu                = force HP
-	 * Vaux2Regu                = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU, 0x01),
-	/*
-	 * Vaux3regu                = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU, 0x00),
-	/*
-	 * Vsmps1                   = 1.15V
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS1SEL1, 0x24),
-	/*
-	 * Vaux1Sel                 = 2.5 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL, 0x08),
-	/*
-	 * Vaux2Sel                 = 2.9 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX2SEL, 0x0d),
-	/*
-	 * Vaux3Sel                 = 2.91 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3SEL, 0x07),
-	/*
-	 * VextSupply12LP           = disabled (no LP)
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL2SPARE, 0x00),
-	/*
-	 * Vaux1Disch               = short discharge time
-	 * Vaux2Disch               = short discharge time
-	 * Vaux3Disch               = short discharge time
-	 * Vintcore12Disch          = short discharge time
-	 * VTVoutDisch              = short discharge time
-	 * VaudioDisch              = short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH, 0x00),
-	/*
-	 * VanaDisch                = short discharge time
-	 * VdmicPullDownEna         = pulldown disabled when Vdmic is disabled
-	 * VdmicDisch               = short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH2, 0x00),
-};
-
 /* AB8500 regulators */
 struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9499215..a795cec 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -14,8 +14,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 
-extern struct ab8500_regulator_reg_init
-ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS];
 extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
 extern struct regulator_init_data tps61052_regulator;
 
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index ac762bd..3b76115 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -203,8 +203,6 @@ static struct platform_device snowball_sbnet_dev = {
 
 static struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
-	.regulator_reg_init = ab8500_regulator_reg_init,
-	.num_regulator_reg_init	= ARRAY_SIZE(ab8500_regulator_reg_init),
 	.regulator	= ab8500_regulators,
 	.num_regulator	= ARRAY_SIZE(ab8500_regulators),
 	.gpio		= &ab8500_gpio_pdata,
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 3764cb6..259adca 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -266,7 +266,6 @@ struct ab8500 {
 	const int *irq_reg_offset;
 };
 
-struct regulator_reg_init;
 struct regulator_init_data;
 struct ab8500_gpio_platform_data;
 struct ab8500_codec_platform_data;
@@ -283,8 +282,6 @@ struct ab8500_codec_platform_data;
 struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
-	int num_regulator_reg_init;
-	struct ab8500_regulator_reg_init *regulator_reg_init;
 	int num_regulator;
 	struct regulator_init_data *regulator;
 	struct ab8500_gpio_platform_data *gpio;
-- 
1.7.9.5

