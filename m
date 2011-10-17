Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1JQL3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:29:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43917 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1JQL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:29:04 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v4 3/7] iommu/omap: announce supported page sizes
Date: Mon, 17 Oct 2011 13:27:22 +0200
Message-Id: <1318850846-16066-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318850846-16066-1-git-send-email-ohad@wizery.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the IOMMU core know we support 4KiB, 64KiB, 1MiB and 16MiB page sizes.

This way the IOMMU core can split any arbitrary-sized physically
contiguous regions (that it needs to map) as needed.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/omap-iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 1bb2971..1692b6a 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -33,6 +33,9 @@
 	     (__i < (n)) && (cr = __iotlb_read_cr((obj), __i), true);	\
 	     __i++)
 
+/* bitmap of the page sizes currently supported */
+#define OMAP_IOMMU_PGSIZES	(SZ_4K | SZ_64K | SZ_1M | SZ_16M)
+
 /**
  * struct omap_iommu_domain - omap iommu domain
  * @pgtable:	the page table
@@ -1207,6 +1210,7 @@ static struct iommu_ops omap_iommu_ops = {
 	.unmap		= omap_iommu_unmap,
 	.iova_to_phys	= omap_iommu_iova_to_phys,
 	.domain_has_cap	= omap_iommu_domain_has_cap,
+	.pgsize_bitmap	= OMAP_IOMMU_PGSIZES,
 };
 
 static int __init omap_iommu_init(void)
-- 
1.7.4.1

