Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1B1XsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:07 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55221 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1B1XsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	S+7bd6qcYwAAEkjQYtvqGzfBSMVrpRjHxCiKLU1fN66eO/U11jFomnQt5Il1n8J6
	5xsUfS1aHjkdNnuxrG/XiWj8WF1w+avnTpxoj6Tnl7n2ghjrG/qGADcbQUxBZlAJ
	MaOEakkegtDe7mKFjpZ1e5XL1hvPa3zqYxhG4jrxT00=
From: ntl@pobox.com
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Oren Laadan <orenl@cs.columbia.edu>,
        Nathan Lynch <ntl@pobox.com>
Subject: [PATCH 01/10] Make exec_mmap extern
Date: Mon, 28 Feb 2011 17:40:23 -0600
Message-Id: <1298936432-29607-2-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298936432-29607-1-git-send-email-ntl@pobox.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: 56FE9754-4394-11E0-A95C-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Restoration of process state from a checkpoint image is similar to
exec in that the calling task's mm is replaced.  Make exec_mmap
available for this purpose.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
[ntl: extracted from Oren's "c/r: dump memory address space (private memory)"]
Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 fs/exec.c          |    2 +-
 include/linux/mm.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c62efcb..9d8c27a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -767,7 +767,7 @@ int kernel_read(struct file *file, loff_t offset,
 
 EXPORT_SYMBOL(kernel_read);
 
-static int exec_mmap(struct mm_struct *mm)
+int exec_mmap(struct mm_struct *mm)
 {
 	struct task_struct *tsk;
 	struct mm_struct * old_mm, *active_mm;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 721f451..5397237 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1321,6 +1321,9 @@ extern int do_munmap(struct mm_struct *, unsigned long, size_t);
 
 extern unsigned long do_brk(unsigned long, unsigned long);
 
+/* fs/exec.c */
+extern int exec_mmap(struct mm_struct *mm);
+
 /* filemap.c */
 extern unsigned long page_unuse(struct page *);
 extern void truncate_inode_pages(struct address_space *, loff_t);
-- 
1.7.4

