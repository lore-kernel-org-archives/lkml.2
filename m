Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1DAOmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:42:25 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41763 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab1DAOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:42:23 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 01 Apr 2011 20:02:38 +0530
Message-Id: <20110401143238.15455.69361.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 2.6.39-rc1-tip 1/26]  1: mm: replace_page() loses static attribute
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


User bkpt will use background page replacement approach to insert/delete
breakpoints. Background page replacement approach is based on
replace_page. Hence replace_page() loses its static attribute.
This is a precursor to moving replace_page() to mm/memory.c

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 include/linux/mm.h |    2 ++
 mm/ksm.c           |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7606d7d..089bda4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1008,6 +1008,8 @@ void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
+int replace_page(struct vm_area_struct *vma, struct page *page,
+					struct page *kpage, pte_t orig_pte);
 
 /* Is the vma a continuation of the stack vma above it? */
 static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
diff --git a/mm/ksm.c b/mm/ksm.c
index 1bbe785..f444158 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -760,7 +760,7 @@ out:
  *
  * Returns 0 on success, -EFAULT on failure.
  */
-static int replace_page(struct vm_area_struct *vma, struct page *page,
+int replace_page(struct vm_area_struct *vma, struct page *page,
 			struct page *kpage, pte_t orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
