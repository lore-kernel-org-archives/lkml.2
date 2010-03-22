Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab0CVVT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:19:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36566 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354Ab0CVVT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:19:28 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de
Cc: alan@lxorguk.ukuu.org.uk, pavan_savoy@ti.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
Date: Mon, 22 Mar 2010 16:19:12 -0500
Message-Id: <1269292756-7469-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
 <1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

This change adds the Kconfig and Make file for TI's
ST line discipline driver and the BlueZ driver for BT
core of the TI BT/FM/GPS combo chip.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/Kconfig        |    1 +
 drivers/misc/Makefile       |    1 +
 drivers/misc/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
 drivers/misc/ti-st/Makefile |    7 +++++++
 4 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ti-st/Kconfig
 create mode 100644 drivers/misc/ti-st/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 625e3a6..c059bca 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -344,5 +344,6 @@ source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
 source "drivers/misc/iwmc3200top/Kconfig"
+source "drivers/misc/ti-st/Kconfig"
 
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c221917..021f282 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 obj-$(CONFIG_HWLAT_DETECTOR)	+= hwlat_detector.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
+obj-y				+= ti-st/
diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
new file mode 100644
index 0000000..18eea1c
--- /dev/null
+++ b/drivers/misc/ti-st/Kconfig
@@ -0,0 +1,24 @@
+#
+# TI's shared transport line discipline and the protocol
+# drivers (BT, FM and GPS)
+#
+menu "Texas Instruments shared transport line discipline"
+    config TI_ST
+    tristate "shared transport core driver"
+    select FW_LOADER
+    help
+        This enables the shared transport core driver for TI
+	    BT / FM and GPS combo chips.This enables protocol drivers
+	    to register themselves with core and send data, the responses
+	    are returned to relevant protocol drivers based on their
+	    packet types.
+
+    config ST_BT
+    tristate "BlueZ bluetooth driver for ST"
+    select BT
+    select TI_ST
+    help
+       This enables the Bluetooth driver for TI BT/FM/GPS combo devices
+       This makes use of shared transport line discipline core driver to
+       communicate with the BT core of the combo chip.
+endmenu
diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
new file mode 100644
index 0000000..cff3770
--- /dev/null
+++ b/drivers/misc/ti-st/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for TI's shared transport line discipline
+# and it's protocol drivers (BT, FM, GPS)
+#
+obj-$(CONFIG_TI_ST) += st_drv.o
+st_drv-objs			:= st_core.o st_kim.o st_ll.o
+obj-$(CONFIG_ST_BT) += bt_drv.o
-- 
1.5.4.3

