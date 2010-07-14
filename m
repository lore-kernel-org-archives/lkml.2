Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0GNSBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:01:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44136 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0GNSBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E9eJH9qDuusICjmLbEwtAwR6fwwszJctik0tmZ4bFC61opbWx5kTGypGq2oG4AMHjd
         ysMb9yXeE8ZvuUQeXO6Fhe+Euy6erKmynlPHiSYIFHJ0q8Uc8Nz3JnG2Swl2jpf23wLs
         VQLlqZJIbTObY6AWButuHNsIue9B/mBxek1z4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, John Kacur <jkacur@redhat.com>,
        Tejun Heo <tj@kernel.org>, Maxim Kuvyrkov <maxim@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] arch/m68knommu/kernel/process.c: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:01:13 +0400
Message-Id: <1279130473-10737-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/m68knommu/kernel/process.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 6aa6613..1096c0e 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -316,14 +316,14 @@ void dump(struct pt_regs *fp)
 		fp->d0, fp->d1, fp->d2, fp->d3);
 	printk(KERN_EMERG "d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",
 		fp->d4, fp->d5, fp->a0, fp->a1);
-	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %08x\n",
-		(unsigned int) rdusp(), (unsigned int) fp);
+	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %p\n",
+		(unsigned int) rdusp(), fp);
 
 	printk(KERN_EMERG "\nCODE:");
 	tp = ((unsigned char *) fp->pc) - 0x20;
 	for (sp = (unsigned long *) tp, i = 0; (i < 0x40);  i += 4) {
 		if ((i % 0x10) == 0)
-			printk(KERN_EMERG "%08x: ", (int) (tp + i));
+			printk(KERN_EMERG "%p: ", tp + i);
 		printk("%08x ", (int) *sp++);
 	}
 	printk(KERN_EMERG "\n");
@@ -332,7 +332,7 @@ void dump(struct pt_regs *fp)
 	tp = ((unsigned char *) fp) - 0x40;
 	for (sp = (unsigned long *) tp, i = 0; (i < 0xc0); i += 4) {
 		if ((i % 0x10) == 0)
-			printk(KERN_EMERG "%08x: ", (int) (tp + i));
+			printk(KERN_EMERG "%p: ", tp + i);
 		printk("%08x ", (int) *sp++);
 	}
 	printk(KERN_EMERG "\n");
@@ -341,7 +341,7 @@ void dump(struct pt_regs *fp)
 	tp = (unsigned char *) (rdusp() - 0x10);
 	for (sp = (unsigned long *) tp, i = 0; (i < 0x80); i += 4) {
 		if ((i % 0x10) == 0)
-			printk(KERN_EMERG "%08x: ", (int) (tp + i));
+			printk(KERN_EMERG "%p: ", tp + i);
 		printk("%08x ", (int) *sp++);
 	}
 	printk(KERN_EMERG "\n");
-- 
1.7.0.4

