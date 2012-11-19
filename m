Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2KSFaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:24 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51385 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2KSFaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:20 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 26/58] mm/internal.h: Declare vma_address unconditionally
Date: Sun, 18 Nov 2012 21:28:05 -0800
Message-Id: <1353302917-13995-27-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/internal.h declares vma_address inside an ifdef
CONFIG_TRANSPARENT_HUGEPAGE; however, mm/rmap.c defines the function
unconditionally.  Move the function outside of the ifdef.

This eliminates a warning from gcc (-Wmissing-prototypes) and from
Sparse (-Wdecl).

mm/rmap.c:527:1: warning: no previous prototype for ‘vma_address’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/internal.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a4fa284..6cd14dc 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -221,10 +221,8 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 	}
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern unsigned long vma_address(struct page *page,
 				 struct vm_area_struct *vma);
-#endif
 #else /* !CONFIG_MMU */
 static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
 {
-- 
1.7.10.4

