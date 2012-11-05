Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab2KEXbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:31:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38466 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab2KEXFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:20 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Len Brown <lenb@kernel.org>
Subject: [PATCH 040/104] drivers/acpi: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:57 -0800
Message-Id: <1352156701-4038-41-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Len Brown <lenb@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/Kconfig |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 119d58d..ad2a291 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -176,7 +176,6 @@ config ACPI_FAN
 
 config ACPI_DOCK
 	bool "Dock"
-	depends on EXPERIMENTAL
 	help
 	  This driver supports ACPI-controlled docking stations and removable
 	  drive bays such as the IBM Ultrabay and the Dell Module Bay.
@@ -196,7 +195,7 @@ config ACPI_PROCESSOR
 	  the module will be called processor.
 config ACPI_IPMI
 	tristate "IPMI"
-	depends on EXPERIMENTAL && IPMI_SI && IPMI_HANDLER
+	depends on IPMI_SI && IPMI_HANDLER
 	default n
 	help
 	  This driver enables the ACPI to access the BMC controller. And it
@@ -208,14 +207,13 @@ config ACPI_IPMI
 
 config ACPI_HOTPLUG_CPU
 	bool
-	depends on EXPERIMENTAL && ACPI_PROCESSOR && HOTPLUG_CPU
+	depends on ACPI_PROCESSOR && HOTPLUG_CPU
 	select ACPI_CONTAINER
 	default y
 
 config ACPI_PROCESSOR_AGGREGATOR
 	tristate "Processor Aggregator"
 	depends on ACPI_PROCESSOR
-	depends on EXPERIMENTAL
 	depends on X86
 	help
 	  ACPI 4.0 defines processor Aggregator, which enables OS to perform
@@ -322,8 +320,7 @@ config X86_PM_TIMER
 	  systems require this timer. 
 
 config ACPI_CONTAINER
-	tristate "Container and Module Devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Container and Module Devices"
 	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
 	help
 	  This driver supports ACPI Container and Module devices (IDs
-- 
1.7.9.5

