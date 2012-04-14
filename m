Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2DNTP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:15:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53219 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2DNTPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:15:19 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 1/3] typecheck: extend typecheck.h with more useful typechecking macros
Date: Sat, 14 Apr 2012 18:14:43 -0400
Message-Id: <1334441685-4438-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macros to compare multiple parameters to a given type, and macros to
compare multiple parameters between themselves.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/typecheck.h |   42 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
index eb5b74a..a495dcb 100644
--- a/include/linux/typecheck.h
+++ b/include/linux/typecheck.h
@@ -5,20 +5,46 @@
  * Check at compile time that something is of a particular type.
  * Always evaluates to 1 so you may use it easily in comparisons.
  */
-#define typecheck(type,x) \
-({	type __dummy; \
-	typeof(x) __dummy2; \
-	(void)(&__dummy == &__dummy2); \
-	1; \
+#define typecheck(type,x)		\
+({	type __dummy;			\
+	typeof(x) __dummy2;		\
+	(void)(&__dummy == &__dummy2);	\
+	1;				\
+})
+
+#define typecheck2(type,x,y)		\
+({	typecheck(type, x);		\
+	typecheck(type, y);		\
+	1;				\
+})
+
+#define typecheck3(type,x,y,z)		\
+({	typecheck2(type,x,y);		\
+	typecheck(type,z);		\
+	1;				\
+})
+
+#define typecmp2(x,y)			\
+({	typeof(x) __x = (x);		\
+	typeof(y) __y = (y);		\
+	typecheck(typeof(x),x);		\
+	typecheck(typeof(y),y);		\
+	(void)(&__x==&__y);		\
+	1;				\
+})
+
+#define typecmp3(x,y,z)			\
+({	typecmp2((x),(y));			\
+	typecmp2((x),(z));			\
 })
 
 /*
  * Check at compile time that 'function' is a certain type, or is a pointer
  * to that type (needs to use typedef for the function type.)
  */
-#define typecheck_fn(type,function) \
-({	typeof(type) __tmp = function; \
-	(void)__tmp; \
+#define typecheck_fn(type,function)	\
+({	typeof(type) __tmp = function;	\
+	(void)__tmp;			\
 })
 
 #endif		/* TYPECHECK_H_INCLUDED */
-- 
1.7.8.5

