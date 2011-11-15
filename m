Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1KOIG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:06:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52987 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1KOIG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:06:28 -0500
Message-ID: <4EC21D78.4080508@gmail.com>
Date: Tue, 15 Nov 2011 16:06:16 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: cleanup the comment for head/tail pages of compound pages
 in mm/page_alloc.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the void prep_compound_page(struct page *page, unsigned long order) code,
compound pages use PG_head/PG_tail, and only tail pages point at head page
using their ->first_page field.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e8ecb6..f645ce8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -332,8 +332,8 @@ out:
  *
  * The remaining PAGE_SIZE pages are called "tail pages".
  *
- * All pages have PG_compound set.  All pages have their ->private pointing at
- * the head page (even the head page has this).
+ * Head page has PG_head set, and all tail pages have PG_tail set. All tail
+ * pages have their ->first_page pointing at the head page.
  *
  * The first tail page's ->lru.next holds the address of the compound page's
  * put_page() function.  Its ->lru.prev holds the order of allocation.
-- 
1.7.1
