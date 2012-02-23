Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2BWOTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:19:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab2BWOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:19:07 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <sameo@linux.intel.com>, "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v5 1/3] arm:davinci: prepare to move aemif driver to drivers/mfd
Date: Thu, 23 Feb 2012 19:28:22 +0530
Message-ID: <1330005504-25321-2-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move platform specific header file to mfd specific location.
This is done as a prerequisite for moving emif handling code out
of platform folders.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Since v4:
No change
Since v3:
No change. Resending as 3/3 in patch changed.
Since v2:
No change.
Since v1:
Patch generated using -M option.

 arch/arm/mach-davinci/aemif.c                      |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c            |    2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |    2 +-
 drivers/mtd/nand/davinci_nand.c                    |    2 +-
 .../aemif.h => include/linux/mfd/davinci_aemif.h   |    0
 7 files changed, 6 insertions(+), 6 deletions(-)
 rename arch/arm/mach-davinci/include/mach/aemif.h => include/linux/mfd/davinci_aemif.h (100%)

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
index d508890..9f2a544 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -41,7 +41,7 @@
 #include <mach/da8xx.h>
 #include <mach/nand.h>
 #include <mach/mux.h>
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 #include <mach/spi.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 1247ecd..99a6639 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -38,7 +38,7 @@
 #include <mach/nand.h>
 #include <mach/mmc.h>
 #include <mach/usb.h>
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #define DM644X_EVM_PHY_ID		"davinci_mdio-0:01"
 #define LXT971_PHY_ID	(0x001378e2)
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 872ac69..af55a9d 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -43,7 +43,7 @@
 #include <mach/nand.h>
 #include <mach/clock.h>
 #include <mach/cdce949.h>
-#include <mach/aemif.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include "clock.h"
 
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
diff --git a/arch/arm/mach-davinci/include/mach/aemif.h b/include/linux/mfd/davinci_aemif.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/aemif.h
rename to include/linux/mfd/davinci_aemif.h
-- 
1.7.1

