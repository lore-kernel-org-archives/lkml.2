Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab1EOLgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:36:04 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59517 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760006Ab1EOLgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:36:00 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 14/15] [orion5x] Refactor mpp code to use common orion platform mpp.
Date: Sun, 15 May 2011 13:32:53 +0200
Message-Id: <1305459174-25517-15-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-orion5x/d2net-setup.c            |   44 +++---
 arch/arm/mach-orion5x/db88f5281-setup.c        |   44 +++---
 arch/arm/mach-orion5x/dns323-setup.c           |  132 ++++++++--------
 arch/arm/mach-orion5x/edmini_v2-setup.c        |   44 +++---
 arch/arm/mach-orion5x/kurobox_pro-setup.c      |   44 +++---
 arch/arm/mach-orion5x/ls-chl-setup.c           |   44 +++---
 arch/arm/mach-orion5x/ls_hgl-setup.c           |   44 +++---
 arch/arm/mach-orion5x/lsmini-setup.c           |   44 +++---
 arch/arm/mach-orion5x/mpp.c                    |  150 ++-----------------
 arch/arm/mach-orion5x/mpp.h                    |  191 +++++++++++++++---------
 arch/arm/mach-orion5x/mss2-setup.c             |   44 +++---
 arch/arm/mach-orion5x/mv2120-setup.c           |   44 +++---
 arch/arm/mach-orion5x/net2big-setup.c          |   44 +++---
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c   |   44 +++---
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c    |   44 +++---
 arch/arm/mach-orion5x/rd88f5182-setup.c        |   44 +++---
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c   |    1 -
 arch/arm/mach-orion5x/terastation_pro2-setup.c |   44 +++---
 arch/arm/mach-orion5x/ts209-setup.c            |   44 +++---
 arch/arm/mach-orion5x/ts409-setup.c            |   44 +++---
 arch/arm/mach-orion5x/ts78xx-setup.c           |   44 +++---
 arch/arm/mach-orion5x/wnr854t-setup.c          |   44 +++---
 arch/arm/mach-orion5x/wrt350n-v2-setup.c       |   44 +++---
 23 files changed, 622 insertions(+), 688 deletions(-)

