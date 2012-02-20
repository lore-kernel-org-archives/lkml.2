Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2BTALD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:11:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2BTALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:11:00 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 05/30] x32: Create posix_types_x32.h
Date: Sun, 19 Feb 2012 16:07:43 -0800
Message-Id: <1329696488-16970-6-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:10:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

This is the same as the 64-bit posix_types.h, except that
__kernel_[u]long_t is defined to be [unsigned] long long and therefore
64 bits.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/Kbuild            |    1 +
 arch/x86/include/asm/posix_types.h     |    4 +++-
 arch/x86/include/asm/posix_types_x32.h |   19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/posix_types_x32.h

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index b57e6a4..986954f 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -14,6 +14,7 @@ header-y += msr.h
 header-y += mtrr.h
 header-y += posix_types_32.h
 header-y += posix_types_64.h
+header-y += posix_types_x32.h
 header-y += prctl.h
 header-y += processor-flags.h
 header-y += ptrace-abi.h
diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index bb7133d..3427b77 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -7,7 +7,9 @@
 #else
 # ifdef __i386__
 #  include "posix_types_32.h"
-# else
+# elif defined(__LP64__)
 #  include "posix_types_64.h"
+# else
+#  include "posix_types_x32.h"
 # endif
 #endif
diff --git a/arch/x86/include/asm/posix_types_x32.h b/arch/x86/include/asm/posix_types_x32.h
new file mode 100644
index 0000000..85f9bda
--- /dev/null
+++ b/arch/x86/include/asm/posix_types_x32.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_X86_POSIX_TYPES_X32_H
+#define _ASM_X86_POSIX_TYPES_X32_H
+
+/*
+ * This file is only used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ *
+ * These types should generally match the ones used by the 64-bit kernel,
+ *
+ */
+
+typedef long long __kernel_long_t;
+typedef unsigned long long __kernel_ulong_t;
+#define __kernel_long_t __kernel_long_t
+
+#include <asm/posix_types_64.h>
+
+#endif /* _ASM_X86_POSIX_TYPES_X32_H */
-- 
1.7.6.5

