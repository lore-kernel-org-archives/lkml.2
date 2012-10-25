Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab2JYJVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:21:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58548 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab2JYJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:21:49 -0400
X-AuditID: cbfee61b-b7f616d00000319b-f4-5089049f8b24
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, "'Bob Liu'" <lliubbo@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mm: fix build warning in try_to_unmap_cluster()
Date: Thu, 25 Oct 2012 18:21:34 +0900
Message-id: <000f01cdb292$20df5910$629e0b30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2ykiCFL5JQQOd7QSCIyo4ugvXrLg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd35LJ0BBg19vBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj05o1jAWb2CvOzX7I2MDYwdbFyMkhIWAi8ejBNihbTOLCvfVA
	NheHkMB0Rolr9/rZIZzZTBJ3Xk9nBaliE1CT+PLlMDuILSLgK/F98QYmEJtZIFriwL8tzCC2
	sICDxKZb9xlBbBYBVYkTkxaCbeAVsJX42zMfyhaU+DH5HgtEr5bE+p3HoebIS2xe8xZoDgfQ
	ReoSj/7qQqzSk2g5eQqqXERi34t3jBMYBWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwYD6T3sG4qsHiEKMAB6MSD+9Bj44AIdbEsuLK3EOMEhzMSiK8298D
	hXhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZODilGhjr9VZyvvvj
	uCrXdIZm4N3zwosWX5ry3LY3OiXIO5FrZ+aNZu9Wm+ys2w/vGolYBUxy/eha4tDxNuGE41YL
	DYH3+/nXe50RFY2JKgvae7OZ6zXDc62fduKaZ4Sv7NI5Ok3Zt3vN082OmrNc3utcimo+8X2y
	08YcUwGDoyIB+Y5nzG6dvjrlRZUSS3FGoqEWc1FxIgB3IWMXSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning in try_to_unmap_cluster() as below:

mm/rmap.c: In function 'try_to_unmap_cluster':
mm/rmap.c:1364:9: warning: unused variable 'pud' [-Wunused-variable]
mm/rmap.c:1363:9: warning: unused variable 'pgd' [-Wunused-variable]

This build warning is introduced by commit 0981230
"mm: introduce mm_find_pmd()".

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Bob Liu <lliubbo@gmail.com>
---
This patch is based on linux-next-20121025 code tree.

 mm/rmap.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6c686c2..98b100e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1360,8 +1360,6 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 		struct vm_area_struct *vma, struct page *check_page)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	pte_t pteval;
-- 
1.7.1


