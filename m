Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1CVKzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:55:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:55878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1CVKz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:55:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,224,1299484800"; 
   d="scan'208";a="722820037"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 7/7] char/mei: Updates to char/Kconfig ane char/Makefile
Date: Tue, 22 Mar 2011 12:51:32 +0200
Message-Id: <1300791092-14319-8-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes of Kconfig and Makefile in driver/char
for adding the Intel MEI Driver to the Linux kernel.
New Makefile building for MEI Driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/char/Kconfig      |   12 +++++++++++-
 drivers/char/Makefile     |    1 +
 drivers/char/mei/Makefile |   19 +++++++++++++++++++
 3 files changed, 31 insertions(+), 1 deletions(-)
 create mode 100644 drivers/char/mei/Makefile

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 04f8b2d..694dc0e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -608,5 +608,15 @@ config RAMOOPS
 	  This enables panic and oops messages to be logged to a circular
 	  buffer in RAM where it can be read back at some later point.
 
-endmenu
+config INTEL_MEI
+	tristate "Intel Management Engine Interface (Intel MEI)"
+	depends on X86 && EXPERIMENTAL
+	help
+		The Intel Management Engine (Intel ME) provides Manageability,
+		Security and Media services for system containing Intel chipsets.
+		if selected /dev/mei misc device will be created.
 
+		For more information see
+		<http://software.intel.com/en-us/manageability/>
+
+endmenu
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 057f654..778b816 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -61,4 +61,5 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
+obj-$(CONFIG_INTEL_MEI)		+= mei/
 js-rtc-y = rtc.o
diff --git a/drivers/char/mei/Makefile b/drivers/char/mei/Makefile
new file mode 100644
index 0000000..5a6b011
--- /dev/null
+++ b/drivers/char/mei/Makefile
@@ -0,0 +1,19 @@
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
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

