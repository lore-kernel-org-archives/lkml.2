Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab1BIOoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:44:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61463 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1BIOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:44:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mnv0LNug9CCM+glDOMs724wGSxlFBILJahtGzDkmYBre3ygXrdXRadZBZtfvMEEYlo
         GiiiVr1MZlAFxCvu4gBx3Xek72PPSoQEAQqkfJkNBj/IDs+PvKT0B+jA5+ehAd9Ha3Iy
         I+DIeA8QjYltxZdx0y1NIT5g7eoHaQBVDC+Vw=
From: Ryota Ozaki <ozaki.ryota@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix out-of-date comments which refers non-existent functions
Date: Wed,  9 Feb 2011 23:42:17 +0900
Message-Id: <1297262537-7425-1-git-send-email-ozaki.ryota@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryota Ozaki <ozaki.ryota@gmail.com>

do_file_page and do_no_page don't exist anymore, but some comments
still refers them. The patch fixes them by replacing them with
existing ones.

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
---
 mm/memory.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

I'm not familiar with the codes very much, so the fix may be wrong.

diff --git a/mm/memory.c b/mm/memory.c
index 31250fa..3fbf32a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2115,10 +2115,10 @@ EXPORT_SYMBOL_GPL(apply_to_page_range);
  * handle_pte_fault chooses page fault handler according to an entry
  * which was read non-atomically.  Before making any commitment, on
  * those architectures or configurations (e.g. i386 with PAE) which
- * might give a mix of unmatched parts, do_swap_page and do_file_page
+ * might give a mix of unmatched parts, do_swap_page and do_nonlinear_fault
  * must check under lock before unmapping the pte and proceeding
  * (but do_wp_page is only called after already making such a check;
- * and do_anonymous_page and do_no_page can safely check later on).
+ * and do_anonymous_page can safely check later on).
  */
 static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 				pte_t *page_table, pte_t orig_pte)
@@ -2316,7 +2316,7 @@ reuse:
 		 * bit after it clear all dirty ptes, but before a racing
 		 * do_wp_page installs a dirty pte.
 		 *
-		 * do_no_page is protected similarly.
+		 * __do_fault is protected similarly.
 		 */
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
-- 
1.7.2.3

