Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1EZLik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:38:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:57288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371Ab1EZLh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:37:59 -0400
From: GuanXuetao <gxt@mprc.pku.edu.cn>
To: arnd@arndb.de
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6/6] unicore32: using generic-y format for one line asm-generic files
Date: Thu, 26 May 2011 11:36:58 +0000
Message-Id: <48ec206f634cad2019c92eef7ba1a87566c743fe.1306408804.git.gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 11:37:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

see commit from Sam Ravnborg <d8ecc5cd8e227bc318513b5306ae88a474b8886d>
  kbuild: asm-generic support

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Makefile           |   35 ----------------------
 arch/unicore32/include/asm/Kbuild |   59 +++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
index 6555abb..6af4bc4 100644
--- a/arch/unicore32/Makefile
+++ b/arch/unicore32/Makefile
@@ -40,39 +40,6 @@ core-y			+= arch/unicore32/mm/
 
 libs-y			+= arch/unicore32/lib/
 
-ASM_GENERATED_DIR	:= $(srctree)/arch/unicore32/include/generated
-LINUXINCLUDE		+= -I$(ASM_GENERATED_DIR)
-
-ASM_GENERIC_HEADERS	:= atomic.h auxvec.h
-ASM_GENERIC_HEADERS	+= bitsperlong.h bug.h bugs.h
-ASM_GENERIC_HEADERS	+= cputime.h current.h
-ASM_GENERIC_HEADERS	+= device.h div64.h
-ASM_GENERIC_HEADERS	+= emergency-restart.h errno.h
-ASM_GENERIC_HEADERS	+= fb.h fcntl.h ftrace.h futex.h
-ASM_GENERIC_HEADERS	+= hardirq.h hw_irq.h
-ASM_GENERIC_HEADERS	+= ioctl.h ioctls.h ipcbuf.h irq_regs.h
-ASM_GENERIC_HEADERS	+= kdebug.h kmap_types.h
-ASM_GENERIC_HEADERS	+= local.h
-ASM_GENERIC_HEADERS	+= mman.h module.h msgbuf.h
-ASM_GENERIC_HEADERS	+= param.h parport.h percpu.h poll.h posix_types.h
-ASM_GENERIC_HEADERS	+= resource.h
-ASM_GENERIC_HEADERS	+= scatterlist.h sections.h segment.h sembuf.h serial.h
-ASM_GENERIC_HEADERS	+= setup.h shmbuf.h shmparam.h
-ASM_GENERIC_HEADERS	+= siginfo.h signal.h sizes.h
-ASM_GENERIC_HEADERS	+= socket.h sockios.h stat.h statfs.h swab.h syscalls.h
-ASM_GENERIC_HEADERS	+= termbits.h termios.h topology.h types.h
-ASM_GENERIC_HEADERS	+= ucontext.h unaligned.h user.h
-ASM_GENERIC_HEADERS	+= vga.h
-ASM_GENERIC_HEADERS	+= xor.h
-
-archprepare:
-ifneq ($(ASM_GENERATED_DIR), $(wildcard $(ASM_GENERATED_DIR)))
-	$(Q)mkdir -p $(ASM_GENERATED_DIR)/asm
-	$(Q)$(foreach a, $(ASM_GENERIC_HEADERS),	\
-		echo '#include <asm-generic/$a>'	\
-			> $(ASM_GENERATED_DIR)/asm/$a; )
-endif
-
 boot			:= arch/unicore32/boot
 
 # Default defconfig and target when executing plain make
@@ -84,8 +51,6 @@ all:	$(KBUILD_IMAGE)
 zImage Image uImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-MRPROPER_DIRS		+= $(ASM_GENERATED_DIR)
-
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index b200fda..ca113d6 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -1,2 +1,61 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += atomic.h
+generic-y += auxvec.h
+generic-y += bitsperlong.h
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fb.h
+generic-y += fcntl.h
+generic-y += ftrace.h
+generic-y += futex.h
+generic-y += hardirq.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += module.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += parport.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += segment.h
+generic-y += sembuf.h
+generic-y += serial.h
+generic-y += setup.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += signal.h
+generic-y += sizes.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += stat.h
+generic-y += statfs.h
+generic-y += swab.h
+generic-y += syscalls.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += unaligned.h
+generic-y += user.h
+generic-y += vga.h
+generic-y += xor.h
-- 
1.7.5.2

