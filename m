Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab2KUFF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:05:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47545 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2KUFF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:05:57 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ea-50ac61347cd6
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 06/12] iommu/exynos: allocate lv2 page table from own slab
Date: Wed, 21 Nov 2012 14:05:55 +0900
Message-id: <002d01cdc7a5$e32ad9e0$a9808da0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HpeME5AbiW3QuTZStpftTA6bQOw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zfV2TxDUBBh8/sFlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW0dH9kL1giUnF87gP2BsZ7Al2MnBwSAiYSJ+Z+ZYew
	xSQu3FvP1sXIxSEksIxR4u3urYwwRX+6XrJDJKYzSrz6+YQZwvnHKPH5x1tWkCo2AS2J1XOP
	M4IkRAR6GSUu9H9lAnGYBX4wSix+84YZpEpYwFdi49plTCA2i4CqRMvmDrAdvAK2EhuWzYay
	BSV+TL7HAmIzA01dv/M4E4QtL7F5zVugORxAN6lLPPqrCxIWEdCT2P+iiRmiRERi34t3jBDj
	BSS+TT7EAlEuK7HpANjREgKT2SUmfHzPBvGapMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGRI72DcVWDxSFGAQ5GJR5eiX2rA4RYE8uKK3MP
	MUpwMCuJ8DLIrwkQ4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5HxgVOeVxBsaG5uYmZiamFua
	mpviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwMjyhdNY6URlq2nejmuyHF/Pnyzuuv84
	YNWMsJoZvulh1tMFnW07o8QCP9S8z3gdN2muaIRR+XGlcnl+75J3lmWvF+Rks2Ta5yycFFZ6
	WPjUnCcMbU8uKUjMCbwb5Sj772cYxz6/DvuNU9TWXbvH8X1dn6NwsmHwvT6e33PcJrGdKy68
	IyMip8RSnJFoqMVcVJwIAOnoDuLJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQV2TxDUBBs2zGS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzWro/shcsEak4
	PvcBewPjPYEuRk4OCQETiT9dL9khbDGJC/fWs3UxcnEICUxnlHj18wkzhPOPUeLzj7esIFVs
	AloSq+ceZwRJiAj0Mkpc6P/KBOIwC/xglFj85g0zSJWwgK/ExrXLmEBsFgFViZbNHYwgNq+A
	rcSGZbOhbEGJH5PvsYDYzEBT1+88zgRhy0tsXvMWaA4H0E3qEo/+6oKERQT0JPa/aGKGKBGR
	2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHJfP
	pHcwrmqwOMQowMGoxMMrsW91gBBrYllxZe4hRgkOZiURXgb5NQFCvCmJlVWpRfnxRaU5qcWH
	GH2AHp3ILCWanA9MGXkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFx
	cEo1MBa4TVuY+bnVR1XKa8UhyVVPkkTNLG3l3W/3vXHdP8GimnchXxqbdbkHqwN3Ot/z+SUG
	O0XPhG/XrA1MFhQulHoQJ5Up0rn9/FH26zP0/vxqLq0TEIrRrmtku/n++Re1n+oC/WvnsEr0
	vPv5pfvsrWurn5d/Wa+7wf8Eg6yUztNi3mMXPBlmKLEUZyQaajEXFScCAB2l5dv4AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kmalloc() does not guarantee the alignment of 1KB when it
allocates 1KB, it is required to allocate lv2 page table from
own slab that guarantees alignment of 1KB.

Change-Id: Ia25642c7c0143d2c50a8ed5a3d0dd9067f324c4e
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4061b17..0bb194e 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -104,6 +104,8 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+static struct kmem_cache *lv2table_kmem_cache;
+
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 {
 	return pgtable + lv1ent_offset(iova);
@@ -865,7 +867,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -959,7 +962,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return NULL;
@@ -982,7 +985,7 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 		if (*pgcnt != NUM_LV2ENTRIES)
 			return -EADDRINUSE;
 
-		kfree(page_entry(sent, 0));
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 
 		*pgcnt = 0;
 	}
@@ -1168,10 +1171,23 @@ static int __init exynos_iommu_init(void)
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


