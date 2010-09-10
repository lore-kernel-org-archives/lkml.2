Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0IJXvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:51:19 -0400
Received: from ns2.cypress.com ([157.95.67.5]:33826 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0IJXvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:51:17 -0400
Subject: [PATCH] west bridge, Kconfig fix
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Fri, 10 Sep 2010 16:51:05 -0700
Message-Id: <1284162665.16135.3.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the currently broken Kconfig for west bridge by
introducing a dependency on a valid HAL Layer for the driver build.

Signed-off-by: David Cross <david.cross@cypress.com>
---
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/Kconfig linux-next-incremen/drivers/staging/westbridge/Kconfig
--- linux-next-vanilla/drivers/staging/westbridge/Kconfig	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/Kconfig	2010-09-09 19:12:18.000000000 -0700
@@ -4,7 +4,7 @@
 
 menuconfig WESTBRIDGE
 	tristate "West Bridge support"
-	depends on HAS_IOMEM && BROKEN
+	depends on WESTBRIDGE_HAL_SELECTED
 	help
 	  This selects West Bridge Peripheral controller support.
 
@@ -12,7 +12,7 @@ menuconfig WESTBRIDGE
 
 menuconfig WESTBRIDGE_ASTORIA
 	bool "West Bridge Astoria support"
-	depends on WESTBRIDGE != n
+	depends on WESTBRIDGE != n && WESTBRIDGE_HAL_SELECTED
 	help
 		This option enables support for West Bridge Astoria
 
@@ -20,11 +20,30 @@ if WESTBRIDGE_ASTORIA
 source "drivers/staging/westbridge/astoria/Kconfig"
 endif #WESTBRIDGE_ASTORIA
 
-menuconfig MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
+config	WESTBRIDGE_HAL_SELECTED
+	boolean
+
+choice
+	prompt "West Bridge HAL"
+	help
+	   West Bridge HAL/processor interface to be used
+
+#
+# HAL Layers
+#
+
+config MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
 	bool "WESTBRIDGE OMAP3430 Astoria PNAND HAL"
-	depends on ARCH_OMAP3 && WESTBRIDGE_ASTORIA
+	depends on ARCH_OMAP3
+	select WESTBRIDGE_HAL_SELECTED
+	help
+	   Include the OMAP3430 HAL for PNAND interface
+
+config MACH_NO_WESTBRIDGE
+	bool "no West Bridge HAL selected"
 	help
-		Include the OMAP3430 Linux Based HAL
+	   Do not include any HAL layer(de-activates West Bridge option)
+endchoice
 
 config WESTBRIDGE_DEBUG
 	bool "West Bridge debugging"


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

