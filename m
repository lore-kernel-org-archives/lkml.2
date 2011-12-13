Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab1LOFB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:01:56 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:54842 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1LOFBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:01:45 -0500
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: [PATCH] iommu: Initialize domain->handler in iommu_domain_alloc()
Date: Tue, 13 Dec 2011 16:14:26 +0900
Message-Id: <1323760466-30333-1-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is not guaranteed that an iommu driver initializes in its
domain_init() function, it must be initialized with NULL to prevent
calling a function in an arbitrary location when iommu fault occurred.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/iommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7cc3c65..1afb896 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -148,6 +148,7 @@ struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 		return NULL;
 
 	domain->ops = bus->iommu_ops;
+	domain->handler = NULL;
 
 	ret = domain->ops->domain_init(domain);
 	if (ret)
-- 
1.7.1