diff --git a/arch/arm/mach-orion5x/d2net-setup.c b/arch/arm/mach-orion5x/d2net-setup.c
index 4258075..19cf5bf 100644
--- a/arch/arm/mach-orion5x/d2net-setup.c
+++ b/arch/arm/mach-orion5x/d2net-setup.c
@@ -267,28 +267,28 @@ static struct platform_device d2net_gpio_buttons = {
  * General Setup
  ****************************************************************************/
 
-static struct orion5x_mpp_mode d2net_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },	/* Board ID (bit 0) */
-	{  1, MPP_GPIO },	/* Board ID (bit 1) */
-	{  2, MPP_GPIO },	/* Board ID (bit 2) */
-	{  3, MPP_GPIO },	/* SATA 0 power */
-	{  4, MPP_UNUSED },
-	{  5, MPP_GPIO },	/* Fan fail detection */
-	{  6, MPP_GPIO },	/* Red front LED */
-	{  7, MPP_UNUSED },
-	{  8, MPP_GPIO },	/* Rear power switch (on|auto) */
-	{  9, MPP_GPIO },	/* Rear power switch (auto|off) */
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_GPIO },	/* SATA 1 power */
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_SATA_LED },	/* SATA 0 active */
-	{ 15, MPP_SATA_LED },	/* SATA 1 active */
-	{ 16, MPP_GPIO },	/* Blue front LED blink control */
-	{ 17, MPP_UNUSED },
-	{ 18, MPP_GPIO },	/* Front button (0 = Released, 1 = Pushed ) */
-	{ 19, MPP_UNUSED },
-	{ -1 }
+static unsigned int d2net_mpp_modes[] __initdata = {
+	MPP0_GPIO,	/* Board ID (bit 0) */
+	MPP1_GPIO,	/* Board ID (bit 1) */
+	MPP2_GPIO,	/* Board ID (bit 2) */
+	MPP3_GPIO,	/* SATA 0 power */
+	MPP4_UNUSED,
+	MPP5_GPIO,	/* Fan fail detection */
+	MPP6_GPIO,	/* Red front LED */
+	MPP7_UNUSED,
+	MPP8_GPIO,	/* Rear power switch (on|auto) */
+	MPP9_GPIO,	/* Rear power switch (auto|off) */
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_GPIO,	/* SATA 1 power */
+	MPP13_UNUSED,
+	MPP14_SATA_LED,	/* SATA 0 active */
+	MPP15_SATA_LED,	/* SATA 1 active */
+	MPP16_GPIO,	/* Blue front LED blink control */
+	MPP17_UNUSED,
+	MPP18_GPIO,	/* Front button (0 = Released, 1 = Pushed ) */
+	MPP19_UNUSED,
+	0,
 	/* 22: USB port 1 fuse (0 = Fail, 1 = Ok) */
 	/* 23: Blue front LED off */
 	/* 24: Inhibit board power off (0 = Disabled, 1 = Enabled) */
diff --git a/arch/arm/mach-orion5x/db88f5281-setup.c b/arch/arm/mach-orion5x/db88f5281-setup.c
index c10a117..24587b7 100644
--- a/arch/arm/mach-orion5x/db88f5281-setup.c
+++ b/arch/arm/mach-orion5x/db88f5281-setup.c
@@ -298,28 +298,28 @@ static struct i2c_board_info __initdata db88f5281_i2c_rtc = {
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode db88f5281_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* USB Over Current */
-	{  1, MPP_GPIO },		/* USB Vbat input */
-	{  2, MPP_PCI_ARB },		/* PCI_REQn[2] */
-	{  3, MPP_PCI_ARB },		/* PCI_GNTn[2] */
-	{  4, MPP_PCI_ARB },		/* PCI_REQn[3] */
-	{  5, MPP_PCI_ARB },		/* PCI_GNTn[3] */
-	{  6, MPP_GPIO },		/* JP0, CON17.2 */
-	{  7, MPP_GPIO },		/* JP1, CON17.1 */
-	{  8, MPP_GPIO },		/* JP2, CON11.2 */
-	{  9, MPP_GPIO },		/* JP3, CON11.3 */
-	{ 10, MPP_GPIO },		/* RTC int */
-	{ 11, MPP_GPIO },		/* Baud Rate Generator */
-	{ 12, MPP_GPIO },		/* PCI int 1 */
-	{ 13, MPP_GPIO },		/* PCI int 2 */
-	{ 14, MPP_NAND },		/* NAND_REn[2] */
-	{ 15, MPP_NAND },		/* NAND_WEn[2] */
-	{ 16, MPP_UART },		/* UART1_RX */
-	{ 17, MPP_UART },		/* UART1_TX */
-	{ 18, MPP_UART },		/* UART1_CTSn */
-	{ 19, MPP_UART },		/* UART1_RTSn */
-	{ -1 },
+static unsigned int db88f5281_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* USB Over Current */
+	MPP1_GPIO,		/* USB Vbat input */
+	MPP2_PCI_ARB,		/* PCI_REQn[2] */
+	MPP3_PCI_ARB,		/* PCI_GNTn[2] */
+	MPP4_PCI_ARB,		/* PCI_REQn[3] */
+	MPP5_PCI_ARB,		/* PCI_GNTn[3] */
+	MPP6_GPIO,		/* JP0, CON17.2 */
+	MPP7_GPIO,		/* JP1, CON17.1 */
+	MPP8_GPIO,		/* JP2, CON11.2 */
+	MPP9_GPIO,		/* JP3, CON11.3 */
+	MPP10_GPIO,		/* RTC int */
+	MPP11_GPIO,		/* Baud Rate Generator */
+	MPP12_GPIO,		/* PCI int 1 */
+	MPP13_GPIO,		/* PCI int 2 */
+	MPP14_NAND,		/* NAND_REn[2] */
+	MPP15_NAND,		/* NAND_WEn[2] */
+	MPP16_UART,		/* UART1_RX */
+	MPP17_UART,		/* UART1_TX */
+	MPP18_UART,		/* UART1_CTSn */
+	MPP19_UART,		/* UART1_RTSn */
+	0,
 };
 
 static void __init db88f5281_init(void)
diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
index 90ab022..855e0e7 100644
--- a/arch/arm/mach-orion5x/dns323-setup.c
+++ b/arch/arm/mach-orion5x/dns323-setup.c
@@ -385,76 +385,76 @@ static struct mv_sata_platform_data dns323_sata_data = {
 /****************************************************************************
  * General Setup
  */
-static struct orion5x_mpp_mode dns323a_mpp_modes[] __initdata = {
-	{  0, MPP_PCIE_RST_OUTn },
-	{  1, MPP_GPIO },		/* right amber LED (sata ch0) */
-	{  2, MPP_GPIO },		/* left amber LED (sata ch1) */
-	{  3, MPP_UNUSED },
-	{  4, MPP_GPIO },		/* power button LED */
-	{  5, MPP_GPIO },		/* power button LED */
-	{  6, MPP_GPIO },		/* GMT G751-2f overtemp */
-	{  7, MPP_GPIO },		/* M41T80 nIRQ/OUT/SQW */
-	{  8, MPP_GPIO },		/* triggers power off */
-	{  9, MPP_GPIO },		/* power button switch */
-	{ 10, MPP_GPIO },		/* reset button switch */
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_UNUSED },
-	{ 15, MPP_UNUSED },
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_UNUSED },
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int dns323a_mpp_modes[] __initdata = {
+	MPP0_PCIE_RST_OUTn,
+	MPP1_GPIO,		/* right amber LED (sata ch0) */
+	MPP2_GPIO,		/* left amber LED (sata ch1) */
+	MPP3_UNUSED,
+	MPP4_GPIO,		/* power button LED */
+	MPP5_GPIO,		/* power button LED */
+	MPP6_GPIO,		/* GMT G751-2f overtemp */
+	MPP7_GPIO,		/* M41T80 nIRQ/OUT/SQW */
+	MPP8_GPIO,		/* triggers power off */
+	MPP9_GPIO,		/* power button switch */
+	MPP10_GPIO,		/* reset button switch */
+	MPP11_UNUSED,
+	MPP12_UNUSED,
+	MPP13_UNUSED,
+	MPP14_UNUSED,
+	MPP15_UNUSED,
+	MPP16_UNUSED,
+	MPP17_UNUSED,
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
-static struct orion5x_mpp_mode dns323b_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED },
-	{  1, MPP_GPIO },		/* right amber LED (sata ch0) */
-	{  2, MPP_GPIO },		/* left amber LED (sata ch1) */
-	{  3, MPP_GPIO },		/* system up flag */
-	{  4, MPP_GPIO },		/* power button LED */
-	{  5, MPP_GPIO },		/* power button LED */
-	{  6, MPP_GPIO },		/* GMT G751-2f overtemp */
-	{  7, MPP_GPIO },		/* M41T80 nIRQ/OUT/SQW */
-	{  8, MPP_GPIO },		/* triggers power off */
-	{  9, MPP_GPIO },		/* power button switch */
-	{ 10, MPP_GPIO },		/* reset button switch */
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },
-	{ 13, MPP_SATA_LED },
-	{ 14, MPP_SATA_LED },
-	{ 15, MPP_SATA_LED },
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_UNUSED },
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int dns323b_mpp_modes[] __initdata = {
+	MPP0_UNUSED,
+	MPP1_GPIO,		/* right amber LED (sata ch0) */
+	MPP2_GPIO,		/* left amber LED (sata ch1) */
+	MPP3_GPIO,		/* system up flag */
+	MPP4_GPIO,		/* power button LED */
+	MPP5_GPIO,		/* power button LED */
+	MPP6_GPIO,		/* GMT G751-2f overtemp */
+	MPP7_GPIO,		/* M41T80 nIRQ/OUT/SQW */
+	MPP8_GPIO,		/* triggers power off */
+	MPP9_GPIO,		/* power button switch */
+	MPP10_GPIO,		/* reset button switch */
+	MPP11_UNUSED,
+	MPP12_SATA_LED,
+	MPP13_SATA_LED,
+	MPP14_SATA_LED,
+	MPP15_SATA_LED,
+	MPP16_UNUSED,
+	MPP17_UNUSED,
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
-static struct orion5x_mpp_mode dns323c_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* ? input */
-	{  1, MPP_GPIO },		/* input power switch (0 = pressed) */
-	{  2, MPP_GPIO },		/* output power off */
-	{  3, MPP_UNUSED },		/* ? output */
-	{  4, MPP_UNUSED },		/* ? output */
-	{  5, MPP_UNUSED },		/* ? output */
-	{  6, MPP_UNUSED },		/* ? output */
-	{  7, MPP_UNUSED },		/* ? output */
-	{  8, MPP_GPIO },		/* i/o right amber LED */
-	{  9, MPP_GPIO },		/* i/o left amber LED */
-	{ 10, MPP_GPIO },		/* input */
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },
-	{ 13, MPP_SATA_LED },
-	{ 14, MPP_SATA_LED },
-	{ 15, MPP_SATA_LED },
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_GPIO },		/* power button LED */
-	{ 18, MPP_GPIO },		/* fan speed bit 0 */
-	{ 19, MPP_GPIO },		/* fan speed bit 1 */
-	{ -1 },
+static unsigned int dns323c_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* ? input */
+	MPP1_GPIO,		/* input power switch (0 = pressed) */
+	MPP2_GPIO,		/* output power off */
+	MPP3_UNUSED,		/* ? output */
+	MPP4_UNUSED,		/* ? output */
+	MPP5_UNUSED,		/* ? output */
+	MPP6_UNUSED,		/* ? output */
+	MPP7_UNUSED,		/* ? output */
+	MPP8_GPIO,		/* i/o right amber LED */
+	MPP9_GPIO,		/* i/o left amber LED */
+	MPP10_GPIO,		/* input */
+	MPP11_UNUSED,
+	MPP12_SATA_LED,
+	MPP13_SATA_LED,
+	MPP14_SATA_LED,
+	MPP15_SATA_LED,
+	MPP16_UNUSED,
+	MPP17_GPIO,		/* power button LED */
+	MPP18_GPIO,		/* fan speed bit 0 */
+	MPP19_GPIO,		/* fan speed bit 1 */
+	0,
 };
 
 /* Rev C1 Fan speed notes:
diff --git a/arch/arm/mach-orion5x/edmini_v2-setup.c b/arch/arm/mach-orion5x/edmini_v2-setup.c
index d037a90..b67cff0 100644
--- a/arch/arm/mach-orion5x/edmini_v2-setup.c
+++ b/arch/arm/mach-orion5x/edmini_v2-setup.c
@@ -180,31 +180,31 @@ static struct platform_device edmini_v2_gpio_buttons = {
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode edminiv2_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED },
-	{  1, MPP_UNUSED },
-	{  2, MPP_UNUSED },
-	{  3, MPP_GPIO },	/* RTC interrupt */
-	{  4, MPP_UNUSED },
-	{  5, MPP_UNUSED },
-	{  6, MPP_UNUSED },
-	{  7, MPP_UNUSED },
-	{  8, MPP_UNUSED },
-	{  9, MPP_UNUSED },
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },	/* SATA 0 presence */
-	{ 13, MPP_SATA_LED },	/* SATA 1 presence */
-	{ 14, MPP_SATA_LED },	/* SATA 0 active */
-	{ 15, MPP_SATA_LED },	/* SATA 1 active */
+static unsigned int edminiv2_mpp_modes[] __initdata = {
+	MPP0_UNUSED,
+	MPP1_UNUSED,
+	MPP2_UNUSED,
+	MPP3_GPIO,	/* RTC interrupt */
+	MPP4_UNUSED,
+	MPP5_UNUSED,
+	MPP6_UNUSED,
+	MPP7_UNUSED,
+	MPP8_UNUSED,
+	MPP9_UNUSED,
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_SATA_LED,	/* SATA 0 presence */
+	MPP13_SATA_LED,	/* SATA 1 presence */
+	MPP14_SATA_LED,	/* SATA 0 active */
+	MPP15_SATA_LED,	/* SATA 1 active */
 	/* 16: Power LED control (0 = On, 1 = Off) */
-	{ 16, MPP_GPIO },
+	MPP16_GPIO,
 	/* 17: Power LED control select (0 = CPLD, 1 = GPIO16) */
-	{ 17, MPP_GPIO },
+	MPP17_GPIO,
 	/* 18: Power button status (0 = Released, 1 = Pressed) */
-	{ 18, MPP_GPIO },
-	{ 19, MPP_UNUSED },
-	{ -1 }
+	MPP18_GPIO,
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init edmini_v2_init(void)
diff --git a/arch/arm/mach-orion5x/kurobox_pro-setup.c b/arch/arm/mach-orion5x/kurobox_pro-setup.c
index 47497c7..c0eb646 100644
--- a/arch/arm/mach-orion5x/kurobox_pro-setup.c
+++ b/arch/arm/mach-orion5x/kurobox_pro-setup.c
@@ -315,28 +315,28 @@ static void kurobox_pro_power_off(void)
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode kurobox_pro_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED },
-	{  1, MPP_UNUSED },
-	{  2, MPP_GPIO },		/* GPIO Micon */
-	{  3, MPP_GPIO },		/* GPIO Rtc */
-	{  4, MPP_UNUSED },
-	{  5, MPP_UNUSED },
-	{  6, MPP_NAND },		/* NAND Flash REn */
-	{  7, MPP_NAND },		/* NAND Flash WEn */
-	{  8, MPP_UNUSED },
-	{  9, MPP_UNUSED },
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },		/* SATA 0 presence */
-	{ 13, MPP_SATA_LED },		/* SATA 1 presence */
-	{ 14, MPP_SATA_LED },		/* SATA 0 active */
-	{ 15, MPP_SATA_LED },		/* SATA 1 active */
-	{ 16, MPP_UART },		/* UART1 RXD */
-	{ 17, MPP_UART },		/* UART1 TXD */
-	{ 18, MPP_UART },		/* UART1 CTSn */
-	{ 19, MPP_UART },		/* UART1 RTSn */
-	{ -1 },
+static unsigned int kurobox_pro_mpp_modes[] __initdata = {
+	MPP0_UNUSED,
+	MPP1_UNUSED,
+	MPP2_GPIO,		/* GPIO Micon */
+	MPP3_GPIO,		/* GPIO Rtc */
+	MPP4_UNUSED,
+	MPP5_UNUSED,
+	MPP6_NAND,		/* NAND Flash REn */
+	MPP7_NAND,		/* NAND Flash WEn */
+	MPP8_UNUSED,
+	MPP9_UNUSED,
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_SATA_LED,		/* SATA 0 presence */
+	MPP13_SATA_LED,		/* SATA 1 presence */
+	MPP14_SATA_LED,		/* SATA 0 active */
+	MPP15_SATA_LED,		/* SATA 1 active */
+	MPP16_UART,		/* UART1 RXD */
+	MPP17_UART,		/* UART1 TXD */
+	MPP18_UART,		/* UART1 CTSn */
+	MPP19_UART,		/* UART1 RTSn */
+	0,
 };
 
 static void __init kurobox_pro_init(void)
