Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2AWP0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:26:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52799 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2AWP03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:26:29 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Sekhar Nori <nsekhar@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [RESEND PATCH] arm:davinci: prepare to move aemif driver to drivers/mfd
Date: Mon, 23 Jan 2012 20:42:32 +0530
Message-ID: <1327331552-9913-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch moves emif header file appropriately as a part preparation to move emif
driver from arch/arm/mach-davinci/ to drivers/mfd folder.
There by it isolates modifications in emif interface depicting as platform code
change.

Patch series are based on the discussion and concerns expressed in
davinci-linux-open-source community. Here is the link for the same:
http://davinci-linux-open-source.1494791.n2.nabble.com/PATCH-arm-davinci-configure-davinci-aemif-chipselects-through-OF-tt7059739.html#none

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Adding: MFD maintainer and mailing list.

 arch/arm/mach-davinci/aemif.c              |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c    |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c    |    2 +-
 arch/arm/mach-davinci/include/mach/aemif.h |   36 ----------------------------
 drivers/mtd/nand/davinci_nand.c            |    2 +-
 include/linux/mfd/davinci_aemif.h          |   36 ++++++++++++++++++++++++++++
 6 files changed, 40 insertions(+), 40 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/include/mach/aemif.h
 create mode 100644 include/linux/mfd/davinci_aemif.h

diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
index 1ce70a9..b67c115 100644
--- a/arch/arm/mach-davinci/aemif.c
+++ b/arch/arm/mach-davinci/aemif.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 
 /* Timing value configuration */
 
diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index dc1afe5..0b43554 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -31,7 +31,7 @@
 #include <mach/nand.h>
 #include <mach/da8xx.h>
 #include <mach/usb.h>
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 #include <mach/spi.h>
 
 #define DA830_EVM_PHY_ID		""
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 6b22b54..6dda013 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -41,7 +41,7 @@
 #include <mach/da8xx.h>
 #include <mach/nand.h>
 #include <mach/mux.h>
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 #include <mach/spi.h>
 
 #define DA850_EVM_PHY_ID		"0:00"
diff --git a/arch/arm/mach-davinci/include/mach/aemif.h b/arch/arm/mach-davinci/include/mach/aemif.h
deleted file mode 100644
index 05b2934..0000000
--- a/arch/arm/mach-davinci/include/mach/aemif.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * TI DaVinci AEMIF support
- *
- * Copyright 2010 (C) Texas Instruments, Inc. http://www.ti.com/
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- */
-#ifndef _MACH_DAVINCI_AEMIF_H
-#define _MACH_DAVINCI_AEMIF_H
-
-#define NRCSR_OFFSET		0x00
-#define AWCCR_OFFSET		0x04
-#define A1CR_OFFSET		0x10
-
-#define ACR_ASIZE_MASK		0x3
-#define ACR_EW_MASK		BIT(30)
-#define ACR_SS_MASK		BIT(31)
-
-/* All timings in nanoseconds */
-struct davinci_aemif_timing {
-	u8	wsetup;
-	u8	wstrobe;
-	u8	whold;
-
-	u8	rsetup;
-	u8	rstrobe;
-	u8	rhold;
-
-	u8	ta;
-};
-
-int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
-					void __iomem *base, unsigned cs);
-#endif
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 6e56615..f19151b 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -35,7 +35,7 @@
 #include <linux/slab.h>
 
 #include <mach/nand.h>
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 
 /*
  * This is a device driver for the NAND flash controller found on the
diff --git a/include/linux/mfd/davinci_aemif.h b/include/linux/mfd/davinci_aemif.h
new file mode 100644
index 0000000..05b2934
--- /dev/null
+++ b/include/linux/mfd/davinci_aemif.h
@@ -0,0 +1,36 @@
+/*
+ * TI DaVinci AEMIF support
+ *
+ * Copyright 2010 (C) Texas Instruments, Inc. http://www.ti.com/
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+#ifndef _MACH_DAVINCI_AEMIF_H
+#define _MACH_DAVINCI_AEMIF_H
+
+#define NRCSR_OFFSET		0x00
+#define AWCCR_OFFSET		0x04
+#define A1CR_OFFSET		0x10
+
+#define ACR_ASIZE_MASK		0x3
+#define ACR_EW_MASK		BIT(30)
+#define ACR_SS_MASK		BIT(31)
+
+/* All timings in nanoseconds */
+struct davinci_aemif_timing {
+	u8	wsetup;
+	u8	wstrobe;
+	u8	whold;
+
+	u8	rsetup;
+	u8	rstrobe;
+	u8	rhold;
+
+	u8	ta;
+};
+
+int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
+					void __iomem *base, unsigned cs);
+#endif
-- 
1.7.1

