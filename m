Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0DWPNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:13:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:63125 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0DWPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:13:06 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Andras Domokos <andras.domokos@nokia.com>
Subject: [RFC PATCH 5/5] HSI CHAR: Add HSI char device kernel configuration
Date: Fri, 23 Apr 2010 18:15:28 +0300
Message-Id: <1272035728-6933-6-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
References: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
X-OriginalArrivalTime: 23 Apr 2010 15:12:34.0967 (UTC) FILETIME=[6732EA70:01CAE2F7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andras Domokos <andras.domokos@nokia.com>

Add HSI character device kernel configuration

Signed-off-by: Andras Domokos <andras.domokos@nokia.com>
---
 drivers/hsi/Kconfig          |    1 +
 drivers/hsi/Makefile         |    2 +-
 drivers/hsi/clients/Kconfig  |   11 +++++++++++
 drivers/hsi/clients/Makefile |    5 +++++
 4 files changed, 18 insertions(+), 1 deletions(-)
 create mode 100644 drivers/hsi/clients/Kconfig
 create mode 100644 drivers/hsi/clients/Makefile

diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
index 0398e23..87d87a1 100644
--- a/drivers/hsi/Kconfig
+++ b/drivers/hsi/Kconfig
@@ -11,5 +11,6 @@ menuconfig HSI
 if HSI
 
 source "drivers/hsi/controllers/Kconfig"
+source "drivers/hsi/clients/Kconfig"
 
 endif # HSI
diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
index d020ae1..ebc91b3 100644
--- a/drivers/hsi/Makefile
+++ b/drivers/hsi/Makefile
@@ -2,4 +2,4 @@
 # Makefile for HSI
 #
 obj-$(CONFIG_HSI)	+= hsi.o
-obj-y			+= controllers/
+obj-y			+= controllers/ clients/
diff --git a/drivers/hsi/clients/Kconfig b/drivers/hsi/clients/Kconfig
new file mode 100644
index 0000000..2145591
--- /dev/null
+++ b/drivers/hsi/clients/Kconfig
@@ -0,0 +1,11 @@
+#
+# HSI clients configuration
+#
+
+config HSI_CHAR
+	tristate "HSI/SSI character driver"
+	depends on HSI && OMAP_SSI
+	---help---
+	  If you say Y here, you will enable the HSI/SSI character driver.
+	  This driver provides a simple character device interface for
+	  serial communication with the cellular modem over HSI/SSI bus.
diff --git a/drivers/hsi/clients/Makefile b/drivers/hsi/clients/Makefile
new file mode 100644
index 0000000..327c0e2
--- /dev/null
+++ b/drivers/hsi/clients/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for HSI clients
+#
+
+obj-$(CONFIG_HSI_CHAR)	+= hsi_char.o
-- 
1.5.6.5

