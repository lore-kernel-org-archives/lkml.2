Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab2DKXQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:16:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab2DKXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:42 -0400
Message-Id: <20120411231027.327921349@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 53/78] ARM: at91/USB host: specify and handle properly vbus_pin_active_low
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit cca0355a09b1bfe9f8985285199a346e13cacf39 upstream.

Due to an error while handling vbus_pin_active_low in ohci-at91 driver,
the specification of this property was not good in devices/board files.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/at91sam9263_devices.c |    3 ++-
 arch/arm/mach-at91/at91sam9g45_devices.c |    6 ++++--
 arch/arm/mach-at91/board-sam9263ek.c     |    1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c  |    1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -71,7 +71,8 @@ void __init at91_add_device_usbh(struct
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
 		if (gpio_is_valid(data->vbus_pin[i]))
-			at91_set_gpio_output(data->vbus_pin[i], 0);
+			at91_set_gpio_output(data->vbus_pin[i],
+					     data->vbus_pin_active_low[i]);
 	}
 
 	/* Enable overcurrent notification */
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -122,7 +122,8 @@ void __init at91_add_device_usbh_ohci(st
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
 		if (gpio_is_valid(data->vbus_pin[i]))
-			at91_set_gpio_output(data->vbus_pin[i], 0);
+			at91_set_gpio_output(data->vbus_pin[i],
+					     data->vbus_pin_active_low[i]);
 	}
 
 	/* Enable overcurrent notification */
@@ -183,7 +184,8 @@ void __init at91_add_device_usbh_ehci(st
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
 		if (gpio_is_valid(data->vbus_pin[i]))
-			at91_set_gpio_output(data->vbus_pin[i], 0);
+			at91_set_gpio_output(data->vbus_pin[i],
+					     data->vbus_pin_active_low[i]);
 	}
 
 	usbh_ehci_data = *data;
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -74,6 +74,7 @@ static void __init ek_init_early(void)
 static struct at91_usbh_data __initdata ek_usbh_data = {
 	.ports		= 2,
 	.vbus_pin	= { AT91_PIN_PA24, AT91_PIN_PA21 },
+	.vbus_pin_active_low = {1, 1},
 	.overcurrent_pin= {-EINVAL, -EINVAL},
 };
 
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -69,6 +69,7 @@ static void __init ek_init_early(void)
 static struct at91_usbh_data __initdata ek_usbh_hs_data = {
 	.ports		= 2,
 	.vbus_pin	= {AT91_PIN_PD1, AT91_PIN_PD3},
+	.vbus_pin_active_low = {1, 1},
 	.overcurrent_pin= {-EINVAL, -EINVAL},
 };
 


