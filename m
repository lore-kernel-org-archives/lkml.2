Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HRTBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:01:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44237 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1HRTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:01:50 -0400
Date: Thu, 18 Aug 2011 20:01:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 17/91] um: get rid of kern_constants.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7qf-0007Xq-8a@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                   |   11 +----------
 arch/um/include/shared/as-layout.h |    2 +-
 arch/um/include/shared/task.h      |    2 +-
 arch/um/include/shared/um_malloc.h |    2 +-
 arch/um/include/shared/user.h      |    2 +-
 5 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 3aded4e..649aebc 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -25,9 +25,6 @@ include $(srctree)/$(ARCH_DIR)/Makefile-skas
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
 ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
-ifneq ($(KBUILD_SRC),)
-ARCH_INCLUDE	+= -I$(SHARED_HEADERS)
-endif
 KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 
 # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
@@ -87,7 +84,6 @@ endef
 KBUILD_KCONFIG := arch/um/Kconfig.$(HEADER_ARCH)
 
 archprepare: include/generated/user_constants.h
-archprepare: $(SHARED_HEADERS)/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib
@@ -118,8 +114,7 @@ endef
 
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
-CLEAN_FILES += linux x.i gmon.out \
-	$(SHARED_HEADERS)/kern_constants.h
+CLEAN_FILES += linux x.i gmon.out
 
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
@@ -146,8 +141,4 @@ endef
 include/generated/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
-$(SHARED_HEADERS)/kern_constants.h:
-	$(Q)mkdir -p $(dir $@)
-	$(Q)echo '#include <generated/asm-offsets.h>' >$@
-
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
diff --git a/arch/um/include/shared/as-layout.h b/arch/um/include/shared/as-layout.h
index a92b678..896e166 100644
--- a/arch/um/include/shared/as-layout.h
+++ b/arch/um/include/shared/as-layout.h
@@ -6,7 +6,7 @@
 #ifndef __START_H__
 #define __START_H__
 
-#include "kern_constants.h"
+#include <generated/asm-offsets.h>
 
 /*
  * Stolen from linux/const.h, which can't be directly included since
diff --git a/arch/um/include/shared/task.h b/arch/um/include/shared/task.h
index 3fe726b..3db6b58 100644
--- a/arch/um/include/shared/task.h
+++ b/arch/um/include/shared/task.h
@@ -1,7 +1,7 @@
 #ifndef __TASK_H
 #define __TASK_H
 
-#include <kern_constants.h>
+#include <generated/asm-offsets.h>
 
 #define TASK_REGS(task) ((struct uml_pt_regs *) &(((char *) (task))[HOST_TASK_REGS]))
 #define TASK_PID(task) *((int *) &(((char *) (task))[HOST_TASK_PID]))
diff --git a/arch/um/include/shared/um_malloc.h b/arch/um/include/shared/um_malloc.h
index c554d70..6395fef 100644
--- a/arch/um/include/shared/um_malloc.h
+++ b/arch/um/include/shared/um_malloc.h
@@ -6,7 +6,7 @@
 #ifndef __UM_MALLOC_H__
 #define __UM_MALLOC_H__
 
-#include "kern_constants.h"
+#include <generated/asm-offsets.h>
 
 extern void *uml_kmalloc(int size, int flags);
 extern void kfree(const void *ptr);
diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
index 293f7c7..2d46f63 100644
--- a/arch/um/include/shared/user.h
+++ b/arch/um/include/shared/user.h
@@ -6,7 +6,7 @@
 #ifndef __USER_H__
 #define __USER_H__
 
-#include "kern_constants.h"
+#include <generated/asm-offsets.h>
 
 /*
  * The usual definition - copied here because the kernel provides its own,
-- 
1.7.2.5


