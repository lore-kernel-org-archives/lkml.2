Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HRTBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:01:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44223 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HRTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:01:19 -0400
Date: Thu, 18 Aug 2011 20:01:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 14/91] um: take user_constants.h to
 include/generated
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7qB-0007Vw-7r@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                               |    5 ++---
 arch/um/sys-i386/shared/sysdep/ptrace.h        |    2 +-
 arch/um/sys-i386/shared/sysdep/ptrace_user.h   |    2 +-
 arch/um/sys-i386/shared/sysdep/sc.h            |    2 +-
 arch/um/sys-x86_64/shared/sysdep/ptrace.h      |    2 +-
 arch/um/sys-x86_64/shared/sysdep/ptrace_user.h |    2 +-
 arch/um/sys-x86_64/shared/sysdep/sc.h          |    2 +-
 7 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index deb0553..3aded4e 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -86,7 +86,7 @@ endef
 
 KBUILD_KCONFIG := arch/um/Kconfig.$(HEADER_ARCH)
 
-archprepare: $(SHARED_HEADERS)/user_constants.h
+archprepare: include/generated/user_constants.h
 archprepare: $(SHARED_HEADERS)/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
@@ -119,7 +119,6 @@ endef
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
 CLEAN_FILES += linux x.i gmon.out \
-	$(SHARED_HEADERS)/user_constants.h \
 	$(SHARED_HEADERS)/kern_constants.h
 
 archclean:
@@ -144,7 +143,7 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
+include/generated/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
 $(SHARED_HEADERS)/kern_constants.h:
diff --git a/arch/um/sys-i386/shared/sysdep/ptrace.h b/arch/um/sys-i386/shared/sysdep/ptrace.h
index 06e03b8..e4c1593 100644
--- a/arch/um/sys-i386/shared/sysdep/ptrace.h
+++ b/arch/um/sys-i386/shared/sysdep/ptrace.h
@@ -6,7 +6,7 @@
 #ifndef __SYSDEP_I386_PTRACE_H
 #define __SYSDEP_I386_PTRACE_H
 
-#include "user_constants.h"
+#include <generated/user_constants.h>
 #include "sysdep/faultinfo.h"
 
 #define MAX_REG_NR (UM_FRAME_SIZE / sizeof(unsigned long))
diff --git a/arch/um/sys-i386/shared/sysdep/ptrace_user.h b/arch/um/sys-i386/shared/sysdep/ptrace_user.h
index ef56247..e4398a3 100644
--- a/arch/um/sys-i386/shared/sysdep/ptrace_user.h
+++ b/arch/um/sys-i386/shared/sysdep/ptrace_user.h
@@ -9,7 +9,7 @@
 #include <sys/ptrace.h>
 #include <linux/ptrace.h>
 #include <asm/ptrace.h>
-#include "user_constants.h"
+#include <generated/user_constants.h>
 
 #define PT_OFFSET(r) ((r) * sizeof(long))
 
diff --git a/arch/um/sys-i386/shared/sysdep/sc.h b/arch/um/sys-i386/shared/sysdep/sc.h
index c57d178..7b89240 100644
--- a/arch/um/sys-i386/shared/sysdep/sc.h
+++ b/arch/um/sys-i386/shared/sysdep/sc.h
@@ -1,7 +1,7 @@
 #ifndef __SYSDEP_I386_SC_H
 #define __SYSDEP_I386_SC_H
 
-#include <user_constants.h>
+#include <generated/user_constants.h>
 
 #define SC_OFFSET(sc, field) \
 	*((unsigned long *) &(((char *) (sc))[HOST_##field]))
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace.h b/arch/um/sys-x86_64/shared/sysdep/ptrace.h
index 096547b..8d06d0a 100644
--- a/arch/um/sys-x86_64/shared/sysdep/ptrace.h
+++ b/arch/um/sys-x86_64/shared/sysdep/ptrace.h
@@ -8,7 +8,7 @@
 #ifndef __SYSDEP_X86_64_PTRACE_H
 #define __SYSDEP_X86_64_PTRACE_H
 
-#include "user_constants.h"
+#include <generated/user_constants.h>
 #include "sysdep/faultinfo.h"
 
 #define MAX_REG_OFFSET (UM_FRAME_SIZE)
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h b/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
index 4dbccdb..faf9cdd 100644
--- a/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
+++ b/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
@@ -12,7 +12,7 @@
 #include <linux/ptrace.h>
 #include <asm/ptrace.h>
 #undef __FRAME_OFFSETS
-#include "user_constants.h"
+#include <generated/user_constants.h>
 
 #define PT_INDEX(off) ((off) / sizeof(unsigned long))
 
diff --git a/arch/um/sys-x86_64/shared/sysdep/sc.h b/arch/um/sys-x86_64/shared/sysdep/sc.h
index 8aee45b..20313a2 100644
--- a/arch/um/sys-x86_64/shared/sysdep/sc.h
+++ b/arch/um/sys-x86_64/shared/sysdep/sc.h
@@ -5,7 +5,7 @@
  * Released under the GPL
  */
 
-#include <user_constants.h>
+#include <generated/user_constants.h>
 
 #define SC_OFFSET(sc, field) \
 	 *((unsigned long *) &(((char *) (sc))[HOST_##field]))
-- 
1.7.2.5


