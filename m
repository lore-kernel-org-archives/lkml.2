Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2KTVFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:05:14 -0500
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:22407
	"EHLO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab2KTVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:12 -0500
X-Yahoo-Newman-Id: 629608.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z8LpG1AVM1lRDArYorRoLN51RYiVVrVKKr5e9gZMkdIkr1A
 NOuEU5Ek9yfqS.MDQJxByV6G5LnIzh3X0CHIa2QNsWjdlO8em3408gY4TulC
 LEUY5axCnAA7YS8RIO6DnT9MVwRf9jbGexCGpgO19P24uLRgGAL9y6RM4L4G
 16BYl7FEScPajAi9CHKSPPcAMG_NU.RPLWvpbXeu27pDBeJpu9HNftZE7ioj
 LIv1mDYTRfYkdw4WT6xR5ctmEmB756HdFMpP_Bz2QkFVOn.2fgOkEKEEC9BU
 c8PtXP04TMluU2DgD97c6MvA5m3OKfgk0uFGT6IZbYG4pPlxg..kzmqmquau
 HKyTIZsZis71yIQEFN7mxzC0pjd9VsDgJL_8Xt8iRKZrn4ZAFcHeQf09pwrH
 H9lELZjsphBKNFAqrOZGIWHGZqi4L7eJhAVbSR0mid2JL2agMISiqq7BBLPG
 yi9q.WUvK1A0gWo2M64EGmABW8sNkAI8-
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
Subject: [PATCH v6 1/9] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Tue, 20 Nov 2012 15:04:59 -0600
Message-Id: <1353445507-7233-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
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
 include/linux/compiler-gcc4.h |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 412bc6c..8914293 100644
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
@@ -31,6 +35,12 @@
 
 #define __linktime_error(message) __attribute__((__error__(message)))
 
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+#endif /* __GNUC_MINOR__ >= 3 */
+
 #if __GNUC_MINOR__ >= 5
 /*
  * Mark a position in code as unreachable.  This can be used to
@@ -46,8 +56,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif
-#endif
+#endif /* __GNUC_MINOR__ >= 5 */
 
 #if __GNUC_MINOR__ >= 6
 /*
@@ -56,10 +65,3 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
-- 
1.7.3.4

