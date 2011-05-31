Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1EaAtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:49:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1EaAty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WjjM880Hvf4cvVgaS2ubyr3fwxjf6zCPg3SxSOFG8OTZrZJOVsQ1XARswqF3rR58Nk
         sWr3FLOVaZOMSCyWV1KA==
Date: Mon, 30 May 2011 17:49:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 10/14] mm: truncate functions are in truncate.c
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301748150.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
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

--- linux.orig/include/linux/mm.h	2011-05-30 13:56:10.444798255 -0700
+++ linux/include/linux/mm.h	2011-05-30 14:43:05.642758070 -0700
@@ -1445,8 +1445,7 @@ extern int do_munmap(struct mm_struct *,
 
 extern unsigned long do_brk(unsigned long, unsigned long);
 
-/* filemap.c */
-extern unsigned long page_unuse(struct page *);
+/* truncate.c */
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
