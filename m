Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1JQLaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:30:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43122 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1JQL3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:29:07 -0400
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
Subject: [PATCH v4 4/7] iommu/msm: announce supported page sizes
Date: Mon, 17 Oct 2011 13:27:23 +0200
Message-Id: <1318850846-16066-5-git-send-email-ohad@wizery.com>
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
Acked-by: David Brown <davidb@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 drivers/iommu/msm_iommu.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 13718d9..08a90b8 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -42,6 +42,9 @@ __asm__ __volatile__ (							\
 #define RCP15_PRRR(reg)		MRC(reg, p15, 0, c10, c2, 0)
 #define RCP15_NMRR(reg)		MRC(reg, p15, 0, c10, c2, 1)
 
+/* bitmap of the page sizes currently supported */
+#define MSM_IOMMU_PGSIZES	(SZ_4K | SZ_64K | SZ_1M | SZ_16M)
+
 static int msm_iommu_tex_class[4];
 
 DEFINE_SPINLOCK(msm_iommu_lock);
@@ -679,7 +682,8 @@ static struct iommu_ops msm_iommu_ops = {
 	.map = msm_iommu_map,
 	.unmap = msm_iommu_unmap,
 	.iova_to_phys = msm_iommu_iova_to_phys,
-	.domain_has_cap = msm_iommu_domain_has_cap
+	.domain_has_cap = msm_iommu_domain_has_cap,
+	.pgsize_bitmap = MSM_IOMMU_PGSIZES,
 };
 
 static int __init get_tex_class(int icp, int ocp, int mt, int nos)
-- 
1.7.4.1

