Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2C0KRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:17:40 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37880 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab2C0KRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:17:38 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org
Subject: [PATCH] mm/memory_failure: Let the compiler add the function name
Date: Tue, 27 Mar 2012 12:17:30 +0200
Message-Id: <1332843450-7100-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

These things tend to get out of sync with time so let the compiler
automatically enter the current function name using __func__.

No functional change.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 mm/memory-failure.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 56080ea36140..7d78d5ec61a7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1384,16 +1384,16 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
 	 */
 	if (!get_page_unless_zero(compound_head(p))) {
 		if (PageHuge(p)) {
-			pr_info("get_any_page: %#lx free huge page\n", pfn);
+			pr_info("%s: %#lx free huge page\n", __func__, pfn);
 			ret = dequeue_hwpoisoned_huge_page(compound_head(p));
 		} else if (is_free_buddy_page(p)) {
-			pr_info("get_any_page: %#lx free buddy page\n", pfn);
+			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
 			/* Set hwpoison bit while page is still isolated */
 			SetPageHWPoison(p);
 			ret = 0;
 		} else {
-			pr_info("get_any_page: %#lx: unknown zero refcount page type %lx\n",
-				pfn, p->flags);
+			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
+				__func__, pfn, p->flags);
 			ret = -EIO;
 		}
 	} else {
-- 
1.7.9.3.362.g71319

