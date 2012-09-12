Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab2ILTqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:46:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58001 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2ILTqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:46:03 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 1/9] ARM: OMAP: iommu: fix including iommu.h without IOMMU_API selected
Date: Wed, 12 Sep 2012 14:45:44 -0500
Message-Id: <1347479152-588-2-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If included without IOMMU_API being selected it will break
compilation:

arch/arm/plat-omap/include/plat/iommu.h:
	In function 'dev_to_omap_iommu':
arch/arm/plat-omap/include/plat/iommu.h:148:
	error: 'struct dev_archdata' has no member named 'iommu'

This will be seen when hwmod includes iommu.h to get the
structure for attributes. Also needed for tidspbridge
incremental migration to use iommu code.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/plat-omap/include/plat/iommu.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 88be3e6..e58d571 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -126,6 +126,7 @@ struct omap_iommu_arch_data {
 	struct omap_iommu *iommu_dev;
 };
 
+#ifdef CONFIG_IOMMU_API
 /**
  * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
  * @dev: iommu client device
@@ -136,6 +137,7 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 
 	return arch_data->iommu_dev;
 }
+#endif
 
 /* IOMMU errors */
 #define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
-- 
1.7.9.5

