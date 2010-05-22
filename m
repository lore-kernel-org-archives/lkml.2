Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0EVDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 23:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab0EVDQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 23:16:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/elfcore.h: hide kernel functions
X-Fcc: ~/Mail/linus
X-Zippy-Says: An Italian is COMBING his hair in suburban DES MOINES!
Message-Id: <20100522031650.D564B49A4D@magilla.sf.frob.com>
Date: Fri, 21 May 2010 20:16:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The declarations for elf_core_extra_phdrs() et al got added on the
wrong side of #ifdef __KERNEL__ in linux/elfcore.h so they leak into
the user header copy and we get a warning at build time about it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/elfcore.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index e687bc3..394a3e0 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -150,8 +150,6 @@ static inline int elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregse
 }
 #endif
 
-#endif /* __KERNEL__ */
-
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
@@ -168,4 +166,6 @@ extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
 extern size_t elf_core_extra_data_size(void);
 
+#endif /* __KERNEL__ */
+
 #endif /* _LINUX_ELFCORE_H */
