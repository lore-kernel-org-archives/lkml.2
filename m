Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0LJRAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:00:31 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:34304 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0LJRA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:00:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A32Bb9ZW2PllQ5vbExP8hEC04s9elXRw6gOPpWynOCy+GLRL30i/eRVlrLwvTd+dds
         MJ1FleuxAID8krQRI0j77SuiFcJpuvJovmNt5hDOH3jZytiWQAy0VOG4URn1KDGCJOR+
         NF4famSC4kNu6VQLPjRwf2/72ea3Q0R/7e8T0=
From: Igor Plyatov <plyatov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, plagnioj@jcrosoft.com, ryan@bluewatersys.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at,
        Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH v4] mach-at91: Support for gsia18s board added
Date: Fri, 10 Dec 2010 20:00:11 +0300
Message-Id: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GS_IA18_S (GMS) is a carrier board from GeoSIG Ltd used with the
Stamp9G20 SoM from Taskit company.
It operate as an internet accelerometer.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 arch/arm/configs/gsia18s_defconfig        |  147 +++++++
 arch/arm/mach-at91/Kconfig                |    7 +
 arch/arm/mach-at91/Makefile               |    1 +
 arch/arm/mach-at91/board-gsia18s.c        |  587 +++++++++++++++++++++++++++++
 arch/arm/mach-at91/include/mach/gsia18s.h |   33 ++
 5 files changed, 775 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/gsia18s_defconfig
 create mode 100644 arch/arm/mach-at91/board-gsia18s.c
 create mode 100644 arch/arm/mach-at91/include/mach/gsia18s.h

diff --git a/arch/arm/configs/gsia18s_defconfig b/arch/arm/configs/gsia18s_defconfig
new file mode 100644
index 0000000..d7cef32
--- /dev/null
+++ b/arch/arm/configs/gsia18s_defconfig
@@ -0,0 +1,147 @@
+CONFIG_EXPERIMENTAL=y
+CONFIG_SYSVIPC=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_ARCH_AT91=y
+CONFIG_ARCH_AT91SAM9G20=y
+CONFIG_MACH_GSIA18S=y
+CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
+CONFIG_AT91_SLOW_CLOCK=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,3145728 root=/dev/ram0 rw"
+CONFIG_KEXEC=y
+CONFIG_CPU_IDLE=y
+CONFIG_PM=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_NETFILTER=y
+CONFIG_NETFILTER_NETLINK_LOG=m
+CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CT_PROTO_SCTP=m
+CONFIG_NF_CT_PROTO_UDPLITE=m
+CONFIG_NF_CONNTRACK_FTP=m
+CONFIG_NF_CONNTRACK_IRC=m
+CONFIG_NF_CONNTRACK_SIP=m
+CONFIG_NF_CT_NETLINK=m
+CONFIG_NETFILTER_XT_MARK=m
+CONFIG_NETFILTER_XT_CONNMARK=m
+CONFIG_NETFILTER_XT_MATCH_STATE=m
+CONFIG_NF_CONNTRACK_IPV4=m
+CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_MATCH_ADDRTYPE=m
+CONFIG_IP_NF_MATCH_AH=m
+CONFIG_IP_NF_MATCH_ECN=m
+CONFIG_IP_NF_MATCH_TTL=m
+CONFIG_IP_NF_FILTER=m
+CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP_NF_TARGET_LOG=m
+CONFIG_IP_NF_TARGET_ULOG=m
+CONFIG_NF_NAT=m
+CONFIG_IP_NF_TARGET_MASQUERADE=m
+CONFIG_IP_NF_TARGET_NETMAP=m
+CONFIG_IP_NF_TARGET_REDIRECT=m
+CONFIG_NF_NAT_SNMP_BASIC=m
+CONFIG_IP_NF_MANGLE=m
+CONFIG_IP_NF_TARGET_CLUSTERIP=m
+CONFIG_IP_NF_TARGET_ECN=m
+CONFIG_IP_NF_TARGET_TTL=m
+CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_ARPTABLES=m
+CONFIG_IP_NF_ARPFILTER=m
+CONFIG_IP_NF_ARP_MANGLE=m
+CONFIG_CFG80211=y
+CONFIG_LIB80211=y
+CONFIG_MAC80211=y
+CONFIG_MAC80211_LEDS=y
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_MTD=y
+CONFIG_MTD_CONCAT=y
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_DATAFLASH=y
+CONFIG_MTD_NAND=y
+CONFIG_MTD_NAND_ATMEL=y
+CONFIG_MTD_UBI=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=8192
+CONFIG_MISC_DEVICES=y
+CONFIG_EEPROM_AT24=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_SCSI_MULTI_LUN=y
+CONFIG_ATA=y
+CONFIG_PATA_AT91=y
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_MACB=y
+CONFIG_RTL8187=m
+CONFIG_RT2X00=y
+CONFIG_RT2500USB=y
+CONFIG_RT73USB=y
+CONFIG_RT2800USB=y
+CONFIG_PPP=y
+CONFIG_PPP_ASYNC=y
+CONFIG_PPP_DEFLATE=y
+CONFIG_PPP_BSDCOMP=y
+CONFIG_PPP_MPPE=y
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=320
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=240
+CONFIG_INPUT_EVDEV=y
+CONFIG_KEYBOARD_GPIO=y
+CONFIG_SERIAL_ATMEL=y
+CONFIG_SERIAL_ATMEL_CONSOLE=y
+CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_GPIO=y
+CONFIG_SPI=y
+CONFIG_SPI_ATMEL=y
+CONFIG_SPI_SPIDEV=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_PCF857X=y
+CONFIG_W1=y
+CONFIG_W1_MASTER_GPIO=y
+CONFIG_W1_SLAVE_DS2431=y
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_ACM=y
+CONFIG_USB_STORAGE=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_ETH=y
+CONFIG_MMC=y
+CONFIG_MMC_ATMELMCI=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_AT91SAM9=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_SUMMARY=y
+CONFIG_UBIFS_FS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_CODEPAGE_850=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_ISO8859_15=y
+CONFIG_NLS_UTF8=y
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index c015b68..72c5b10 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -381,6 +381,13 @@ config MACH_PCONTROL_G20
 	  Select this if you are using taskit's Stamp9G20 CPU module on this
 	  carrier board, beeing the decentralized unit of a building automation
 	  system; featuring nvram, eth-switch, iso-rs485, display, io
