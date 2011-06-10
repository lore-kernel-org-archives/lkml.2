Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1FJNnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:43:01 -0400
Received: from smtp.nokia.com ([147.243.1.48]:39700 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab1FJNmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:42:54 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Andras Domokos <andras.domokos@nokia.com>
Subject: [RFC PATCHv5 5/7] HSI: hsi_char: Add HSI char device kernel configuration
Date: Fri, 10 Jun 2011 16:38:42 +0300
Message-Id: <1307713124-3946-6-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andras Domokos <andras.domokos@nokia.com>

Add HSI character device kernel configuration

Signed-off-by: Andras Domokos <andras.domokos@nokia.com>
Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
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
index bba73ea..2c76de4 100644
--- a/drivers/hsi/Kconfig
+++ b/drivers/hsi/Kconfig
@@ -15,5 +15,6 @@ config HSI_BOARDINFO
 	default y
 
 source "drivers/hsi/controllers/Kconfig"
+source "drivers/hsi/clients/Kconfig"
 
 endif # HSI
diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
index 0de87bd..d47ca5d 100644
--- a/drivers/hsi/Makefile
+++ b/drivers/hsi/Makefile
@@ -3,4 +3,4 @@
 #
 obj-$(CONFIG_HSI_BOARDINFO)	+= hsi_boardinfo.o
 obj-$(CONFIG_HSI)		+= hsi.o
-obj-y				+= controllers/
+obj-y				+= controllers/ clients/
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
index 01f6362..d41e127 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -3,6 +3,7 @@ header-y += can/
 header-y += caif/
 header-y += dvb/
 header-y += hdlc/
+header-y += hsi/
 header-y += isdn/
 header-y += mmc/
 header-y += nfsd/
diff --git a/include/linux/hsi/Kbuild b/include/linux/hsi/Kbuild
new file mode 100644
index 0000000..271a770
--- /dev/null
+++ b/include/linux/hsi/Kbuild
@@ -0,0 +1 @@
+header-y += hsi_char.h
-- 
1.7.1

