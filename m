Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0LIJds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:33:48 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53617 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab0LIJdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:33:44 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 004/211] unicore32: new file arch/unicore32/Makefile
Date: Thu, 9 Dec 2010 17:33:41 +0800
Message-ID: <01d201cb9784$2ad85910$80890b30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhCgrazqO0GWZThO2j58W/f3C3A==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	Global Makefile for UniCore32 architecture

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/Makefile |  151
+++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 151 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
new file mode 100644
index 0000000..36eb5f7
--- /dev/null
+++ b/arch/unicore32/Makefile
@@ -0,0 +1,151 @@
+#
+# arch/unicore32/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General
Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2002~2010 by Guan Xue-tao
+LOCALVERSION	:= -uc32
+
+CROSS_COMPILE	:=
/usr/unicore/gnu-toolchain-unicore/uc4/bin/unicore32-linux-
+
+INSTALL_MOD_PATH := $(obj)/usr
+
+LDFLAGS_vmlinux	:=-p --no-undefined -X
+
+OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
+GZFLAGS		:=-9
+#KBUILD_CFLAGS	+=-pipe
+# Explicitly specifiy 32-bit UniCore ISA:
+KBUILD_CFLAGS	+=$(call cc-option,-municore,)
+
+# Never generate .eh_frame
+KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
+
+ifeq ($(CONFIG_FRAME_POINTER),y)
+KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mno-sched-prolog
+endif
+
+KBUILD_CPPFLAGS	+= -mlittle-endian
+AS		+= -EL
+LD		+= -EL
+
+comma = ,
+
+# Need -Uunicore32 for gcc < 3.x
+# delete -mstructure-size-boundary=32, and default being 8
+# delete -funsigned-char, and default being signed-char
+KBUILD_CFLAGS	+=$(call cc-option,-mshort-load-bytes,$(call
cc-option,-malignment-traps,)) -msoft-float -Uunicore32
+KBUILD_AFLAGS	+=-msoft-float
+
+CHECKFLAGS	+= -D__unicore32__
+
+#Default value
+head-y		:= arch/unicore32/kernel/head.o
arch/unicore32/kernel/init_task.o
+textofs-y	:= 0x00408000
+
+# The byte offset of the kernel image in RAM from the start of RAM.
+TEXT_OFFSET := $(textofs-y)
+
+export	TEXT_OFFSET GZFLAGS
+
+core-y				+= arch/unicore32/kernel/ arch/unicore32/mm/
+core-$(CONFIG_UNICORE_FPU_F64)	+= arch/unicore32/uc-f64/
+
+drivers-$(CONFIG_ARCH_PUV3)	+= drivers/staging/puv3/
+
+libs-y				+= arch/unicore32/lib/
+libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS)
-print-file-name=libc.a)
+libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS)
-print-file-name=libgcc.a)
+
+# Default target when executing plain make
+KBUILD_IMAGE := zImage
+
+all:	$(KBUILD_IMAGE)
+
+boot := arch/unicore32/boot
+
+ASM_GENERIC_HEADERS	:= arch/unicore32/include/asm/atomic.h
\
+			   arch/unicore32/include/asm/bitsperlong.h
\
+			   arch/unicore32/include/asm/bug.h
\
+			   arch/unicore32/include/asm/bugs.h
\
+			   arch/unicore32/include/asm/cputime.h
\
+			   arch/unicore32/include/asm/current.h
\
+			   arch/unicore32/include/asm/device.h
\
+			   arch/unicore32/include/asm/emergency-restart.h
\
+			   arch/unicore32/include/asm/errno.h
\
+			   arch/unicore32/include/asm/fb.h
\
+			   arch/unicore32/include/asm/fcntl.h
\
+			   arch/unicore32/include/asm/hardirq.h
\
+			   arch/unicore32/include/asm/hw_irq.h
\
+			   arch/unicore32/include/asm/ioctl.h
\
+			   arch/unicore32/include/asm/ioctls.h
\
+			   arch/unicore32/include/asm/ipcbuf.h
\
+			   arch/unicore32/include/asm/irq_regs.h
\
+			   arch/unicore32/include/asm/kdebug.h
\
+			   arch/unicore32/include/asm/kmap_types.h
\
+			   arch/unicore32/include/asm/local.h
\
+			   arch/unicore32/include/asm/mman.h
\
+			   arch/unicore32/include/asm/module.h
\
+			   arch/unicore32/include/asm/msgbuf.h
\
+			   arch/unicore32/include/asm/param.h
\
+			   arch/unicore32/include/asm/parport.h
\
+			   arch/unicore32/include/asm/percpu.h
\
+			   arch/unicore32/include/asm/poll.h
\
+			   arch/unicore32/include/asm/posix_types.h
\
+			   arch/unicore32/include/asm/resource.h
\
+			   arch/unicore32/include/asm/scatterlist.h
\
+			   arch/unicore32/include/asm/sections.h
\
+			   arch/unicore32/include/asm/sembuf.h
\
+			   arch/unicore32/include/asm/serial.h
\
+			   arch/unicore32/include/asm/shmbuf.h
\
+			   arch/unicore32/include/asm/shmparam.h
\
+			   arch/unicore32/include/asm/siginfo.h
\
+			   arch/unicore32/include/asm/signal.h
\
+			   arch/unicore32/include/asm/socket.h
\
+			   arch/unicore32/include/asm/sockios.h
\
+			   arch/unicore32/include/asm/statfs.h
\
+			   arch/unicore32/include/asm/termbits.h
\
+			   arch/unicore32/include/asm/termios.h
\
+			   arch/unicore32/include/asm/topology.h
\
+			   arch/unicore32/include/asm/types.h
\
+			   arch/unicore32/include/asm/ucontext.h
\
+			   arch/unicore32/include/asm/unaligned.h
\
+			   arch/unicore32/include/asm/vga.h
\
+			   arch/unicore32/include/asm/xor.h
+
+%.h:
+	$(Q)echo '#include <asm-generic/$(notdir $@)>' > $@
+
+archprepare: $(ASM_GENERIC_HEADERS)
+
+# Convert bzImage to zImage
+bzImage: zImage
+
+zImage Image uImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
+zinstall install: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
+
+CLEAN_DIRS += $(INSTALL_MOD_PATH)/lib
+CLEAN_FILES += $(ASM_GENERIC_HEADERS)
+
+# We use MRPROPER_FILES and CLEAN_FILES now
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+define archhelp
+  echo  '* zImage        - Compressed kernel image
(arch/$(ARCH)/boot/zImage)'
+  echo  '  Image         - Uncompressed kernel image
(arch/$(ARCH)/boot/Image)'
+  echo  '  uImage        - U-Boot wrapped zImage'
+  echo  '  install       - Install uncompressed kernel'
+  echo  '  zinstall      - Install compressed kernel'
+  echo  '                  Install using (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
+  echo  '                  install to $$(INSTALL_PATH) and run lilo'
+endef

