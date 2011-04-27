Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1D0Kag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:30:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:23595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab1D0Ka3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,273,1301900400"; 
   d="scan'208";a="739084332"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 8/8] staging/mei: Updates to staging/Kconfig ane staging/Makefile and a new Makefile and Kconfig
Date: Wed, 27 Apr 2011 13:27:37 +0300
Message-Id: <1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes of Kconfig and Makefile in drivers/staging
for adding the Intel MEI Driver to the Linux kernel.
New Makefile and Kconfig building for MEI Driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/Kconfig      |    2 ++
 drivers/staging/Makefile     |    1 +
 drivers/staging/mei/Kconfig  |   10 ++++++++++
 drivers/staging/mei/Makefile |   20 ++++++++++++++++++++
 4 files changed, 33 insertions(+), 0 deletions(-)
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
index 0000000..5beb2b1
--- /dev/null
+++ b/drivers/staging/mei/Kconfig
@@ -0,0 +1,10 @@
+config INTEL_MEI
+	tristate "Intel Management Engine Interface (Intel MEI)"
+	depends on X86 && EXPERIMENTAL
+	help
+		The Intel Management Engine (Intel ME) provides Manageability,
+		Security and Media services for system containing Intel chipsets.
+		if selected /dev/mei misc device will be created.
+
+		For more information see
+		<http://software.intel.com/en-us/manageability/>
diff --git a/drivers/staging/mei/Makefile b/drivers/staging/mei/Makefile
new file mode 100644
index 0000000..21a5088
--- /dev/null
+++ b/drivers/staging/mei/Makefile
@@ -0,0 +1,20 @@
+#
+# Makefile - Intel Management Engine Interface (Intel MEI) Linux driver
+# Copyright (c) 2010-2011, Intel Corporation.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+# more details.
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

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

