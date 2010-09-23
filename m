Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0IWGwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:23 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:37760
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087Ab0IWGwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:21 -0400
From: matt mooney <mfm@muteddisk.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 16/20] um: change to new flag variables
Date: Wed, 22 Sep 2010 23:51:31 -0700
Message-Id: <1285224691-30001-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/um/sys-ppc/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/sys-ppc/Makefile b/arch/um/sys-ppc/Makefile
index b8bc844..20d363b 100644
--- a/arch/um/sys-ppc/Makefile
+++ b/arch/um/sys-ppc/Makefile
@@ -6,7 +6,7 @@ OBJ = built-in.o
 OBJS = ptrace.o sigcontext.o checksum.o miscthings.o misc.o \
 	ptrace_user.o sysrq.o
 
-EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(srctree)/arch/ppc/kernel
+asflags-y := -DCONFIG_PPC32 -I. -I$(srctree)/arch/ppc/kernel
 
 all: $(OBJ)
 
@@ -15,10 +15,10 @@ $(OBJ): $(OBJS)
 	$(LD) $(LINKFLAGS) --start-group $^ --end-group -o $@
 
 ptrace_user.o: ptrace_user.c
-	$(CC) -D__KERNEL__ $(USER_CFLAGS) $(EXTRA_CFLAGS) -c -o $@ $<
+	$(CC) -D__KERNEL__ $(USER_CFLAGS) $(ccflags-y) -c -o $@ $<
 
 sigcontext.o: sigcontext.c
-	$(CC) $(USER_CFLAGS) $(EXTRA_CFLAGS) -c -o $@ $<
+	$(CC) $(USER_CFLAGS) $(ccflags-y) -c -o $@ $<
 
 checksum.S:
 	rm -f $@
@@ -53,13 +53,13 @@ ppc_defs.h: mk_defs.c ppc_defs.head \
 checksum.o: checksum.S
 	rm -f asm
 	ln -s $(srctree)/include/asm-ppc asm
-	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
+	$(CC) $(asflags-y) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
 misc.o: misc.S ppc_defs.h
 	rm -f asm
 	ln -s $(srctree)/include/asm-ppc asm
-	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
+	$(CC) $(asflags-y) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
 clean-files := $(OBJS) ppc_defs.h checksum.S mk_defs.c
-- 
1.7.2.1

