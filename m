Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1LUX5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:57:24 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50892 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab1LUX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:57:22 -0500
Date: Wed, 21 Dec 2011 15:57:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] radix_tree: expand comment on optimization
In-Reply-To: <20111221221527.GE23662@dastard>
Message-ID: <alpine.LSU.2.00.1112211555430.25868@eggly.anvils>
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils> <20111221050740.GD23662@dastard> <alpine.LSU.2.00.1112202218490.4026@eggly.anvils> <20111221221527.GE23662@dastard>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand comment on optimization in radix_tree_range_tag_if_tagged(),
along the lines proposed by Dave Chinner.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
And with -p2, this patch will also apply to the rtth tree.

 lib/radix-tree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- mmotm/lib/radix-tree.c	2011-12-16 20:40:26.152758485 -0800
+++ linux/lib/radix-tree.c	2011-12-21 14:57:20.073657540 -0800
@@ -703,7 +703,13 @@ unsigned long radix_tree_range_tag_if_ta
 			node = node->parent;
 		}
 
-		/* optimization: no need to walk up from this node again */
+		/*
+		 * Small optimization: now clear that node pointer.
+		 * Since all of this slot's ancestors now have the tag set
+		 * from setting it above, we have no further need to walk
+		 * back up the tree setting tags, until we update slot to
+		 * point to another radix_tree_node.
+		 */
 		node = NULL;
 
 next:
