Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2HAJG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:06:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36718 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2HAJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:06:28 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, joerg.roedel@amd.com, pullip.cho@samsung.com,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] iommu/exynos: Fix build error
Date: Wed,  1 Aug 2012 14:35:17 +0530
Message-Id: <1343811917-24054-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following build error introduced by commit 3177bb76a8
("iommu/exynos: Implement DOMAIN_ATTR_GEOMETRY attribute"):

drivers/iommu/exynos-iommu.c: In function ‘exynos_iommu_domain_init’:
drivers/iommu/exynos-iommu.c:735:2: error: ‘dom’ undeclared
(first use in this function)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/iommu/exynos-iommu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 45350ff..80bad32 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -732,9 +732,9 @@ static int exynos_iommu_domain_init(struct iommu_domain *domain)
 	spin_lock_init(&priv->pgtablelock);
 	INIT_LIST_HEAD(&priv->clients);
 
-	dom->geometry.aperture_start = 0;
-	dom->geometry.aperture_end   = ~0UL;
-	dom->geometry.force_aperture = true;
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end   = ~0UL;
+	domain->geometry.force_aperture = true;
 
 	domain->priv = priv;
 	return 0;
-- 
1.7.4.1

