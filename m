Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0ENCFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:05:52 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:52248 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab0ENCFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:05:50 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] radix-tree: fix radix_tree_prev_hole underflow case
Date: Thu, 13 May 2010 23:05:24 -0300
Message-Id: <1273802724-3414-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radix_tree_prev_hole() used LONG_MAX to detect underflow; however,
ULONG_MAX is clearly what was intended, both here and by its only user
(count_history_pages at mm/readahead.c).

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 lib/radix-tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index b69031f..be40980 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -656,7 +656,7 @@ EXPORT_SYMBOL(radix_tree_next_hole);
  *
  *	Returns: the index of the hole if found, otherwise returns an index
  *	outside of the set specified (in which case 'index - return >= max_scan'
- *	will be true). In rare cases of wrap-around, LONG_MAX will be returned.
+ *	will be true). In rare cases of wrap-around, ULONG_MAX will be returned.
  *
  *	radix_tree_next_hole may be called under rcu_read_lock. However, like
  *	radix_tree_gang_lookup, this will not atomically search a snapshot of
@@ -674,7 +674,7 @@ unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
 		if (!radix_tree_lookup(root, index))
 			break;
 		index--;
-		if (index == LONG_MAX)
+		if (index == ULONG_MAX)
 			break;
 	}
 
-- 
1.6.6.1