diff --git a/arch/arm/mach-orion5x/ls-chl-setup.c b/arch/arm/mach-orion5x/ls-chl-setup.c
index 6ae12aa..5065803 100644
--- a/arch/arm/mach-orion5x/ls-chl-setup.c
+++ b/arch/arm/mach-orion5x/ls-chl-setup.c
@@ -251,28 +251,28 @@ static struct platform_device lschl_fan_device = {
  * GPIO Data
  ****************************************************************************/
 
-static struct orion5x_mpp_mode lschl_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO }, /* LED POWER */
-	{  1, MPP_GPIO }, /* HDD POWER */
-	{  2, MPP_GPIO }, /* LED ALARM */
-	{  3, MPP_GPIO }, /* LED INFO */
-	{  4, MPP_UNUSED },
-	{  5, MPP_UNUSED },
-	{  6, MPP_GPIO }, /* FAN LOCK */
-	{  7, MPP_GPIO }, /* SW INIT */
-	{  8, MPP_GPIO }, /* SW POWER */
-	{  9, MPP_GPIO }, /* USB POWER */
-	{ 10, MPP_GPIO }, /* SW AUTO POWER */
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_GPIO }, /* FAN HIGH */
-	{ 15, MPP_GPIO }, /* SW FUNC */
-	{ 16, MPP_GPIO }, /* FAN LOW */
-	{ 17, MPP_GPIO }, /* LED FUNC */
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int lschl_mpp_modes[] __initdata = {
+	MPP0_GPIO, /* LED POWER */
+	MPP1_GPIO, /* HDD POWER */
+	MPP2_GPIO, /* LED ALARM */
+	MPP3_GPIO, /* LED INFO */
+	MPP4_UNUSED,
+	MPP5_UNUSED,
+	MPP6_GPIO, /* FAN LOCK */
+	MPP7_GPIO, /* SW INIT */
+	MPP8_GPIO, /* SW POWER */
+	MPP9_GPIO, /* USB POWER */
+	MPP10_GPIO, /* SW AUTO POWER */
+	MPP11_UNUSED,
+	MPP12_UNUSED,
+	MPP13_UNUSED,
+	MPP14_GPIO, /* FAN HIGH */
+	MPP15_GPIO, /* SW FUNC */
+	MPP16_GPIO, /* FAN LOW */
+	MPP17_GPIO, /* LED FUNC */
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init lschl_init(void)
diff --git a/arch/arm/mach-orion5x/ls_hgl-setup.c b/arch/arm/mach-orion5x/ls_hgl-setup.c
index 7adafd7..8503d0a 100644
--- a/arch/arm/mach-orion5x/ls_hgl-setup.c
+++ b/arch/arm/mach-orion5x/ls_hgl-setup.c
@@ -200,28 +200,28 @@ static void ls_hgl_power_off(void)
 
 #define LS_HGL_GPIO_HDD_POWER	1
 
-static struct orion5x_mpp_mode ls_hgl_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO }, /* LED_PWR */
-	{  1, MPP_GPIO }, /* HDD_PWR */
-	{  2, MPP_GPIO }, /* LED_ALARM */
-	{  3, MPP_GPIO }, /* LED_INFO */
-	{  4, MPP_UNUSED },
-	{  5, MPP_UNUSED },
-	{  6, MPP_GPIO }, /* FAN_LCK */
-	{  7, MPP_GPIO }, /* INIT */
-	{  8, MPP_GPIO }, /* POWER */
-	{  9, MPP_GPIO }, /* USB_PWR */
-	{ 10, MPP_GPIO }, /* AUTO_POWER */
-	{ 11, MPP_UNUSED }, /* LED_ETH (dummy) */
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_UNUSED },
-	{ 15, MPP_GPIO }, /* FUNC */
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_GPIO }, /* LED_FUNC */
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int ls_hgl_mpp_modes[] __initdata = {
+	MPP0_GPIO, /* LED_PWR */
+	MPP1_GPIO, /* HDD_PWR */
+	MPP2_GPIO, /* LED_ALARM */
+	MPP3_GPIO, /* LED_INFO */
+	MPP4_UNUSED,
+	MPP5_UNUSED,
+	MPP6_GPIO, /* FAN_LCK */
+	MPP7_GPIO, /* INIT */
+	MPP8_GPIO, /* POWER */
+	MPP9_GPIO, /* USB_PWR */
+	MPP10_GPIO, /* AUTO_POWER */
+	MPP11_UNUSED, /* LED_ETH (dummy) */
+	MPP12_UNUSED,
+	MPP13_UNUSED,
+	MPP14_UNUSED,
+	MPP15_GPIO, /* FUNC */
+	MPP16_UNUSED,
+	MPP17_GPIO, /* LED_FUNC */
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init ls_hgl_init(void)
diff --git a/arch/arm/mach-orion5x/lsmini-setup.c b/arch/arm/mach-orion5x/lsmini-setup.c
index 869958f..9c82723 100644
--- a/arch/arm/mach-orion5x/lsmini-setup.c
+++ b/arch/arm/mach-orion5x/lsmini-setup.c
@@ -201,28 +201,28 @@ static void lsmini_power_off(void)
 #define LSMINI_GPIO_HDD_POWER0	1
 #define LSMINI_GPIO_HDD_POWER1	19
 
-static struct orion5x_mpp_mode lsmini_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED }, /* LED_RESERVE1 (unused) */
-	{  1, MPP_GPIO }, /* HDD_PWR */
-	{  2, MPP_GPIO }, /* LED_ALARM */
-	{  3, MPP_GPIO }, /* LED_INFO */
-	{  4, MPP_UNUSED },
-	{  5, MPP_UNUSED },
-	{  6, MPP_UNUSED },
-	{  7, MPP_UNUSED },
-	{  8, MPP_UNUSED },
-	{  9, MPP_GPIO }, /* LED_FUNC */
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED }, /* LED_ETH (dummy) */
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_GPIO }, /* LED_PWR */
-	{ 15, MPP_GPIO }, /* FUNC */
-	{ 16, MPP_GPIO }, /* USB_PWR */
-	{ 17, MPP_GPIO }, /* AUTO_POWER */
-	{ 18, MPP_GPIO }, /* POWER */
-	{ 19, MPP_GPIO }, /* HDD_PWR1 */
-	{ -1 },
+static unsigned int lsmini_mpp_modes[] __initdata = {
+	MPP0_UNUSED, /* LED_RESERVE1 (unused) */
+	MPP1_GPIO, /* HDD_PWR */
+	MPP2_GPIO, /* LED_ALARM */
+	MPP3_GPIO, /* LED_INFO */
+	MPP4_UNUSED,
+	MPP5_UNUSED,
+	MPP6_UNUSED,
+	MPP7_UNUSED,
+	MPP8_UNUSED,
+	MPP9_GPIO, /* LED_FUNC */
+	MPP10_UNUSED,
+	MPP11_UNUSED, /* LED_ETH (dummy) */
+	MPP12_UNUSED,
+	MPP13_UNUSED,
+	MPP14_GPIO, /* LED_PWR */
+	MPP15_GPIO, /* FUNC */
+	MPP16_GPIO, /* USB_PWR */
+	MPP17_GPIO, /* AUTO_POWER */
+	MPP18_GPIO, /* POWER */
+	MPP19_GPIO, /* HDD_PWR1 */
+	0,
 };
 
 static void __init lsmini_init(void)
diff --git a/arch/arm/mach-orion5x/mpp.c b/arch/arm/mach-orion5x/mpp.c
index 2288207..f12c41b 100644
--- a/arch/arm/mach-orion5x/mpp.c
+++ b/arch/arm/mach-orion5x/mpp.c
@@ -12,154 +12,34 @@
 #include <linux/init.h>
 #include <linux/mbus.h>
 #include <linux/io.h>
-#include <asm/gpio.h>
 #include <mach/hardware.h>
-#include "common.h"
+#include <plat/mpp.h>
 #include "mpp.h"
+#include "common.h"
 
-static int is_5181l(void)
-{
-	u32 dev;
-	u32 rev;
-
-	orion5x_pcie_id(&dev, &rev);
-
-	return !!(dev == MV88F5181_DEV_ID && rev >= MV88F5181L_REV_A0);
-}
-
-static int is_5182(void)
+static unsigned int __init orion5x_variant(void)
 {
 	u32 dev;
 	u32 rev;
 
 	orion5x_pcie_id(&dev, &rev);
 
-	return !!(dev == MV88F5182_DEV_ID);
-}
+	if (dev == MV88F5181_DEV_ID && rev >= MV88F5181L_REV_A0)
+		return MPP_F5181_MASK;
 
-static int is_5281(void)
-{
-	u32 dev;
-	u32 rev;
+	if (dev == MV88F5182_DEV_ID)
+		return MPP_F5182_MASK;
 
-	orion5x_pcie_id(&dev, &rev);
+	if (dev == MV88F5281_DEV_ID)
+		return MPP_F5281_MASK;
 
-	return !!(dev == MV88F5281_DEV_ID);
+	printk(KERN_ERR "MPP setup: unknown orion5x variant "
+	       "(dev %#x rev %#x)\n", dev, rev);
+	return 0;
 }
 
