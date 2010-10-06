Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab0JEW4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:56:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50411 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab0JEW4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:56:12 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/4] drivers:misc: ti-st: Kconfig & Makefile for TI_ST
Date: Tue,  5 Oct 2010 20:08:36 -0400
Message-Id: <1286323717-2925-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1286323717-2925-3-git-send-email-pavan_savoy@ti.com>
References: <1286323717-2925-1-git-send-email-pavan_savoy@ti.com>
 <1286323717-2925-2-git-send-email-pavan_savoy@ti.com>
 <1286323717-2925-3-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Add the Kconfig and the Makefile for the TI_ST driver.
TI_ST driver is the line discipline driver for the Texas Instrument's
WiLink chipsets.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/Kconfig  |   17 +++++++++++++++++
 drivers/misc/ti-st/Makefile |    6 ++++++
 2 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ti-st/Kconfig
 create mode 100644 drivers/misc/ti-st/Makefile

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

