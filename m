Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab0JZUT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:19:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53568 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab0JZUTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:19:23 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 11/12] davinci: add tnetv107x evm backlight device
Date: Tue, 26 Oct 2010 16:18:27 -0400
Message-Id: <1288124308-14999-12-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288124308-14999-1-git-send-email-cyril@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tnetv107x evm board has a backlight device that is connected on one of the
SSP ports.  This patch adds the board definitions necessary to plug the
backlight driver to the GPIO corresponding to this SSP pin.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index e0acc13..e7f413e 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -45,6 +45,7 @@
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
 #define EVM_SPI_CS_GPIO		54
+#define EVM_BACKLIGHT_GPIO	(SSP_GPIO_START + 2)
 
 static int initialize_gpio(int gpio, char *desc)
 {
@@ -360,6 +361,12 @@ static struct spi_board_info spi_info[] __initconst = {
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
@@ -368,6 +375,8 @@ static __init void tnetv107x_evm_board_init(void)
 
 	tnetv107x_devices_init(&evm_device_info);
 
+	platform_device_register(&backlight_device);
+
 	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 }
 
-- 
1.7.0.4

