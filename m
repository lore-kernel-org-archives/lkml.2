Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0EGPQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:16:19 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49488 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0EGPQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:16:08 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Andras Domokos <andras.domokos@nokia.com>
Subject: [RFC PATCHv2 5/7] HSI CHAR: Add HSI char device kernel configuration
Date: Fri,  7 May 2010 18:18:35 +0300
Message-Id: <1273245517-30712-6-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
X-OriginalArrivalTime: 07 May 2010 15:15:54.0920 (UTC) FILETIME=[3029D280:01CAEDF8]
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
 drivers/hsi/clients/Kconfig  |   13 +++++++++++++
 drivers/hsi/clients/Makefile |    5 +++++
 include/linux/Kbuild         |    1 +
 include/linux/hsi/Kbuild     |    1 +
 6 files changed, 22 insertions(+), 1 deletions(-)
 create mode 100644 drivers/hsi/clients/Kconfig
 create mode 100644 drivers/hsi/clients/Makefile
 create mode 100644 include/linux/hsi/Kbuild

diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
index 07987b6..94fc793 100644
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
index 0000000..3bacd27
--- /dev/null
+++ b/drivers/hsi/clients/Kconfig
@@ -0,0 +1,13 @@
+#
+# HSI clients configuration
+#
+
+comment "HSI clients"
+
+config HSI_CHAR
+	tristate "HSI/SSI character driver"
+	depends on HSI
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
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e2ea0b2..d8a1cd6 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -2,6 +2,7 @@ header-y += byteorder/
 header-y += can/
 header-y += dvb/
 header-y += hdlc/
+header-y += hsi/
 header-y += isdn/
 header-y += nfsd/
 header-y += raid/
diff --git a/include/linux/hsi/Kbuild b/include/linux/hsi/Kbuild
new file mode 100644
index 0000000..271a770
--- /dev/null
+++ b/include/linux/hsi/Kbuild
@@ -0,0 +1 @@
+header-y += hsi_char.h
-- 
1.5.6.5

