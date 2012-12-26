Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2LZBxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:53:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48015 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2LZBxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:53:38 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7b-50da58a128c6
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: [PATCH v6 03/12] iommu/exynos: allocate lv2 page table from own slab
Date: Wed, 26 Dec 2012 10:53:37 +0900
Message-id: <003601cde30b$d24fc140$76ef43c0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC9H2hrGFZmptTIiRxRqpOc2ItQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zA92FEbcCDOY9sLS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mro773CVvBOuOLGndtMDYyrBboYOTkkBEwk5uztZIew
	xSQu3FvP1sXIxSEksIxRoq/3FitM0cElj1kgEosYJTo3vYeq+scosenlbSaQKjYBLYnVc48z
	gtgiAncZJV6e5wEpYhb4yyjx6cwhsB3CAr4Sb5fsAytiEVCV+Lj8NNgKXgFbiQ/vPjFB2IIS
	PybfYwGxmQUMJN7P6mOFsOUlNq95y9zFyAF0krrEo7+6ELv0JPqmLmOHKBGR2PfiHdR4AYlv
	kw+xQJTLSmw6wAxyjoRAP7vEly13oT6TlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIyRupHcwrmqwOMQowMGoxMPL+etmgBBrYllxZe4hRgkO
	ZiURXuePQCHelMTKqtSi/Pii0pzU4kOMPkCXT2SWEk3OB8Z0Xkm8obGxiZmJqYm5pam5KQ5h
	JXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2MxqdtNlee7Ni54cJ/C2u2H5y13xfF7JH4df7d
	ieRg+ZMMx1JLjvKlaKv68efcC7iue4bjdG+a1P9PBn/qAtqzvB8E16os2Dv/7slNl6U3HY55
	/XqZ4BX/iKcvf9xIqFub6/qlbKb8VN6oU4c3bywTPTph59Zfh77fX517cI+5WLP7kxg1u6fv
	PyuxFGckGmoxFxUnAgCTBbknyAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd2FEbcCDO5/Nra4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6O+9wlbwTrji
	xp3bTA2MqwW6GDk5JARMJA4uecwCYYtJXLi3nq2LkYtDSGARo0TnpvdQzj9GiU0vbzOBVLEJ
	aEmsnnucEcQWEbjLKPHyPA9IEbPAX0aJT2cOsYMkhAV8Jd4u2QdWxCKgKvFx+WlWEJtXwFbi
	w7tPTBC2oMSPyffAVjMLGEi8n9XHCmHLS2xe85a5i5ED6CR1iUd/dSF26Un0TV3GDlEiIrHv
	xTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgqn0nv
	YFzVYHGIUYCDUYmHl/PXzQAh1sSy4srcQ4wSHMxKIrzOH4FCvCmJlVWpRfnxRaU5qcWHGH2A
	Hp3ILCWanA9MGHkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1
	MBocPbB80pVD57jOMot+W2Bu9PFfnZUzq3hlXMKNW6/D1dW8l87uZAiXa7uhkb8pTfnwuniz
	0HDdH6ubjjZuTC5W2njj0/zpnPeeXza8pr3t5GMmm62Vmfkx27RnuRlrmm7mVe/M8dNPMQ64
	Ux0zO1zxza9Su0Pmn1ulQsJ/ZoZ8Mzqcz8I/RYmlOCPRUIu5qDgRAEPKe/D3AgAA
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


