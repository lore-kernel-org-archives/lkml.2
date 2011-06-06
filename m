Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1FFEhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:37:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1FFEg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DUn3tYFeutDYNhcKUXS92hm8DeCUxX44aCITFLMUB8goHl/pNG8RWXWNEcDyxSmtbC
         JmKgmfmV4zj+MXOV3kxA==
Date: Sun, 5 Jun 2011 21:36:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 10/14] mm: truncate functions are in truncate.c
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052135550.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct comment on truncate_inode_pages*() in linux/mm.h; and remove
declaration of page_unuse(), it didn't exist even in 2.2.26 or 2.4.0!

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/mm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux.orig/include/linux/mm.h	2011-06-05 17:16:33.313740660 -0700
+++ linux/include/linux/mm.h	2011-06-05 18:57:56.399905055 -0700
@@ -1445,8 +1445,7 @@ extern int do_munmap(struct mm_struct *,
 
 extern unsigned long do_brk(unsigned long, unsigned long);
 
-/* filemap.c */
-extern unsigned long page_unuse(struct page *);
+/* truncate.c */
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
