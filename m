Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1LWNin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:38:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62362 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1LWNik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:38:40 -0500
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 21:38:38 +0800
Message-ID: <CAJd=RBCS3-PoFa3FUVwhiznPTQH5xq7fTYa3m01a0-buACQbCA@mail.gmail.com>
Subject: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page

If we have to hand back the newly allocated huge page to page allocator,
for any reason, the changed counter should be recovered.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
+++ b/mm/hugetlb.c	Fri Dec 23 21:18:06 2011
@@ -800,7 +800,7 @@ static struct page *alloc_buddy_huge_pag

 	if (page && arch_prepare_hugepage(page)) {
 		__free_pages(page, huge_page_order(h));
-		return NULL;
+		page = NULL;
 	}

 	spin_lock(&hugetlb_lock);
