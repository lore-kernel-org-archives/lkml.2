Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0H1RLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:11:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0H1RLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:11:19 -0400
Date: Sat, 28 Aug 2010 10:10:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] acpi_toshiba: fix kconfig error
Message-Id: <20100828101050.7d4321fe.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig recursive dependency error in ACPI_TOSHIBA:
it uses both select and depends on for BACKLIGHT_CLASS_DEVICE.

drivers/video/backlight/Kconfig:117:error: recursive dependency detected!
drivers/video/backlight/Kconfig:117:    symbol BACKLIGHT_CLASS_DEVICE is selected by ACPI_TOSHIBA
drivers/platform/x86/Kconfig:490:       symbol ACPI_TOSHIBA depends on LEDS_CLASS
drivers/leds/Kconfig:12:        symbol LEDS_CLASS is selected by BACKLIGHT_ADP8860
drivers/video/backlight/Kconfig:285:    symbol BACKLIGHT_ADP8860 depends on BACKLIGHT_CLASS_DEVICE

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- linux-next-20100827.orig/drivers/platform/x86/Kconfig
+++ linux-next-20100827/drivers/platform/x86/Kconfig
@@ -497,7 +497,6 @@ config ACPI_TOSHIBA
 	depends on RFKILL || RFKILL = n
 	select INPUT_POLLDEV
 	select INPUT_SPARSEKMAP
-	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to certain system settings
 	  on "legacy free" Toshiba laptops.  These laptops can be recognized by
