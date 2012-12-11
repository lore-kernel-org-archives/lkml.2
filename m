Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2LKLIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:08:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42982 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2LKLIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:08:53 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e8-50c71444bd16
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
Subject: [PATCH v5 03/14] iommu/exynos: allocate lv2 page table from own slab
Date: Tue, 11 Dec 2012 20:08:51 +0900
Message-id: <003301cdd78f$e71a7b60$b54f7220$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjG+P2Ij5g2hRRDmuQTzvSQa18wAA3AKg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zA10XkeMBBltfSVhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0915hK3gnXHHjzm2mBsbVAl2MnBwSAiYSOxbtZYKw
	xSQu3FvPBmILCSxjlLjzkR+mZs2dU0BxLqD4dEaJ/pMvWSCK/jFK7N7PCGKzCWhJrJ57HMwW
	EbjLKPHyPA9IA7PAESaJnffPgTUIC/hK/PuwGsxmEVCVOP5rDVADBwevgK3E5oNgvbwCghI/
	Jt8DK2EGmrl+53EmCFteYvOat8wg5RIC6hKP/upCrDKSuLp6ETNEiYjEvhfvGCGmC0h8m3yI
	BaJcVmLTAWaQayQE+tklnn67wQbxl6TEwRU3WCYwis1CsnkWks2zkGyehWTFAkaWVYyiqQXJ
	BcVJ6blGesWJucWleel6yfm5mxghESO9g3FVg8UhRgEORiUeXg2tYwFCrIllxZW5hxglOJiV
	RHgjhY4HCPGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MJrzSuINjY1NzExMTcwtTc1NcQgr
	ifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamD0W8K4ouPYNnnRV/rfma5cd/EIVRBYsCBq564v
	PzY9E9rszHv3vI5clqMms9rOmKR9YosS+I4+8dHq/nvSd2lm4FIz6SVlitZz25a4HVl7l1Pu
	1s5DO5o/nlnXoaF6yaRtVs78iTkSK4/f2X5Y5MX3Zi+Wg/08d74lKK4rzbC7vu6XlUXf91ou
	JZbijERDLeai4kQAP9x5wcUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQV0XkeMBBi+6hC0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz+nuvsBW8E664
	cec2UwPjaoEuRk4OCQETiTV3TrFB2GISF+6tB7K5OIQEpjNK9J98yQKSEBL4xyixez8jiM0m
	oCWxeu5xMFtE4C6jxMvzPCANzAJHmCR23j8H1iAs4Cvx78NqMJtFQFXi+K81QA0cHLwCthKb
	D4L18goISvyYfA+shBlo5vqdx5kgbHmJzWveMoOUSwioSzz6qwuxykji6upFzBAlIhL7Xrxj
	nMAoMAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj8pn0DsZV
	DRaHGAU4GJV4eDW0jgUIsSaWFVfmHmKU4GBWEuGNFDoeIMSbklhZlVqUH19UmpNafIjRB+jP
	icxSosn5wGSRVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVANj
	XF/DSoZt0p9DAmJvr9jUUZLAMatt6rUfe86cWxu5ffOJ88w2NX+ubFx5p4WlYkFfU8rt35PL
	MpkXTVZ6ecyj28nR3c501azXngUMkvlfdDqtkitZeH6mrT12nLHb1K3x4sYpvTX809Tlnzpt
	lNh38ZniporqxlaToyff5Z77/aBKXK9pJ99MJZbijERDLeai4kQABlmLQ/UCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kmalloc() does not guarantee the alignment of 1KB when it
allocates 1KB, it is required to allocate lv2 page table from
own slab that guarantees alignment of 1KB.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index ef7dbd1..58d2a24 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -101,6 +101,8 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+static struct kmem_cache *lv2table_kmem_cache;
+
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 {
 	return pgtable + lv1ent_offset(iova);
@@ -739,7 +741,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -833,7 +836,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return NULL;
@@ -856,7 +859,7 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 		if (*pgcnt != NUM_LV2ENTRIES)
 			return -EADDRINUSE;
 
-		kfree(page_entry(sent, 0));
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 
 		*pgcnt = 0;
 	}
@@ -1044,10 +1047,23 @@ static int __init exynos_iommu_init(void)
 {
 	int ret;
 
+	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
+		LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
+	if (!lv2table_kmem_cache) {
+		pr_err("%s: failed to create kmem cache\n", __func__);
+		return -ENOMEM;
+	}
+
 	ret = platform_driver_register(&exynos_sysmmu_driver);
 
 	if (ret == 0)
-		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+		ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+
+	if (ret) {
+		pr_err("%s: Failed to register exynos-iommu driver.\n",
+								__func__);
+		kmem_cache_destroy(lv2table_kmem_cache);
+	}
 
 	return ret;
 }
-- 
1.8.0


