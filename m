Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0LHAqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:47 -0500
Received: from kroah.org ([198.145.64.141]:45924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab0LHAqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:46 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:26 2010
Message-Id: <20101208004426.395756365@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [020/127] numa: fix slab_node(MPOL_BIND)
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1482,7 +1482,7 @@ unsigned slab_node(struct mempolicy *pol
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone->node;
+		return zone ? zone->node : numa_node_id();
 	}
 
 	default:


