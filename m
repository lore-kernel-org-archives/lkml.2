Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1HRVvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:51:39 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:36616 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484Ab1HRVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:51:01 -0400
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Cc: James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: davinci: da850, omapl138: share the davinci_uart_config
Date: Thu, 18 Aug 2011 17:50:50 -0400
Message-Id: <69e35d4eac3c4a52d7896bc18c69b4578d1b15b3.1313702401.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the common davinci_uart_config.enabled_uarts=0x7 passed to
davinci_serial_init() from all of the da850/omapl138 boards to the
da850-reference object introduced in a previous commit.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 arch/arm/mach-davinci/board-da850-evm.c            |    6 +-----
 arch/arm/mach-davinci/board-mityomapl138.c         |    6 +-----
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    6 +-----
 arch/arm/mach-davinci/da850-reference.c            |    9 +++++++++
 .../mach-davinci/include/mach/da850-reference.h    |    1 +
 5 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 109b016..18e60e3 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -704,10 +704,6 @@ static struct davinci_i2c_platform_data da850_evm_i2c_0_pdata = {
 	.bus_delay	= 0,	/* usec */
 };
 
-static struct davinci_uart_config da850_evm_uart_config __initdata = {
-	.enabled_uarts = 0x7,
-};
-
 /* davinci da850 evm audio machine driver */
 static u8 da850_iis_serializer_direction[] = {
 	INACTIVE_MODE,	INACTIVE_MODE,	INACTIVE_MODE,	INACTIVE_MODE,
@@ -1174,7 +1170,7 @@ static __init void da850_evm_init(void)
 					" %d\n", ret);
 	}
 
-	davinci_serial_init(&da850_evm_uart_config);
+	da850_reference_serial_init();
 
 	i2c_register_board_info(1, da850_evm_i2c_devices,
 			ARRAY_SIZE(da850_evm_i2c_devices));
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index 998cd2e..d3cd099 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -433,10 +433,6 @@ static void __init mityomapl138_setup_nand(void)
 				 ARRAY_SIZE(mityomapl138_devices));
 }
 
-static struct davinci_uart_config mityomapl138_uart_config __initdata = {
-	.enabled_uarts = 0x7,
-};
-
 static const short mityomap_mii_pins[] = {
 	DA850_MII_TXEN, DA850_MII_TXCLK, DA850_MII_COL, DA850_MII_TXD_3,
 	DA850_MII_TXD_2, DA850_MII_TXD_1, DA850_MII_TXD_0, DA850_MII_RXER,
@@ -516,7 +512,7 @@ static void __init mityomapl138_init(void)
 	if (ret)
 		pr_warning("watchdog registration failed: %d\n", ret);
 
-	davinci_serial_init(&mityomapl138_uart_config);
+	da850_reference_serial_init();
 
 	ret = da8xx_register_i2c(0, &mityomap_i2c_0_pdata);
 	if (ret)
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index 73d826d..d5ead44 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -294,15 +294,11 @@ usb11_setup_oc_fail:
 	gpio_free(DA850_USB1_VBUS_PIN);
 }
 
-static struct davinci_uart_config omapl138_hawk_uart_config __initdata = {
-	.enabled_uarts = 0x7,
-};
-
 static __init void omapl138_hawk_init(void)
 {
 	int ret;
 
-	davinci_serial_init(&omapl138_hawk_uart_config);
+	da850_reference_serial_init();
 
 	omapl138_hawk_config_emac();
 
diff --git a/arch/arm/mach-davinci/da850-reference.c b/arch/arm/mach-davinci/da850-reference.c
index 25df6476..e4f5072 100644
--- a/arch/arm/mach-davinci/da850-reference.c
+++ b/arch/arm/mach-davinci/da850-reference.c
@@ -20,3 +20,12 @@ int da850_reference_add_preferred_console(void)
 {
 	return add_preferred_console("ttyS", 2, "115200");
 }
+
+static struct davinci_uart_config da850_reference_uart_config __initdata = {
+	.enabled_uarts = 0x7,
+};
+
+void da850_reference_serial_init(void)
+{
+	davinci_serial_init(&da850_reference_uart_config);
+}
diff --git a/arch/arm/mach-davinci/include/mach/da850-reference.h b/arch/arm/mach-davinci/include/mach/da850-reference.h
index ed72c53..d6e0b28 100644
--- a/arch/arm/mach-davinci/include/mach/da850-reference.h
+++ b/arch/arm/mach-davinci/include/mach/da850-reference.h
@@ -15,5 +15,6 @@
 
 void __init da850_reference_map_io(void);
 int da850_reference_add_preferred_console(void);
+void da850_reference_serial_init(void);
 
 #endif /* __ASM_ARCH_DAVINCI_DA850_REFERENCE_H */
-- 
1.7.4.1

