Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2LKLIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:08:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42848 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LKLIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:08:01 -0500
X-AuditID: cbfee61b-b7f616d00000319b-dd-50c714107258
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Dae Inki'" <inki.dae@samsung.com>, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahun Sharma'" <rahul.sharma@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'SWKim'" <sw0312.kim@samsung.com>
Subject: [PATCH v5 01/14] iommu/exynos: add missing cache flush for removed
 pagetable entries
Date: Tue, 11 Dec 2012 20:07:59 +0900
Message-id: <003101cdd78f$c7e8f280$57bad780$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjGqeidtx2ToqRtS+zJKPhJXolgAA0Lzg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ10BkeMBBivOM1lc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXsWvGepeA2R8XOaWENjHPZuxg5OSQETCT61nxjgrDF
	JC7cW8/WxcjFISSwjFHid9MCRpiig9cnQyWmM0psPvuEGcL5xygxZ+ETsFFsAloSq+ceB+sQ
	EbjLKPHyPA9IEbPAESaJnffPsYAkhAXiJVq+nmYFsVkEVCU2nz4GZvMK2ErM37maBcIWlPgx
	+R6YzQw0dP3O40wQtrzE5jVvgTZzAJ2kLvHory7ELiOJF5sPskGUiEjse/GOEWK8gMS3yYdY
	IMplJTYdALtZQqCfXeLI8RdsEJ9JShxccYNlAqPYLCSbZyHZPAvJ5llIVixgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERI10jsYVzVYHGIU4GBU4uHV0DoWIMSaWFZcmXuIUYKDWUmE
	N1LoeIAQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wMjOq8k3tDY2MTMxNTE3NLU3BSHsJI4
	b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxhjt7V0//131MalqCDD3FazS+va3IUZ38xFVs26r
	O62y0XuVzj4IPiPEEf0yfr3XE02xeDPf188UWHeFTYtIajuv/G7+6WSv5xxT05bPv3X1PN+E
	7p0bv9WbvVt187z08xu7nm2R9nvbWxv1LGbVg8WWW+8ckElpbGg5mvozwGvn69ymfVWL/JVY
	ijMSDbWYi4oTATj9fZ/HAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQV1+keMBBpfmW1tc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7FrxnqXgNkfF
	zmlhDYxz2bsYOTkkBEwkDl6fzAZhi0lcuLceyObiEBKYziix+ewTZgjnH6PEnIVPwDrYBLQk
	Vs89zghiiwjcZZR4eZ4HpIhZ4AiTxM7751hAEsIC8RItX0+zgtgsAqoSm08fA7N5BWwl5u9c
	zQJhC0r8mHwPzGYGGrp+53EmCFteYvOat0CbOYBOUpd49FcXYpeRxIvNB9kgSkQk9r14xziB
	UWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx+Qz6R2Mqxos
	DjEKcDAq8fBqaB0LEGJNLCuuzD3EKMHBrCTCGyl0PECINyWxsiq1KD++qDQntfgQow/QoxOZ
	pUST84HpIq8k3tDYxMzI0sjMwsjE3ByHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxt6X
	D5z2XolZ/euQtIv2QstopWu1ScsnC/yPvVjTGb2/8Nt358KdjRcnPPNakaMr574lli/9ZUCq
	u/rV1idzTE23nXq4b+IntbT1dyY+7gy4u0T9D+97lvCXnCL8B2NVA2zVFFli7k4+/PvV5OSG
	y6cv6O49uMffNEd6dvQz3dMmO7IvvOra+FmJpTgj0VCLuag4EQDr6tfr9gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds cache flush for removed small page and large page
entries in exynos_iommu_unmap(). Missing cache flush of removed
page table entries can cause missing page fault interrupt when a
master IP accesses an unmapped area.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7fe44f8..b96f3b9 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 
 	if (lv2ent_small(ent)) {
 		*ent = 0;
+		pgtable_flush(ent, ent + 1);
 		size = SPAGE_SIZE;
 		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
@@ -1011,6 +1012,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	BUG_ON(size < LPAGE_SIZE);
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
 	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
-- 
1.8.0


