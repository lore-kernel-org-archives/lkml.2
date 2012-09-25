Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab2IYXaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:30:18 -0400
Received: from nm26.bullet.mail.sp2.yahoo.com ([98.139.91.96]:36535 "HELO
	nm26.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752063Ab2IYXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:30:16 -0400
X-Yahoo-Newman-Id: 226433.71733.bm@omp1028.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KO5rfL4VM1legOgJFFqyvf.QgIgk5GTjeIMSVE4SzK4DLnF
 3N_66xJ120_fEiAHxJVI1SCXcnUskH0t0bNVwApR0rW1FE7797Iemc2Sw4dK
 GNvspnLMaf.7tmGuwrOhK7aBLolBABOAAtV_yh9MzA8gNmfZIqqEDzNlTUdJ
 3IRy1ZTy3wVF9_3ovL46NmrDr7SRRg.ki8ezengf9VlzaY.YPrSz0BEXSKEV
 67PTFOMHWR4S1HGuyvBMel2I0zFxAzovzM1CE.amqCdYTY5cjsOeMPFqs7WW
 xlmboRVYcuKtkWMyQpOos8Z_mTEGhWBQyb9AoqsbgbyWfupTTfy2wSOWkgxj
 oNH_zYDiOs81HJuU2p.MNzz3dtjZXG3UU7tp6JjrBW7WJkNikFLxKkaLdPrn
 OiXUFWN0U1QT9R31yRunqALdhh.h8BJ05zgHo.Jsp3I8ZeI5mHBQu
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
Subject: [PATCH v5 2/25] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Tue, 25 Sep 2012 18:30:07 -0500
Message-Id: <1348615807-10028-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps to keep the file from getting confusing, removes one
duplicate version check and should encourage future editors to put new
macros where they belong.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 10ce4fa..a334107 100644
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
@@ -46,13 +56,5 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif
-#endif
+#endif /* __GNUC_MINOR__ >= 5 */
 
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
-- 
1.7.3.4

