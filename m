Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1ARTWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:22:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab1ARTWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:22:39 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net, sameo@linux.intel.com,
        rpurdie@rpsys.net, dbrownell@users.sourceforge.net
Cc: c-park@ti.com, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v8 10/11] davinci: add tnetv107x evm backlight device
Date: Tue, 18 Jan 2011 14:21:44 -0500
Message-Id: <1295378505-15221-11-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295378505-15221-1-git-send-email-cyril@ti.com>
References: <1295378505-15221-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tnetv107x evm board has a backlight device that is connected on one of the
SSP ports.  This patch adds the board definitions necessary to plug the
backlight driver to the GPIO corresponding to this SSP pin.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index e3863dd..ac62de2 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -44,6 +44,7 @@
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
 #define EVM_SPI_CS_GPIO		54
+#define EVM_BACKLIGHT_GPIO	(SSP_GPIO_START + 2)
 
 static int initialize_gpio(int gpio, char *desc)
 {
@@ -353,6 +354,12 @@ static struct spi_board_info spi_info[] __initconst = {
 	},
 };
 
+static struct platform_device backlight_device = {
+	.name		= "tps6116x",
+	.id		= -1,
+	.dev.platform_data = (void *)EVM_BACKLIGHT_GPIO,
+};
+
 static __init void tnetv107x_evm_board_init(void)
 {
 	davinci_cfg_reg_list(sdio1_pins);
@@ -364,6 +371,13 @@ static __init void tnetv107x_evm_board_init(void)
 	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 }
 
+static int __init tnetv107x_evm_late_init(void)
+{
+	platform_device_register(&backlight_device);
+	return 0;
+}
+late_initcall(tnetv107x_evm_late_init);
+
 #ifdef CONFIG_SERIAL_8250_CONSOLE
 static int __init tnetv107x_evm_console_init(void)
 {
-- 
1.7.1

