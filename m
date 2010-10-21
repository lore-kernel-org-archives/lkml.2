Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0JUVEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:04:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35299 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab0JUVB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:01:59 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 07/12] davinci: add tnetv107x evm regulators
Date: Thu, 21 Oct 2010 17:01:08 -0400
Message-Id: <1287694873-12904-8-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287694873-12904-1-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator and spi board info definitions for the tps6524x
power management IC found on tnetv107x evm boards.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   85 +++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index c37c5c6..d4c3d18 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -26,6 +26,9 @@
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/driver.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -257,7 +260,89 @@ static struct tnetv107x_device_info evm_device_info __initconst = {
 	.ssp_config		= &ssp_config,
 };
 
+static struct regulator_consumer_supply usb_consumers[] = {
+	REGULATOR_SUPPLY("vbus", "musb_hdrc.1"),
+};
+
+static struct regulator_consumer_supply lcd_consumers[] = {
+	REGULATOR_SUPPLY("vlcd", "tps6116x"),
+};
+
+static struct regulator_init_data regulators[] = {
+	{
+		.constraints		= {
+			.name		= "DCDC1",
+			.min_uV		= 1000000,
+			.max_uV		= 1000000,
+			.always_on	= 1,
+			.boot_on	= 1,
+		},
+	},
+	{
+		.constraints		= {
+			.name		= "DCDC2",
+			.min_uV		= 1800000,
+			.max_uV		= 1800000,
+			.always_on	= 1,
+			.boot_on	= 1,
+		},
+	},
+	{
+		.constraints		= {
+			.name		= "DCDC3",
+			.min_uV		= 3300000,
+			.max_uV		= 3300000,
+			.always_on	= 1,
+			.boot_on	= 1,
+		},
+	},
+	{
+		.constraints		= {
+			.name		= "LDO1",
+			.min_uV		= 4800000,
+			.max_uV		= 4800000,
+			.always_on	= 1,
+			.boot_on	= 1,
+		},
+	},
+	{
+		.constraints		= {
+			.name		= "LDO1",
+			.min_uV		= 3300000,
+			.max_uV		= 3300000,
+			.always_on	= 1,
+			.boot_on	= 1,
+		},
+	},
+	{
+		.num_consumer_supplies	= ARRAY_SIZE(usb_consumers),
+		.consumer_supplies	= usb_consumers,
+		.constraints		= {
+			.name		= "USB",
+			.min_uA		= 200000,
+			.max_uA		= 1000000,
+			.valid_ops_mask	= REGULATOR_CHANGE_CURRENT |
+					  REGULATOR_CHANGE_STATUS,
+		},
+	},
+	{
+		.num_consumer_supplies	= ARRAY_SIZE(lcd_consumers),
+		.consumer_supplies	= lcd_consumers,
+		.constraints		= {
+			.name		= "LCD",
+			.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
+		},
+	},
+};
+
 static struct spi_board_info spi_info[] __initconst = {
+	{
+		.modalias	= "tps6524x",
+		.bus_num	= 1,
+		.chip_select	= 0,
+		.mode		= SPI_MODE_0,
+		.platform_data	= regulators,
+	},
 };
 
 static __init void tnetv107x_evm_board_init(void)
-- 
1.7.0.4

