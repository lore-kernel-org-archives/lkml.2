Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab1ETG2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:28:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33009 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab1ETG16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:27:58 -0400
Date: Fri, 20 May 2011 16:27:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110520162756.0ebc8d37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

mm/slab.c: In function '__cache_alloc':
mm/slab.c:3493: error: implicit declaration of function 'prefetchw'

Applied this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 May 2011 16:24:17 +1000
Subject: [PATCH] mm: include prefetch.h

Commit e66eed651fd1 ("list: remove prefetching from regular list
iterators") removed the include of prefetch.h from list.h, so include
it explicitly.

Fixes this build error on sparc32:

mm/slab.c: In function '__cache_alloc':
mm/slab.c:3493: error: implicit declaration of function 'prefetchw'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/slab.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 46a9c16..bcfa498 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -115,6 +115,7 @@
 #include	<linux/debugobjects.h>
 #include	<linux/kmemcheck.h>
 #include	<linux/memory.h>
+#include	<linux/prefetch.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
-- 
1.7.5.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
