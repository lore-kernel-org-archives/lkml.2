Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2LQLtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:49:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2LQLtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:49:22 -0500
Date: Mon, 17 Dec 2012 11:49:17 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH] mm: Suppress mm/memory.o warning on older compilers if
 !CONFIG_NUMA_BALANCING
Message-ID: <20121217114917.GF9887@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test robot reported the following after the merge of Automatic
NUMA Balancing when cross-compiling for avr32.

mm/memory.c: In function 'do_pmd_numa_page':
mm/memory.c:3593: warning: no return statement in function returning non-void

The code is unreachable but the avr32 cross-compiler was not new enough
to know that. This patch suppresses the warning.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index e6a3b93..23f1fdf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3590,6 +3590,7 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		     unsigned long addr, pmd_t *pmdp)
 {
 	BUG();
+	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
