Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0EXNyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 09:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab0EXNyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 09:54:46 -0400
Date: Mon, 24 May 2010 09:54:44 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, d.hatayama@jp.fujitsu.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100524134942.5765.4089.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: Fix userspace warnings in elfcore.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compile warning:

/home/rhel6/usr/include/linux/elfcore.h:104: userspace cannot call function or variable defined in the kernel
/home/rhel6/usr/include/linux/elfcore.h:105: userspace cannot call function or variable defined in the kernel
/home/rhel6/usr/include/linux/elfcore.h:108: userspace cannot call function or variable defined in the kernel
/home/rhel6/usr/include/linux/elfcore.h:110: userspace cannot call function or variable defined in the kernel

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index e687bc3..26f7486 100644
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
@@ -167,5 +165,6 @@ elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
 extern size_t elf_core_extra_data_size(void);
+#endif /* __KERNEL__ */
 
 #endif /* _LINUX_ELFCORE_H */
