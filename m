Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1LRADL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 19:03:11 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23621 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1LRADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:03:08 -0500
Date: Sun, 18 Dec 2011 01:03:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] Put braces around potentially empty 'if' body in
 handle_pte_fault()
Message-ID: <alpine.LNX.2.00.1112180059080.21784@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-457409574-1324166586=:21784"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-457409574-1324166586=:21784
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

If one builds the kernel with -Wempty-body one gets this warning:

  mm/memory.c:3432:46: warning: suggest braces around empty body in an ¡if¢ statement [-Wempty-body]

due to the fact that 'flush_tlb_fix_spurious_fault' is a macro that
can sometimes be defined to nothing.

I suggest we heed gcc's advice and put a pair of braces on that if.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mm/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 829d437..9cf1b48 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3428,9 +3428,9 @@ int handle_pte_fault(struct mm_struct *mm,
 		 * This still avoids useless tlb flushes for .text page faults
 		 * with threads.
 		 */
-		if (flags & FAULT_FLAG_WRITE)
+		if (flags & FAULT_FLAG_WRITE) {
 			flush_tlb_fix_spurious_fault(vma, address);
+		}
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);
-- 
1.7.8

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-457409574-1324166586=:21784--
