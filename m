Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2I1XVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:21:06 -0400
Received: from nm3-vm0.bullet.mail.sp2.yahoo.com ([98.139.90.230]:41895 "HELO
	nm3-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758913Ab2I1XU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:20:59 -0400
X-Yahoo-Newman-Id: 742122.28587.bm@omp1022.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0IWi0CEVM1mPMmVjyQKmJ0x0qVTwbR0ZmSO7TL3cENVg.uy
 BiO0mD2hMiA6h_iPZvWMWGUZ64hvFS0tonPstQu_G5FM_ufk4RLffoC3oRcU
 GITpPSHZOVi9onDX4wO2.tLtEh4_jvDwCjlnrmhlmTpJA3.JcfXVc3unB20N
 EqBcEzXsMCqt2xoEbaxdU7gTWzDAC00IV9URElNdqBck80dKiw3liWdAUq20
 ISSwRdlls8JIPOVARG7VkXyjJuqI.3VSXn.9TVYc8kf2lXrS8FyHQDSetyCG
 D4DzBAl.o4WpRGvOqdnKr0E.Q16I6oMjTsUlk1E3b1G2B5K7npvRn2ofoGEK
 VkzrF75ItyqJ8mcowat0Xue5qnH1pZLr0ClrXMec2v3HDTwU5dQGs5pDlazf
 B_k.OgefiE3F7cU2PgSm__MnTeX8qGfTSOt8qGDN6eEKnvUybOmIP
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Date: Fri, 28 Sep 2012 18:20:05 -0500
Message-Id: <1348874411-28288-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using GCC_VERSION reduces complexity, is easier to read and is GCC's
recommended mechanism for doing version checks. (Just don't ask me why
they didn't define it in the first place.)  This also makes it easy to
merge compiler-gcc{3,4}.h should somebody want to.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc3.h |    8 ++++----
 include/linux/compiler-gcc4.h |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

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
index 4506d65..b44307d 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -4,7 +4,7 @@
 
 /* GCC 4.1.[01] miscompiles __weak */
 #ifdef __KERNEL__
-# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
+# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
 //#  error Your version of gcc miscompiles the __weak directive
 # endif
 #endif
@@ -13,11 +13,11 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
-#if __GNUC_MINOR__ > 0
+#if GCC_VERSION >= 40102
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
 
-#if __GNUC_MINOR__ >= 3
+#if GCC_VERSION >= 40300
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
    are unnecessary now for any paths leading to the usual suspects
@@ -39,9 +39,9 @@
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
@@ -56,9 +56,9 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif /* __GNUC_MINOR__ >= 5 */
+#endif /* GCC_VERSION >= 40500 */
 
-#if __GNUC_MINOR__ >= 6
+#if GCC_VERSION >= 40600
 /*
  * Tell the optimizer that something else uses this function or variable.
  */
-- 
1.7.3.4

