Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1IPRxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:53:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53304 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab1IPRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:52:22 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v3 2/6] iommu/omap: announce supported page sizes
Date: Fri, 16 Sep 2011 20:51:42 +0300
Message-Id: <1316195506-9777-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316195506-9777-1-git-send-email-ohad@wizery.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the IOMMU core know we support 4KiB, 64KiB, 1MiB and 16MiB page sizes.

This way the IOMMU core can split any arbitrary-sized physically
contiguous regions (that it needs to map) as needed.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
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

