Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab2EHHVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:21:11 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:57749 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab2EHHVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:21:05 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 05/12] ARM: imx: eukrea-cpuimx51: remove board
Date: Tue,  8 May 2012 09:20:20 +0200
Message-Id: <1336461627-30315-5-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461627-30315-1-git-send-email-eric@eukrea.com>
References: <1336461627-30315-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this board is not publicly available and is replaced by cpuimx51sd

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/Kconfig                    |   30 ---
 arch/arm/mach-imx/Makefile                   |    2 -
 arch/arm/mach-imx/eukrea_mbimx51-baseboard.c |  206 ------------------
 arch/arm/mach-imx/mach-cpuimx51.c            |  301 --------------------------
 4 files changed, 0 insertions(+), 539 deletions(-)
 delete mode 100644 arch/arm/mach-imx/eukrea_mbimx51-baseboard.c
 delete mode 100644 arch/arm/mach-imx/mach-cpuimx51.c

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 28d89d3..2f824d8 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -685,36 +685,6 @@ config MACH_MX51_3DS
 	  Include support for MX51PDK (3DS) platform. This includes specific
 	  configurations for the board and its peripherals.
 
-config MACH_EUKREA_CPUIMX51
-	bool "Support Eukrea CPUIMX51 module"
-	select SOC_IMX51
-	select IMX_HAVE_PLATFORM_FSL_USB2_UDC
-	select IMX_HAVE_PLATFORM_IMX_I2C
-	select IMX_HAVE_PLATFORM_IMX_UART
-	select IMX_HAVE_PLATFORM_MXC_EHCI
-	select IMX_HAVE_PLATFORM_MXC_NAND
-	select IMX_HAVE_PLATFORM_SPI_IMX
-	help
-	  Include support for Eukrea CPUIMX51 platform. This includes
-	  specific configurations for the module and its peripherals.
-
-choice
-	prompt "Baseboard"
-	depends on MACH_EUKREA_CPUIMX51
-	default MACH_EUKREA_MBIMX51_BASEBOARD
-
-config MACH_EUKREA_MBIMX51_BASEBOARD
-	prompt "Eukrea MBIMX51 development board"
-	bool
-	select IMX_HAVE_PLATFORM_IMX_KEYPAD
-	select IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX
-	select LEDS_GPIO_REGISTER
-	help
-	  This adds board specific devices that can be found on Eukrea's
-	  MBIMX51 evaluation board.
-
-endchoice
-
 config MACH_EUKREA_CPUIMX51SD
 	bool "Support Eukrea CPUIMX51SD module"
 	select SOC_IMX51
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index ab939c5..55303d9 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -83,8 +83,6 @@ obj-$(CONFIG_MACH_MX53_EVK) += mach-mx53_evk.o
 obj-$(CONFIG_MACH_MX53_SMD) += mach-mx53_smd.o
 obj-$(CONFIG_MACH_MX53_LOCO) += mach-mx53_loco.o
 obj-$(CONFIG_MACH_MX53_ARD) += mach-mx53_ard.o
-obj-$(CONFIG_MACH_EUKREA_CPUIMX51) += mach-cpuimx51.o
-obj-$(CONFIG_MACH_EUKREA_MBIMX51_BASEBOARD) += eukrea_mbimx51-baseboard.o
 obj-$(CONFIG_MACH_EUKREA_CPUIMX51SD) += mach-cpuimx51sd.o
 obj-$(CONFIG_MACH_EUKREA_MBIMXSD51_BASEBOARD) += eukrea_mbimxsd-baseboard.o
 obj-$(CONFIG_MX51_EFIKA_COMMON) += mx51_efika.o
