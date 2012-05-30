Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2E3GrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:47:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57232 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2E3GrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:47:04 -0400
From: Huang Shijie <shijie8@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] fork: use vma_pages() to simplify the code
Date: Wed, 30 May 2012 14:50:51 -0400
Message-Id: <1338403851-4119-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code can be replaced by vma_pages().
So use it to simplify the code.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3417e1b..3decf6d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -386,7 +386,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len;
-			len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			len = vma_pages(mpnt);
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
-- 
1.7.4.4

