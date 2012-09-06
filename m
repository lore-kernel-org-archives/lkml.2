Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2IFJTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:19:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54365 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2IFJTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:19:38 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 17:11:18 +0800
Message-ID: <CAFNq8R65BCuTn2BDAQ=5twA0epaeR9tdJ2HTRb1tEWM15j0hQA@mail.gmail.com>
Subject: [PATCH 2/2] mm: Fixup abandoned PG_buddy for private in struct page
From: Li Haifeng <omycle@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PG_buddy, an abandoned flag, indicates page(s) is/are free
and in buddy allocator. And when page(s) in buddy allocator,
the _mapcount will equal PAGE_BUDDY_MAPCOUNT_VALUE. So,
here, "_mapcount equals PAGE_BUDDY_MAPCOUNT_VALUE" instead
of "PG_buddy is set".

Signed-off-by: Haifeng Li <omycle@gmail.com>
---
 include/linux/mm_types.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 704a626..49d9247 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -126,7 +126,8 @@ struct page {
                                                 * if PagePrivate set; used for
                                                 * swp_entry_t if PageSwapCache;
                                                 * indicates order in the buddy
-                                                * system if PG_buddy is set.
+                                                * system if _mapcount equals
+                                                * PAGE_BUDDY_MAPCOUNT_VALUE.
                                                 */
 #if USE_SPLIT_PTLOCKS
                spinlock_t ptl;
--
1.7.5.4
