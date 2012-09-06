Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab2IFEeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:34:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64941 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2IFEeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:34:10 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 12:34:09 +0800
Message-ID: <CAPgLHd-QRgrRMCab-Co=dU9a524KGU12LKcRape4hVfiYgRxAA@mail.gmail.com>
Subject: [PATCH] iommu/exynos: use list_del_init instead of list_del/INIT_LIST_HEAD
From: Wei Yongjun <weiyj.lk@gmail.com>
To: joerg.roedel@amd.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_del_init() instead of list_del() + INIT_LIST_HEAD().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/iommu/exynos-iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 80bad32..7fe44f8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -840,8 +840,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 	if (__exynos_sysmmu_disable(data)) {
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
 					__func__, __pa(priv->pgtable));
-		list_del(&data->node);
-		INIT_LIST_HEAD(&data->node);
+		list_del_init(&data->node);
 
 	} else {
 		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",


