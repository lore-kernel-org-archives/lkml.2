Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3AAVKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:10:12 -0500
Received: from nm23.access.bullet.mail.mud.yahoo.com ([66.94.237.88]:39151
	"EHLO nm23.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3AAVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:10:09 -0500
X-Yahoo-Newman-Id: 379963.17119.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xu6fNyoVM1mT898cf0xnJc9zdC.llbq21d95VjQNH8IBH9Y
 DrEpQ5_sOQxILhTsfLQfQzdiYhUqgPEyelRjk3OGaMPacOkqEhBPMmPSBLec
 YD_n.5rBG0xaLgx_f342Wp0JW1k6ofV1FsjRG5pESyjkjQV6qlzVEDyb4Gyc
 O09wHU1oHKNZszzoSOavFvazd9MgJc64cOwLhVooUIVlxI7Hk.Enfyacfda_
 pVQysbskuLGEGE78CDC9aeQJCbSTgwgxiXM.dGsS9.ex_TN3IsL76oGo4W9K
 c1kBY2slQkHlbuODk6iFDVABHUmgqFWYx2r9wxjgwihB4lF5ephib5b3fAJH
 EXDonF9Y6MVtPnbJKS2Ic98IIlxGHtdJshkqeDnGbiL5EwxyslesHPlHltD_
 K8h7mEiplvsB9ewEB3WovLuhZsKvXBrT8.ttx2p9eFMxWo_Rb4am4EwqEisz
 IvzOZv2HGWU5hvrKkLsVF5wmP2GQ03w--
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
Subject: [PATCH v7 1/9] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Tue,  1 Jan 2013 15:09:49 -0600
Message-Id: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps to keep the file from getting confusing, removes one
duplicate version check and should encourage future editors to put new
macros where they belong.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/compiler-gcc4.h |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 662fd1b..78090c6 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -13,6 +13,10 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
+#if __GNUC_MINOR__ > 0
+# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
@@ -33,6 +37,12 @@
 
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+#endif /* __GNUC_MINOR__ >= 3 */
+
 #if __GNUC_MINOR__ >= 5
 /*
  * Mark a position in code as unreachable.  This can be used to
@@ -48,8 +58,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif
-#endif
+#endif /* __GNUC_MINOR__ >= 5 */
 
 #if __GNUC_MINOR__ >= 6
 /*
@@ -58,20 +67,13 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
 
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

