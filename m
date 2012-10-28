Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2J1U5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:57:14 -0400
Received: from nm30-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.194]:44492
	"EHLO nm30-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab2J1U5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:10 -0400
X-Yahoo-Newman-Id: 585251.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0NDVMXgVM1lNuYifRTFoK9IL33IysA9kfDgrxBMgAJCXt.I
 ntcsn.vBGvhnIUJKBSYkPx_6xqn.9a8Ba0cKcQ32_GRw0xqMaZliCu_.etay
 FIE6jGK_sf8l_m.zfGW5AgWXp5Qily5yJzARti4xhTyZrBjiTweC5L7nZWuG
 ENWp2LKC98WM56ukvVpmHfd4SkNWn0QnR3ckuzFJ8gqz8OxOdRI3XTVN2r1O
 ITTkPHHF8pl_0ZxsCIdlWpAW2KoLpGJknRb8.lf6Gkw6yh8jxhoZkaehQuIh
 UoiOD5Z7YTNnFEZuOnji5rFJzqxL3AXrswUtt4r98JmfuZGmWUi_N.4Kyf1G
 PDHz5tmPJUKRQgJahu.KTxjoT6WxwpvjLQkkNYZBjexGqzGyF9nnG.i.x4FX
 u3H_mDhhdBUxiH8nxT3ts8W2vLsNNsPv07.UBQRfsE_oFEEUDo11F6l.BZm0
 y285Jyso0VKnBeM114zpsWAoWD19wUQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v4 3/9] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Date: Sun, 28 Oct 2012 15:57:09 -0500
Message-Id: <1351457835-7553-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
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
index 8914293..9755029 100644
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

