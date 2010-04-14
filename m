Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0DNPAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:00:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47021 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab0DNPAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RTc8w3N/drc6acrIZtR3GooDqiEABif9NU65Vo4Dv5pwVipJ/M1GlrBT084sCN7V3R
         Ngobkt4zRaiCLy50PBtFytrrVCM4rca4FlcpfA9injdMxT4FG9lgaWxpqRtNKY5EsNwS
         49TRd03Ojg9oMxri62ZmlUm+QQyatBDs2gXZw=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2] Add comment in alloc_pages_exact_node
Date: Wed, 14 Apr 2010 23:58:39 +0900
Message-Id: <1271257119-30117-6-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
References: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2
 o modify comment by suggestion. (Thanks to Mel)

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
 include/linux/gfp.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b65f003..56b5fe6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -288,6 +288,12 @@ static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
+/*
+ * Use this instead of alloc_pages_node when the caller knows
+ * exactly which node they need (as opposed to passing in -1
+ * for current). Fallback to other nodes will still occur
+ * unless __GFP_THISNODE is specified.
+ */
 static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-- 
1.7.0.5

