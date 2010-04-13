Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0DMP2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:28:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39161 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab0DMP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GexRowe7oHYOSeJgCTbSZCAX7ITP89/+S7sbM77zRrbgrRtrzldBd1dp6oekAS362g
         AKZos8G6cUOXaE3HVhMC7iI0nfJnh9+gRJrBaH0WLj8OtrsuAGc9p6ND3Ltmpa1UW+0/
         Jfn/WYd96lDV8rkAHGbQJK297GpKLzBZxl15E=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 4/6] change alloc function in vmemmap_alloc_block
Date: Wed, 14 Apr 2010 00:25:01 +0900
Message-Id: <3108a367a27c55392904c3f046aa0b5420efe261.1271171877.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if node_state is N_HIGH_MEMORY, node doesn't have -1.
It means node's validity check is unnecessary.
So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/sparse-vmemmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 392b9bb..7710ebc 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -53,7 +53,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		struct page *page;
 
 		if (node_state(node, N_HIGH_MEMORY))
-			page = alloc_pages_node(node,
+			page = alloc_pages_exact_node(node,
 				GFP_KERNEL | __GFP_ZERO, get_order(size));
 		else
 			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-- 
1.7.0.5