-static int __init determine_type_encoding(int mpp, enum orion5x_mpp_type type)
+void __init orion5x_mpp_conf(unsigned int *mpp_list)
 {
-	switch (type) {
-	case MPP_UNUSED:
-	case MPP_GPIO:
-		if (mpp == 0)
-			return 3;
-		if (mpp >= 1 && mpp <= 15)
-			return 0;
-		if (mpp >= 16 && mpp <= 19) {
-			if (is_5182())
-				return 5;
-			if (type == MPP_UNUSED)
-				return 0;
-		}
-		return -1;
-
-	case MPP_PCIE_RST_OUTn:
-		if (mpp == 0)
-			return 0;
-		return -1;
-
-	case MPP_PCI_ARB:
-		if (mpp >= 0 && mpp <= 7)
-			return 2;
-		return -1;
-
-	case MPP_PCI_PMEn:
-		if (mpp == 2)
-			return 3;
-		return -1;
-
-	case MPP_GIGE:
-		if (mpp >= 8 && mpp <= 19)
-			return 1;
-		return -1;
-
-	case MPP_NAND:
-		if (is_5182() || is_5281()) {
-			if (mpp >= 4 && mpp <= 7)
-				return 4;
-			if (mpp >= 12 && mpp <= 17)
-				return 4;
-		}
-		return -1;
-
-	case MPP_PCI_CLK:
-		if (is_5181l() && mpp >= 6 && mpp <= 7)
-			return 5;
-		return -1;
-
-	case MPP_SATA_LED:
-		if (is_5182()) {
-			if (mpp >= 4 && mpp <= 7)
-				return 5;
-			if (mpp >= 12 && mpp <= 15)
-				return 5;
-		}
-		return -1;
-
-	case MPP_UART:
-		if (mpp >= 16 && mpp <= 19)
-			return 0;
-		return -1;
-	}
-
-	printk(KERN_INFO "unknown MPP type %d\n", type);
-
-	return -1;
-}
-
-void __init orion5x_mpp_conf(struct orion5x_mpp_mode *mode)
-{
-	u32 mpp_0_7_ctrl = readl(MPP_0_7_CTRL);
-	u32 mpp_8_15_ctrl = readl(MPP_8_15_CTRL);
-	u32 mpp_16_19_ctrl = readl(MPP_16_19_CTRL);
-
-	for ( ; mode->mpp >= 0; mode++) {
-		u32 *reg;
-		int num_type;
-		int shift;
-
-		if (mode->mpp >= 0 && mode->mpp <= 7)
-			reg = &mpp_0_7_ctrl;
-		else if (mode->mpp >= 8 && mode->mpp <= 15)
-			reg = &mpp_8_15_ctrl;
-		else if (mode->mpp >= 16 && mode->mpp <= 19)
-			reg = &mpp_16_19_ctrl;
-		else {
-			printk(KERN_ERR "orion5x_mpp_conf: invalid MPP "
-					"(%d)\n", mode->mpp);
-			continue;
-		}
-
-		num_type = determine_type_encoding(mode->mpp, mode->type);
-		if (num_type < 0) {
-			printk(KERN_ERR "orion5x_mpp_conf: invalid MPP "
-					"combination (%d, %d)\n", mode->mpp,
-					mode->type);
-			continue;
-		}
-
-		shift = (mode->mpp & 7) << 2;
-		*reg &= ~(0xf << shift);
-		*reg |= (num_type & 0xf) << shift;
-
-		if (mode->type == MPP_UNUSED && (mode->mpp < 16 || is_5182()))
-			orion_gpio_set_unused(mode->mpp);
-
-		orion_gpio_set_valid(mode->mpp, !!(mode->type == MPP_GPIO));
-	}
-
-	writel(mpp_0_7_ctrl, MPP_0_7_CTRL);
-	writel(mpp_8_15_ctrl, MPP_8_15_CTRL);
-	writel(mpp_16_19_ctrl, MPP_16_19_CTRL);
+	orion_mpp_conf(mpp_list, orion5x_variant(),
+		       MPP_MAX, ORION5X_DEV_BUS_VIRT_BASE);
 }
diff --git a/arch/arm/mach-orion5x/mpp.h b/arch/arm/mach-orion5x/mpp.h
index 290e610..eac6897 100644
--- a/arch/arm/mach-orion5x/mpp.h
+++ b/arch/arm/mach-orion5x/mpp.h
@@ -1,74 +1,129 @@
 #ifndef __ARCH_ORION5X_MPP_H
 #define __ARCH_ORION5X_MPP_H
 
-enum orion5x_mpp_type {
-	/*
-	 * This MPP is unused.
-	 */
-	MPP_UNUSED,
-
-	/*
-	 * This MPP pin is used as a generic GPIO pin.  Valid for
-	 * MPPs 0-15 and device bus data pins 16-31.  On 5182, also
-	 * valid for MPPs 16-19.
-	 */
-	MPP_GPIO,
-
-	/*
-	 * This MPP is used as PCIe_RST_OUTn pin.  Valid for
-	 * MPP 0 only.
-	 */
-	MPP_PCIE_RST_OUTn,
-
-	/*
-	 * This MPP is used as PCI arbiter pin (REQn/GNTn).
-	 * Valid for MPPs 0-7 only.
-	 */
-	MPP_PCI_ARB,
-
-	/*
-	 * This MPP is used as PCI_PMEn pin.  Valid for MPP 2 only.
-	 */
-	MPP_PCI_PMEn,
-
-	/*
-	 * This MPP is used as GigE half-duplex (COL, CRS) or GMII
-	 * (RXERR, CRS, TXERR, TXD[7:4], RXD[7:4]) pin.  Valid for
-	 * MPPs 8-19 only.
-	 */
-	MPP_GIGE,
-
-	/*
-	 * This MPP is used as NAND REn/WEn pin.  Valid for MPPs
-	 * 4-7 and 12-17 only, and only on the 5181l/5182/5281.
-	 */
-	MPP_NAND,
-
-	/*
-	 * This MPP is used as a PCI clock output pin.  Valid for
-	 * MPPs 6-7 only, and only on the 5181l.
-	 */
-	MPP_PCI_CLK,
-
-	/*
-	 * This MPP is used as a SATA presence/activity LED.
-	 * Valid for MPPs 4-7 and 12-15 only, and only on the 5182.
-	 */
-	MPP_SATA_LED,
-
-	/*
-	 * This MPP is used as UART1 RXD/TXD/CTSn/RTSn pin.
-	 * Valid for MPPs 16-19 only.
-	 */
-	MPP_UART,
-};
-
-struct orion5x_mpp_mode {
-	int			mpp;
-	enum orion5x_mpp_type	type;
-};
-
-void orion5x_mpp_conf(struct orion5x_mpp_mode *mode);
+#define MPP(_num, _sel, _in, _out, _F5181l, _F5182, _F5281) ( \
+	/* MPP number */		((_num) & 0xff) | \
+	/* MPP select value */		(((_sel) & 0xf) << 8) | \
+	/* may be input signal */	((!!(_in)) << 12) | \
+	/* may be output signal */	((!!(_out)) << 13) | \
+	/* available on F5181l */	((!!(_F5181l)) << 14) | \
+	/* available on F5182 */	((!!(_F5182)) << 15) | \
+	/* available on F5281 */	((!!(_F5281)) << 16))
 
