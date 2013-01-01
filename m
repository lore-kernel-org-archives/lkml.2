Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3AAW4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:56:10 -0500
Received: from nm25-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.191]:23657
	"EHLO nm25-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab3AAWyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:23 -0500
X-Yahoo-Newman-Id: 375115.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: D2E2qP4VM1k0ycATZEBrH75r4BqStMWrqOylE3TgSLyxvWV
 m4RO5p9BQLq1pr2yekAbcTvsN8DXz2YpruE1T3eC0JKuszLeQ2nVdr7CD8zh
 UQ_EX2FQzfh_IMDHqtL3SZvR6ZRKkredFasn9ItJj2S_OlnQSxVCxr5q5P6D
 NNiPvnmRyOyTg397QKfwV9aiynzrEPDVlB01V.6VoBRY2Pio87omarKiaVY5
 Hft.s07QJWAuIdUCCl72w0jaWufT4DLFj90UDrjvt0tUfFmyAwvpSWoBHUZF
 E3h2v7RHhqzMv1XjCcHRAdU9KuS7DkyhUka56Vwm5nSdBeM3_zZdx9uqhFEP
 BOoSX1Vvmx5CsAMWv97SKFi0V_arG0nDlFcYfC4LjvBS0lzoYF_9_Sm7pzSc
 OMwOtJVuRRiX0zNGFK5eUoWqxnrmKsGzXRZel3z6yQtR5.C.ad9nyCuv1bCv
 lUqYoP.QL3g1ELyhF.Eh7CAdz6KstFo5yURTcOJxqmQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v8 3/9] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Date: Tue,  1 Jan 2013 16:54:05 -0600
Message-Id: <1357080851-30938-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using GCC_VERSION reduces complexity, is easier to read and is GCC's
recommended mechanism for doing version checks. (Just don't ask me why
they didn't define it in the first place.)  This also makes it easy to
merge compiler-gcc{,3,4}.h should somebody want to.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/compiler-gcc3.h |    8 ++++----
 include/linux/compiler-gcc4.h |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index 37d4124..7d89feb 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -2,22 +2,22 @@
 #error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
 #endif
 
-#if __GNUC_MINOR__ < 2
+#if GCC_VERSION < 30200
 # error Sorry, your compiler is too old - please upgrade it.
 #endif
 
-#if __GNUC_MINOR__ >= 3
+#if GCC_VERSION >= 30300
 # define __used			__attribute__((__used__))
 #else
 # define __used			__attribute__((__unused__))
 #endif
 
-#if __GNUC_MINOR__ >= 4
+#if GCC_VERSION >= 30400
 #define __must_check		__attribute__((warn_unused_result))
 #endif
 
 #ifdef CONFIG_GCOV_KERNEL
-# if __GNUC_MINOR__ < 4
+# if GCC_VERSION < 30400
 #   error "GCOV profiling support for gcc versions below 3.4 not included"
 # endif /* __GNUC_MINOR__ */
 #endif /* CONFIG_GCOV_KERNEL */
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index c9785c2..a9ffdfe 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -4,7 +4,7 @@
 
 /* GCC 4.1.[01] miscompiles __weak */
 #ifdef __KERNEL__
-# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
+# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
 #  error Your version of gcc miscompiles the __weak directive
 # endif
 #endif
@@ -13,11 +13,11 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
-#if __GNUC_MINOR__ > 0
+#if GCC_VERSION >= 40100
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
 
-#if __GNUC_MINOR__ >= 3
+#if GCC_VERSION >= 40300
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
    are unnecessary now for any paths leading to the usual suspects
@@ -41,9 +41,9 @@
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
 #endif /* __CHECKER__ */
-#endif /* __GNUC_MINOR__ >= 3 */
+#endif /* GCC_VERSION >= 40300 */
 
-#if __GNUC_MINOR__ >= 5
+#if GCC_VERSION >= 40500
 /*
  * Mark a position in code as unreachable.  This can be used to
  * suppress control flow warnings after asm blocks that transfer
@@ -58,9 +58,9 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif /* __GNUC_MINOR__ >= 5 */
+#endif /* GCC_VERSION >= 40500 */
 
-#if __GNUC_MINOR__ >= 6
+#if GCC_VERSION >= 40600
 /*
  * Tell the optimizer that something else uses this function or variable.
  */
@@ -69,11 +69,11 @@
 
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
-#if __GNUC_MINOR__ >= 4
+#if GCC_VERSION >= 40400
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
 #endif
-#if __GNUC_MINOR__ >= 8 || (defined(__powerpc__) && __GNUC_MINOR__ >= 6)
+#if GCC_VERSION >= 40800 || (defined(__powerpc__) && GCC_VERSION >= 40600)
 #define __HAVE_BUILTIN_BSWAP16__
 #endif
-#endif
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
-- 
1.7.8.6

