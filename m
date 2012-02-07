Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2BGAWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:22:42 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab2BGAWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:22:18 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        Artem.Bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/5] MTD: Relax dependencies
Date: Tue,  7 Feb 2012 01:22:50 +0100
Message-Id: <1328574170-2286-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1328574170-2286-1-git-send-email-richard@nod.at>
References: <1328574170-2286-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GENERIC_IO is just enough for the basic MTD stuff.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/Kconfig         |    2 +-
 drivers/mtd/devices/Kconfig |    1 +
 drivers/mtd/maps/Kconfig    |    1 +
 drivers/mtd/nand/Kconfig    |    2 ++
 drivers/mtd/onenand/Kconfig |    1 +
 5 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 1be6218..284cf34 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -1,6 +1,6 @@
 menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
-	depends on HAS_IOMEM
+	depends on GENERIC_IO
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
 	  used for solid state file systems on embedded devices. This option
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 37b05c3..8d3dac4 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -1,5 +1,6 @@
 menu "Self-contained MTD device drivers"
 	depends on MTD!=n
+	depends on HAS_IOMEM
 
 config MTD_PMC551
 	tristate "Ramix PMC551 PCI Mezzanine RAM card support"
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 6c5c431..8af67cf 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -1,5 +1,6 @@
 menu "Mapping drivers for chip access"
 	depends on MTD!=n
+	depends on HAS_IOMEM
 
 config MTD_COMPLEX_MAPPINGS
 	bool "Support non-linear mappings of flash chips"
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 31b034b..80de7b3 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -246,6 +246,7 @@ config MTD_NAND_BCM_UMI_HWCS
 config MTD_NAND_DISKONCHIP
 	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation) (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on HAS_IOMEM
 	select REED_SOLOMON
 	select REED_SOLOMON_DEC16
 	help
@@ -431,6 +432,7 @@ config MTD_NAND_GPMI_NAND
 
 config MTD_NAND_PLATFORM
 	tristate "Support for generic platform NAND driver"
+	depends on HAS_IOMEM
 	help
 	  This implements a generic NAND driver for on-SOC platform
 	  devices. You will need to provide platform-specific functions
diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
index 772ad29..91467bb 100644
--- a/drivers/mtd/onenand/Kconfig
+++ b/drivers/mtd/onenand/Kconfig
@@ -1,6 +1,7 @@
 menuconfig MTD_ONENAND
 	tristate "OneNAND Device Support"
 	depends on MTD
+	depends on HAS_IOMEM
 	help
 	  This enables support for accessing all type of OneNAND flash
 	  devices. For further information see
-- 
1.7.6