+				/* num sel  i  o  5181 5182 5281 */
+
+#define MPP_F5181_MASK		MPP(0,  0x0, 0, 0, 1,   0,   0)
+#define MPP_F5182_MASK		MPP(0,  0x0, 0, 0, 0,   1,   0)
+#define MPP_F5281_MASK		MPP(0,  0x0, 0, 0, 0,   0,   1)
+
+#define MPP0_UNUSED	        MPP(0,  0x3, 0, 0, 1,   1,   1)
+#define MPP0_GPIO		MPP(0,  0x3, 1, 1, 1,   1,   1)
+#define MPP0_PCIE_RST_OUTn	MPP(0,  0x0, 0, 0, 1,   1,   1)
+#define MPP0_PCI_ARB            MPP(0,  0x2, 0, 0, 1,   1,   1)
+
+#define MPP1_UNUSED		MPP(1,  0x0, 0, 0, 1,   1,   1)
+#define MPP1_GPIO		MPP(1,  0x0, 1, 1, 1,   1,   1)
+#define MPP1_PCI_ARB            MPP(1,  0x2, 0, 0, 1,   1,   1)
+
+#define MPP2_UNUSED		MPP(2,  0x0, 0, 0, 1,   1,   1)
+#define MPP2_GPIO		MPP(2,  0x0, 1, 1, 1,   1,   1)
+#define MPP2_PCI_ARB            MPP(2,  0x2, 0, 0, 1,   1,   1)
+#define MPP2_PCI_PMEn           MPP(2,  0x3, 0, 0, 1,   1,   1)
+
+#define MPP3_UNUSED		MPP(3,  0x0, 0, 0, 1,   1,   1)
+#define MPP3_GPIO		MPP(3,  0x0, 1, 1, 1,   1,   1)
+#define MPP3_PCI_ARB            MPP(3,  0x2, 0, 0, 1,   1,   1)
+
+#define MPP4_UNUSED		MPP(4,  0x0, 0, 0, 1,   1,   1)
+#define MPP4_GPIO		MPP(4,  0x0, 1, 1, 1,   1,   1)
+#define MPP4_PCI_ARB            MPP(4,  0x2, 0, 0, 1,   1,   1)
+#define MPP4_NAND               MPP(4,  0x4, 0, 0, 0,   1,   1)
+#define MPP4_SATA_LED           MPP(4,  0x5, 0, 0, 0,   1,   0)
+
+#define MPP5_UNUSED		MPP(5,  0x0, 0, 0, 1,   1,   1)
+#define MPP5_GPIO		MPP(5,  0x0, 1, 1, 1,   1,   1)
+#define MPP5_PCI_ARB            MPP(5,  0x2, 0, 0, 1,   1,   1)
+#define MPP5_NAND               MPP(5,  0x4, 0, 0, 0,   1,   1)
+#define MPP5_SATA_LED           MPP(5,  0x5, 0, 0, 0,   1,   0)
+
+#define MPP6_UNUSED		MPP(6,  0x0, 0, 0, 1,   1,   1)
+#define MPP6_GPIO		MPP(6,  0x0, 1, 1, 1,   1,   1)
+#define MPP6_PCI_ARB            MPP(6,  0x2, 0, 0, 1,   1,   1)
+#define MPP6_NAND               MPP(6,  0x4, 0, 0, 0,   1,   1)
+#define MPP6_PCI_CLK            MPP(6,  0x5, 0, 0, 1,   0,   0)
+#define MPP6_SATA_LED           MPP(6,  0x5, 0, 0, 0,   1,   0)
+
+#define MPP7_UNUSED		MPP(7,  0x0, 0, 0, 1,   1,   1)
+#define MPP7_GPIO		MPP(7,  0x0, 1, 1, 1,   1,   1)
+#define MPP7_PCI_ARB            MPP(7,  0x2, 0, 0, 1,   1,   1)
+#define MPP7_NAND               MPP(7,  0x4, 0, 0, 0,   1,   1)
+#define MPP7_PCI_CLK            MPP(7,  0x5, 0, 0, 1,   0,   0)
+#define MPP7_SATA_LED           MPP(7,  0x5, 0, 0, 0,   1,   0)
+
+#define MPP8_UNUSED		MPP(8,  0x0, 0, 0, 1,   1,   1)
+#define MPP8_GPIO		MPP(8,  0x0, 1, 1, 1,   1,   1)
+#define MPP8_GIGE               MPP(8,  0x1, 0, 0, 1,   1,   1)
+
+#define MPP9_UNUSED		MPP(9,  0x0, 0, 0, 1,   1,   1)
+#define MPP9_GPIO		MPP(9,  0x0, 0, 0, 1,   1,   1)
+#define MPP9_GIGE               MPP(9,  0x1, 1, 1, 1,   1,   1)
+
+#define MPP10_UNUSED		MPP(10, 0x0, 0, 0, 1,   1,   1)
+#define MPP10_GPIO		MPP(10, 0x0, 1, 1, 1,   1,   1)
+#define MPP10_GIGE              MPP(10, 0x1, 0, 0, 1,   1,   1)
+
+#define MPP11_UNUSED		MPP(11, 0x0, 0, 0, 1,   1,   1)
+#define MPP11_GPIO		MPP(11, 0x0, 1, 1, 1,   1,   1)
+#define MPP11_GIGE              MPP(11, 0x1, 0, 0, 1,   1,   1)
+
+#define MPP12_UNUSED		MPP(12, 0x0, 0, 0, 1,   1,   1)
+#define MPP12_GPIO		MPP(12, 0x0, 1, 1, 1,   1,   1)
+#define MPP12_GIGE              MPP(12, 0x1, 0, 0, 1,   1,   1)
+#define MPP12_NAND              MPP(12, 0x4, 0, 0, 0,   1,   1)
+#define MPP12_SATA_LED          MPP(12, 0x5, 0, 0, 0,   1,   0)
+
+#define MPP13_UNUSED		MPP(13, 0x0, 0, 0, 1,   1,   1)
+#define MPP13_GPIO		MPP(13, 0x0, 1, 1, 1,   1,   1)
+#define MPP13_GIGE              MPP(13, 0x1, 0, 0, 1,   1,   1)
+#define MPP13_NAND              MPP(13, 0x4, 0, 0, 0,   1,   1)
+#define MPP13_SATA_LED          MPP(13, 0x5, 0, 0, 0,   1,   0)
+
+#define MPP14_UNUSED		MPP(14, 0x0, 0, 0, 1,   1,   1)
+#define MPP14_GPIO		MPP(14, 0x0, 1, 1, 1,   1,   1)
+#define MPP14_GIGE              MPP(14, 0x1, 0, 0, 1,   1,   1)
+#define MPP14_NAND              MPP(14, 0x4, 0, 0, 0,   1,   1)
+#define MPP14_SATA_LED          MPP(14, 0x5, 0, 0, 0,   1,   0)
+
+#define MPP15_UNUSED		MPP(15, 0x0, 0, 0, 1,   1,   1)
+#define MPP15_GPIO		MPP(15, 0x0, 1, 1, 1,   1,   1)
+#define MPP15_GIGE              MPP(15, 0x1, 0, 0, 1,   1,   1)
+#define MPP15_NAND              MPP(15, 0x4, 0, 0, 0,   1,   1)
+#define MPP15_SATA_LED          MPP(15, 0x5, 0, 0, 0,   1,   0)
+
+#define MPP16_UNUSED		MPP(16, 0x0, 0, 0, 1,   1,   1)
+#define MPP16_GPIO		MPP(16, 0x5, 1, 1, 0,   1,   0)
+#define MPP16_GIGE              MPP(16, 0x1, 0, 0, 1,   1,   1)
+#define MPP16_NAND              MPP(16, 0x4, 0, 0, 0,   1,   1)
+#define MPP16_UART              MPP(16, 0x0, 0, 0, 0,   1,   1)
+
+#define MPP17_UNUSED		MPP(17, 0x0, 0, 0, 1,   1,   1)
+#define MPP17_GPIO		MPP(17, 0x5, 1, 1, 0,   1,   0)
+#define MPP17_GIGE              MPP(17, 0x1, 0, 0, 1,   1,   1)
+#define MPP17_NAND              MPP(17, 0x4, 0, 0, 0,   1,   1)
+#define MPP17_UART              MPP(17, 0x0, 0, 0, 0,   1,   1)
+
+#define MPP18_UNUSED		MPP(18, 0x0, 0, 0, 1,   1,   1)
+#define MPP18_GPIO		MPP(18, 0x5, 1, 1, 0,   1,   0)
+#define MPP18_GIGE              MPP(18, 0x1, 0, 0, 1,   1,   1)
+#define MPP18_UART              MPP(18, 0x0, 0, 0, 0,   1,   1)
+
+#define MPP19_UNUSED		MPP(19, 0x0, 0, 0, 1,   1,   1)
+#define MPP19_GPIO		MPP(19, 0x5, 1, 1, 0,   1,   0)
+#define MPP19_GIGE              MPP(19, 0x1, 0, 0, 1,   1,   1)
+#define MPP19_UART              MPP(19, 0x0, 0, 0, 0,   1,   1)
+
+#define MPP_MAX			19
+
+void orion5x_mpp_conf(unsigned int *mpp_list);
 
 #endif
diff --git a/arch/arm/mach-orion5x/mss2-setup.c b/arch/arm/mach-orion5x/mss2-setup.c
index b43b208..59263b7 100644
--- a/arch/arm/mach-orion5x/mss2-setup.c
+++ b/arch/arm/mach-orion5x/mss2-setup.c
@@ -193,28 +193,28 @@ static void mss2_power_off(void)
 /****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode mss2_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* Power LED */
