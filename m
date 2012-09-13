Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2IMOgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:36:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39274 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2IMOgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:36:00 -0400
Date: Thu, 13 Sep 2012 16:35:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core kernel fix
Message-ID: <20120913143542.GA16170@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 15674868d6c5985466835c56dd89d39235f16302 mm/memblock: Use NULL instead of 0 for pointers

Fixes a Sparse warning.

 Thanks,

	Ingo

------------------>
Sachin Kamat (1):
      mm/memblock: Use NULL instead of 0 for pointers


 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 4d9393c..82aa349 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -246,7 +246,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type,
 				min(new_area_start, memblock.current_limit),
 				new_alloc_size, PAGE_SIZE);
 
-		new_array = addr ? __va(addr) : 0;
+		new_array = addr ? __va(addr) : NULL;
 	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
