Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1ETGXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:23:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34811 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1ETGXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:23:51 -0400
Date: Fri, 20 May 2011 16:23:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110520162347.6c780d3b.sfr@canb.auug.org.au>
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

mm/prio_tree.c: In function 'vma_prio_tree_next':
mm/prio_tree.c:178: error: implicit declaration of function 'prefetch'

Caused by commit e66eed651fd1 ("list: remove prefetching from regular list
iterators").

I added this patch  for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 May 2011 16:19:57 +1000
Subject: [PATCH] mm: include prefetch.h

Commit e66eed651fd1 ("list: remove prefetching from regular list
iterators") removed the include of prefetch.h from list.h, so include
it explicitly.

Fixes thids build error on sparc32:

mm/prio_tree.c: In function 'vma_prio_tree_next':
mm/prio_tree.c:178: error: implicit declaration of function 'prefetch'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/prio_tree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/prio_tree.c b/mm/prio_tree.c
index 603ae98..799dcfd 100644
--- a/mm/prio_tree.c
+++ b/mm/prio_tree.c
@@ -13,6 +13,7 @@
 
 #include <linux/mm.h>
 #include <linux/prio_tree.h>
+#include <linux/prefetch.h>
 
 /*
  * See lib/prio_tree.c for details on the general radix priority search tree
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
