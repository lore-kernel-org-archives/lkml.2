Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2HWIkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:40:22 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47964 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801Ab2HWIkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:40:15 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 16:40:13 +0800
Message-ID: <CAFNq8R7ibTNeRP_Wftwyr7mK6Du4TVysQysgL_RYj+CGf9N2qg@mail.gmail.com>
Subject: Fixup the page of buddy_higher address's calculation
From: Li Haifeng <omycle@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d7cd78f9d71a5c9ddeed02724558096f0bb4508a Mon Sep 17 00:00:00 2001
From: Haifeng Li <omycle@gmail.com>
Date: Thu, 23 Aug 2012 16:27:19 +0800
Subject: [PATCH] Fixup the page of buddy_higher address's calculation

Signed-off-by: Haifeng Li <omycle@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ddbc17d..5588f68 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -579,7 +579,7 @@ static inline void __free_one_page(struct page *page,
                combined_idx = buddy_idx & page_idx;
                higher_page = page + (combined_idx - page_idx);
                buddy_idx = __find_buddy_index(combined_idx, order + 1);
-               higher_buddy = page + (buddy_idx - combined_idx);
+               higher_buddy = page + (buddy_idx - page_idx);
                if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
                        list_add_tail(&page->lru,
                                &zone->free_area[order].free_list[migratetype]);
--
1.7.5.4
