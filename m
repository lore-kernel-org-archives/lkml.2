Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1HQMtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:49:03 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:42307 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1HQMs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:48:58 -0400
X-IronPort-AV: E=Sophos;i="4.68,240,1312156800"; 
   d="scan'208";a="7316366"
Subject: [Fwd: [PATCH] mm: make HASHED_PAGE_VIRTUAL page_address' struct
 page argument const.]
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 17 Aug 2011 13:48:56 +0100
Message-ID: <1313585336.5010.214.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending with correct LKML address this time. Apologies for the noise)

-------- Forwarded Message --------
From: Ian Campbell <ian.campbell@citrix.com>
To: linux@vger.kernel.org <linux@vger.kernel.org>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>, Andrea Arcangeli
<aarcange@redhat.com>, Rik van Riel <riel@redhat.com>, Michel Lespinasse
<walken@google.com>, Mel Gorman <mel@csn.ul.ie>, Andrew Morton
<akpm@linux-foundation.org>, Linus Torvalds
<torvalds@linux-foundation.org>
Subject: [PATCH] mm: make HASHED_PAGE_VIRTUAL page_address' struct page
argument const.
Date: Wed, 17 Aug 2011 13:45:09 +0100

Followup to 33dd4e0ec911 "mm: make some struct page's const" which missed the
HASHED_PAGE_VIRTUAL case.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/hash.h |    2 +-
 include/linux/mm.h   |    2 +-
 mm/highmem.c         |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/hash.h b/include/linux/hash.h
index 06d25c1..b80506b 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -63,7 +63,7 @@ static inline u32 hash_32(u32 val, unsigned int bits)
 	return hash >> (32 - bits);
 }
 
-static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
+static inline unsigned long hash_ptr(const void *ptr, unsigned int bits)
 {
 	return hash_long((unsigned long)ptr, bits);
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70116f5..12793b6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -741,7 +741,7 @@ static __always_inline void *lowmem_page_address(const struct page *page)
 #endif
 
 #if defined(HASHED_PAGE_VIRTUAL)
-void *page_address(struct page *page);
+void *page_address(const struct page *page);
 void set_page_address(struct page *page, void *virtual);
 void page_address_init(void);
 #endif
diff --git a/mm/highmem.c b/mm/highmem.c
index 693394d..5ef672c 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -326,7 +326,7 @@ static struct page_address_slot {
 	spinlock_t lock;			/* Protect this bucket's list */
 } ____cacheline_aligned_in_smp page_address_htable[1<<PA_HASH_ORDER];
 
-static struct page_address_slot *page_slot(struct page *page)
+static struct page_address_slot *page_slot(const struct page *page)
 {
 	return &page_address_htable[hash_ptr(page, PA_HASH_ORDER)];
 }
@@ -337,7 +337,7 @@ static struct page_address_slot *page_slot(struct page *page)
  *
  * Returns the page's virtual address.
  */
-void *page_address(struct page *page)
+void *page_address(const struct page *page)
 {
 	unsigned long flags;
 	void *ret;
-- 
1.7.2.5



