Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1ITSc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab1ITSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:32:58 -0400
Date: Tue, 20 Sep 2011 14:32:55 -0400
From: Dean Nelson <dnelson@redhat.com>
To: linux-mm@kvack.org
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Message-Id: <20110920183254.3926.59134.email-sent-by-dnelson@localhost6.localdomain6>
Subject: [PATCH] HWPOISON: Convert pr_debug()s to pr_info()s
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fb46e73520940bfc426152cfe5e4a9f1ae3f00b6 authored by Andi Kleen
converted a number of pr_debug()s to pr_info()s.

About the same time additional code with pr_debug()s was added by
two other commits 8c6c2ecb44667f7204e9d2b89c4c1f42edc5a196 and
d950b95882f3dc47e86f1496cd3f7fef540d6d6b. And these pr_debug()s
failed to get converted to pr_info()s.

This patch converts them as well. And does some minor related
whitespace cleanup.

Signed-off-by: Dean Nelson <dnelson@redhat.com>

---
 mm/memory-failure.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2b43ba0..edc388d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1310,7 +1310,7 @@ int unpoison_memory(unsigned long pfn)
 		 * to the end.
 		 */
 		if (PageHuge(page)) {
-			pr_debug("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
+			pr_info("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
@@ -1419,7 +1419,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
 
 	if (PageHWPoison(hpage)) {
 		put_page(hpage);
-		pr_debug("soft offline: %#lx hugepage already poisoned\n", pfn);
+		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
 		return -EBUSY;
 	}
 
@@ -1433,8 +1433,8 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		list_for_each_entry_safe(page1, page2, &pagelist, lru)
 			put_page(page1);
 
-		pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
-			 pfn, ret, page->flags);
+		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
+			pfn, ret, page->flags);
 		if (ret > 0)
 			ret = -EIO;
 		return ret;
@@ -1505,7 +1505,7 @@ int soft_offline_page(struct page *page, int flags)
 	}
 	if (!PageLRU(page)) {
 		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
-				pfn, page->flags);
+			pfn, page->flags);
 		return -EIO;
 	}
 
@@ -1566,7 +1566,7 @@ int soft_offline_page(struct page *page, int flags)
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
-				pfn, ret, page_count(page), page->flags);
+			pfn, ret, page_count(page), page->flags);
 	}
 	if (ret)
 		return ret;
