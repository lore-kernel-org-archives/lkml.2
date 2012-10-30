Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab2J3Mco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:32:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:12203 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab2J3Mcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:32:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="162351163"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/3] dma: move dw_dmac driver to an own directory
Date: Tue, 30 Oct 2012 14:32:11 +0200
Message-Id: <1351600332-29443-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_dmac driver contains multiple files. To make a management of them more
convenient move it to an own directory.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/Makefile                |    3 +--
 drivers/dma/dw/Makefile             |    2 ++
 drivers/dma/{ => dw}/dw_dmac.c      |    2 +-
 drivers/dma/{ => dw}/dw_dmac_pci.c  |    0
 drivers/dma/{ => dw}/dw_dmac_regs.h |    0
 5 files changed, 4 insertions(+), 3 deletions(-)
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{ => dw}/dw_dmac.c (99%)
 rename drivers/dma/{ => dw}/dw_dmac_pci.c (100%)
 rename drivers/dma/{ => dw}/dw_dmac_regs.h (100%)

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 15eef5f..122a48a 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -11,8 +11,7 @@ obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
-obj-$(CONFIG_DW_DMAC) += dw_dmac.o
-obj-$(CONFIG_DW_DMAC_PCI) += dw_dmac_pci.o
+obj-$(CONFIG_DW_DMAC) += dw/
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
diff --git a/drivers/dma/dw/Makefile b/drivers/dma/dw/Makefile
new file mode 100644
index 0000000..2edfb24
--- /dev/null
+++ b/drivers/dma/dw/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_DW_DMAC) += dw_dmac.o
+obj-$(CONFIG_DW_DMAC_PCI) += dw_dmac_pci.o
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw/dw_dmac.c
similarity index 99%
rename from drivers/dma/dw_dmac.c
rename to drivers/dma/dw/dw_dmac.c
index 2c8096d..29aa9d86 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw/dw_dmac.c
@@ -23,8 +23,8 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
+#include "../dmaengine.h"
 #include "dw_dmac_regs.h"
-#include "dmaengine.h"
 
 /*
  * This supports the Synopsys "DesignWare AHB Central DMA Controller",
diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw/dw_dmac_pci.c
similarity index 100%
rename from drivers/dma/dw_dmac_pci.c
rename to drivers/dma/dw/dw_dmac_pci.c
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw/dw_dmac_regs.h
similarity index 100%
rename from drivers/dma/dw_dmac_regs.h
rename to drivers/dma/dw/dw_dmac_regs.h
-- 
1.7.10.4

