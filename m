Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2KSFai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:38 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58015 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2KSFag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:36 -0500
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/58] mm: include/linux/huge_mm.h: Declare is_vma_temporary_stack unconditionally
Date: Sun, 18 Nov 2012 21:28:03 -0800
Message-Id: <1353302917-13995-25-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/huge_mm.h declares is_vma_temporary_stack inside an ifdef
CONFIG_TRANSPARENT_HUGEPAGE; however, mm/rmap.c defines the function
unconditionally.  Move the function outside of the ifdef.

This eliminates a warning from gcc (-Wmissing-prototypes) and from
Sparse (-Wdecl).

mm/rmap.c:1440:6: warning: no previous prototype for ‘is_vma_temporary_stack’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/huge_mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b31cb7d..3f39803 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -53,13 +53,13 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
+extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT HPAGE_SHIFT
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
-extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
-
 #define transparent_hugepage_enabled(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
-- 
1.7.10.4