+
+config MACH_GSIA18S
+	bool "GS_IA18_S board"
+	help
+	  This enables support for the GS_IA18_S board
+	  produced by GeoSIG Ltd company. This is an internet accelerograph.
+	  <http://www.geosig.com>
 endif
 
 if (ARCH_AT91SAM9260 || ARCH_AT91SAM9G20)
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index d13add7..e8a33c3 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
 obj-$(CONFIG_MACH_STAMP9G20)	+= board-stamp9g20.o
 obj-$(CONFIG_MACH_PORTUXG20)	+= board-stamp9g20.o
 obj-$(CONFIG_MACH_PCONTROL_G20)	+= board-pcontrol-g20.o board-stamp9g20.o
+obj-$(CONFIG_MACH_GSIA18S)	+= board-gsia18s.o board-stamp9g20.o
 
 # AT91SAM9260/AT91SAM9G20 board-specific support
 obj-$(CONFIG_MACH_SNAPPER_9260)	+= board-snapper9260.o
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
new file mode 100644
index 0000000..797ed5a
--- /dev/null
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -0,0 +1,587 @@
+/*
+ *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
+ *                     taskit GmbH
+ *                2010 Igor Plyatov <plyatov@gmail.com>
+ *                     GeoSIG Ltd
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
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/w1-gpio.h>
+#include <linux/i2c/pcf857x.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include <mach/board.h>
+#include <mach/at91sam9_smc.h>
+#include <mach/gsia18s.h>
+#include <mach/stamp9g20.h>
+
+#include "sam9_smc.h"
+#include "generic.h"
+
+static void __init gsia18s_map_io(void)
+{
+	stamp9g20_map_io();
+
+	/*
+	 * USART0 on ttyS1 (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI).
+	 * Used for Internal Analog Modem.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US0, 1,
+			     ATMEL_UART_CTS | ATMEL_UART_RTS
+			   | ATMEL_UART_DTR | ATMEL_UART_DSR
+			   | ATMEL_UART_DCD | ATMEL_UART_RI);
+	/*
+	 * USART1 on ttyS2 (Rx, Tx, CTS, RTS).
+	 * Used for GPS or WiFi or Data stream.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US1, 2,
+			   ATMEL_UART_CTS | ATMEL_UART_RTS);
+	/*
+	 * USART2 on ttyS3 (Rx, Tx, CTS, RTS).
+	 * Used for External Modem.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US2, 3,
+			   ATMEL_UART_CTS | ATMEL_UART_RTS);
+	/*
+	 * USART3 on ttyS4 (Rx, Tx, RTS).
+	 * Used for RS-485.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US3, 4, ATMEL_UART_RTS);
+
+	/*
+	 * USART4 on ttyS5 (Rx, Tx).
+	 * Used for TRX433 Radio Module.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
+}
+
+static void __init init_irq(void)
+{
+	at91sam9260_init_interrupts(NULL);
+}
+
+/*
+ * Two USB Host ports
+ */
+static struct at91_usbh_data __initdata usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata udc_data = {
+	.vbus_pin	= AT91_PIN_PA22,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA28,
+	.is_rmii	= 1,
+};
+
+/*
+ * LEDs and GPOs
+ */
+static struct gpio_led gpio_leds[] = {
+	{
+		.name                   = "gpo:spi1reset",
+		.gpio                   = AT91_PIN_PC1,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "gpo:trig_net_out",
+		.gpio                   = AT91_PIN_PB20,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "gpo:trig_net_dir",
+		.gpio                   = AT91_PIN_PB19,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "gpo:charge_dis",
+		.gpio                   = AT91_PIN_PC2,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "led:event",
+		.gpio                   = AT91_PIN_PB17,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "led:lan",
+		.gpio                   = AT91_PIN_PB18,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "led:error",
+		.gpio                   = AT91_PIN_PB16,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	}
+};
+
+static struct gpio_led_platform_data gpio_led_info = {
+	.leds		= gpio_leds,
+	.num_leds	= ARRAY_SIZE(gpio_leds),
+};
+
+static struct platform_device leds = {
+	.name	= "leds-gpio",
+	.id	= 0,
+	.dev	= {
+		.platform_data	= &gpio_led_info,
+	}
+};
+
+static void __init gsia18s_leds_init(void)
+{
+	platform_device_register(&leds);
+}
+
+/* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
+static struct gpio_led pcf_gpio_leds1[] = {
+	{ /* bit 0 */
+		.name                   = "gpo:hdc_power",
+		.gpio                   = PCF_GPIO_HDC_POWER,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 1 */
+		.name                   = "gpo:wifi_setup",
+		.gpio                   = PCF_GPIO_WIFI_SETUP,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 2 */
+		.name                   = "gpo:wifi_enable",
+		.gpio                   = PCF_GPIO_WIFI_ENABLE,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 3  */
+		.name                   = "gpo:wifi_reset",
+		.gpio                   = PCF_GPIO_WIFI_RESET,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	},
+	/* bit 4 used as GPI  */
+	{ /* bit 5 */
+		.name                   = "gpo:gps_setup",
+		.gpio                   = PCF_GPIO_GPS_SETUP,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 6 */
+		.name                   = "gpo:gps_standby",
+		.gpio                   = PCF_GPIO_GPS_STANDBY,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	},
+	{ /* bit 7 */
+		.name                   = "gpo:gps_power",
+		.gpio                   = PCF_GPIO_GPS_POWER,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	}
+};
+
+static struct gpio_led_platform_data pcf_gpio_led_info1 = {
+	.leds		= pcf_gpio_leds1,
+	.num_leds	= ARRAY_SIZE(pcf_gpio_leds1),
+};
+
+static struct platform_device pcf_leds1 = {
+	.name	= "leds-gpio", /* GS_IA18-CB_board */
+	.id	= 1,
+	.dev	= {
+		.platform_data	= &pcf_gpio_led_info1,
+	}
+};
+
+/* PCF8574 0x22 GPIO - U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
+static struct gpio_led pcf_gpio_leds2[] = {
+	{ /* bit 0 */
+		.name                   = "gpo:alarm_1",
+		.gpio                   = PCF_GPIO_ALARM1,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 1 */
+		.name                   = "gpo:alarm_2",
+		.gpio                   = PCF_GPIO_ALARM2,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 2 */
+		.name                   = "gpo:alarm_3",
+		.gpio                   = PCF_GPIO_ALARM3,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 3 */
+		.name                   = "gpo:alarm_4",
+		.gpio                   = PCF_GPIO_ALARM4,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	/* bits 4, 5, 6 not used */
+	{ /* bit 7 */
+		.name                   = "gpo:alarm_v_relay_on",
+		.gpio                   = PCF_GPIO_ALARM_V_RELAY_ON,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+};
+
+static struct gpio_led_platform_data pcf_gpio_led_info2 = {
+	.leds		= pcf_gpio_leds2,
+	.num_leds	= ARRAY_SIZE(pcf_gpio_leds2),
+};
+
+static struct platform_device pcf_leds2 = {
+	.name	= "leds-gpio",
+	.id	= 2,
+	.dev	= {
+		.platform_data	= &pcf_gpio_led_info2,
+	}
+};
+
+/* PCF8574 0x24 GPIO U1 on the GS_2G-OPT23-A_V0 board (Modem) */
+static struct gpio_led pcf_gpio_leds3[] = {
+	{ /* bit 0 */
+		.name                   = "gpo:modem_power",
+		.gpio                   = PCF_GPIO_MODEM_POWER,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	  /* bits 1 and 2 not used */
+	{ /* bit 3 */
+		.name                   = "gpo:modem_reset",
+		.gpio                   = PCF_GPIO_MODEM_RESET,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	},
+	  /* bits 4, 5 and 6 not used */
+	{ /* bit 7 */
+		.name                   = "gpo:trx_reset",
+		.gpio                   = PCF_GPIO_TRX_RESET,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	}
+};
+
+static struct gpio_led_platform_data pcf_gpio_led_info3 = {
+	.leds		= pcf_gpio_leds3,
+	.num_leds	= ARRAY_SIZE(pcf_gpio_leds3),
+};
+
+static struct platform_device pcf_leds3 = {
+	.name	= "leds-gpio",
+	.id	= 3,
+	.dev	= {
+		.platform_data	= &pcf_gpio_led_info3,
+	}
+};
+
+static void __init gsia18s_pcf_leds_init(void)
+{
+	platform_device_register(&pcf_leds1);
+	platform_device_register(&pcf_leds2);
+	platform_device_register(&pcf_leds3);
+}
+
+/*
+ * SPI busses.
+ */
+static struct spi_board_info gsia18s_spi_devices[] = {
+	{ /* User accessible spi0, cs0 used for communication with MSP RTC */
+		.modalias	= "spidev",
+		.bus_num	= 0,
+		.chip_select	= 0,
+		.max_speed_hz	= 580000,
+		.mode		= SPI_MODE_1,
+	},
+	{ /* User accessible spi1, cs0 used for communication with int. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 0,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	},
+	{ /* User accessible spi1, cs1 used for communication with ext. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 1,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	},
+	{ /* User accessible spi1, cs2 used for communication with ext. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 2,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	},
+	{ /* User accessible spi1, cs3 used for communication with ext. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 3,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	}
+};
+
+/*
+ * GPI Buttons
+ */
+static struct gpio_keys_button buttons[] = {
+	{
+		.gpio		= GPIO_TRIG_NET_IN,
+		.code		= BTN_1,
+		.desc		= "TRIG_NET_IN",
+		.type		= EV_KEY,
+		.active_low	= 0,
+		.wakeup		= 1,
+	},
+	{ /* SW80 on the GS_IA18_S-MN board*/
+		.gpio		= GPIO_CARD_UNMOUNT_0,
+		.code		= BTN_2,
+		.desc		= "Card umount 0",
+		.type		= EV_KEY,
+		.active_low	= 1,
+		.wakeup		= 1,
+	},
+	{ /* SW79 on the GS_IA18_S-MN board*/
+		.gpio		= GPIO_CARD_UNMOUNT_1,
+		.code		= BTN_3,
+		.desc		= "Card umount 1",
+		.type		= EV_KEY,
+		.active_low	= 1,
+		.wakeup		= 1,
+	},
+	{ /* SW280 on the GS_IA18-CB board*/
+		.gpio		= GPIO_KEY_POWER,
+		.code		= KEY_POWER,
+		.desc		= "Power Off Button",
+		.type		= EV_KEY,
+		.active_low	= 0,
+		.wakeup		= 1,
+	}
+};
+
+static struct gpio_keys_platform_data button_data = {
+	.buttons	= buttons,
+	.nbuttons	= ARRAY_SIZE(buttons),
+};
+
+static struct platform_device button_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.num_resources	= 0,
+	.dev		= {
+		.platform_data	= &button_data,
+	}
+};
+
+static void __init gsia18s_add_device_buttons(void)
+{
+	at91_set_gpio_input(GPIO_TRIG_NET_IN, 1);
+	at91_set_deglitch(GPIO_TRIG_NET_IN, 1);
+	at91_set_gpio_input(GPIO_CARD_UNMOUNT_0, 1);
+	at91_set_deglitch(GPIO_CARD_UNMOUNT_0, 1);
+	at91_set_gpio_input(GPIO_CARD_UNMOUNT_1, 1);
+	at91_set_deglitch(GPIO_CARD_UNMOUNT_1, 1);
+	at91_set_gpio_input(GPIO_KEY_POWER, 0);
+	at91_set_deglitch(GPIO_KEY_POWER, 1);
+
+	platform_device_register(&button_device);
+}
+
+/*
+ * I2C
+ */
+static int pcf8574x_0x20_setup(struct i2c_client *client, int gpio,
+				unsigned int ngpio, void *context)
+{
+	int status;
+
+	status = gpio_request(gpio + PCF_GPIO_ETH_DETECT, "eth_det");
+	if (status < 0) {
+		pr_err("error: can't request GPIO%d\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+	status = gpio_direction_input(gpio + PCF_GPIO_ETH_DETECT);
+	if (status < 0) {
+		pr_err("error: can't setup GPIO%d as input\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+	status = gpio_export(gpio + PCF_GPIO_ETH_DETECT, false);
+	if (status < 0) {
+		pr_err("error: can't export GPIO%d\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+	status = gpio_sysfs_set_active_low(gpio + PCF_GPIO_ETH_DETECT, 1);
+	if (status < 0) {
+		pr_err("error: gpio_sysfs_set active_low(GPIO%d, 1)\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+
+	return 0;
+}
+
+static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio,
+					unsigned ngpio, void *context)
+{
+	gpio_free(gpio + PCF_GPIO_ETH_DETECT);
+	return 0;
+}
+
+static struct pcf857x_platform_data pcf20_pdata = {
+	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE0,
+	.n_latch	= (1 << 4),
+	.setup		= pcf8574x_0x20_setup,
+	.teardown	= pcf8574x_0x20_teardown,
+};
+
+static struct pcf857x_platform_data pcf22_pdata = {
+	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE1,
+};
+
+static struct pcf857x_platform_data pcf24_pdata = {
+	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE2,
+};
+
+static struct i2c_board_info __initdata gsia18s_i2c_devices[] = {
+	{ /* U1 on the GS_IA18-CB_V3 board */
+		I2C_BOARD_INFO("pcf8574", 0x20),
+		.platform_data = &pcf20_pdata,
+	},
+	{ /* U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
+		I2C_BOARD_INFO("pcf8574", 0x22),
+		.platform_data = &pcf22_pdata,
+	},
+	{ /* U1 on the GS_2G-OPT23-A_V0 board (Modem) */
+		I2C_BOARD_INFO("pcf8574", 0x24),
+		.platform_data = &pcf24_pdata,
+	},
+	{ /* U161 on the GS_IA18_S-MN board */
+		I2C_BOARD_INFO("24c1024", 0x50),
+	},
+	{ /* U162 on the GS_IA18_S-MN board */
+		I2C_BOARD_INFO("24c01", 0x53),
+	},
+};
+
+/*
+ * Compact Flash
+ */
+static struct at91_cf_data __initdata gsia18s_cf1_data = {
+	.irq_pin	= AT91_PIN_PA27,
+	.det_pin	= AT91_PIN_PB30,
+	.rst_pin	= AT91_PIN_PB31,
+	.chipselect	= 5,
+	.flags		= AT91_CF_TRUE_IDE,
+};
+
+/* Power Off by RTC */
+static void gsia18s_power_off(void)
+{
+	pr_notice("Power supply will be switched off automatically now or after 60 seconds without ArmDAS.\n");
+	at91_set_gpio_output(AT91_PIN_PA25, 1);
+	/* Spin to death... */
+	while (1)
+		;
+}
+
+static int __init gsia18s_power_off_init(void)
+{
+	pm_power_off = gsia18s_power_off;
+	return 0;
+}
+
+/* ---------------------------------------------------------------------------*/
+
+static void __init gsia18s_board_init(void)
+{
+	stamp9g20_board_init();
+	at91_add_device_usbh(&usbh_data);
+	at91_add_device_udc(&udc_data);
+	at91_add_device_eth(&macb_data);
+	gsia18s_leds_init();
+	gsia18s_pcf_leds_init();
+	gsia18s_add_device_buttons();
+	at91_add_device_i2c(gsia18s_i2c_devices,
+				ARRAY_SIZE(gsia18s_i2c_devices));
+	at91_add_device_cf(&gsia18s_cf1_data);
+	at91_add_device_spi(gsia18s_spi_devices,
+				ARRAY_SIZE(gsia18s_spi_devices));
+	gsia18s_power_off_init();
+}
+
+/*
+ * Up to date linux/arch/arm/tools/mach-types database required to support this.
+MACHINE_START(GSIA18S, "GS_IA18_S")
+*/
+MACHINE_START(STAMP9G20, "GS_IA18_S")
+	.boot_params	= AT91_SDRAM_BASE + 0x100,
+	.timer		= &at91sam926x_timer,
+	.map_io		= gsia18s_map_io,
+	.init_irq	= init_irq,
+	.init_machine	= gsia18s_board_init,
+MACHINE_END
diff --git a/arch/arm/mach-at91/include/mach/gsia18s.h b/arch/arm/mach-at91/include/mach/gsia18s.h
new file mode 100644
index 0000000..307c194
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/gsia18s.h
@@ -0,0 +1,33 @@
+/* Buttons */
+#define GPIO_TRIG_NET_IN		AT91_PIN_PB21
+#define GPIO_CARD_UNMOUNT_0		AT91_PIN_PB13
+#define GPIO_CARD_UNMOUNT_1		AT91_PIN_PB12
+#define GPIO_KEY_POWER			AT91_PIN_PA25
+
+/* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
+#define GS_IA18_S_PCF_GPIO_BASE0	NR_BUILTIN_GPIO
+#define PCF_GPIO_HDC_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 0)
+#define PCF_GPIO_WIFI_SETUP		(GS_IA18_S_PCF_GPIO_BASE0 + 1)
+#define PCF_GPIO_WIFI_ENABLE		(GS_IA18_S_PCF_GPIO_BASE0 + 2)
+#define PCF_GPIO_WIFI_RESET		(GS_IA18_S_PCF_GPIO_BASE0 + 3)
+#define PCF_GPIO_ETH_DETECT		4 /* this is a GPI */
+#define PCF_GPIO_GPS_SETUP		(GS_IA18_S_PCF_GPIO_BASE0 + 5)
+#define PCF_GPIO_GPS_STANDBY		(GS_IA18_S_PCF_GPIO_BASE0 + 6)
+#define PCF_GPIO_GPS_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 7)
+
+/* PCF8574 0x22 GPIO - U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
+#define GS_IA18_S_PCF_GPIO_BASE1	(GS_IA18_S_PCF_GPIO_BASE0 + 8)
+#define PCF_GPIO_ALARM1			(GS_IA18_S_PCF_GPIO_BASE1 + 0)
+#define PCF_GPIO_ALARM2			(GS_IA18_S_PCF_GPIO_BASE1 + 1)
+#define PCF_GPIO_ALARM3			(GS_IA18_S_PCF_GPIO_BASE1 + 2)
+#define PCF_GPIO_ALARM4			(GS_IA18_S_PCF_GPIO_BASE1 + 3)
+/* bits 4, 5, 6 not used */
+#define PCF_GPIO_ALARM_V_RELAY_ON	(GS_IA18_S_PCF_GPIO_BASE1 + 7)
+
+/* PCF8574 0x24 GPIO U1 on the GS_2G-OPT23-A_V0 board (Modem) */
+#define GS_IA18_S_PCF_GPIO_BASE2	(GS_IA18_S_PCF_GPIO_BASE1 + 8)
+#define PCF_GPIO_MODEM_POWER		(GS_IA18_S_PCF_GPIO_BASE2 + 0)
+#define PCF_GPIO_MODEM_RESET		(GS_IA18_S_PCF_GPIO_BASE2 + 3)
+/* bits 1, 2, 4, 5 not used */
+#define PCF_GPIO_TRX_RESET		(GS_IA18_S_PCF_GPIO_BASE2 + 6)
+/* bit 7 not used */
-- 
1.7.0.4

