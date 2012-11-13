Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2KMWNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:13:53 -0500
Received: from nm1.access.bullet.mail.sp2.yahoo.com ([98.139.44.128]:28528
	"EHLO nm1.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab2KMWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:50 -0500
X-Yahoo-Newman-Id: 886847.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nCeq.joVM1kM4f3GEGKzFtYeIKnnScxvbYSn2T0UouCcOrQ
 2hfpSLq8JYrFbd5crfUvrVYsDoWwzZM28m.Qb21iB4wo_JQ469g5QSHP0T1j
 qa8i5igwx35.roaim6Ts01HheUyqk6OgTW8wdjD84noZ7illAILwD46ESLDY
 uOaY4yJ6n5Tx6d653kAIOnEO8eQlbjppvYggawIjxErE27.0zZD3EtCVjBdv
 VPf6DREjPz4yMGhEPifh7oSse2CRxHoScgkz3br09XT9.lm82elJQJ3q0DFc
 EUfJgmSFjM7vxEXCYXks3gW6VVGzbwuni9cbAuSV5t.GtIB28OMJKY51LnWH
 O.IS8IkUpYSiDnWmu6I5kVaX0_7wybDM9wCHiNjBf0GaJ5o.MDthexDEDAwv
 k8uNoE8J4VP8O3GWYvsfOsGgpAp9D5vPZeN4lWEM6iyGWd8v1kvBmW5DPNQ5
 EnjgDsOqKglsfnGfJCSliab4IDgaiiw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v5 1/9] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Tue, 13 Nov 2012 16:13:33 -0600
Message-Id: <1352844821-18952-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
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

