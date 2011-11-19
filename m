Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab1KSANk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:13:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517Ab1KSAKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:10:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:28 2011
Message-Id: <20111119000328.214865274@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jochen Friedrich <jochen@scram.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [04/26] ARM: at91: Fix USBA gadget registration
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jochen Friedrich <jochen@scram.de>

commit dd0b3825495a2e7a8cd6cf0ec077618c008ac7c4 upstream.

Since 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b, various AT91 boards don't
register USBA adapters anymore due to depending on a now non-existing
symbol. Fix the symbol name.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-at91/at91cap9_devices.c    |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
 
 static struct resource usba_udc_resources[] = {
 	[0] = {
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -191,7 +191,7 @@ void __init at91_add_device_usbh_ehci(st
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
 static struct resource usba_udc_resources[] = {
 	[0] = {
 		.start	= AT91SAM9G45_UDPHS_FIFO,
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -75,7 +75,7 @@ void __init at91_add_device_hdmac(void)
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
 
 static struct resource usba_udc_resources[] = {
 	[0] = {


