Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2IEGg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:36:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55928 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2IEGgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:36:55 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 14:36:54 +0800
Message-ID: <CAPgLHd-3Uwj1Uf31xqPO8LyYT0DS2Tcb1fa5KTYXdATEOHT9qw@mail.gmail.com>
Subject: [PATCH] mm: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 mm/rmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0f3b7cd..6333654 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -307,8 +307,7 @@ void anon_vma_moveto_tail(struct vm_area_struct *dst)
 		struct anon_vma *anon_vma = pavc->anon_vma;
 		VM_BUG_ON(pavc->vma != dst);
 		root = lock_anon_vma_root(root, anon_vma);
-		list_del(&pavc->same_anon_vma);
-		list_add_tail(&pavc->same_anon_vma, &anon_vma->head);
+		list_move_tail(&pavc->same_anon_vma, &anon_vma->head);
 	}
 	unlock_anon_vma_root(root);
 }


