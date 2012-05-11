Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2EKQkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:40:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:20996 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2EKQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:40:11 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 1/7] ACPI: Add CONFIG_HOTPLUG_OST option
Date: Fri, 11 May 2012 10:36:57 -0600
Message-Id: <1336754223-5346-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
References: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CONFIG_ACPI_HOTPLUG_OPT option. When this config option is disabled,
this patchset has no effect on the platform. This option is disabled by
default. The dependency list assures consistent behavior among CPU, memory
and container hotplug operations with regarding the _OST support.

Some platforms may require the OS to support _OST in order to support
ACPI hotplug operations. For example, if a platform has the management
console where user can request a hotplug operation from, this _OST support
would be required for the management console to show the result of the
hotplug request to user.

ACPI PCI hotplug is not enhanced to support _OST at this time since it is
a legacy method being replaced by PCI native hotplug. _OST support for
ACPI PCI hotplug may be added in future if necessary.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 47768ff..d318c5e 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -351,6 +351,20 @@ config ACPI_HOTPLUG_MEMORY
 	  To compile this driver as a module, choose M here:
 	  the module will be called acpi_memhotplug.
 
+config ACPI_HOTPLUG_OST
+	bool "Hotplug Status Indication Support"
+	depends on ACPI_HOTPLUG_CPU
+	depends on ACPI_HOTPLUG_MEMORY
+	depends on ACPI_CONTAINER
+	default n
+	help
+	  This option enables the use of the ACPI OSPM Status Indication
+          (_OST), if available, for the platform to determine the status
+	  of various hotplug operations. Some platforms may require that
+	  this option be enabled to track the status of hotplug operations.
+	  This option has no effect when the platform does not support
+	  _OST.
+
 config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
-- 
1.7.7.6

