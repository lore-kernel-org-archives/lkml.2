Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0LIUGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:06:12 -0500
Received: from mail.perches.com ([173.55.12.10]:2427 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083Ab0LIUEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:16 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>, linux-mm@kvack.org
Subject: [PATCH 14/15] mm: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:07 -0800
Message-Id: <6f83d6103080eb248402114b60f6cf30c0f54db8.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index eb5cc7d..31dcb64 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -748,7 +748,7 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
 					node, gfp_mask);
-	if (unlikely(IS_ERR(va))) {
+	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
 	}
-- 
1.7.3.3.464.gf80b6

