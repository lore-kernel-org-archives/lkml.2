Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0INH6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:58:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34716 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0INH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dWoTEDt7SjHK8aDXkUKbZv0wdUxegyhboG4sN9zZOuJS5ZalriC7Gz7YfuwlU4zN97
         iGrATcDR/vbwX0TbtXDHK7fBUir3CbNfOc1d2LIdtTQUfMc0n0PzSsTxG6EYEqYBHxvT
         +fHOyadk/9wL6BWbpktNecOEhSKfIPxndlJfA=
Message-ID: <4C8F2B1B.7090003@gmail.com>
Date: Tue, 14 Sep 2010 11:58:19 +0400
From: Maxim Osipov <maxim.osipov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100903 Thunderbird/3.1.3
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maxim Osipov <maxim.osipov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] AT91: Add flexibity board support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please find updated flexibity board support patch below.

Kind regards,
Maxim

>From 1fe2aaae2574a4eabda2547ecad0bd0085e3ca3e Mon Sep 17 00:00:00 2001
From: Maxim Osipov <maxim.osipov@gmail.com>
Date: Sun, 12 Sep 2010 16:23:48 +0400
Subject: [PATCH] AT91: Add flexibity board support

Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
---
 arch/arm/mach-at91/Kconfig           |    6 ++
 arch/arm/mach-at91/Makefile          |    1 +
 arch/arm/mach-at91/board-flexibity.c |  164 ++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-at91/board-flexibity.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 939bccd..ca33862 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -248,6 +248,12 @@ config MACH_CPU9260
 	  Select this if you are using a Eukrea Electromatique's
 	  CPU9260 Board <http://www.eukrea.com/>
 
+config MACH_FLEXIBITY
+	bool "Flexibity Connect board"
+	help
+	  Select this if you are using Flexibity Connect board
+	  <http://www.flexibity.com>
+
 endif
 
 # ----------------------------------------------------------
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index ca2ac00..7cbe06d 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_MACH_USB_A9260)	+= board-usb-a9260.o
 obj-$(CONFIG_MACH_QIL_A9260)	+= board-qil-a9260.o
 obj-$(CONFIG_MACH_AFEB9260)	+= board-afeb-9260v1.o
 obj-$(CONFIG_MACH_CPU9260)	+= board-cpu9krea.o
+obj-$(CONFIG_MACH_FLEXIBITY)	+= board-flexibity.o
 
 # AT91SAM9261 board-specific support
 obj-$(CONFIG_MACH_AT91SAM9261EK) += board-sam9261ek.o
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
new file mode 100644
index 0000000..216c8ca
--- /dev/null
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -0,0 +1,164 @@
+/*
+ * linux/arch/arm/mach-at91/board-flexibity.c
+ *
+ *  Copyright (C) 2010 Flexibity
+ *  Copyright (C) 2005 SAN People
+ *  Copyright (C) 2006 Atmel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/input.h>
+#include <linux/gpio.h>
+
+#include <asm/mach-types.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/board.h>
+
+#include "generic.h"
+
+static void __init flexibity_map_io(void)
+{
+	/* Initialize processor: 18.432 MHz crystal */
+	at91sam9260_initialize(18432000);
+
+	/* DBGU on ttyS0. (Rx & Tx only) */
+	at91_register_uart(0, 0, 0);
+
+	/* set serial console to ttyS0 (ie, DBGU) */
+	at91_set_serial_console(0);
+}
+
+static void __init flexibity_init_irq(void)
+{
+	at91sam9260_init_interrupts(NULL);
+}
+
+/* USB Host port */
+static struct at91_usbh_data __initdata flexibity_usbh_data = {
+	.ports		= 2,
+};
+
+/* USB Device port */
+static struct at91_udc_data __initdata flexibity_udc_data = {
+	.vbus_pin	= AT91_PIN_PC5,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+/* SPI devices */
+static struct spi_board_info flexibity_spi_devices[] = {
+	{	/* DataFlash chip */
+		.modalias	= "mtd_dataflash",
+		.chip_select	= 1,
+		.max_speed_hz	= 15 * 1000 * 1000,
+		.bus_num	= 0,
+	},
+};
+
+/* MCI (SD/MMC) */
+static struct at91_mmc_data __initdata flexibity_mmc_data = {
+	.slot_b		= 0,
+	.wire4		= 1,
+	.det_pin	= AT91_PIN_PC9,
+	.wp_pin		= AT91_PIN_PC4,
+};
+
+/* LEDs */
+static struct gpio_led flexibity_leds[] = {
+	{
+		.name			= "usb1:green",
+		.gpio			= AT91_PIN_PA12,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb1:red",
+		.gpio			= AT91_PIN_PA13,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb2:green",
+		.gpio			= AT91_PIN_PB26,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb2:red",
+		.gpio			= AT91_PIN_PB27,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb3:green",
+		.gpio			= AT91_PIN_PC8,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb3:red",
+		.gpio			= AT91_PIN_PC6,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb4:green",
+		.gpio			= AT91_PIN_PB4,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "usb4:red",
+		.gpio			= AT91_PIN_PB5,
+		.active_low		= 1,
+		.default_trigger	= "default-on",
+	}
+};
+
+static void __init flexibity_board_init(void)
+{
+	/* Serial */
+	at91_add_device_serial();
+	/* USB Host */
+	at91_add_device_usbh(&flexibity_usbh_data);
+	/* USB Device */
+	at91_add_device_udc(&flexibity_udc_data);
+	/* SPI */
+	at91_add_device_spi(flexibity_spi_devices,
+		ARRAY_SIZE(flexibity_spi_devices));
+	/* MMC */
+	at91_add_device_mmc(0, &flexibity_mmc_data);
+	/* LEDs */
+	at91_gpio_leds(flexibity_leds, ARRAY_SIZE(flexibity_leds));
+}
+
+MACHINE_START(FLEXIBITY, "Flexibity Connect")
+	/* Maintainer: Maxim Osipov */
+	.phys_io	= AT91_BASE_SYS,
+	.io_pg_offst	= (AT91_VA_BASE_SYS >> 18) & 0xfffc,
+	.boot_params	= AT91_SDRAM_BASE + 0x100,
+	.timer		= &at91sam926x_timer,
+	.map_io		= flexibity_map_io,
+	.init_irq	= flexibity_init_irq,
+	.init_machine	= flexibity_board_init,
+MACHINE_END
-- 
1.7.1
