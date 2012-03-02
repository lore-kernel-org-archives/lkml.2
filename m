Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2CBKml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:42:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44415 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2CBKmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:42:40 -0500
Date: Fri, 2 Mar 2012 11:42:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tj@elte.hu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] memblock fix
Message-ID: <20120302104231.GA19451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 847854f5988a04fe7e02d2fdd4fa0df9f96360fe memblock: Fix size aligning of memblock_alloc_base_nid()

 Thanks,

	Ingo

------------------>
Tejun Heo (1):
      memblock: Fix size aligning of memblock_alloc_base_nid()


 mm/memblock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 77b5f22..99f2855 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -99,9 +99,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
@@ -731,6 +728,9 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 {
 	phys_addr_t found;
 
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
+
 	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
