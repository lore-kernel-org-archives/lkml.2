Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2KVTnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:43:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10375 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2KVTn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:43:26 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-f6-50ae0d7b9635
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 06/12] iommu/exynos: allocate lv2 page table from own slab
Date: Thu, 22 Nov 2012 20:33:15 +0900
Message-id: <002701cdc8a5$294e2a80$7bea7f80$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpSkv3Ig/Wl/7SBmsKMOe6FrDGQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zY91q3nUBBk/nylhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXsv9nKWvBOuKL/QDtjA+NqgS5GTg4JAROJptcXWSFs
	MYkL99azdTFycQgJLGOU2Pt1NzNM0eGD96ES0xklmh9cYYJw/jFKzH3awgJSxSagJbF67nFG
	kISIQC+jxIX+r2BVzAI/GCWmb/4FViUs4CvR/fYbO4jNIqAq8W3bU7AdvAK2Ev/frGCHsAUl
	fky+B1bPDDR1/c7jTBC2vMTmNW+B6jmAblKXePRXFyQsIqAnsWv9M2aIEhGJfS/eMUKMF5D4
	NvkQC0S5rMSmA8wg50gITGaXOL3/PyPEa5ISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmKERI7UDsaVDRaHGAU4GJV4eDWd1wYIsSaWFVfmHmKU
	4GBWEuG9x70uQIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgVGdVxJvaGxsYmZiamJuaWpu
	ikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPj9qf5cQ6hXf2/Q+3LYl62LNfMyrx1fOWf
	a5edN0xrCv9zRae67GV1+jU76zkFtSF7f848vmdGgq3zOnnuD297F560vP93S9ThFZtKBG2e
	9bZLHnlnH9nKkCz1Udymp6NH4ldK99sUpaeXg5/W3iq/5bq5Ssnow9ymAtbuyNfCNyeF7EtK
	W2arxFKckWioxVxUnAgAedfeMskCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd1q3nUBBie7xS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz9t9sZS14J1zR
	f6CdsYFxtUAXIyeHhICJxOGD99kgbDGJC/fWA9lcHEIC0xklmh9cYYJw/jFKzH3awgJSxSag
	JbF67nFGkISIQC+jxIX+r2BVzAI/GCWmb/4FViUs4CvR/fYbO4jNIqAq8W3bU2YQm1fAVuL/
	mxXsELagxI/J98DqmYGmrt95nAnClpfYvOYtUD0H0E3qEo/+6oKERQT0JHatf8YMUSIise/F
	O8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOC6fSe1g
	XNlgcYhRgINRiYdX03ltgBBrYllxZe4hRgkOZiUR3nvc6wKEeFMSK6tSi/Lji0pzUosPMfoA
	PTqRWUo0OR+YMvJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRq
	YLS//uudZv/f80t/1LxSiMrne3VmybrfNx5P8CwVZXyitfKY2MRPq6uXvGDQ6awqPTxnoY3D
	8o2yIgJJhqsec+xzsI7csGpJ65MVZqUH7US5pm3gN03ifuZ9J+0ic/S6KdNWJTyc4fZ3TsHb
	nyYrVZ21evgZ8xqY3+48yMLg+e2NkJaTSO5c60QlluKMREMt5qLiRADO6Yln+AIAAA==
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


