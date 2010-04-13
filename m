Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0DMP3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:29:18 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45531 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0DMP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HaAkVEyCuZtcfk74Urf7yOWx/FoLVcgz76OfZBdk5tOMIGdG2daoRuWGkyZNNgnm90
         tDK0iQr5k35TxJtf9M5L58coqIEpfGiaD9Ned4dXy448zEb5lMiznOnsZmcscorYaE+7
         K9Hu6E7DZG0eV1h2Q2qtom1cgYBIJr+Smx0WQ=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 6/6] Add comment in alloc_pages_exact_node
Date: Wed, 14 Apr 2010 00:25:03 +0900
Message-Id: <d74305233536342dfeb1ca7ffe9e83495ce1f285.1271171877.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pages_exact_node naming makes some people misleading.
They considered it following as.
"This function will allocate pages from node which I wanted
exactly".
But it can allocate pages from fallback list if page allocator
can't find free page from node user wanted.

So let's comment this NOTE.

Actually I wanted to change naming with better.
ex) alloc_pages_explict_node.
But I changed my mind since the comment would be enough.

If anybody suggests better name, I will do with pleasure.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/gfp.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b65f003..7539c17 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -288,6 +288,11 @@ static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
+/*
+ * NOTE : Allow page from fallback if page allocator can't find free page
+ * in your nid. Only if you want to allocate page from your nid, use
+ * __GFP_THISNODE flags with gfp_mask.
+ */
 static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-- 
1.7.0.5

