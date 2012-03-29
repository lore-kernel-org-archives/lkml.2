Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab2C2NaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:30:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:26774 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab2C2N17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:59 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 03/12] ARM: at91/USB host: specify and handle properly vbus_pin_active_low
Date: Thu, 29 Mar 2012 15:27:14 +0200
Message-Id: <ce442f466ded5a4c75a0fc15700dc14fe60b91d8.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to an error while handling vbus_pin_active_low in ohci-at91 driver,
the specification of this property was not good in devices/board files.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: stable <stable@vger.kernel.org>         [3.2+]
---
 arch/arm/mach-at91/at91sam9263_devices.c |    3 ++-
 arch/arm/mach-at91/at91sam9g45_devices.c |    6 ++++--
 arch/arm/mach-at91/board-sam9263ek.c     |    1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c  |    1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 53688c4..5cdca89d 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -72,7 +72,8 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data)
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
 		if (gpio_is_valid(data->vbus_pin[i]))
-			at91_set_gpio_output(data->vbus_pin[i], 0);
+			at91_set_gpio_output(data->vbus_pin[i],
+					     data->vbus_pin_active_low[i] ^ 0);
 	}
 
 	/* Enable overcurrent notification */
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 4320b20..763deba 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -127,7 +127,8 @@ void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data)
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
 		if (gpio_is_valid(data->vbus_pin[i]))
-			at91_set_gpio_output(data->vbus_pin[i], 0);
+			at91_set_gpio_output(data->vbus_pin[i],
+					     data->vbus_pin_active_low[i] ^ 0);
 	}
 
 	/* Enable overcurrent notification */
@@ -188,7 +189,8 @@ void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data)
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
 		if (gpio_is_valid(data->vbus_pin[i]))
-			at91_set_gpio_output(data->vbus_pin[i], 0);
+			at91_set_gpio_output(data->vbus_pin[i],
+					     data->vbus_pin_active_low[i] ^ 0);
 	}
 
 	usbh_ehci_data = *data;
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 66f0ddf..2ffe50f 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -74,6 +74,7 @@ static void __init ek_init_early(void)
 static struct at91_usbh_data __initdata ek_usbh_data = {
 	.ports		= 2,
 	.vbus_pin	= { AT91_PIN_PA24, AT91_PIN_PA21 },
+	.vbus_pin_active_low = {1, 1},
 	.overcurrent_pin= {-EINVAL, -EINVAL},
 };
 
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index e1bea73..c88e908 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -71,6 +71,7 @@ static void __init ek_init_early(void)
 static struct at91_usbh_data __initdata ek_usbh_hs_data = {
 	.ports		= 2,
 	.vbus_pin	= {AT91_PIN_PD1, AT91_PIN_PD3},
+	.vbus_pin_active_low = {1, 1},
 	.overcurrent_pin= {-EINVAL, -EINVAL},
 };
 
-- 
1.7.9.4