diff --git a/arch/arm/mach-imx/eukrea_mbimx51-baseboard.c b/arch/arm/mach-imx/eukrea_mbimx51-baseboard.c
deleted file mode 100644
index a6a3ab8..0000000
--- a/arch/arm/mach-imx/eukrea_mbimx51-baseboard.c
+++ /dev/null
@@ -1,206 +0,0 @@
-/*
- *
- * Copyright (C) 2010 Eric Bénard <eric@eukrea.com>
- *
- * The code contained herein is licensed under the GNU General Public
- * License. You may obtain a copy of the GNU General Public License
- * Version 2 or later at the following locations:
- *
- * http://www.opensource.org/licenses/gpl-license.html
- * http://www.gnu.org/copyleft/gpl.html
- */
-
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/serial_8250.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/i2c/tsc2007.h>
-#include <linux/leds.h>
-
-#include <mach/common.h>
-#include <mach/hardware.h>
-#include <mach/iomux-mx51.h>
-
-#include <asm/mach/arch.h>
-
-#include "devices-imx51.h"
-
-#define MBIMX51_TSC2007_GPIO	IMX_GPIO_NR(3, 30)
-#define MBIMX51_LED0		IMX_GPIO_NR(3, 5)
-#define MBIMX51_LED1		IMX_GPIO_NR(3, 6)
-#define MBIMX51_LED2		IMX_GPIO_NR(3, 7)
-#define MBIMX51_LED3		IMX_GPIO_NR(3, 8)
-
-static const struct gpio_led mbimx51_leds[] __initconst = {
-	{
-		.name			= "led0",
-		.default_trigger	= "heartbeat",
-		.active_low		= 1,
-		.gpio			= MBIMX51_LED0,
-	},
-	{
-		.name			= "led1",
-		.default_trigger	= "nand-disk",
-		.active_low		= 1,
-		.gpio			= MBIMX51_LED1,
-	},
-	{
-		.name			= "led2",
-		.default_trigger	= "mmc0",
-		.active_low		= 1,
-		.gpio			= MBIMX51_LED2,
-	},
-	{
-		.name			= "led3",
-		.default_trigger	= "default-on",
-		.active_low		= 1,
-		.gpio			= MBIMX51_LED3,
-	},
-};
-
-static const struct gpio_led_platform_data mbimx51_leds_info __initconst = {
-	.leds		= mbimx51_leds,
-	.num_leds	= ARRAY_SIZE(mbimx51_leds),
-};
-
-static iomux_v3_cfg_t mbimx51_pads[] = {
-	/* UART2 */
-	MX51_PAD_UART2_RXD__UART2_RXD,
-	MX51_PAD_UART2_TXD__UART2_TXD,
-
-	/* UART3 */
-	MX51_PAD_UART3_RXD__UART3_RXD,
-	MX51_PAD_UART3_TXD__UART3_TXD,
-	MX51_PAD_KEY_COL4__UART3_RTS,
-	MX51_PAD_KEY_COL5__UART3_CTS,
-
-	/* TSC2007 IRQ */
-	MX51_PAD_NANDF_D10__GPIO3_30,
-
-	/* LEDS */
-	MX51_PAD_DISPB2_SER_DIN__GPIO3_5,
-	MX51_PAD_DISPB2_SER_DIO__GPIO3_6,
-	MX51_PAD_DISPB2_SER_CLK__GPIO3_7,
-	MX51_PAD_DISPB2_SER_RS__GPIO3_8,
-
-	/* KPP */
-	MX51_PAD_KEY_ROW0__KEY_ROW0,
-	MX51_PAD_KEY_ROW1__KEY_ROW1,
-	MX51_PAD_KEY_ROW2__KEY_ROW2,
-	MX51_PAD_KEY_ROW3__KEY_ROW3,
-	MX51_PAD_KEY_COL0__KEY_COL0,
-	MX51_PAD_KEY_COL1__KEY_COL1,
-	MX51_PAD_KEY_COL2__KEY_COL2,
-	MX51_PAD_KEY_COL3__KEY_COL3,
-
-	/* SD 1 */
-	MX51_PAD_SD1_CMD__SD1_CMD,
-	MX51_PAD_SD1_CLK__SD1_CLK,
-	MX51_PAD_SD1_DATA0__SD1_DATA0,
-	MX51_PAD_SD1_DATA1__SD1_DATA1,
-	MX51_PAD_SD1_DATA2__SD1_DATA2,
-	MX51_PAD_SD1_DATA3__SD1_DATA3,
-
-	/* SD 2 */
-	MX51_PAD_SD2_CMD__SD2_CMD,
-	MX51_PAD_SD2_CLK__SD2_CLK,
-	MX51_PAD_SD2_DATA0__SD2_DATA0,
-	MX51_PAD_SD2_DATA1__SD2_DATA1,
-	MX51_PAD_SD2_DATA2__SD2_DATA2,
-	MX51_PAD_SD2_DATA3__SD2_DATA3,
-};
-
-static const struct imxuart_platform_data uart_pdata __initconst = {
-	.flags = IMXUART_HAVE_RTSCTS,
-};
-
-static int mbimx51_keymap[] = {
-	KEY(0, 0, KEY_1),
-	KEY(0, 1, KEY_2),
-	KEY(0, 2, KEY_3),
-	KEY(0, 3, KEY_UP),
-
-	KEY(1, 0, KEY_4),
-	KEY(1, 1, KEY_5),
-	KEY(1, 2, KEY_6),
-	KEY(1, 3, KEY_LEFT),
-
-	KEY(2, 0, KEY_7),
-	KEY(2, 1, KEY_8),
-	KEY(2, 2, KEY_9),
-	KEY(2, 3, KEY_RIGHT),
-
-	KEY(3, 0, KEY_0),
-	KEY(3, 1, KEY_DOWN),
-	KEY(3, 2, KEY_ESC),
-	KEY(3, 3, KEY_ENTER),
-};
-
-static const struct matrix_keymap_data mbimx51_map_data __initconst = {
-	.keymap		= mbimx51_keymap,
-	.keymap_size	= ARRAY_SIZE(mbimx51_keymap),
-};
-
-static int tsc2007_get_pendown_state(void)
-{
-	return !gpio_get_value(MBIMX51_TSC2007_GPIO);
-}
-
-struct tsc2007_platform_data tsc2007_data = {
-	.model = 2007,
-	.x_plate_ohms = 180,
-	.get_pendown_state = tsc2007_get_pendown_state,
-};
-
-static struct i2c_board_info mbimx51_i2c_devices[] = {
-	{
-		I2C_BOARD_INFO("tsc2007", 0x49),
-		.irq  = IMX_GPIO_TO_IRQ(MBIMX51_TSC2007_GPIO),
-		.platform_data = &tsc2007_data,
-	}, {
-		I2C_BOARD_INFO("tlv320aic23", 0x1a),
-	},
-};
-
-/*
- * baseboard initialization.
- */
-void __init eukrea_mbimx51_baseboard_init(void)
-{
-	mxc_iomux_v3_setup_multiple_pads(mbimx51_pads,
-					ARRAY_SIZE(mbimx51_pads));
-
-	imx51_add_imx_uart(1, NULL);
-	imx51_add_imx_uart(2, &uart_pdata);
-
-	gpio_request(MBIMX51_LED0, "LED0");
-	gpio_direction_output(MBIMX51_LED0, 1);
-	gpio_free(MBIMX51_LED0);
-	gpio_request(MBIMX51_LED1, "LED1");
-	gpio_direction_output(MBIMX51_LED1, 1);
-	gpio_free(MBIMX51_LED1);
-	gpio_request(MBIMX51_LED2, "LED2");
-	gpio_direction_output(MBIMX51_LED2, 1);
-	gpio_free(MBIMX51_LED2);
-	gpio_request(MBIMX51_LED3, "LED3");
-	gpio_direction_output(MBIMX51_LED3, 1);
-	gpio_free(MBIMX51_LED3);
-
-	gpio_led_register_device(-1, &mbimx51_leds_info);
-
-	imx51_add_imx_keypad(&mbimx51_map_data);
-
-	gpio_request(MBIMX51_TSC2007_GPIO, "tsc2007_irq");
-	gpio_direction_input(MBIMX51_TSC2007_GPIO);
-	irq_set_irq_type(gpio_to_irq(MBIMX51_TSC2007_GPIO),
-					IRQF_TRIGGER_FALLING);
-	i2c_register_board_info(1, mbimx51_i2c_devices,
-				ARRAY_SIZE(mbimx51_i2c_devices));
-
-	imx51_add_sdhci_esdhc_imx(0, NULL);
-	imx51_add_sdhci_esdhc_imx(1, NULL);
-}
diff --git a/arch/arm/mach-imx/mach-cpuimx51.c b/arch/arm/mach-imx/mach-cpuimx51.c
deleted file mode 100644
index 944025d..0000000
--- a/arch/arm/mach-imx/mach-cpuimx51.c
+++ /dev/null
@@ -1,301 +0,0 @@
-/*
- *
- * Copyright (C) 2010 Eric Bénard <eric@eukrea.com>
- *
- * based on board-mx51_babbage.c which is
- * Copyright 2009 Freescale Semiconductor, Inc. All Rights Reserved.
- * Copyright (C) 2009-2010 Amit Kucheria <amit.kucheria@canonical.com>
- *
- * The code contained herein is licensed under the GNU General Public
- * License. You may obtain a copy of the GNU General Public License
- * Version 2 or later at the following locations:
- *
- * http://www.opensource.org/licenses/gpl-license.html
- * http://www.gnu.org/copyleft/gpl.html
- */
-
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/serial_8250.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/delay.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-
-#include <mach/eukrea-baseboards.h>
-#include <mach/common.h>
-#include <mach/hardware.h>
-#include <mach/iomux-mx51.h>
-
-#include <asm/setup.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-
-#include "devices-imx51.h"
-
-#define CPUIMX51_USBH1_STP	IMX_GPIO_NR(1, 27)
-#define CPUIMX51_QUARTA_GPIO	IMX_GPIO_NR(3, 28)
-#define CPUIMX51_QUARTB_GPIO	IMX_GPIO_NR(3, 25)
-#define CPUIMX51_QUARTC_GPIO	IMX_GPIO_NR(3, 26)
-#define CPUIMX51_QUARTD_GPIO	IMX_GPIO_NR(3, 27)
-#define CPUIMX51_QUART_XTAL	14745600
-#define CPUIMX51_QUART_REGSHIFT	17
-
-/* USB_CTRL_1 */
-#define MX51_USB_CTRL_1_OFFSET		0x10
-#define MX51_USB_CTRL_UH1_EXT_CLK_EN	(1 << 25)
-
-#define	MX51_USB_PLLDIV_12_MHZ		0x00
-#define	MX51_USB_PLL_DIV_19_2_MHZ	0x01
-#define	MX51_USB_PLL_DIV_24_MHZ		0x02
-
-static struct plat_serial8250_port serial_platform_data[] = {
-	{
-		.mapbase = (unsigned long)(MX51_CS1_BASE_ADDR + 0x400000),
-		.irq = IMX_GPIO_TO_IRQ(CPUIMX51_QUARTA_GPIO),
-		.irqflags = IRQF_TRIGGER_HIGH,
-		.uartclk = CPUIMX51_QUART_XTAL,
-		.regshift = CPUIMX51_QUART_REGSHIFT,
-		.iotype = UPIO_MEM,
-		.flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_IOREMAP,
-	}, {
-		.mapbase = (unsigned long)(MX51_CS1_BASE_ADDR + 0x800000),
-		.irq = IMX_GPIO_TO_IRQ(CPUIMX51_QUARTB_GPIO),
-		.irqflags = IRQF_TRIGGER_HIGH,
-		.uartclk = CPUIMX51_QUART_XTAL,
-		.regshift = CPUIMX51_QUART_REGSHIFT,
-		.iotype = UPIO_MEM,
-		.flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_IOREMAP,
-	}, {
-		.mapbase = (unsigned long)(MX51_CS1_BASE_ADDR + 0x1000000),
-		.irq = IMX_GPIO_TO_IRQ(CPUIMX51_QUARTC_GPIO),
-		.irqflags = IRQF_TRIGGER_HIGH,
-		.uartclk = CPUIMX51_QUART_XTAL,
-		.regshift = CPUIMX51_QUART_REGSHIFT,
-		.iotype = UPIO_MEM,
-		.flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_IOREMAP,
-	}, {
-		.mapbase = (unsigned long)(MX51_CS1_BASE_ADDR + 0x2000000),
-		.irq = IMX_GPIO_TO_IRQ(CPUIMX51_QUARTD_GPIO),
-		.irqflags = IRQF_TRIGGER_HIGH,
-		.uartclk = CPUIMX51_QUART_XTAL,
-		.regshift = CPUIMX51_QUART_REGSHIFT,
-		.iotype = UPIO_MEM,
-		.flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_IOREMAP,
-	}, {
-	}
-};
-
-static struct platform_device serial_device = {
-	.name = "serial8250",
-	.id = 0,
-	.dev = {
-		.platform_data = serial_platform_data,
-	},
-};
-
-static struct platform_device *devices[] __initdata = {
-	&serial_device,
-};
-
-static iomux_v3_cfg_t eukrea_cpuimx51_pads[] = {
-	/* UART1 */
-	MX51_PAD_UART1_RXD__UART1_RXD,
-	MX51_PAD_UART1_TXD__UART1_TXD,
-	MX51_PAD_UART1_RTS__UART1_RTS,
-	MX51_PAD_UART1_CTS__UART1_CTS,
-
-	/* I2C2 */
-	MX51_PAD_GPIO1_2__I2C2_SCL,
-	MX51_PAD_GPIO1_3__I2C2_SDA,
-	MX51_PAD_NANDF_D10__GPIO3_30,
-
-	/* QUART IRQ */
-	MX51_PAD_NANDF_D15__GPIO3_25,
-	MX51_PAD_NANDF_D14__GPIO3_26,
-	MX51_PAD_NANDF_D13__GPIO3_27,
-	MX51_PAD_NANDF_D12__GPIO3_28,
-
-	/* USB HOST1 */
-	MX51_PAD_USBH1_CLK__USBH1_CLK,
-	MX51_PAD_USBH1_DIR__USBH1_DIR,
-	MX51_PAD_USBH1_NXT__USBH1_NXT,
-	MX51_PAD_USBH1_DATA0__USBH1_DATA0,
-	MX51_PAD_USBH1_DATA1__USBH1_DATA1,
-	MX51_PAD_USBH1_DATA2__USBH1_DATA2,
-	MX51_PAD_USBH1_DATA3__USBH1_DATA3,
-	MX51_PAD_USBH1_DATA4__USBH1_DATA4,
-	MX51_PAD_USBH1_DATA5__USBH1_DATA5,
-	MX51_PAD_USBH1_DATA6__USBH1_DATA6,
-	MX51_PAD_USBH1_DATA7__USBH1_DATA7,
-	MX51_PAD_USBH1_STP__USBH1_STP,
-};
-
-static const struct mxc_nand_platform_data
-		eukrea_cpuimx51_nand_board_info __initconst = {
-	.width		= 1,
-	.hw_ecc		= 1,
-	.flash_bbt	= 1,
-};
-
-static const struct imxuart_platform_data uart_pdata __initconst = {
-	.flags = IMXUART_HAVE_RTSCTS,
-};
-
-static const
-struct imxi2c_platform_data eukrea_cpuimx51_i2c_data __initconst = {
-	.bitrate = 100000,
-};
-
-static struct i2c_board_info eukrea_cpuimx51_i2c_devices[] = {
-	{
-		I2C_BOARD_INFO("pcf8563", 0x51),
-	},
-};
-
-/* This function is board specific as the bit mask for the plldiv will also
-be different for other Freescale SoCs, thus a common bitmask is not
-possible and cannot get place in /plat-mxc/ehci.c.*/
-static int initialize_otg_port(struct platform_device *pdev)
-{
-	u32 v;
-	void __iomem *usb_base;
-	void __iomem *usbother_base;
-
-	usb_base = ioremap(MX51_USB_OTG_BASE_ADDR, SZ_4K);
-	if (!usb_base)
-		return -ENOMEM;
-	usbother_base = usb_base + MX5_USBOTHER_REGS_OFFSET;
-
-	/* Set the PHY clock to 19.2MHz */
-	v = __raw_readl(usbother_base + MXC_USB_PHY_CTR_FUNC2_OFFSET);
-	v &= ~MX5_USB_UTMI_PHYCTRL1_PLLDIV_MASK;
-	v |= MX51_USB_PLL_DIV_19_2_MHZ;
-	__raw_writel(v, usbother_base + MXC_USB_PHY_CTR_FUNC2_OFFSET);
-	iounmap(usb_base);
-
-	mdelay(10);
-
-	return mx51_initialize_usb_hw(0, MXC_EHCI_INTERNAL_PHY);
-}
-
-static int initialize_usbh1_port(struct platform_device *pdev)
-{
-	u32 v;
-	void __iomem *usb_base;
-	void __iomem *usbother_base;
-
-	usb_base = ioremap(MX51_USB_OTG_BASE_ADDR, SZ_4K);
-	if (!usb_base)
-		return -ENOMEM;
-	usbother_base = usb_base + MX5_USBOTHER_REGS_OFFSET;
-
-	/* The clock for the USBH1 ULPI port will come externally from the PHY. */
-	v = __raw_readl(usbother_base + MX51_USB_CTRL_1_OFFSET);
-	__raw_writel(v | MX51_USB_CTRL_UH1_EXT_CLK_EN, usbother_base + MX51_USB_CTRL_1_OFFSET);
-	iounmap(usb_base);
-
-	mdelay(10);
-
-	return mx51_initialize_usb_hw(1, MXC_EHCI_POWER_PINS_ENABLED |
-			MXC_EHCI_ITC_NO_THRESHOLD);
-}
-
-static const struct mxc_usbh_platform_data dr_utmi_config __initconst = {
-	.init		= initialize_otg_port,
-	.portsc	= MXC_EHCI_UTMI_16BIT,
-};
-
-static const struct fsl_usb2_platform_data usb_pdata __initconst = {
-	.operating_mode	= FSL_USB2_DR_DEVICE,
-	.phy_mode	= FSL_USB2_PHY_UTMI_WIDE,
-};
-
-static const struct mxc_usbh_platform_data usbh1_config __initconst = {
-	.init		= initialize_usbh1_port,
-	.portsc	= MXC_EHCI_MODE_ULPI,
-};
-
-static int otg_mode_host;
-
-static int __init eukrea_cpuimx51_otg_mode(char *options)
-{
-	if (!strcmp(options, "host"))
-		otg_mode_host = 1;
-	else if (!strcmp(options, "device"))
-		otg_mode_host = 0;
-	else
-		pr_info("otg_mode neither \"host\" nor \"device\". "
-			"Defaulting to device\n");
-	return 0;
-}
-__setup("otg_mode=", eukrea_cpuimx51_otg_mode);
-
-/*
- * Board specific initialization.
- */
-static void __init eukrea_cpuimx51_init(void)
-{
-	imx51_soc_init();
-
-	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51_pads,
-					ARRAY_SIZE(eukrea_cpuimx51_pads));
-
-	imx51_add_imx_uart(0, &uart_pdata);
-	imx51_add_mxc_nand(&eukrea_cpuimx51_nand_board_info);
-
-	gpio_request(CPUIMX51_QUARTA_GPIO, "quarta_irq");
-	gpio_direction_input(CPUIMX51_QUARTA_GPIO);
-	gpio_free(CPUIMX51_QUARTA_GPIO);
-	gpio_request(CPUIMX51_QUARTB_GPIO, "quartb_irq");
-	gpio_direction_input(CPUIMX51_QUARTB_GPIO);
-	gpio_free(CPUIMX51_QUARTB_GPIO);
-	gpio_request(CPUIMX51_QUARTC_GPIO, "quartc_irq");
-	gpio_direction_input(CPUIMX51_QUARTC_GPIO);
-	gpio_free(CPUIMX51_QUARTC_GPIO);
-	gpio_request(CPUIMX51_QUARTD_GPIO, "quartd_irq");
-	gpio_direction_input(CPUIMX51_QUARTD_GPIO);
-	gpio_free(CPUIMX51_QUARTD_GPIO);
-
-	imx51_add_fec(NULL);
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-
-	imx51_add_imx_i2c(1, &eukrea_cpuimx51_i2c_data);
-	i2c_register_board_info(1, eukrea_cpuimx51_i2c_devices,
-				ARRAY_SIZE(eukrea_cpuimx51_i2c_devices));
-
-	if (otg_mode_host)
-		imx51_add_mxc_ehci_otg(&dr_utmi_config);
-	else {
-		initialize_otg_port(NULL);
-		imx51_add_fsl_usb2_udc(&usb_pdata);
-	}
-	imx51_add_mxc_ehci_hs(1, &usbh1_config);
-
-#ifdef CONFIG_MACH_EUKREA_MBIMX51_BASEBOARD
-	eukrea_mbimx51_baseboard_init();
-#endif
-}
-
-static void __init eukrea_cpuimx51_timer_init(void)
-{
-	mx51_clocks_init(32768, 24000000, 22579200, 0);
-}
-
-static struct sys_timer mxc_timer = {
-	.init	= eukrea_cpuimx51_timer_init,
-};
-
-MACHINE_START(EUKREA_CPUIMX51, "Eukrea CPUIMX51 Module")
-	/* Maintainer: Eric Bénard <eric@eukrea.com> */
-	.atag_offset = 0x100,
-	.map_io = mx51_map_io,
-	.init_early = imx51_init_early,
-	.init_irq = mx51_init_irq,
-	.handle_irq = imx51_handle_irq,
-	.timer = &mxc_timer,
-	.init_machine = eukrea_cpuimx51_init,
-	.restart	= mxc_restart,
-MACHINE_END
-- 
1.7.7.6

