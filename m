Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2KPSeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:34:13 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:10936 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2KPSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:34:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAGGplBbdWOb/2dsb2JhbABEwmaBCIIfAQV5EFFXBhOIEb50kUADlXyJSIZ7gnA
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net, jens.taprogge@taprogge.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 2/2] ipack: remove ipack_ids.h file
Date: Fri, 16 Nov 2012 19:33:46 +0100
Message-Id: <1353090826-11068-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353090826-11068-1-git-send-email-siglesias@igalia.com>
References: <1353090826-11068-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its contents are merged into ipack.h. So this file is not needed.

Doing that, it simplifies the ipack-related driver development.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    1 -
 drivers/ipack/ipack.c           |    1 -
 drivers/ipack/ipack_ids.h       |   32 --------------------------------
 include/linux/ipack.h           |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 34 deletions(-)
 delete mode 100644 drivers/ipack/ipack_ids.h

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 7f568e2..c06ab39 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -23,7 +23,6 @@
 #include <linux/atomic.h>
 #include <linux/io.h>
 #include <linux/ipack.h>
-#include "../ipack_ids.h"
 #include "ipoctal.h"
 #include "scc2698.h"
 
diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index cc54983..7ec6b20 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -14,7 +14,6 @@
 #include <linux/idr.h>
 #include <linux/io.h>
 #include <linux/ipack.h>
-#include "ipack_ids.h"
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
 #define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)
diff --git a/drivers/ipack/ipack_ids.h b/drivers/ipack/ipack_ids.h
deleted file mode 100644
index 8153fee..0000000
--- a/drivers/ipack/ipack_ids.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * IndustryPack Fromat, Vendor and Device IDs.
- */
-
-/* ID section format versions */
-#define IPACK_ID_VERSION_INVALID	0x00
-#define IPACK_ID_VERSION_1		0x01
-#define IPACK_ID_VERSION_2		0x02
-
-/* Vendors and devices. Sort key: vendor first, device next. */
-#define IPACK1_VENDOR_ID_RESERVED1	0x00
-#define IPACK1_VENDOR_ID_RESERVED2	0xFF
-#define IPACK1_VENDOR_ID_UNREGISTRED01	0x01
-#define IPACK1_VENDOR_ID_UNREGISTRED02	0x02
-#define IPACK1_VENDOR_ID_UNREGISTRED03	0x03
-#define IPACK1_VENDOR_ID_UNREGISTRED04	0x04
-#define IPACK1_VENDOR_ID_UNREGISTRED05	0x05
-#define IPACK1_VENDOR_ID_UNREGISTRED06	0x06
-#define IPACK1_VENDOR_ID_UNREGISTRED07	0x07
-#define IPACK1_VENDOR_ID_UNREGISTRED08	0x08
-#define IPACK1_VENDOR_ID_UNREGISTRED09	0x09
-#define IPACK1_VENDOR_ID_UNREGISTRED10	0x0A
-#define IPACK1_VENDOR_ID_UNREGISTRED11	0x0B
-#define IPACK1_VENDOR_ID_UNREGISTRED12	0x0C
-#define IPACK1_VENDOR_ID_UNREGISTRED13	0x0D
-#define IPACK1_VENDOR_ID_UNREGISTRED14	0x0E
-#define IPACK1_VENDOR_ID_UNREGISTRED15	0x0F
-
-#define IPACK1_VENDOR_ID_SBS            0xF0
-#define IPACK1_DEVICE_ID_SBS_OCTAL_232  0x22
-#define IPACK1_DEVICE_ID_SBS_OCTAL_422  0x2A
-#define IPACK1_DEVICE_ID_SBS_OCTAL_485  0x48
diff --git a/include/linux/ipack.h b/include/linux/ipack.h
index 7a0a308..a360c73 100644
--- a/include/linux/ipack.h
+++ b/include/linux/ipack.h
@@ -26,6 +26,39 @@
 #define IPACK_IDPROM_OFFSET_NUM_BYTES		0x15
 #define IPACK_IDPROM_OFFSET_CRC			0x17
 
+/*
+ * IndustryPack Fromat, Vendor and Device IDs.
+ */
+
+/* ID section format versions */
+#define IPACK_ID_VERSION_INVALID	0x00
+#define IPACK_ID_VERSION_1		0x01
+#define IPACK_ID_VERSION_2		0x02
+
+/* Vendors and devices. Sort key: vendor first, device next. */
+#define IPACK1_VENDOR_ID_RESERVED1	0x00
+#define IPACK1_VENDOR_ID_RESERVED2	0xFF
+#define IPACK1_VENDOR_ID_UNREGISTRED01	0x01
+#define IPACK1_VENDOR_ID_UNREGISTRED02	0x02
+#define IPACK1_VENDOR_ID_UNREGISTRED03	0x03
+#define IPACK1_VENDOR_ID_UNREGISTRED04	0x04
+#define IPACK1_VENDOR_ID_UNREGISTRED05	0x05
+#define IPACK1_VENDOR_ID_UNREGISTRED06	0x06
+#define IPACK1_VENDOR_ID_UNREGISTRED07	0x07
+#define IPACK1_VENDOR_ID_UNREGISTRED08	0x08
+#define IPACK1_VENDOR_ID_UNREGISTRED09	0x09
+#define IPACK1_VENDOR_ID_UNREGISTRED10	0x0A
+#define IPACK1_VENDOR_ID_UNREGISTRED11	0x0B
+#define IPACK1_VENDOR_ID_UNREGISTRED12	0x0C
+#define IPACK1_VENDOR_ID_UNREGISTRED13	0x0D
+#define IPACK1_VENDOR_ID_UNREGISTRED14	0x0E
+#define IPACK1_VENDOR_ID_UNREGISTRED15	0x0F
+
+#define IPACK1_VENDOR_ID_SBS            0xF0
+#define IPACK1_DEVICE_ID_SBS_OCTAL_232  0x22
+#define IPACK1_DEVICE_ID_SBS_OCTAL_422  0x2A
+#define IPACK1_DEVICE_ID_SBS_OCTAL_485  0x48
+
 struct ipack_bus_ops;
 struct ipack_driver;
 
-- 
1.7.10.4

