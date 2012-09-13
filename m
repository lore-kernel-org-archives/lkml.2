Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2IMOV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:21:29 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:48923 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2IMOV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:21:28 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH] thp, s390: add missing earlyclobber to inline assembly
Date: Thu, 13 Sep 2012 16:21:03 +0200
Message-Id: <1347546063-6337-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.6
In-Reply-To: <1346937043-28208-9-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-9-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12091314-1948-0000-0000-000002F23AD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The constraints of the rrbm inline assembly are missing two
earlyclobber operands, which can lead to an addressing exception
depending on compiler register allocation decisions.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---

Hello Andrew, please merge this with patch
thp-s390-architecture-backend-for-thp-on-s390.patch

 arch/s390/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 1393a3c..ce67458 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1296,7 +1296,8 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 			"	ogr	%1,%0\n"
 			"	la	%3,0(%4,%3)\n"
 			"	brct	%2,0b\n"
-			: "=d" (tmp), "+d" (rc), "+d" (counter), "+a" (pmd_addr)
+			: "=&d" (tmp), "+&d" (rc), "+d" (counter),
+			  "+a" (pmd_addr)
 			: "a" (64 * 4096UL) : "cc");
 		rc = !!rc;
 	} else {
-- 
1.7.11.6

