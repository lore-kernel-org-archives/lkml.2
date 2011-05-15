Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab1EOKqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:46:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447Ab1EOKpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:45:47 -0400
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se, tomas.winkler@intel.com,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 10/10] staging/mei: add mei to staging Kbuild
Date: Sun, 15 May 2011 13:43:48 +0300
Message-Id: <1305456228-15265-11-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
References: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mei to Kconfig and Makefile in drivers/staging

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/Kconfig      |    2 ++
 drivers/staging/Makefile     |    1 +
 drivers/staging/mei/Kconfig  |   28 ++++++++++++++++++++++++++++
 drivers/staging/mei/Makefile |   11 +++++++++++
 4 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/Kconfig
 create mode 100644 drivers/staging/mei/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e3786f1..856c0d6 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -177,5 +177,7 @@ source "drivers/staging/gma500/Kconfig"
 
 source "drivers/staging/altera-stapl/Kconfig"
 
+source "drivers/staging/mei/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index f0d5c53..73e7f80 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -70,3 +70,4 @@ obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_TOUCHSCREEN_CLEARPAD_TM1217)	+= cptm1217/
 obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
 obj-$(CONFIG_DRM_PSB)		+= gma500/
+obj-$(CONFIG_INTEL_MEI)		+= mei/
diff --git a/drivers/staging/mei/Kconfig b/drivers/staging/mei/Kconfig
new file mode 100644
index 0000000..3f3f170
--- /dev/null
+++ b/drivers/staging/mei/Kconfig
@@ -0,0 +1,28 @@
+config INTEL_MEI
+	tristate "Intel Management Engine Interface (Intel MEI)"
+	depends on X86 && PCI && EXPERIMENTAL
+	help
+	  The Intel Management Engine (Intel ME) provides Manageability,
+	  Security and Media services for system containing Intel chipsets.
+	  if selected /dev/mei misc device will be created.
+
+	  Supported Chipsets are:
+	  7 Series Chipset Family
+	  6 Series Chipset Family
+	  5 Series Chipset Family
+	  4 Series Chipset Family
+	  Mobile 4 Series Chipset Family
+	  ICH9
+	  82946GZ/GL
+	  82G35 Express
+	  82Q963/Q965
+	  82P965/G965
+	  Mobile PM965/GM965
+	  Mobile GME965/GLE960
+	  82Q35 Express
+	  82G33/G31/P35/P31 Express
+	  82Q33 Express
+	  82X38/X48 Express
+
+	  For more information see
+	  <http://software.intel.com/en-us/manageability/>
diff --git a/drivers/staging/mei/Makefile b/drivers/staging/mei/Makefile
new file mode 100644
index 0000000..57168db
--- /dev/null
+++ b/drivers/staging/mei/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile - Intel Management Engine Interface (Intel MEI) Linux driver
+# Copyright (c) 2010-2011, Intel Corporation.
+#
+obj-$(CONFIG_INTEL_MEI) += mei.o
+mei-objs := init.o
+mei-objs += interrupt.o
+mei-objs += interface.o
+mei-objs += iorw.o
+mei-objs += main.o
+mei-objs += wd.o
-- 
1.7.1

