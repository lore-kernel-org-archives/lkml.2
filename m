Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2IYXg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:36:28 -0400
Received: from nm8-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.95]:41726 "HELO
	nm8-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754105Ab2IYXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:36:24 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:36:24 EDT
X-Yahoo-Newman-Id: 525499.71035.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rXoUf5IVM1mPQePnsge3iMCzRj_hsWuMSH1fI5BQkdS6RPf
 6VUi2HkgR2y9Xie1ok1_7NDDB5SyYIUug_cr.aaWeEneRCNzSN4G1W.sDIZZ
 KEqWN4nEJDybxRFesnVnCZAXrJJ57EeWLuN6oFo9lLIgzi4MG0I_AH0dk8hv
 JI7Zkd91MfnW7plXOVB7xoZddb.LPUQsY7vTbfBKUvEvRJU1WfB8rAJg3xU7
 Czh5zEZSwAZuP6l7pSy68XgcvII7ut95a2iDiLxLttF5JvAM.DNmObomIuRf
 dqXBfFKYL19UMOgT7S_AaQ0Ues3QJBbkOwSSnbvGpphFXj_zNHVBxAxpDX3_
 bKBA6IpOhVucfrbEFA0f97S_k8tzoRrJ0vS3DsDvjQMatkQ5GA1L.yb9gntv
 Hx503ietXnyTC.6viYaGnXCHUO_DBisdgjdmbI0TrxGEcuhx8Bexz1w--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 4/25] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Date: Tue, 25 Sep 2012 18:30:25 -0500
Message-Id: <1348615825-10094-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
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
 include/linux/compiler-gcc4.h |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

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
index a334107..7ad60cd 100644
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
@@ -56,5 +56,5 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif /* __GNUC_MINOR__ >= 5 */
+#endif /* GCC_VERSION >= 40500 */
 
-- 
1.7.3.4

