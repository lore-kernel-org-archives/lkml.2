Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HRTFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:05:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44345 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1HRTFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:05:50 -0400
Date: Thu, 18 Aug 2011 20:05:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 41/91] um: merge skas_ptrace.h 32/64bit variants
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7uX-0007kB-JX@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-x86/shared/sysdep/skas_ptrace.h    |   25 ++++++++++++++++++++---
 arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h |   22 ---------------------
 arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h |   22 ---------------------
 3 files changed, 21 insertions(+), 48 deletions(-)
 delete mode 100644 arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h

diff --git a/arch/um/sys-x86/shared/sysdep/skas_ptrace.h b/arch/um/sys-x86/shared/sysdep/skas_ptrace.h
index e63b575..453febe 100644
--- a/arch/um/sys-x86/shared/sysdep/skas_ptrace.h
+++ b/arch/um/sys-x86/shared/sysdep/skas_ptrace.h
@@ -1,5 +1,22 @@
-#ifdef __i386__
-#include "skas_ptrace_32.h"
-#else
-#include "skas_ptrace_64.h"
+/*
+ * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __SYSDEP_X86_SKAS_PTRACE_H
+#define __SYSDEP_X86_SKAS_PTRACE_H
+
+struct ptrace_faultinfo {
+        int is_write;
+        unsigned long addr;
+};
+
+struct ptrace_ldt {
+        int func;
+        void *ptr;
+        unsigned long bytecount;
+};
+
+#define PTRACE_LDT 54
+
 #endif
diff --git a/arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h b/arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h
deleted file mode 100644
index e27b8a7..0000000
--- a/arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SYSDEP_I386_SKAS_PTRACE_H
-#define __SYSDEP_I386_SKAS_PTRACE_H
-
-struct ptrace_faultinfo {
-        int is_write;
-        unsigned long addr;
-};
-
-struct ptrace_ldt {
-        int func;
-        void *ptr;
-        unsigned long bytecount;
-};
-
-#define PTRACE_LDT 54
-
-#endif
diff --git a/arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h b/arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h
deleted file mode 100644
index 95db4be7..0000000
--- a/arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SYSDEP_X86_64_SKAS_PTRACE_H
-#define __SYSDEP_X86_64_SKAS_PTRACE_H
-
-struct ptrace_faultinfo {
-        int is_write;
-        unsigned long addr;
-};
-
-struct ptrace_ldt {
-        int func;
-        void *ptr;
-        unsigned long bytecount;
-};
-
-#define PTRACE_LDT 54
-
-#endif
-- 
1.7.2.5


