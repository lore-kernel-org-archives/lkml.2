Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1INOJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:09:33 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:8507
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821Ab1INOJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:09:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRIN9A-01-GNL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-omap@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
Date: Wed, 14 Sep 2011 16:07:39 +0200
Message-ID: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch it is possible to select the VIDEO_OMAP3
driver which then selects OMAP_IOVMM. But the omap iommu
driver is not compiled without IOMMU_SUPPORT enabled. Fix
that by forcing OMAP_IOMMU and OMAP_IOVMM are enabled before
VIDEO_OMAP3 can be selected.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/Kconfig       |    4 ++--
 drivers/media/video/Kconfig |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d901930..ae46776 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -114,8 +114,8 @@ config OMAP_IOMMU
 	select IOMMU_API
 
 config OMAP_IOVMM
-	tristate
-	select OMAP_IOMMU
+	tristate "OMAP IO Virtual Memory Manager Support"
+	depends on OMAP_IOMMU
 
 config OMAP_IOMMU_DEBUG
        tristate "Export OMAP IOMMU/IOVMM internals in DebugFS"
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6a25fad..6201069 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -763,8 +763,7 @@ source "drivers/media/video/m5mols/Kconfig"
 
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
-	select OMAP_IOVMM
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
+	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
 	---help---
 	  Driver for an OMAP 3 camera controller.
 
-- 
1.7.4.1


