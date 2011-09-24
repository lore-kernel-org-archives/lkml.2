Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1I0Ln1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:43:27 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40473 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1I0LnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:43:21 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, KyongHo Cho <pullip.cho@samsung.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] iommu/exynos: Use bus_set_iommu instead of register_iommu
Date: Sat, 24 Sep 2011 11:02:50 +0900
Message-Id: <1316829770-21949-5-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1316829770-21949-1-git-send-email-pullip.cho@samsung.com>
References: <1316829770-21949-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces register_iommu() with bus_set_iommu() according to the
suggestion of Joerg Roedel.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
index fe5b5d8..148e238 100644
--- a/drivers/iommu/exynos_iommu.c
+++ b/drivers/iommu/exynos_iommu.c
@@ -852,7 +852,7 @@ static int __init exynos_iommu_init(void)
 	if (!l2table_cachep)
 		return -ENOMEM;
 
-	register_iommu(&exynos_iommu_ops);
+	bus_set_iommu(&platform_bus_type, &omap_iommu_ops);
 
 	return 0;
 }
-- 
1.7.1

