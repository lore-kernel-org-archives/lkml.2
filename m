Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2C2Nae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:30:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27506 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2C2N14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:56 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 12/12] ARM: at91: fix check of valid GPIO for SPI and USB
Date: Thu, 29 Mar 2012 15:27:23 +0200
Message-Id: <8849f8f500eeccdf26576228f1c3a98bdc627ecd.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI chip select pins have to be checked by gpio_is_valid().
The USB host overcurrent_pin checking was missing.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/at91sam9260_devices.c |    3 +++
 arch/arm/mach-at91/at91sam9261_devices.c |    3 +++
 arch/arm/mach-at91/at91sam9263_devices.c |    3 +++
 arch/arm/mach-at91/at91sam9g45_devices.c |    5 ++++-
 arch/arm/mach-at91/at91sam9rl_devices.c  |    3 +++
 5 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 7e5651e..5652dde 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -598,6 +598,9 @@ void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices)
 		else
 			cs_pin = spi1_standard_cs[devices[i].chip_select];
 
+		if (!gpio_is_valid(cs_pin))
+			continue;
+
 		if (devices[i].bus_num == 0)
 			enable_spi0 = 1;
 		else
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 096da87..4db961a 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -415,6 +415,9 @@ void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices)
 		else
 			cs_pin = spi1_standard_cs[devices[i].chip_select];
 
+		if (!gpio_is_valid(cs_pin))
+			continue;
+
 		if (devices[i].bus_num == 0)
 			enable_spi0 = 1;
 		else
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 5cdca89d..32ce589 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -672,6 +672,9 @@ void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices)
 		else
 			cs_pin = spi1_standard_cs[devices[i].chip_select];
 
+		if (!gpio_is_valid(cs_pin))
+			continue;
+
 		if (devices[i].bus_num == 0)
 			enable_spi0 = 1;
 		else
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 763deba..9cff8b4 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -133,7 +133,7 @@ void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data)
 
 	/* Enable overcurrent notification */
 	for (i = 0; i < data->ports; i++) {
-		if (data->overcurrent_pin[i])
+		if (gpio_is_valid(data->overcurrent_pin[i]))
 			at91_set_gpio_input(data->overcurrent_pin[i], 1);
 	}
 
@@ -788,6 +788,9 @@ void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices)
 		else
 			cs_pin = spi1_standard_cs[devices[i].chip_select];
 
+		if (!gpio_is_valid(cs_pin))
+			continue;
+
 		if (devices[i].bus_num == 0)
 			enable_spi0 = 1;
 		else
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index eda72e8..fe4ae22 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -419,6 +419,9 @@ void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices)
 		else
 			cs_pin = spi_standard_cs[devices[i].chip_select];
 
+		if (!gpio_is_valid(cs_pin))
+			continue;
+
 		/* enable chip-select pin */
 		at91_set_gpio_output(cs_pin, 1);
 
-- 
1.7.9.4

