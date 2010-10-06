Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0JFPFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:05:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36414 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759160Ab0JFPFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:05:38 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/2] drivers:misc: ti-st: Kconfig & Makefile for TI_ST
Date: Wed,  6 Oct 2010 12:18:15 -0400
Message-Id: <1286381895-11329-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
 <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Add the Kconfig and the Makefile for the TI_ST driver.
TI_ST driver is the line discipline driver for the Texas Instrument's
WiLink chipsets.
Also add the ti-st folder to list of drivers under drivers/misc.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/Kconfig        |    1 +
 drivers/misc/Makefile       |    1 +
 drivers/misc/ti-st/Kconfig  |   17 +++++++++++++++++
 drivers/misc/ti-st/Makefile |    6 ++++++
 4 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ti-st/Kconfig
 create mode 100644 drivers/misc/ti-st/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 53b21ff..9d0a84d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -415,5 +415,6 @@ source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
 source "drivers/misc/iwmc3200top/Kconfig"
+source "drivers/misc/ti-st/Kconfig"
 
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 4c771a2..d71d5a7 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
+obj-y				+= ti-st/
diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
new file mode 100644
index 0000000..2c8c3f3
--- /dev/null
+++ b/drivers/misc/ti-st/Kconfig
@@ -0,0 +1,17 @@
+#
+# TI's shared transport line discipline and the protocol
+# drivers (BT, FM and GPS)
+#
+menu "Texas Instruments shared transport line discipline"
+config TI_ST
+	tristate "Shared transport core driver"
+	depends on RFKILL
+	select FW_LOADER
+	help
+	  This enables the shared transport core driver for TI
+	  BT / FM and GPS combo chips. This enables protocol drivers
+	  to register themselves with core and send data, the responses
+	  are returned to relevant protocol drivers based on their
+	  packet types.
+
+endmenu
diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
new file mode 100644
index 0000000..78d7ebb
--- /dev/null
+++ b/drivers/misc/ti-st/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for TI's shared transport line discipline
+# and its protocol drivers (BT, FM, GPS)
+#
+obj-$(CONFIG_TI_ST) 		+= st_drv.o
+st_drv-objs			:= st_core.o st_kim.o st_ll.o
-- 
1.6.5

