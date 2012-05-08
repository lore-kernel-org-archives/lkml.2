Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2EHUPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:15:30 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16677 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab2EHUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:15:28 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 1/7] ACPI: Add CONFIG_HOTPLUG_OST option
Date: Tue,  8 May 2012 14:12:18 -0600
Message-Id: <1336507944-10219-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CONFIG_ACPI_HOTPLUG_OPT option. When this config option is disabled,
this patchset has no effect on the platform. This option is disabled by
default. The dependency list assures consistent behavior among CPU, memory
and container hotplug operations with regarding the _OST support.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 47768ff..1e3a756 100644
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
+	  of various hotplug operations. Some platforms may require this
+	  option be enabled to track the status of hotplug operations.
+	  This option has no effect when the platform does not support
+	  _OST.
+
 config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
-- 
1.7.7.6

