Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab2AYKkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:40:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43272 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2AYKj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:39:58 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Sekhar Nori <nsekhar@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v2 1/3] arm:davinci: prepare to move aemif driver to drivers/mfd
Date: Wed, 25 Jan 2012 15:55:54 +0530
Message-ID: <1327487156-10238-1-git-send-email-prakash.pm@ti.com>
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
Since v1:
Patch is generated using -M option.

 arch/arm/mach-davinci/aemif.c                      |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c            |    2 +-
 drivers/mtd/nand/davinci_nand.c                    |    2 +-
 .../aemif.h => include/linux/mfd/davinci_aemif.h   |    0
 5 files changed, 4 insertions(+), 4 deletions(-)
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

