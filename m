Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0LLXqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35871 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0LLXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:08 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: eric.dumazet@gmail.com, mel@csn.ul.ie, cl@linux.com,
        lee.schermerhorn@hp.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [68/223] numa: fix slab_node(MPOL_BIND)
Message-Id: <20101212234606.93EEDB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 800416f799e0723635ac2d720ad4449917a1481c upstream.

When a node contains only HighMem memory, slab_node(MPOL_BIND)
dereferences a NULL pointer.

[ This code seems to go back all the way to commit 19770b32609b: "mm:
  filter based on a nodemask as well as a gfp_mask".  Which was back in
  April 2008, and it got merged into 2.6.26.  - Linus ]

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/mempolicy.c
===================================================================
--- linux.orig/mm/mempolicy.c
+++ linux/mm/mempolicy.c
@@ -1576,7 +1576,7 @@ unsigned slab_node(struct mempolicy *pol
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone->node;
+		return zone ? zone->node : numa_node_id();
 	}
 
 	default:
