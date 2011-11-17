Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1KQV5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:57:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33433 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1KQV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:57:39 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH v2 1/2] hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
Date: Thu, 17 Nov 2011 13:57:29 -0800
Message-Id: <1321567050-13197-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

When linux-next 10111117 is build for MIPS with
cavium-octeon_defconfig, we get:

  arch/mips/mm/tlb-r4k.c: In function 'local_flush_tlb_range':
  arch/mips/mm/tlb-r4k.c:129:28: error: 'HPAGE_SHIFT' undeclared (first use in this function)

The fix is to supply a dummy HPAGE_SHIFT in the !CONFIG_HUGETLB_PAGE
case.  Instead of supplying the non-huge value, as was done for
HPAGE_MASK and HPAGE_SIZE, we do BUG() instead.  This satisfies the
compiler, but give us runtime safety if someone were to use HPAGE_SIZE
incorrectly.

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/hugetlb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 19644e0..380451c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -113,6 +113,7 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
 #ifndef HPAGE_MASK
 #define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
 #define HPAGE_SIZE	PAGE_SIZE
+#define HPAGE_SHIFT	({BUG(); 0; })
 #endif
 
 #endif /* !CONFIG_HUGETLB_PAGE */
-- 
1.7.2.3

