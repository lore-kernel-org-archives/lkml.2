Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1LIOIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:08:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49832 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1LIOII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:08:08 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 09/10] xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
Date: Fri,  9 Dec 2011 15:07:27 +0100
Message-Id: <1323439648-22697-10-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_XSHM should be selected from architectures supporting
C2C, this will enable the XSHM configuration.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/Kconfig       |    2 +
 drivers/Makefile      |    1 +
 drivers/xshm/Kconfig  |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/xshm/Makefile |    5 ++++
 4 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/Kconfig
 create mode 100644 drivers/xshm/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 041426c..742f028 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -138,4 +138,6 @@ source "drivers/virt/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/xshm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 91077ac..30eae54 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
+obj-$(CONFIG_XSHM)		+= xshm/
 #common clk code
 obj-y				+= clk/
 
diff --git a/drivers/xshm/Kconfig b/drivers/xshm/Kconfig
new file mode 100644
index 0000000..97c9e11
--- /dev/null
+++ b/drivers/xshm/Kconfig
@@ -0,0 +1,60 @@
+#
+# XSHM Framework
+#
+
+config XSHM
+	tristate
+	default n
+	depends on EXPERIMENTAL
+if XSHM
+
+menu "XSHM drivers and interfaces"
+	depends on XSHM
+
+config DUMMY_C2C
+	tristate "Dummy C2C GENIO driver"
+	default XSHM
+	---help---
+	Say "Y" or "M" if you want to compile a dummy C2C driver.
+	Use this if you want to compile without the real
+	C2C driver available.
+
+config XSHM_BUS
+	tristate
+	default XSHM_DEV
+
+config XSHM_BOOT
+	tristate
+	depends on XSHM_DEV
+	default XSHM_DEV
+
+config XSHM_DEV
+	tristate "XSHM Channels for External Shared Memory (XSHM)"
+	depends on DUMMY_C2C || C2C
+	select XSHM_BUS
+	select XSHM_BOOT
+	default XSHM
+	---help---
+	Say "Y" to use External Shared Memory (XSHM) IPC mechanism.
+	XSHM is an IPC protocol used to talk to external device such
+	as modem over a shared memory (e.g. Chip to Chip).
+	Only say "M" here if you want to test XSHM and need to load
+	and unload its module.
+	If unsure say N.
+
+config XSHM_CHR
+	tristate "Character device for External Shared Memory (XSHM)"
+	depends on XSHM_DEV
+	default XSHM_DEV
+	---help---
+	Say "Y" to use a character device for the External Shared
+	Memory (XSHM) IPC mechanism. XSHM is an IPC protocol used to
+	talk to external device such as modem over a shared memory
+	(e.g. Chip to Chip).
+	Only say "M" here if you want to test XSHM and need to load
+	and unload its module.
+	If unsure say N.
+
+endmenu
+
+endif
diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
new file mode 100644
index 0000000..001cd79
--- /dev/null
+++ b/drivers/xshm/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_XSHM_BUS) += xshm_bus.o
+obj-$(CONFIG_XSHM_BOOT) += xshm_boot.o
+obj-$(CONFIG_XSHM_DEV) += xshm_dev.o
+obj-$(CONFIG_XSHM_CHR) +=  xshm_chr.o
+obj-$(CONFIG_DUMMY_C2C) +=  dummy_c2c_genio.o
-- 
1.7.0.4

