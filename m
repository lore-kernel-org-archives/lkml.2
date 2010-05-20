Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0ETTMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:12:21 -0400
Received: from king.tilera.com ([72.1.168.226]:6986 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab0ETTMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:12:20 -0400
Message-ID: <4BF5898E.7050503@tilera.com>
Date: Thu, 20 May 2010 12:12:14 -0700
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Barry Song <21cnbao@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] generic: make lowmem_page_address() use PFN_PHYS() for improved
 portability
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
In-Reply-To: <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2010 19:12:19.0364 (UTC) FILETIME=[5E1EF640:01CAF850]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that platforms with lowmem PAs above 32 bits work
correctly by avoiding truncating the PA during a left shift.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/linux/mm.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fb19bb9..33bedcf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -13,6 +13,7 @@
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 #include <linux/range.h>
+#include <linux/pfn.h>

 struct mempolicy;
 struct anon_vma;
@@ -591,7 +592,7 @@ static inline void set_page_links(struct page *page,
enum zone_type zone,

 static __always_inline void *lowmem_page_address(struct page *page)
 {
-       return __va(page_to_pfn(page) << PAGE_SHIFT);
+       return __va(PFN_PHYS(page_to_pfn(page)));
 }

 #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)


