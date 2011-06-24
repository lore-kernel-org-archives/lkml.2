Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1FXNMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:12:08 -0400
Received: from multi.imgtec.com ([194.200.65.239]:1422 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1FXNMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:12:06 -0400
Message-ID: <4E048986.3040007@imgtec.com>
Date: Fri, 24 Jun 2011 13:56:38 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Subject: [PATCH 4/6] mmc: dw_mmc: brackets in register access macros
References: <4E0488A9.6050109@imgtec.com>
In-Reply-To: <4E0488A9.6050109@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:56:39.0366 (UTC) FILETIME=[28783660:01CC326E]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_56_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add brackets around use of the dev argument to the
mci_{read,write}{w,l,q}() macros, for extra safety.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 23c662a..bb9e5de 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -134,22 +134,22 @@
 
 /* Register access macros */
 #define mci_readl(dev, reg)			\
-	__raw_readl(dev->regs + SDMMC_##reg)
+	__raw_readl((dev)->regs + SDMMC_##reg)
 #define mci_writel(dev, reg, value)			\
-	__raw_writel((value), dev->regs + SDMMC_##reg)
+	__raw_writel((value), (dev)->regs + SDMMC_##reg)
 
 /* 16-bit FIFO access macros */
 #define mci_readw(dev, reg)			\
-	__raw_readw(dev->regs + SDMMC_##reg)
+	__raw_readw((dev)->regs + SDMMC_##reg)
 #define mci_writew(dev, reg, value)			\
-	__raw_writew((value), dev->regs + SDMMC_##reg)
+	__raw_writew((value), (dev)->regs + SDMMC_##reg)
 
 /* 64-bit FIFO access macros */
 #ifdef readq
 #define mci_readq(dev, reg)			\
-	__raw_readq(dev->regs + SDMMC_##reg)
+	__raw_readq((dev)->regs + SDMMC_##reg)
 #define mci_writeq(dev, reg, value)			\
-	__raw_writeq((value), dev->regs + SDMMC_##reg)
+	__raw_writeq((value), (dev)->regs + SDMMC_##reg)
 #else
 /*
  * Dummy readq implementation for architectures that don't define it.
@@ -160,9 +160,9 @@
  * rest of the code free from ifdefs.
  */
 #define mci_readq(dev, reg)			\
-	(*(volatile u64 __force *)(dev->regs + SDMMC_##reg))
+	(*(volatile u64 __force *)((dev)->regs + SDMMC_##reg))
 #define mci_writeq(dev, reg, value)			\
-	(*(volatile u64 __force *)(dev->regs + SDMMC_##reg) = value)
+	(*(volatile u64 __force *)((dev)->regs + SDMMC_##reg) = (value))
 #endif
 
 #endif /* _DW_MMC_H_ */
-- 
1.7.2.3


