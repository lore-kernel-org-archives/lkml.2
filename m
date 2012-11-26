Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2KZLX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:23:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab2KZLXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:23:55 -0500
Date: Mon, 26 Nov 2012 11:23:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: compaction: Fix return value of capture_free_page
Message-ID: <20121126112350.GI8218@suse.de>
References: <20121121192151.3FFE0A9A@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121121192151.3FFE0A9A@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 02:21:51PM -0500, Dave Hansen wrote:
> 
> This needs to make it in before 3.7 is released.
> 

This is also required. Dave, can you double check? The surprise is that
this does not blow up very obviously.

---8<---
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH] mm: compaction: Fix return value of capture_free_page

Commit ef6c5be6 (fix incorrect NR_FREE_PAGES accounting (appears like
memory leak)) fixes a NR_FREE_PAGE accounting leak but missed the return
value which was also missed by this reviewer until today. That return value
is used by compaction when adding pages to a list of isolated free
pages and without this follow-up fix, there is a risk of free list
corruption.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bcb72c6..8193809 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1422,7 +1422,7 @@ int capture_free_page(struct page *page, int alloc_order, int migratetype)
 		}
 	}
 
-	return 1UL << order;
+	return 1UL << alloc_order;
 }
 
 /*
