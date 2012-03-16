Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2CPRXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:23:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35806 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2CPRX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:23:28 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] TRIVIAL: mmap.c: fix comment for __insert_vm_struct()
Date: Fri, 16 Mar 2012 13:23:10 -0400
Message-Id: <1331918590-2786-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above __insert_vm_struct seems to suggest that this
function is also going to link the VMA with the anon_vma, but
this is not true.
This function only links the VMA to the mm->mm_rb tree and the mm->mmap linked
list.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index da15a79..6328a36 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -452,8 +452,8 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 
 /*
  * Helper for vma_adjust in the split_vma insert case:
- * insert vm structure into list and rbtree and anon_vma,
- * but it has already been inserted into prio_tree earlier.
+ * insert vm structure into list and rbtree, but it has
+ * already been inserted into prio_tree earlier.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-- 
1.7.5.4

