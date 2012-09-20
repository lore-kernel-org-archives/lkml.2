Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2ITMSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:18:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2ITMNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/32] ARM: ux500: Pass SDI DMA information though AUX_DATA to MMCI
Date: Thu, 20 Sep 2012 14:12:33 +0200
Message-Id: <1348143170-2130-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are four SDIs on the HREF, as opposed to the original two
enabled on Snowball. To get them working we have to pass their DMA
information in the same was as we need with the other two.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-sdi.c |    4 ++--
 arch/arm/mach-ux500/board-mop500.c     |    2 ++
 arch/arm/mach-ux500/board-mop500.h     |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 18ff781..9c8e4a9 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -152,7 +152,7 @@ static struct stedma40_chan_cfg sdi1_dma_cfg_tx = {
 };
 #endif
 
-static struct mmci_platform_data mop500_sdi1_data = {
+struct mmci_platform_data mop500_sdi1_data = {
 	.ocr_mask	= MMC_VDD_29_30,
 	.f_max		= 50000000,
 	.capabilities	= MMC_CAP_4_BIT_DATA,
@@ -189,7 +189,7 @@ static struct stedma40_chan_cfg mop500_sdi2_dma_cfg_tx = {
 };
 #endif
 
-static struct mmci_platform_data mop500_sdi2_data = {
+struct mmci_platform_data mop500_sdi2_data = {
 	.ocr_mask	= MMC_VDD_165_195,
 	.f_max		= 50000000,
 	.capabilities	= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA |
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5d0f135..8890b19 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -736,6 +736,8 @@ struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires DMA bindings. */
 	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
+	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
+	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  &mop500_sdi4_data),
 	/* Requires clock name bindings. */
 	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index d04a8e6..eb421f9 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -80,6 +80,8 @@
 struct device;
 struct i2c_board_info;
 extern struct mmci_platform_data mop500_sdi0_data;
+extern struct mmci_platform_data mop500_sdi1_data;
+extern struct mmci_platform_data mop500_sdi2_data;
 extern struct mmci_platform_data mop500_sdi4_data;
 extern struct arm_pmu_platdata db8500_pmu_platdata;
 
-- 
1.7.9.5

