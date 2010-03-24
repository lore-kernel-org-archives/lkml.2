Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0CXRCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:02:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab0CXRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:02:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FDPIC: For-loop in elf_core_vma_data_size() is incorrect
To: torvalds@osdl.org, akpm@linux-foundation.org, d.hatayama@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 24 Mar 2010 17:02:28 +0000
Message-ID: <20100324170228.10633.81950.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an incorrect for-loop in elf_core_vma_data_size().  The advance-pointer
statement lacks an assignment:

	  CC      fs/binfmt_elf_fdpic.o
	fs/binfmt_elf_fdpic.c: In function 'elf_core_vma_data_size':
	fs/binfmt_elf_fdpic.c:1593: warning: statement with no effect

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 2c32d00..7ab23e0 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1590,7 +1590,7 @@ static size_t elf_core_vma_data_size(unsigned long mm_flags)
 	struct vm_area_struct *vma;
 	size_t size = 0;
 
-	for (vma = current->mm->mmap; vma; vma->vm_next)
+	for (vma = current->mm->mmap; vma; vma = vma->vm_next)
 		if (maydump(vma, mm_flags))
 			size += vma->vm_end - vma->vm_start;
 	return size;

