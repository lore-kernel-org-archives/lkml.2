Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0EGPQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:16:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:28492 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab0EGPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:15:56 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv2 3/7] OMAP SSI: Add OMAP SSI to the kernel configuration
Date: Fri,  7 May 2010 18:18:33 +0300
Message-Id: <1273245517-30712-4-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
X-OriginalArrivalTime: 07 May 2010 15:15:49.0874 (UTC) FILETIME=[2D27DD20:01CAEDF8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OMAP SSI device and driver to the kernel configuration

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 arch/arm/mach-omap2/Makefile     |    3 +++
 drivers/hsi/Kconfig              |    2 ++
 drivers/hsi/Makefile             |    1 +
 drivers/hsi/controllers/Kconfig  |   13 +++++++++++++
 drivers/hsi/controllers/Makefile |    5 +++++
 5 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 4b9fc57..106f0d5 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -97,6 +97,9 @@ obj-$(CONFIG_OMAP_IOMMU)		+= $(iommu-y)
 i2c-omap-$(CONFIG_I2C_OMAP)		:= i2c.o
 obj-y					+= $(i2c-omap-m) $(i2c-omap-y)
 
+omap-ssi-$(CONFIG_OMAP_SSI)		:= ssi.o
+obj-y					+= $(omap-ssi-m) $(omap-ssi-y)
+
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
index 5af62ce..07987b6 100644
--- a/drivers/hsi/Kconfig
+++ b/drivers/hsi/Kconfig
@@ -10,4 +10,6 @@ menuconfig HSI
 
 if HSI
 
+source "drivers/hsi/controllers/Kconfig"
+
 endif # HSI
diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
index b42b6cf..d020ae1 100644
--- a/drivers/hsi/Makefile
+++ b/drivers/hsi/Makefile
@@ -2,3 +2,4 @@
 # Makefile for HSI
 #
 obj-$(CONFIG_HSI)	+= hsi.o
+obj-y			+= controllers/
diff --git a/drivers/hsi/controllers/Kconfig b/drivers/hsi/controllers/Kconfig
new file mode 100644
index 0000000..398abba
--- /dev/null
+++ b/drivers/hsi/controllers/Kconfig
@@ -0,0 +1,13 @@
+#
+# HSI controllers configuration
+#
+comment "HSI controllers"
+
+config OMAP_SSI
+	tristate "OMAP SSI hardware driver"
+	depends on ARCH_OMAP && HSI
+	default n
+	---help---
+	  If you say Y here, you will enable the OMAP SSI hardware driver.
+
+	  If unsure, say N.
diff --git a/drivers/hsi/controllers/Makefile b/drivers/hsi/controllers/Makefile
new file mode 100644
index 0000000..c4ba2c2
--- /dev/null
+++ b/drivers/hsi/controllers/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for HSI controllers drivers
+#
+
+obj-$(CONFIG_OMAP_SSI)		+= omap_ssi.o
-- 
1.5.6.5

