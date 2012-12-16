Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2LPR1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:27:19 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2LPRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:58 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 07/14] shmobile-iommu: Move header file from arch/ to drivers/iommu/
Date: Sun, 16 Dec 2012 18:25:53 +0100
Message-Id: <1355678760-27357-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And split the function used by board code to its own
include/linux/sh_iommu.h header.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    2 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |    2 +-
 drivers/iommu/shmobile-iommu.c                     |    4 +++-
 drivers/iommu/shmobile-ipmmu.c                     |    3 ++-
 .../mach/ipmmu.h => drivers/iommu/shmobile-ipmmu.h |    5 -----
 include/linux/sh_iommu.h                           |   12 ++++++++++++
 7 files changed, 20 insertions(+), 10 deletions(-)
 rename arch/arm/mach-shmobile/include/mach/ipmmu.h => drivers/iommu/shmobile-ipmmu.h (78%)
 create mode 100644 include/linux/sh_iommu.h

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 7006abb..0c40d72 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -38,6 +38,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/smsc911x.h>
 #include <linux/sh_intc.h>
+#include <linux/sh_iommu.h>
 #include <linux/sh_clk.h>
 #include <linux/gpio.h>
 #include <linux/input.h>
@@ -61,7 +62,6 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
-#include <mach/ipmmu.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 1c34520..a9cdfc2 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -45,6 +45,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/smsc911x.h>
 #include <linux/sh_intc.h>
+#include <linux/sh_iommu.h>
 #include <linux/tca6416_keypad.h>
 #include <linux/usb/renesas_usbhs.h>
 #include <linux/dma-mapping.h>
@@ -60,7 +61,6 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
-#include <mach/ipmmu.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index aadb769..5dd3576 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -30,6 +30,7 @@
 #include <linux/serial_sci.h>
 #include <linux/sh_dma.h>
 #include <linux/sh_intc.h>
+#include <linux/sh_iommu.h>
 #include <linux/sh_timer.h>
 #include <linux/pm_domain.h>
 #include <linux/dma-mapping.h>
@@ -38,7 +39,6 @@
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
 #include <mach/common.h>
-#include <mach/ipmmu.h>
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index 9f2243e3..463da32 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -23,8 +23,10 @@
 #include <linux/io.h>
 #include <linux/iommu.h>
 #include <linux/platform_device.h>
+#include <linux/sh_iommu.h>
 #include <linux/slab.h>
-#include <mach/ipmmu.h>
+
+#include "shmobile-ipmmu.h"
 
 #define L1_SIZE CONFIG_SHMOBILE_IOMMU_L1SIZE
 #define L1_LEN (L1_SIZE / 4)
diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
index edec3b8..34e3c66 100644
--- a/drivers/iommu/shmobile-ipmmu.c
+++ b/drivers/iommu/shmobile-ipmmu.c
@@ -22,7 +22,8 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <mach/ipmmu.h>
+
+#include "shmobile-ipmmu.h"
 
 #define IMCTR1 0x000
 #define IMCTR2 0x004
diff --git a/arch/arm/mach-shmobile/include/mach/ipmmu.h b/drivers/iommu/shmobile-ipmmu.h
similarity index 78%
rename from arch/arm/mach-shmobile/include/mach/ipmmu.h
rename to drivers/iommu/shmobile-ipmmu.h
index 4b805b1f..0e0a6a4 100644
--- a/arch/arm/mach-shmobile/include/mach/ipmmu.h
+++ b/drivers/iommu/shmobile-ipmmu.h
@@ -5,13 +5,8 @@
 void ipmmu_tlb_flush(struct device *ipmmu_dev);
 void ipmmu_tlb_set(struct device *ipmmu_dev, unsigned long phys, int size,
 		   int asid);
-void ipmmu_add_device(struct device *dev);
 int ipmmu_iommu_init(struct device *dev);
 #else
-static inline void ipmmu_add_device(struct device *dev)
-{
-}
-
 static int ipmmu_iommu_init(struct device *dev)
 {
 	return -EINVAL;
diff --git a/include/linux/sh_iommu.h b/include/linux/sh_iommu.h
new file mode 100644
index 0000000..cc669a0
--- /dev/null
+++ b/include/linux/sh_iommu.h
@@ -0,0 +1,12 @@
+#ifndef __SH_IOMMU_H__
+#define __SH_IOMMU_H__
+
+#ifdef CONFIG_SHMOBILE_IPMMU_TLB
+void ipmmu_add_device(struct device *dev);
+#else
+static inline void ipmmu_add_device(struct device *dev)
+{
+}
+#endif
+
+#endif /* __SH_IOMMU_H__ */
-- 
1.7.8.6

