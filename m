Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1CJNo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:44:56 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:40990 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497Ab1CJNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:44:55 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] mach-ux500: provide ab8500 init vector
Date: Thu, 10 Mar 2011 14:44:02 +0100
Message-ID: <1299764642-2604-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

This adds an ab8500 regulator initialization vector for the
HREF/MOP500 series of boards. This also sets the display
regulator to be on at boot so we don't loose our splash
screen when the board comes up.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  178 +++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c            |    2 +
 2 files changed, 180 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 533967c..e8e9785 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -12,6 +12,182 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 
+/* ab8500 regulator register initialization */
+struct ab8500_regulator_reg_init
+ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
+	/*
+	 * VanaRequestCtrl          = HP/LP depending on VxRequest
+	 * VextSupply1RequestCtrl   = HP/LP depending on VxRequest
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2, 0x00),
+	/*
+	 * VextSupply2RequestCtrl   = HP/LP depending on VxRequest
+	 * VextSupply3RequestCtrl   = HP/LP depending on VxRequest
+	 * Vaux1RequestCtrl         = HP/LP depending on VxRequest
+	 * Vaux2RequestCtrl         = HP/LP depending on VxRequest
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL3, 0x00),
+	/*
+	 * Vaux3RequestCtrl         = HP/LP depending on VxRequest
+	 * SwHPReq                  = Control through SWValid disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4, 0x00),
+	/*
+	 * VanaSysClkReq1HPValid    = disabled
+	 * Vaux1SysClkReq1HPValid   = disabled
+	 * Vaux2SysClkReq1HPValid   = disabled
+	 * Vaux3SysClkReq1HPValid   = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x00),
+	/*
+	 * VextSupply1SysClkReq1HPValid = disabled
+	 * VextSupply2SysClkReq1HPValid = disabled
+	 * VextSupply3SysClkReq1HPValid = SysClkReq1 controlled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID2, 0x40),
+	/*
+	 * VanaHwHPReq1Valid        = disabled
+	 * Vaux1HwHPreq1Valid       = disabled
+	 * Vaux2HwHPReq1Valid       = disabled
+	 * Vaux3HwHPReqValid        = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID1, 0x00),
+	/*
+	 * VextSupply1HwHPReq1Valid = disabled
+	 * VextSupply2HwHPReq1Valid = disabled
+	 * VextSupply3HwHPReq1Valid = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID2, 0x00),
+	/*
+	 * VanaHwHPReq2Valid        = disabled
+	 * Vaux1HwHPReq2Valid       = disabled
+	 * Vaux2HwHPReq2Valid       = disabled
+	 * Vaux3HwHPReq2Valid       = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID1, 0x00),
+	/*
+	 * VextSupply1HwHPReq2Valid = disabled
+	 * VextSupply2HwHPReq2Valid = disabled
+	 * VextSupply3HwHPReq2Valid = HWReq2 controlled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID2, 0x04),
+	/*
+	 * VanaSwHPReqValid         = disabled
+	 * Vaux1SwHPReqValid        = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID1, 0x00),
+	/*
+	 * Vaux2SwHPReqValid        = disabled
+	 * Vaux3SwHPReqValid        = disabled
+	 * VextSupply1SwHPReqValid  = disabled
+	 * VextSupply2SwHPReqValid  = disabled
+	 * VextSupply3SwHPReqValid  = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID2, 0x00),
+	/*
+	 * SysClkReq2Valid1         = SysClkReq2 controlled
+	 * SysClkReq3Valid1         = disabled
+	 * SysClkReq4Valid1         = SysClkReq4 controlled
+	 * SysClkReq5Valid1         = disabled
+	 * SysClkReq6Valid1         = SysClkReq6 controlled
+	 * SysClkReq7Valid1         = disabled
+	 * SysClkReq8Valid1         = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID1, 0x2a),
+	/*
+	 * SysClkReq2Valid2         = disabled
+	 * SysClkReq3Valid2         = disabled
+	 * SysClkReq4Valid2         = disabled
+	 * SysClkReq5Valid2         = disabled
+	 * SysClkReq6Valid2         = SysClkReq6 controlled
+	 * SysClkReq7Valid2         = disabled
+	 * SysClkReq8Valid2         = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID2, 0x20),
+	/*
+	 * VTVoutEna                = disabled
+	 * Vintcore12Ena            = disabled
+	 * Vintcore12Sel            = 1.25 V
+	 * Vintcore12LP             = inactive (HP)
+	 * VTVoutLP                 = inactive (HP)
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUMISC1, 0x10),
+	/*
+	 * VaudioEna                = disabled
+	 * VdmicEna                 = disabled
+	 * Vamic1Ena                = disabled
+	 * Vamic2Ena                = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VAUDIOSUPPLY, 0x00),
+	/*
+	 * Vamic1_dzout             = high-Z when Vamic1 is disabled
+	 * Vamic2_dzout             = high-Z when Vamic2 is disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC, 0x00),
+	/*
+	 * VPll                     = Hw controlled
+	 * VanaRegu                 = force off
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VPLLVANAREGU, 0x02),
+	/*
+	 * VrefDDREna               = disabled
+	 * VrefDDRSleepMode         = inactive (no pulldown)
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VREFDDR, 0x00),
+	/*
+	 * VextSupply1Regu          = HW control
+	 * VextSupply2Regu          = HW control
+	 * VextSupply3Regu          = HW control
+	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
+	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU, 0x2a),
+	/*
+	 * Vaux1Regu                = force HP
+	 * Vaux2Regu                = force off
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU, 0x01),
+	/*
+	 * Vaux3regu                = force off
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU, 0x00),
+	/*
+	 * Vsmps1                   = 1.15V
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS1SEL1, 0x24),
+	/*
+	 * Vaux1Sel                 = 2.5 V
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL, 0x08),
+	/*
+	 * Vaux2Sel                 = 2.9 V
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VAUX2SEL, 0x0d),
+	/*
+	 * Vaux3Sel                 = 2.91 V
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3SEL, 0x07),
+	/*
+	 * VextSupply12LP           = disabled (no LP)
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL2SPARE, 0x00),
+	/*
+	 * Vaux1Disch               = short discharge time
+	 * Vaux2Disch               = short discharge time
+	 * Vaux3Disch               = short discharge time
+	 * Vintcore12Disch          = short discharge time
+	 * VTVoutDisch              = short discharge time
+	 * VaudioDisch              = short discharge time
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH, 0x00),
+	/*
+	 * VanaDisch                = short discharge time
+	 * VdmicPullDownEna         = pulldown disabled when Vdmic is disabled
+	 * VdmicDisch               = short discharge time
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH2, 0x00),
+};
+
 /* AB8500 regulators */
 struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
@@ -22,6 +198,7 @@ struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 			.max_uV = 2900000,
 			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
 					  REGULATOR_CHANGE_STATUS,
+			.boot_on = 1, /* must be on for display */
 		},
 	},
 	/* supplies to the on-board eMMC */
@@ -42,6 +219,7 @@ struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 			.max_uV = 3300000,
 			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
 					  REGULATOR_CHANGE_STATUS,
+			.boot_on = 1, /* must be on for display */
 		},
 	},
 	/* supply for tvout, gpadc, TVOUT LDO */
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 8e3a688..89776c4 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -82,6 +82,8 @@ static pin_cfg_t mop500_pins[] = {
 
 static struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
+	.regulator_reg_init = ab8500_regulator_reg_init,
+	.num_regulator_reg_init	= ARRAY_SIZE(ab8500_regulator_reg_init),
 	.regulator	= ab8500_regulators,
 	.num_regulator	= ARRAY_SIZE(ab8500_regulators),
 };
-- 
1.7.3.2

