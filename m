Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0LNKKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:10:38 -0500
Received: from smtp.nokia.com ([147.243.1.48]:51967 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035Ab0LNKJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:09:06 -0500
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv4 3/7] HSI: omap_ssi: Add OMAP SSI to the kernel configuration
Date: Tue, 14 Dec 2010 12:09:39 +0200
Message-Id: <1292321383-30200-4-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OMAP SSI device and driver to the kernel configuration

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 arch/arm/mach-omap2/Makefile     |    2 ++
 drivers/hsi/Kconfig              |    2 ++
 drivers/hsi/Makefile             |    1 +
 drivers/hsi/controllers/Kconfig  |   23 +++++++++++++++++++++++
 drivers/hsi/controllers/Makefile |    5 +++++
 5 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index b0810b9..1a1c0d9 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -111,6 +111,8 @@ obj-y					+= $(i2c-omap-m) $(i2c-omap-y)
 ifneq ($(CONFIG_TIDSPBRIDGE),)
 obj-y					+= dsp.o
 endif
+omap-ssi-$(CONFIG_OMAP_SSI)		:= ssi.o
+obj-y					+= $(omap-ssi-m) $(omap-ssi-y)
 
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
index 937062e..bba73ea 100644
--- a/drivers/hsi/Kconfig
+++ b/drivers/hsi/Kconfig
@@ -14,4 +14,6 @@ config HSI_BOARDINFO
 	bool
 	default y
 
+source "drivers/hsi/controllers/Kconfig"
+
 endif # HSI
diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
index ed94a3a..0de87bd 100644
--- a/drivers/hsi/Makefile
+++ b/drivers/hsi/Makefile
@@ -3,3 +3,4 @@
 #
 obj-$(CONFIG_HSI_BOARDINFO)	+= hsi_boardinfo.o
 obj-$(CONFIG_HSI)		+= hsi.o
+obj-y				+= controllers/
diff --git a/drivers/hsi/controllers/Kconfig b/drivers/hsi/controllers/Kconfig
new file mode 100644
index 0000000..3efe0f0
--- /dev/null
+++ b/drivers/hsi/controllers/Kconfig
@@ -0,0 +1,23 @@
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
+	  SSI is a legacy version of HSI. It is usually used to connect
+	  an application engine with a cellular modem.
+	  If you say Y here, you will enable the OMAP SSI hardware driver.
+
+	  If unsure, say N.
+
+if OMAP_SSI
+
+config OMAP_SSI_CONFIG
+	boolean
+	default y
+
+endif # OMAP_SSI
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
1.7.1