-	{  1, MPP_GPIO },		/* Error LED */
-	{  2, MPP_UNUSED },
-	{  3, MPP_GPIO },		/* RTC interrupt */
-	{  4, MPP_GPIO },		/* HDD ind. (Single/Dual)*/
-	{  5, MPP_GPIO },		/* HD0 5V control */
-	{  6, MPP_GPIO },		/* HD0 12V control */
-	{  7, MPP_GPIO },		/* HD1 5V control */
-	{  8, MPP_GPIO },		/* HD1 12V control */
-	{  9, MPP_UNUSED },
-	{ 10, MPP_GPIO },		/* Fan control */
-	{ 11, MPP_GPIO },		/* Power button */
-	{ 12, MPP_GPIO },		/* Reset button */
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_SATA_LED },		/* SATA 0 active */
-	{ 15, MPP_SATA_LED },		/* SATA 1 active */
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_UNUSED },
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int mss2_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* Power LED */
+	MPP1_GPIO,		/* Error LED */
+	MPP2_UNUSED,
+	MPP3_GPIO,		/* RTC interrupt */
+	MPP4_GPIO,		/* HDD ind. (Single/Dual)*/
+	MPP5_GPIO,		/* HD0 5V control */
+	MPP6_GPIO,		/* HD0 12V control */
+	MPP7_GPIO,		/* HD1 5V control */
+	MPP8_GPIO,		/* HD1 12V control */
+	MPP9_UNUSED,
+	MPP10_GPIO,		/* Fan control */
+	MPP11_GPIO,		/* Power button */
+	MPP12_GPIO,		/* Reset button */
+	MPP13_UNUSED,
+	MPP14_SATA_LED,		/* SATA 0 active */
+	MPP15_SATA_LED,		/* SATA 1 active */
+	MPP16_UNUSED,
+	MPP17_UNUSED,
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init mss2_init(void)
diff --git a/arch/arm/mach-orion5x/mv2120-setup.c b/arch/arm/mach-orion5x/mv2120-setup.c
index c55d071..63ff10c 100644
--- a/arch/arm/mach-orion5x/mv2120-setup.c
+++ b/arch/arm/mach-orion5x/mv2120-setup.c
@@ -108,28 +108,28 @@ static struct platform_device mv2120_button_device = {
 /****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode mv2120_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* Sys status LED */
-	{  1, MPP_GPIO },		/* Sys error LED */
-	{  2, MPP_GPIO },		/* OverTemp interrupt */
-	{  3, MPP_GPIO },		/* RTC interrupt */
-	{  4, MPP_GPIO },		/* V_LED 5V */
-	{  5, MPP_GPIO },		/* V_LED 3.3V */
-	{  6, MPP_UNUSED },
-	{  7, MPP_UNUSED },
-	{  8, MPP_GPIO },		/* SATA 0 fail LED */
-	{  9, MPP_GPIO },		/* SATA 1 fail LED */
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },		/* SATA 0 presence */
-	{ 13, MPP_SATA_LED },		/* SATA 1 presence */
-	{ 14, MPP_SATA_LED },		/* SATA 0 active */
-	{ 15, MPP_SATA_LED },		/* SATA 1 active */
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_GPIO },		/* Reset button */
-	{ 18, MPP_GPIO },		/* Power button */
-	{ 19, MPP_GPIO },		/* Power off */
-	{ -1 },
+static unsigned int mv2120_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* Sys status LED */
+	MPP1_GPIO,		/* Sys error LED */
+	MPP2_GPIO,		/* OverTemp interrupt */
+	MPP3_GPIO,		/* RTC interrupt */
+	MPP4_GPIO,		/* V_LED 5V */
+	MPP5_GPIO,		/* V_LED 3.3V */
+	MPP6_UNUSED,
+	MPP7_UNUSED,
+	MPP8_GPIO,		/* SATA 0 fail LED */
+	MPP9_GPIO,		/* SATA 1 fail LED */
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_SATA_LED,		/* SATA 0 presence */
+	MPP13_SATA_LED,		/* SATA 1 presence */
+	MPP14_SATA_LED,		/* SATA 0 active */
+	MPP15_SATA_LED,		/* SATA 1 active */
+	MPP16_UNUSED,
+	MPP17_GPIO,		/* Reset button */
+	MPP18_GPIO,		/* Power button */
+	MPP19_GPIO,		/* Power off */
+	0,
 };
 
 static struct i2c_board_info __initdata mv2120_i2c_rtc = {
diff --git a/arch/arm/mach-orion5x/net2big-setup.c b/arch/arm/mach-orion5x/net2big-setup.c
index 429ecaf..a9609b0 100644
--- a/arch/arm/mach-orion5x/net2big-setup.c
+++ b/arch/arm/mach-orion5x/net2big-setup.c
@@ -339,28 +339,28 @@ static struct platform_device net2big_gpio_buttons = {
  * General Setup
  ****************************************************************************/
 
-static struct orion5x_mpp_mode net2big_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },	/* Raid mode (bit 0) */
-	{  1, MPP_GPIO },	/* USB port 2 fuse (0 = Fail, 1 = Ok) */
-	{  2, MPP_GPIO },	/* Raid mode (bit 1) */
-	{  3, MPP_GPIO },	/* Board ID (bit 0) */
-	{  4, MPP_GPIO },	/* Fan activity (0 = Off, 1 = On) */
-	{  5, MPP_GPIO },	/* Fan fail detection */
-	{  6, MPP_GPIO },	/* Red front LED (0 = Off, 1 = On) */
-	{  7, MPP_GPIO },	/* Disable initial blinking on front LED */
-	{  8, MPP_GPIO },	/* Rear power switch (on|auto) */
-	{  9, MPP_GPIO },	/* Rear power switch (auto|off) */
-	{ 10, MPP_GPIO },	/* SATA 1 red LED (0 = Off, 1 = On) */
-	{ 11, MPP_GPIO },	/* SATA 0 red LED (0 = Off, 1 = On) */
-	{ 12, MPP_GPIO },	/* Board ID (bit 1) */
-	{ 13, MPP_GPIO },	/* SATA 1 blue LED blink control */
-	{ 14, MPP_SATA_LED },
-	{ 15, MPP_SATA_LED },
-	{ 16, MPP_GPIO },	/* Blue front LED control */
-	{ 17, MPP_GPIO },	/* SATA 0 blue LED blink control */
-	{ 18, MPP_GPIO },	/* Front button (0 = Released, 1 = Pushed ) */
-	{ 19, MPP_GPIO },	/* SATA{0,1} power On/Off request */
-	{ -1 }
+static unsigned int net2big_mpp_modes[] __initdata = {
+	MPP0_GPIO,	/* Raid mode (bit 0) */
+	MPP1_GPIO,	/* USB port 2 fuse (0 = Fail, 1 = Ok) */
+	MPP2_GPIO,	/* Raid mode (bit 1) */
+	MPP3_GPIO,	/* Board ID (bit 0) */
+	MPP4_GPIO,	/* Fan activity (0 = Off, 1 = On) */
+	MPP5_GPIO,	/* Fan fail detection */
+	MPP6_GPIO,	/* Red front LED (0 = Off, 1 = On) */
+	MPP7_GPIO,	/* Disable initial blinking on front LED */
+	MPP8_GPIO,	/* Rear power switch (on|auto) */
+	MPP9_GPIO,	/* Rear power switch (auto|off) */
+	MPP10_GPIO,	/* SATA 1 red LED (0 = Off, 1 = On) */
+	MPP11_GPIO,	/* SATA 0 red LED (0 = Off, 1 = On) */
+	MPP12_GPIO,	/* Board ID (bit 1) */
+	MPP13_GPIO,	/* SATA 1 blue LED blink control */
+	MPP14_SATA_LED,
+	MPP15_SATA_LED,
+	MPP16_GPIO,	/* Blue front LED control */
+	MPP17_GPIO,	/* SATA 0 blue LED blink control */
+	MPP18_GPIO,	/* Front button (0 = Released, 1 = Pushed ) */
+	MPP19_GPIO,	/* SATA{0,1} power On/Off request */
+	0,
 	/* 22: USB port 1 fuse (0 = Fail, 1 = Ok) */
 	/* 23: SATA 0 power status */
 	/* 24: Board power off */
diff --git a/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c b/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
index 34310ab..9eec7c2 100644
--- a/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
@@ -64,28 +64,28 @@ static struct platform_device rd88f5181l_fxo_nor_boot_flash = {
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode rd88f5181l_fxo_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* LED1 CardBus LED (front panel) */
-	{  1, MPP_GPIO },		/* PCI_intA */
-	{  2, MPP_GPIO },		/* Hard Reset / Factory Init*/
-	{  3, MPP_GPIO },		/* FXS or DAA select */
-	{  4, MPP_GPIO },		/* LED6 - phone LED (front panel) */
-	{  5, MPP_GPIO },		/* LED5 - phone LED (front panel) */
-	{  6, MPP_PCI_CLK },		/* CPU PCI refclk */
-	{  7, MPP_PCI_CLK },		/* PCI/PCIe refclk */
-	{  8, MPP_GPIO },		/* CardBus reset */
-	{  9, MPP_GPIO },		/* GE_RXERR */
-	{ 10, MPP_GPIO },		/* LED2 MiniPCI LED (front panel) */
-	{ 11, MPP_GPIO },		/* Lifeline control */
-	{ 12, MPP_GIGE },		/* GE_TXD[4] */
-	{ 13, MPP_GIGE },		/* GE_TXD[5] */
-	{ 14, MPP_GIGE },		/* GE_TXD[6] */
-	{ 15, MPP_GIGE },		/* GE_TXD[7] */
-	{ 16, MPP_GIGE },		/* GE_RXD[4] */
-	{ 17, MPP_GIGE },		/* GE_RXD[5] */
-	{ 18, MPP_GIGE },		/* GE_RXD[6] */
-	{ 19, MPP_GIGE },		/* GE_RXD[7] */
-	{ -1 },
+static unsigned int rd88f5181l_fxo_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* LED1 CardBus LED (front panel) */
+	MPP1_GPIO,		/* PCI_intA */
+	MPP2_GPIO,		/* Hard Reset / Factory Init*/
+	MPP3_GPIO,		/* FXS or DAA select */
+	MPP4_GPIO,		/* LED6 - phone LED (front panel) */
+	MPP5_GPIO,		/* LED5 - phone LED (front panel) */
+	MPP6_PCI_CLK,		/* CPU PCI refclk */
+	MPP7_PCI_CLK,		/* PCI/PCIe refclk */
+	MPP8_GPIO,		/* CardBus reset */
+	MPP9_GPIO,		/* GE_RXERR */
+	MPP10_GPIO,		/* LED2 MiniPCI LED (front panel) */
+	MPP11_GPIO,		/* Lifeline control */
+	MPP12_GIGE,		/* GE_TXD[4] */
+	MPP13_GIGE,		/* GE_TXD[5] */
+	MPP14_GIGE,		/* GE_TXD[6] */
+	MPP15_GIGE,		/* GE_TXD[7] */
+	MPP16_GIGE,		/* GE_RXD[4] */
+	MPP17_GIGE,		/* GE_RXD[5] */
+	MPP18_GIGE,		/* GE_RXD[6] */
+	MPP19_GIGE,		/* GE_RXD[7] */
+	0,
 };
 
 static struct mv643xx_eth_platform_data rd88f5181l_fxo_eth_data = {
diff --git a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
index c1f79fa..0cc90bb 100644
--- a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
@@ -65,28 +65,28 @@ static struct platform_device rd88f5181l_ge_nor_boot_flash = {
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode rd88f5181l_ge_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* LED1 */
-	{  1, MPP_GPIO },		/* LED5 */
-	{  2, MPP_GPIO },		/* LED4 */
-	{  3, MPP_GPIO },		/* LED3 */
-	{  4, MPP_GPIO },		/* PCI_intA */
-	{  5, MPP_GPIO },		/* RTC interrupt */
-	{  6, MPP_PCI_CLK },		/* CPU PCI refclk */
-	{  7, MPP_PCI_CLK },		/* PCI/PCIe refclk */
-	{  8, MPP_GPIO },		/* 88e6131 interrupt */
-	{  9, MPP_GPIO },		/* GE_RXERR */
-	{ 10, MPP_GPIO },		/* PCI_intB */
-	{ 11, MPP_GPIO },		/* LED2 */
-	{ 12, MPP_GIGE },		/* GE_TXD[4] */
-	{ 13, MPP_GIGE },		/* GE_TXD[5] */
-	{ 14, MPP_GIGE },		/* GE_TXD[6] */
-	{ 15, MPP_GIGE },		/* GE_TXD[7] */
-	{ 16, MPP_GIGE },		/* GE_RXD[4] */
-	{ 17, MPP_GIGE },		/* GE_RXD[5] */
-	{ 18, MPP_GIGE },		/* GE_RXD[6] */
-	{ 19, MPP_GIGE },		/* GE_RXD[7] */
-	{ -1 },
+static unsigned int rd88f5181l_ge_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* LED1 */
+	MPP1_GPIO,		/* LED5 */
+	MPP2_GPIO,		/* LED4 */
+	MPP3_GPIO,		/* LED3 */
+	MPP4_GPIO,		/* PCI_intA */
+	MPP5_GPIO,		/* RTC interrupt */
+	MPP6_PCI_CLK,		/* CPU PCI refclk */
+	MPP7_PCI_CLK,		/* PCI/PCIe refclk */
+	MPP8_GPIO,		/* 88e6131 interrupt */
+	MPP9_GPIO,		/* GE_RXERR */
+	MPP10_GPIO,		/* PCI_intB */
+	MPP11_GPIO,		/* LED2 */
+	MPP12_GIGE,		/* GE_TXD[4] */
+	MPP13_GIGE,		/* GE_TXD[5] */
+	MPP14_GIGE,		/* GE_TXD[6] */
+	MPP15_GIGE,		/* GE_TXD[7] */
+	MPP16_GIGE,		/* GE_RXD[4] */
+	MPP17_GIGE,		/* GE_RXD[5] */
+	MPP18_GIGE,		/* GE_RXD[6] */
+	MPP19_GIGE,		/* GE_RXD[7] */
+	0,
 };
 
 static struct mv643xx_eth_platform_data rd88f5181l_ge_eth_data = {
diff --git a/arch/arm/mach-orion5x/rd88f5182-setup.c b/arch/arm/mach-orion5x/rd88f5182-setup.c
index 67ec695..e29852a 100644
--- a/arch/arm/mach-orion5x/rd88f5182-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5182-setup.c
@@ -241,28 +241,28 @@ static struct mv_sata_platform_data rd88f5182_sata_data = {
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode rd88f5182_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* Debug Led */
-	{  1, MPP_GPIO },		/* Reset Switch */
-	{  2, MPP_UNUSED },
-	{  3, MPP_GPIO },		/* RTC Int */
-	{  4, MPP_GPIO },
-	{  5, MPP_GPIO },
-	{  6, MPP_GPIO },		/* PCI_intA */
-	{  7, MPP_GPIO },		/* PCI_intB */
-	{  8, MPP_UNUSED },
-	{  9, MPP_UNUSED },
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },		/* SATA 0 presence */
-	{ 13, MPP_SATA_LED },		/* SATA 1 presence */
-	{ 14, MPP_SATA_LED },		/* SATA 0 active */
-	{ 15, MPP_SATA_LED },		/* SATA 1 active */
-	{ 16, MPP_UNUSED },
-	{ 17, MPP_UNUSED },
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int rd88f5182_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* Debug Led */
+	MPP1_GPIO,		/* Reset Switch */
+	MPP2_UNUSED,
+	MPP3_GPIO,		/* RTC Int */
+	MPP4_GPIO,
+	MPP5_GPIO,
+	MPP6_GPIO,		/* PCI_intA */
+	MPP7_GPIO,		/* PCI_intB */
+	MPP8_UNUSED,
+	MPP9_UNUSED,
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_SATA_LED,		/* SATA 0 presence */
+	MPP13_SATA_LED,		/* SATA 1 presence */
+	MPP14_SATA_LED,		/* SATA 0 active */
+	MPP15_SATA_LED,		/* SATA 1 active */
+	MPP16_UNUSED,
+	MPP17_UNUSED,
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init rd88f5182_init(void)
diff --git a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
index b080c69..ad2eba9 100644
--- a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
@@ -27,7 +27,6 @@
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
 #include "common.h"
-#include "mpp.h"
 
 static struct mv643xx_eth_platform_data rd88f6183ap_ge_eth_data = {
 	.phy_addr	= -1,
diff --git a/arch/arm/mach-orion5x/terastation_pro2-setup.c b/arch/arm/mach-orion5x/terastation_pro2-setup.c
index 5653ee6..de8db88 100644
--- a/arch/arm/mach-orion5x/terastation_pro2-setup.c
+++ b/arch/arm/mach-orion5x/terastation_pro2-setup.c
@@ -295,28 +295,28 @@ static void tsp2_power_off(void)
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode tsp2_mpp_modes[] __initdata = {
-	{  0, MPP_PCIE_RST_OUTn },
-	{  1, MPP_UNUSED },
-	{  2, MPP_UNUSED },
-	{  3, MPP_UNUSED },
-	{  4, MPP_NAND },		/* BOOT NAND Flash REn */
-	{  5, MPP_NAND },		/* BOOT NAND Flash WEn */
-	{  6, MPP_NAND },		/* BOOT NAND Flash HREn[0] */
-	{  7, MPP_NAND },		/* BOOT NAND Flash WEn[0] */
-	{  8, MPP_GPIO },		/* MICON int */
-	{  9, MPP_GPIO },		/* RTC int */
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_GPIO },		/* PCI Int A */
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_GPIO },		/* UPS on UART0 enable */
-	{ 14, MPP_GPIO },		/* UPS low battery detection */
-	{ 15, MPP_UNUSED },
-	{ 16, MPP_UART },		/* UART1 RXD */
-	{ 17, MPP_UART },		/* UART1 TXD */
-	{ 18, MPP_UART },		/* UART1 CTSn */
-	{ 19, MPP_UART },		/* UART1 RTSn */
-	{ -1 },
+static unsigned int tsp2_mpp_modes[] __initdata = {
+	MPP0_PCIE_RST_OUTn,
+	MPP1_UNUSED,
+	MPP2_UNUSED,
+	MPP3_UNUSED,
+	MPP4_NAND,		/* BOOT NAND Flash REn */
+	MPP5_NAND,		/* BOOT NAND Flash WEn */
+	MPP6_NAND,		/* BOOT NAND Flash HREn[0] */
+	MPP7_NAND,		/* BOOT NAND Flash WEn[0] */
+	MPP8_GPIO,		/* MICON int */
+	MPP9_GPIO,		/* RTC int */
+	MPP10_UNUSED,
+	MPP11_GPIO,		/* PCI Int A */
+	MPP12_UNUSED,
+	MPP13_GPIO,		/* UPS on UART0 enable */
+	MPP14_GPIO,		/* UPS low battery detection */
+	MPP15_UNUSED,
+	MPP16_UART,		/* UART1 RXD */
+	MPP17_UART,		/* UART1 TXD */
+	MPP18_UART,		/* UART1 CTSn */
+	MPP19_UART,		/* UART1 RTSn */
+	0,
 };
 
 static void __init tsp2_init(void)
diff --git a/arch/arm/mach-orion5x/ts209-setup.c b/arch/arm/mach-orion5x/ts209-setup.c
index 8bbd27e..a53c8b3 100644
--- a/arch/arm/mach-orion5x/ts209-setup.c
+++ b/arch/arm/mach-orion5x/ts209-setup.c
@@ -244,28 +244,28 @@ static struct mv_sata_platform_data qnap_ts209_sata_data = {
 
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode ts209_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED },
-	{  1, MPP_GPIO },		/* USB copy button */
-	{  2, MPP_GPIO },		/* Load defaults button */
-	{  3, MPP_GPIO },		/* GPIO RTC */
-	{  4, MPP_UNUSED },
-	{  5, MPP_UNUSED },
-	{  6, MPP_GPIO },		/* PCI Int A */
-	{  7, MPP_GPIO },		/* PCI Int B */
-	{  8, MPP_UNUSED },
-	{  9, MPP_UNUSED },
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_SATA_LED },		/* SATA 0 presence */
-	{ 13, MPP_SATA_LED },		/* SATA 1 presence */
-	{ 14, MPP_SATA_LED },		/* SATA 0 active */
-	{ 15, MPP_SATA_LED },		/* SATA 1 active */
-	{ 16, MPP_UART },		/* UART1 RXD */
-	{ 17, MPP_UART },		/* UART1 TXD */
-	{ 18, MPP_GPIO },		/* SW_RST */
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int ts209_mpp_modes[] __initdata = {
+	MPP0_UNUSED,
+	MPP1_GPIO,		/* USB copy button */
+	MPP2_GPIO,		/* Load defaults button */
+	MPP3_GPIO,		/* GPIO RTC */
+	MPP4_UNUSED,
+	MPP5_UNUSED,
+	MPP6_GPIO,		/* PCI Int A */
+	MPP7_GPIO,		/* PCI Int B */
+	MPP8_UNUSED,
+	MPP9_UNUSED,
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_SATA_LED,		/* SATA 0 presence */
+	MPP13_SATA_LED,		/* SATA 1 presence */
+	MPP14_SATA_LED,		/* SATA 0 active */
+	MPP15_SATA_LED,		/* SATA 1 active */
+	MPP16_UART,		/* UART1 RXD */
+	MPP17_UART,		/* UART1 TXD */
+	MPP18_GPIO,		/* SW_RST */
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init qnap_ts209_init(void)
diff --git a/arch/arm/mach-orion5x/ts409-setup.c b/arch/arm/mach-orion5x/ts409-setup.c
index 92f393f..366247f 100644
--- a/arch/arm/mach-orion5x/ts409-setup.c
+++ b/arch/arm/mach-orion5x/ts409-setup.c
@@ -242,28 +242,28 @@ static struct platform_device qnap_ts409_button_device = {
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode ts409_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED },
-	{  1, MPP_UNUSED },
-	{  2, MPP_UNUSED },
-	{  3, MPP_UNUSED },
-	{  4, MPP_GPIO },		/* HDD 1 status */
-	{  5, MPP_GPIO },		/* HDD 2 status */
-	{  6, MPP_GPIO },		/* HDD 3 status */
-	{  7, MPP_GPIO },		/* HDD 4 status */
-	{  8, MPP_UNUSED },
-	{  9, MPP_UNUSED },
-	{ 10, MPP_GPIO },		/* RTC int */
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_GPIO },		/* SW_RST */
-	{ 15, MPP_GPIO },		/* USB copy button */
-	{ 16, MPP_UART },		/* UART1 RXD */
-	{ 17, MPP_UART },		/* UART1 TXD */
-	{ 18, MPP_UNUSED },
-	{ 19, MPP_UNUSED },
-	{ -1 },
+static unsigned int ts409_mpp_modes[] __initdata = {
+	MPP0_UNUSED,
+	MPP1_UNUSED,
+	MPP2_UNUSED,
+	MPP3_UNUSED,
+	MPP4_GPIO,		/* HDD 1 status */
+	MPP5_GPIO,		/* HDD 2 status */
+	MPP6_GPIO,		/* HDD 3 status */
+	MPP7_GPIO,		/* HDD 4 status */
+	MPP8_UNUSED,
+	MPP9_UNUSED,
+	MPP10_GPIO,		/* RTC int */
+	MPP11_UNUSED,
+	MPP12_UNUSED,
+	MPP13_UNUSED,
+	MPP14_GPIO,		/* SW_RST */
+	MPP15_GPIO,		/* USB copy button */
+	MPP16_UART,		/* UART1 RXD */
+	MPP17_UART,		/* UART1 TXD */
+	MPP18_UNUSED,
+	MPP19_UNUSED,
+	0,
 };
 
 static void __init qnap_ts409_init(void)
diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index 8554707..8211fa6 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -557,27 +557,27 @@ static struct kobj_attribute ts78xx_fpga_attr =
 /*****************************************************************************
  * General Setup
  ****************************************************************************/
-static struct orion5x_mpp_mode ts78xx_mpp_modes[] __initdata = {
-	{  0, MPP_UNUSED },
-	{  1, MPP_GPIO },		/* JTAG Clock */
-	{  2, MPP_GPIO },		/* JTAG Data In */
-	{  3, MPP_GPIO },		/* Lat ECP2 256 FPGA - PB2B */
-	{  4, MPP_GPIO },		/* JTAG Data Out */
-	{  5, MPP_GPIO },		/* JTAG TMS */
-	{  6, MPP_GPIO },		/* Lat ECP2 256 FPGA - PB31A_CLK4+ */
-	{  7, MPP_GPIO },		/* Lat ECP2 256 FPGA - PB22B */
-	{  8, MPP_UNUSED },
-	{  9, MPP_UNUSED },
-	{ 10, MPP_UNUSED },
-	{ 11, MPP_UNUSED },
-	{ 12, MPP_UNUSED },
-	{ 13, MPP_UNUSED },
-	{ 14, MPP_UNUSED },
-	{ 15, MPP_UNUSED },
-	{ 16, MPP_UART },
-	{ 17, MPP_UART },
-	{ 18, MPP_UART },
-	{ 19, MPP_UART },
+static unsigned int ts78xx_mpp_modes[] __initdata = {
+	MPP0_UNUSED,
+	MPP1_GPIO,		/* JTAG Clock */
+	MPP2_GPIO,		/* JTAG Data In */
+	MPP3_GPIO,		/* Lat ECP2 256 FPGA - PB2B */
+	MPP4_GPIO,		/* JTAG Data Out */
+	MPP5_GPIO,		/* JTAG TMS */
+	MPP6_GPIO,		/* Lat ECP2 256 FPGA - PB31A_CLK4+ */
+	MPP7_GPIO,		/* Lat ECP2 256 FPGA - PB22B */
+	MPP8_UNUSED,
+	MPP9_UNUSED,
+	MPP10_UNUSED,
+	MPP11_UNUSED,
+	MPP12_UNUSED,
+	MPP13_UNUSED,
+	MPP14_UNUSED,
+	MPP15_UNUSED,
+	MPP16_UART,
+	MPP17_UART,
+	MPP18_UART,
+	MPP19_UART,
 	/*
 	 * MPP[20] PCI Clock Out 1
 	 * MPP[21] PCI Clock Out 0
@@ -586,7 +586,7 @@ static struct orion5x_mpp_mode ts78xx_mpp_modes[] __initdata = {
 	 * MPP[24] Unused
 	 * MPP[25] Unused
 	 */
-	{ -1 },
+	0,
 };
 
 static void __init ts78xx_init(void)
diff --git a/arch/arm/mach-orion5x/wnr854t-setup.c b/arch/arm/mach-orion5x/wnr854t-setup.c
index 4e5216b..444a1c7 100644
--- a/arch/arm/mach-orion5x/wnr854t-setup.c
+++ b/arch/arm/mach-orion5x/wnr854t-setup.c
@@ -24,28 +24,28 @@
 #include "common.h"
 #include "mpp.h"
 
-static struct orion5x_mpp_mode wnr854t_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* Power LED green (0=on) */
-	{  1, MPP_GPIO },		/* Reset Button (0=off) */
-	{  2, MPP_GPIO },		/* Power LED blink (0=off) */
-	{  3, MPP_GPIO },		/* WAN Status LED amber (0=off) */
-	{  4, MPP_GPIO },		/* PCI int */
-	{  5, MPP_GPIO },		/* ??? */
-	{  6, MPP_GPIO },		/* ??? */
-	{  7, MPP_GPIO },		/* ??? */
-	{  8, MPP_UNUSED },		/* ??? */
-	{  9, MPP_GIGE },		/* GE_RXERR */
-	{ 10, MPP_UNUSED },		/* ??? */
-	{ 11, MPP_UNUSED },		/* ??? */
-	{ 12, MPP_GIGE },		/* GE_TXD[4] */
-	{ 13, MPP_GIGE },		/* GE_TXD[5] */
-	{ 14, MPP_GIGE },		/* GE_TXD[6] */
-	{ 15, MPP_GIGE },		/* GE_TXD[7] */
-	{ 16, MPP_GIGE },		/* GE_RXD[4] */
-	{ 17, MPP_GIGE },		/* GE_RXD[5] */
-	{ 18, MPP_GIGE },		/* GE_RXD[6] */
-	{ 19, MPP_GIGE },		/* GE_RXD[7] */
-	{ -1 },
+static unsigned int wnr854t_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* Power LED green (0=on) */
+	MPP1_GPIO,		/* Reset Button (0=off) */
+	MPP2_GPIO,		/* Power LED blink (0=off) */
+	MPP3_GPIO,		/* WAN Status LED amber (0=off) */
+	MPP4_GPIO,		/* PCI int */
+	MPP5_GPIO,		/* ??? */
+	MPP6_GPIO,		/* ??? */
+	MPP7_GPIO,		/* ??? */
+	MPP8_UNUSED,		/* ??? */
+	MPP9_GIGE,		/* GE_RXERR */
+	MPP10_UNUSED,		/* ??? */
+	MPP11_UNUSED,		/* ??? */
+	MPP12_GIGE,		/* GE_TXD[4] */
+	MPP13_GIGE,		/* GE_TXD[5] */
+	MPP14_GIGE,		/* GE_TXD[6] */
+	MPP15_GIGE,		/* GE_TXD[7] */
+	MPP16_GIGE,		/* GE_RXD[4] */
+	MPP17_GIGE,		/* GE_RXD[5] */
+	MPP18_GIGE,		/* GE_RXD[6] */
+	MPP19_GIGE,		/* GE_RXD[7] */
+	0,
 };
 
 /*
diff --git a/arch/arm/mach-orion5x/wrt350n-v2-setup.c b/arch/arm/mach-orion5x/wrt350n-v2-setup.c
index fab79d0..d1952be 100644
--- a/arch/arm/mach-orion5x/wrt350n-v2-setup.c
+++ b/arch/arm/mach-orion5x/wrt350n-v2-setup.c
@@ -101,28 +101,28 @@ static struct platform_device wrt350n_v2_button_device = {
 /*
  * General setup
  */
-static struct orion5x_mpp_mode wrt350n_v2_mpp_modes[] __initdata = {
-	{  0, MPP_GPIO },		/* Power LED green (0=on) */
-	{  1, MPP_GPIO },		/* Security LED (0=on) */
-	{  2, MPP_GPIO },		/* Internal Button (0=on) */
-	{  3, MPP_GPIO },		/* Reset Button (0=on) */
-	{  4, MPP_GPIO },		/* PCI int */
-	{  5, MPP_GPIO },		/* Power LED orange (0=on) */
-	{  6, MPP_GPIO },		/* USB LED (0=on) */
-	{  7, MPP_GPIO },		/* Wireless LED (0=on) */
-	{  8, MPP_UNUSED },		/* ??? */
-	{  9, MPP_GIGE },		/* GE_RXERR */
-	{ 10, MPP_UNUSED },		/* ??? */
-	{ 11, MPP_UNUSED },		/* ??? */
-	{ 12, MPP_GIGE },		/* GE_TXD[4] */
-	{ 13, MPP_GIGE },		/* GE_TXD[5] */
-	{ 14, MPP_GIGE },		/* GE_TXD[6] */
-	{ 15, MPP_GIGE },		/* GE_TXD[7] */
-	{ 16, MPP_GIGE },		/* GE_RXD[4] */
-	{ 17, MPP_GIGE },		/* GE_RXD[5] */
-	{ 18, MPP_GIGE },		/* GE_RXD[6] */
-	{ 19, MPP_GIGE },		/* GE_RXD[7] */
-	{ -1 },
+static unsigned int wrt350n_v2_mpp_modes[] __initdata = {
+	MPP0_GPIO,		/* Power LED green (0=on) */
+	MPP1_GPIO,		/* Security LED (0=on) */
+	MPP2_GPIO,		/* Internal Button (0=on) */
+	MPP3_GPIO,		/* Reset Button (0=on) */
+	MPP4_GPIO,		/* PCI int */
+	MPP5_GPIO,		/* Power LED orange (0=on) */
+	MPP6_GPIO,		/* USB LED (0=on) */
+	MPP7_GPIO,		/* Wireless LED (0=on) */
+	MPP8_UNUSED,		/* ??? */
+	MPP9_GIGE,		/* GE_RXERR */
+	MPP10_UNUSED,		/* ??? */
+	MPP11_UNUSED,		/* ??? */
+	MPP12_GIGE,		/* GE_TXD[4] */
+	MPP13_GIGE,		/* GE_TXD[5] */
+	MPP14_GIGE,		/* GE_TXD[6] */
+	MPP15_GIGE,		/* GE_TXD[7] */
+	MPP16_GIGE,		/* GE_RXD[4] */
+	MPP17_GIGE,		/* GE_RXD[5] */
+	MPP18_GIGE,		/* GE_RXD[6] */
+	MPP19_GIGE,		/* GE_RXD[7] */
+	0,
 };
 
 /*
-- 
1.7.4.4

