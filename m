Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1IMTcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:32:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1IMTcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:32:09 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 2/6] iommu/omap: announce supported page sizes
Date: Tue, 13 Sep 2011 22:31:24 +0300
Message-Id: <1315942288-17297-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315942288-17297-1-git-send-email-ohad@wizery.com>
References: <1315942288-17297-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the IOMMU core know we support 4KB, 64KB, 1MB and 16MB page sizes.

This way the IOMMU core can split any arbitrary-sized physically
contiguous regions (that it needs to map) as needed.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/omap-iommu.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 7e0188f..403dd6a 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1202,6 +1202,9 @@ static int omap_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+/* bitmap of the page sizes supported by the OMAP IOMMU hardware */
+static unsigned long omap_iommu_pgsizes = SZ_4K | SZ_64K | SZ_1M | SZ_16M;
+
 static struct iommu_ops omap_iommu_ops = {
 	.domain_init	= omap_iommu_domain_init,
 	.domain_destroy	= omap_iommu_domain_destroy,
@@ -1225,7 +1228,8 @@ static int __init omap_iommu_init(void)
 		return -ENOMEM;
 	iopte_cachep = p;
 
-	register_iommu(&omap_iommu_ops);
+	/* we're only using the first 25 bits of the pgsizes bitmap */
+	register_iommu_pgsize(&omap_iommu_ops, &omap_iommu_pgsizes, 25);
 
 	return platform_driver_register(&omap_iommu_driver);
 }
-- 
1.7.4.1

