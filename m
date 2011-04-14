Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab1DNRrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:38549 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab1DNRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 035/209] numa: fix slab_node(MPOL_BIND)
Date: Thu, 14 Apr 2011 13:41:05 -0400
Message-Id: <1302803039-9400-36-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 08f40a2..c7f53b12 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1509,7 +1509,7 @@ unsigned slab_node(struct mempolicy *policy)
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone->node;
+		return zone ? zone->node : numa_node_id();
 	}
 
 	default:
-- 
1.7.4.4

