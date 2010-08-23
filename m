Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0HWRcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:32:39 -0400
Received: from tex.lwn.net ([70.33.254.29]:54095 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab0HWRci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:32:38 -0400
Date: Mon, 23 Aug 2010 11:32:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI_TOSHIBA needs LEDS support
Message-ID: <20100823113236.221deec7@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't ask how ACPI_TOSHIBA got enabled on in desktop system's .config -
I don't know.  But it has silently been there until I tried 2.6.36-rc2,
where it broke the build because I don't have LED support turned on.
Attached patch fixes things up.

(I had to change BACKLIGHT_CLASS_DEVICE to "depends" because otherwise
I get unsightly core dumps out of scripts/kconfig/conf).

jon

--
toshiba: make sure we pull in LED support

The Toshiba extras driver uses the LED module, so make sure we have it
configure in.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 044f430..cff7cc2 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -486,10 +486,12 @@ config TOPSTAR_LAPTOP
 config ACPI_TOSHIBA
 	tristate "Toshiba Laptop Extras"
 	depends on ACPI
+	depends on LEDS_CLASS
+	depends on NEW_LEDS
+	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
 	select INPUT_POLLDEV
-	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to certain system settings
 	  on "legacy free" Toshiba laptops.  These laptops can be recognized by
