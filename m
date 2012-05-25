Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2EYMhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:37:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2EYMhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:37:22 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: remove repeat implementation of page_referenced
Date: Fri, 25 May 2012 20:37:10 +0800
Message-Id: <1337949430-24626-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

page_referenced function just called from mm/vmscan.c to handle paging
out.It is realized in mm/rmap.c and has an interface exported in rmap.h.

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 include/linux/rmap.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index fd07c45..ee0c005 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -234,14 +234,6 @@ int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
 #define anon_vma_prepare(vma)	(0)
 #define anon_vma_link(vma)	do {} while (0)
 
-static inline int page_referenced(struct page *page, int is_locked,
-				  struct mem_cgroup *memcg,
-				  unsigned long *vm_flags)
-{
-	*vm_flags = 0;
-	return 0;
-}
-
 #define try_to_unmap(page, refs) SWAP_FAIL
 
 static inline int page_mkclean(struct page *page)
-- 
1.7.9.5

