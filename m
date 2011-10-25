Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1JYTEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:04:33 -0400
Received: from mail0.scram.de ([78.47.204.202]:59084 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1JYTEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:04:31 -0400
X-Greylist: delayed 774 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 15:04:31 EDT
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.183
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jochen Friedrich <jochen@scram.de>, stable@kernel.org
Subject: [PATCH] ARM: at91: Fix USBA gadget registration
Date: Tue, 25 Oct 2011 20:51:06 +0200
Message-Id: <1319568666-10745-1-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b, various AT91 boards don't
register USBA adapters anymore due to depending on a now non-existing
symbol. Fix the symbol name.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
CC: stable@kernel.org
---
 arch/arm/mach-at91/at91cap9_devices.c    |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index dba0d8d..0512baf 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
 
 static struct resource usba_udc_resources[] = {
 	[0] = {
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 600bffb..371bb0e 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -191,7 +191,7 @@ void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data) {}
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
 static struct resource usba_udc_resources[] = {
 	[0] = {
 		.start	= AT91SAM9G45_UDPHS_FIFO,
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index aacb19d..c884d59 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -75,7 +75,7 @@ void __init at91_add_device_hdmac(void) {}
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
 
 static struct resource usba_udc_resources[] = {
 	[0] = {
-- 
1.7.7

