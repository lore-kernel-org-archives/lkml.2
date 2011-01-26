Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1AZTRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:17:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57032 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1AZTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:17:50 -0500
Date: Wed, 26 Jan 2011 11:16:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Cc: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH -mmotm] backlight: apple_bl depends on ACPI
Message-Id: <20110126111602.7bfea64e.randy.dunlap@oracle.com>
In-Reply-To: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org>
References: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

apple_bl uses ACPI interfaces (data & code), so it should depend on ACPI.

drivers/video/backlight/apple_bl.c:142: warning: 'struct acpi_device' declared inside parameter list
drivers/video/backlight/apple_bl.c:142: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/video/backlight/apple_bl.c:201: warning: 'struct acpi_device' declared inside parameter list
drivers/video/backlight/apple_bl.c:215: error: variable 'apple_bl_driver' has initializer but incomplete type
drivers/video/backlight/apple_bl.c:216: error: unknown field 'name' specified in initializer
drivers/video/backlight/apple_bl.c:216: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:216: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:217: error: unknown field 'ids' specified in initializer
drivers/video/backlight/apple_bl.c:217: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:217: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:218: error: unknown field 'ops' specified in initializer
drivers/video/backlight/apple_bl.c:218: error: extra brace group at end of initializer
drivers/video/backlight/apple_bl.c:218: error: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:221: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:221: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:226: error: implicit declaration of function 'acpi_bus_register_driver'
drivers/video/backlight/apple_bl.c:231: error: implicit declaration of function 'acpi_bus_unregister_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2011-0125-1547.orig/drivers/video/backlight/Kconfig
+++ mmotm-2011-0125-1547/drivers/video/backlight/Kconfig
@@ -238,10 +238,10 @@ config BACKLIGHT_MAX8925
 
 config BACKLIGHT_APPLE
        tristate "Apple Backlight Driver"
-       depends on X86
+       depends on X86 && ACPI
        help
          If you have an Intel-based Apple say Y to enable a driver for its
-	 backlight
+	 backlight.
 
 config BACKLIGHT_TOSA
 	tristate "Sharp SL-6000 Backlight Driver"
