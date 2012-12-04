Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2LDOFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2LDOFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975296"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/15] mei: extarct device dependent constants into hw-mei.h
Date: Tue,  4 Dec 2012 16:04:33 +0200
Message-Id: <1354629884-3202-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-mei.h  |  118 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw.h      |   98 ------------------------------------
 drivers/misc/mei/mei_dev.h |    2 +
 3 files changed, 120 insertions(+), 98 deletions(-)
 create mode 100644 drivers/misc/mei/hw-mei.h

diff --git a/drivers/misc/mei/hw-mei.h b/drivers/misc/mei/hw-mei.h
new file mode 100644
index 0000000..ecc58f7
--- /dev/null
+++ b/drivers/misc/mei/hw-mei.h
@@ -0,0 +1,118 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef _MEI_HW_MEI_H_
+#define _MEI_HW_MEI_H_
+
+/*
+ * MEI device IDs
+ */
+#define MEI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
+#define MEI_DEV_ID_82G35      0x2984  /* 82G35 Express */
+#define MEI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
+#define MEI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
+
+#define MEI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
+#define MEI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
+
+#define MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
+#define MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
+#define MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
+#define MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
+#define MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
+
+#define MEI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
+
+#define MEI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
+#define MEI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
+#define MEI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
+#define MEI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
+
+#define MEI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
+#define MEI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
+#define MEI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
+#define MEI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
+
+#define MEI_DEV_ID_IBXPK_1    0x3B64  /* Calpella */
+#define MEI_DEV_ID_IBXPK_2    0x3B65  /* Calpella */
+
+#define MEI_DEV_ID_CPT_1      0x1C3A  /* Couger Point */
+#define MEI_DEV_ID_PBG_1      0x1D3A  /* C600/X79 Patsburg */
+
+#define MEI_DEV_ID_PPT_1      0x1E3A  /* Panther Point */
+#define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
+#define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
+
+#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
+#define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
+/*
+ * MEI HW Section
+ */
+
+/* MEI registers */
+/* H_CB_WW - Host Circular Buffer (CB) Write Window register */
+#define H_CB_WW    0
+/* H_CSR - Host Control Status register */
+#define H_CSR      4
+/* ME_CB_RW - ME Circular Buffer Read Window register (read only) */
+#define ME_CB_RW   8
+/* ME_CSR_HA - ME Control Status Host Access register (read only) */
+#define ME_CSR_HA  0xC
+
+
+/* register bits of H_CSR (Host Control Status register) */
+/* Host Circular Buffer Depth - maximum number of 32-bit entries in CB */
+#define H_CBD             0xFF000000
+/* Host Circular Buffer Write Pointer */
+#define H_CBWP            0x00FF0000
+/* Host Circular Buffer Read Pointer */
+#define H_CBRP            0x0000FF00
+/* Host Reset */
+#define H_RST             0x00000010
+/* Host Ready */
+#define H_RDY             0x00000008
+/* Host Interrupt Generate */
+#define H_IG              0x00000004
+/* Host Interrupt Status */
+#define H_IS              0x00000002
+/* Host Interrupt Enable */
+#define H_IE              0x00000001
+
+
+/* register bits of ME_CSR_HA (ME Control Status Host Access register) */
+/* ME CB (Circular Buffer) Depth HRA (Host Read Access) - host read only
+access to ME_CBD */
+#define ME_CBD_HRA        0xFF000000
+/* ME CB Write Pointer HRA - host read only access to ME_CBWP */
+#define ME_CBWP_HRA       0x00FF0000
+/* ME CB Read Pointer HRA - host read only access to ME_CBRP */
+#define ME_CBRP_HRA       0x0000FF00
+/* ME Reset HRA - host read only access to ME_RST */
+#define ME_RST_HRA        0x00000010
+/* ME Ready HRA - host read only access to ME_RDY */
+#define ME_RDY_HRA        0x00000008
+/* ME Interrupt Generate HRA - host read only access to ME_IG */
+#define ME_IG_HRA         0x00000004
+/* ME Interrupt Status HRA - host read only access to ME_IS */
+#define ME_IS_HRA         0x00000002
+/* ME Interrupt Enable HRA - host read only access to ME_IE */
+#define ME_IE_HRA         0x00000001
+
+#endif /* _MEI_HW_MEI_H_ */
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 7d47366..ba7d06c 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -33,104 +33,6 @@
 
 
 /*
- * MEI device IDs
- */
-#define MEI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
-#define MEI_DEV_ID_82G35      0x2984  /* 82G35 Express */
-#define MEI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
-#define MEI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
-
-#define MEI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
-#define MEI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
-
-#define MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
-#define MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
-#define MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
-#define MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
-#define MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
-
-#define MEI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
-
-#define MEI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
-
-#define MEI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
-
-#define MEI_DEV_ID_IBXPK_1    0x3B64  /* Calpella */
-#define MEI_DEV_ID_IBXPK_2    0x3B65  /* Calpella */
-
-#define MEI_DEV_ID_CPT_1      0x1C3A  /* Couger Point */
-#define MEI_DEV_ID_PBG_1      0x1D3A  /* C600/X79 Patsburg */
-
-#define MEI_DEV_ID_PPT_1      0x1E3A  /* Panther Point */
-#define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
-#define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
-
-#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
-#define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
-/*
- * MEI HW Section
- */
-
-/* MEI registers */
-/* H_CB_WW - Host Circular Buffer (CB) Write Window register */
-#define H_CB_WW    0
-/* H_CSR - Host Control Status register */
-#define H_CSR      4
-/* ME_CB_RW - ME Circular Buffer Read Window register (read only) */
-#define ME_CB_RW   8
-/* ME_CSR_HA - ME Control Status Host Access register (read only) */
-#define ME_CSR_HA  0xC
-
-
-/* register bits of H_CSR (Host Control Status register) */
-/* Host Circular Buffer Depth - maximum number of 32-bit entries in CB */
-#define H_CBD             0xFF000000
-/* Host Circular Buffer Write Pointer */
-#define H_CBWP            0x00FF0000
-/* Host Circular Buffer Read Pointer */
-#define H_CBRP            0x0000FF00
-/* Host Reset */
-#define H_RST             0x00000010
-/* Host Ready */
-#define H_RDY             0x00000008
-/* Host Interrupt Generate */
-#define H_IG              0x00000004
-/* Host Interrupt Status */
-#define H_IS              0x00000002
-/* Host Interrupt Enable */
-#define H_IE              0x00000001
-
-
-/* register bits of ME_CSR_HA (ME Control Status Host Access register) */
-/* ME CB (Circular Buffer) Depth HRA (Host Read Access) - host read only
-access to ME_CBD */
-#define ME_CBD_HRA        0xFF000000
-/* ME CB Write Pointer HRA - host read only access to ME_CBWP */
-#define ME_CBWP_HRA       0x00FF0000
-/* ME CB Read Pointer HRA - host read only access to ME_CBRP */
-#define ME_CBRP_HRA       0x0000FF00
-/* ME Reset HRA - host read only access to ME_RST */
-#define ME_RST_HRA        0x00000010
-/* ME Ready HRA - host read only access to ME_RDY */
-#define ME_RDY_HRA        0x00000008
-/* ME Interrupt Generate HRA - host read only access to ME_IG */
-#define ME_IG_HRA         0x00000004
-/* ME Interrupt Status HRA - host read only access to ME_IS */
-#define ME_IS_HRA         0x00000002
-/* ME Interrupt Enable HRA - host read only access to ME_IE */
-#define ME_IE_HRA         0x00000001
-
-/*
  * MEI Version
  */
 #define HBM_MINOR_VERSION                   0
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 39cd289..ddc23f5 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -21,7 +21,9 @@
 #include <linux/watchdog.h>
 #include <linux/poll.h>
 #include <linux/mei.h>
+
 #include "hw.h"
+#include "hw-mei.h"
 
 /*
  * watch dog definition
-- 
1.7.4.4

