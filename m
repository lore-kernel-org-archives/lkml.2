Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2LZBxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:53:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37785 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2LZBxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:53:24 -0500
X-AuditID: cbfee61b-b7f616d00000319b-00-50da5893550a
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
Subject: [PATCH v6 01/12] iommu/exynos: add missing cache flush for removed
 pagetable entries
Date: Wed, 26 Dec 2012 10:53:22 +0900
Message-id: <003401cde30b$c99d7f60$5cd87e20$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC8l/G1SP7pXJRfmNlrLGHqL/1Q==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zA93JEbcCDHb/FrG4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYteI9S8Ftjoqd08IaGOeydzFycEgImEhcvaHaxcgJ
	ZIpJXLi3nq2LkYtDSGAZo8TiOR2MMDWfXiWA1AgJLGKUuLPbDaLmH6PEp5nr2EESbAJaEqvn
	HmcEsUUE7jJKvDzPA1LELPAXqOjMIbAiYYF4ia/Hn4DZLAKqEgenHWUDsXkFbCUO79vFCGEL
	SvyYfI8FxGYWMJB4P6uPFcKWl9i85i0zxEHqEo/+6kLs0pNYeHYCI0SJiMS+F+8YIcYLSHyb
	fIgFolxWYtMBZpBzJAS62SVOzTzIBvGwpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGCHxIr2DcVWDxSFGAQ5GJR5ezl83A4RYE8uKK3MPMUpw
	MCuJ8Dp/BArxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhyPjCW80riDY2NTcxMTE3MLU3NTXEI
	K4nzNnukBAgJpCeWpGanphakFsGMY+LglGpglGVK0z2kybxoalmaRVfw1z5vh68r1yTV7rD+
	eUDY+8+duttMV77rTp/ycfFrv2/VdQdP5trH5fM83nxiseVpV/7f22Lcmt8aqWZ81uqXFlp7
	7Yw0a/ErHZmLZc65S38onZtQq9h7defXZFHHYA/xrqpvz+WNz5n9MHwyc2V37dOGvy0/XNwb
	lViKMxINtZiLihMBy72qp8QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd3JEbcCDDoWClhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7FrxnqXgNkfF
	zmlhDYxz2bsYOTgkBEwkPr1K6GLkBDLFJC7cW88GYgsJLGKUuLPbrYuRC8j+xyjxaeY6dpAE
	m4CWxOq5xxlBbBGBu4wSL8/zgBQxC/wFKjpzCKxIWCBe4uvxJ2A2i4CqxMFpR8Gm8grYShze
	t4sRwhaU+DH5HguIzSxgIPF+Vh8rhC0vsXnNW2aI49QlHv3VhdilJ7Hw7ARGiBIRiX0v3jFO
	YBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH4THoH46oG
	i0OMAhyMSjy8nL9uBgixJpYVV+YeYpTgYFYS4XX+CBTiTUmsrEotyo8vKs1JLT7E6AP06ERm
	KdHkfGCqyCuJNzQ2MTOyNDKzMDIxN8chrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBcWNG
	t6pvwP7VKSctufVVrwhUPNLW+zhfbGk63+Q+i0nuy/53C4cffHlF49C+nqgTPucmfmRtSZKT
	S1nW4cwf/adqsW9c8Ja840+5bOxYa5PEq4Mnxj9jPvSZyXivSpGcVFy8lbV50hyD/JZPeVfe
	V81UynhsF9fMlLNq2waxVevVrruskpmuxFKckWioxVxUnAgAWawxzfQCAAA=
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


