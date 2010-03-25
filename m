Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0CYXUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:20:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34466 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab0CYXUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:20:40 -0400
From: pavan_savoy@ti.com
To: marcel@holtmann.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in,
       Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:staging: Kconfig, Makefile for TI's ST ldisc
Date: Thu, 25 Mar 2010 18:20:21 -0500
Message-Id: <1269559223-4043-7-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1269559223-4043-6-git-send-email-pavan_savoy@ti.com>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-3-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-4-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-5-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-6-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

This change adds the Kconfig and Make file for TI's
ST line discipline driver and the BlueZ driver for BT
core of the TI BT/FM/GPS combo chip.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/Kconfig        |    2 ++
 drivers/staging/Makefile       |    1 +
 drivers/staging/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
 drivers/staging/ti-st/Makefile |    7 +++++++
 4 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/Kconfig
 create mode 100644 drivers/staging/ti-st/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 5589616..209fe00 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -141,5 +141,7 @@ source "drivers/staging/dt3155/Kconfig"
 
 source "drivers/staging/crystalhd/Kconfig"
 
+source "drivers/staging/ti-st/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index ec45d4b..b41aa1a 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -52,3 +52,4 @@ obj-$(CONFIG_PCMCIA_NETWAVE)	+= netwave/
 obj-$(CONFIG_FB_SM7XX)		+= sm7xx/
 obj-$(CONFIG_DT3155)		+= dt3155/
 obj-$(CONFIG_CRYSTALHD)		+= crystalhd/
+obj-$(CONFIG_TI_ST)		+= ti-st/
diff --git a/drivers/staging/ti-st/Kconfig b/drivers/staging/ti-st/Kconfig
new file mode 100644
index 0000000..120e8db
--- /dev/null
+++ b/drivers/staging/ti-st/Kconfig
@@ -0,0 +1,24 @@
+#
+# TI's shared transport line discipline and the protocol
+# drivers (BT, FM and GPS)
+#
+menu "Texas Instruments shared transport line discipline"
+config TI_ST
+	tristate "shared transport core driver"
+	select FW_LOADER
+	help
+	  This enables the shared transport core driver for TI
+	  BT / FM and GPS combo chips. This enables protocol drivers
+	  to register themselves with core and send data, the responses
+	  are returned to relevant protocol drivers based on their
+	  packet types.
+
+config ST_BT
+	tristate "BlueZ bluetooth driver for ST"
+	depends on BT
+	select TI_ST
+	help
+	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
+	  This makes use of shared transport line discipline core driver to
+	  communicate with the BT core of the combo chip.
+endmenu
diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
new file mode 100644
index 0000000..0167d1d
--- /dev/null
+++ b/drivers/staging/ti-st/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for TI's shared transport line discipline
+# and its protocol drivers (BT, FM, GPS)
+#
+obj-$(CONFIG_TI_ST) 		+= st_drv.o
+st_drv-objs			:= st_core.o st_kim.o st_ll.o
+obj-$(CONFIG_ST_BT) 		+= bt_drv.o
-- 
1.5.4.3

