Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2KTHaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:30:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21065 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KTHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:46 -0500
X-AuditID: cbfee61b-b7f616d00000319b-21-50ab3192a7a1
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v6 06/12] iommu/exynos: allocate lv2 page table from own slab
Date: Tue, 20 Nov 2012 16:30:26 +0900
Message-id: <002001cdc6f0$e8eb2e30$bac18a90$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8OjSUX3qtyUFQ7WrGtUMXUhngQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI91JhqsDDI7/0re4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4f24GY8E74YoDP20aGFcLdDFyckgImEjMfniXFcIW
	k7hwbz0biC0ksIxRomEbC1zN83mMXYxcQPHpjBKPtk6Fcv4xSrRuWg5WxSagJbF67nGwhIhA
	L6PEhf6vTCAOs8APRonpm3+BVQkL+Ep8nHACbB+LgKrEmpXtYHFeAVuJBx1HmCBsQYkfk++B
	xZmBpq7feZwJwpaX2LzmLXMXIwfQTeoSj/7qgoRFBPQkWp99Z4QoEZHY9+IdI8R4AYlvkw+x
	QJTLSmw6wAxyjoRAP7vElimvoF6WlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIyRqpHcwrmqwOMQowMGoxMP7MGFVgBBrYllxZe4hRgkOZiUR
	3qZyoBBvSmJlVWpRfnxRaU5q8SFGH6DLJzJLiSbnAyM6ryTe0NjYxMzE1MTc0tTcFIewkjhv
	s0dKgJBAemJJanZqakFqEcw4Jg5OqQZGgRmqFYZHbhso2rn7XwvqL9UriWTleVbN1LzY88jd
	qSwLWb9Pf56ldv9iewbv3H+R27iPbXXLsjrA8WC/QszhzexLC39n7dkas+3PyeIevQPHDdm+
	1Z6pWcXtdcz/560b346c1jDNfLhl3T2nz8w7Zoh8njShbNpP9SvzOiYdV1/TtvtlwquLf5RY
	ijMSDbWYi4oTAfYyrYTHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd1JhqsDDBo3aVlc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm/D83g7HgnXDF
	gZ82DYyrBboYOTkkBEwkZj+fxwhhi0lcuLeerYuRi0NIYDqjxKOtUxkhnH+MEq2blrOAVLEJ
	aEmsnnscLCEi0MsocaH/KxOIwyzwg1Fi+uZfYFXCAr4SHyecYAWxWQRUJdasbAeL8wrYSjzo
	OMIEYQtK/Jh8DyzODDR1/c7jTBC2vMTmNW+Zuxg5gG5Sl3j0VxckLCKgJ9H67DsjRImIxL4X
	7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh8Jr2D
	cVWDxSFGAQ5GJR7ehwmrAoRYE8uKK3MPMUpwMCuJ8DaVA4V4UxIrq1KL8uOLSnNSiw8x+gA9
	OpFZSjQ5H5gw8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg
	NPiQ7/k3yjpAR1WzMTy0Y80z13n7bNyUH+yuv5svm+PrExQ47VXy/e3mpuWOqpus5p88O0Hd
	K7hUoJeZMapLrDhiv71jxoUFqxymmib4G1+Q0/oTePLX27nvVquKvqooEfxyXv+g9eWmxmsW
	87zVz+vHf/2zsElQPWbtJzdVTisWrtceJSJKLMUZiYZazEXFiQDw0eLP9wIAAA==
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
index b939b6e..0191ab5 100644
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
@@ -868,7 +870,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -962,7 +965,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return NULL;
@@ -985,7 +988,7 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 		if (*pgcnt != NUM_LV2ENTRIES)
 			return -EADDRINUSE;
 
-		kfree(page_entry(sent, 0));
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 
 		*pgcnt = 0;
 	}
@@ -1171,10 +1174,23 @@ static int __init exynos_iommu_init(void)
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


