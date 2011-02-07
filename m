Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1BGSpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:45:16 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41844 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1BGSpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:45:15 -0500
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] compiler, gcc: Unify macro definitions
Date: Mon,  7 Feb 2011 19:46:53 +0100
Message-Id: <1297104413-24711-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Unify identical gcc3.x and gcc4.x macros.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/compiler-gcc.h  |    8 ++++++++
 include/linux/compiler-gcc3.h |    8 --------
 include/linux/compiler-gcc4.h |    8 --------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 16508bc..cb4c1eb 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -92,3 +92,11 @@
 #if !defined(__noclone)
 #define __noclone	/* not needed */
 #endif
+
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
+
+#define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index b721129..37d4124 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -21,11 +21,3 @@
 #   error "GCOV profiling support for gcc versions below 3.4 not included"
 # endif /* __GNUC_MINOR__ */
 #endif /* CONFIG_GCOV_KERNEL */
-
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
-
-#define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index fcfa5b9..64b7c00 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -12,13 +12,6 @@
 #define __used			__attribute__((__used__))
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
-#define __always_inline		inline __attribute__((always_inline))
-
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
 
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
@@ -53,7 +46,6 @@
 #define __noclone	__attribute__((__noclone__))
 
 #endif
-
 #endif
 
 #if __GNUC_MINOR__ > 0
-- 
1.7.4.rc2

