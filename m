Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2J1U5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:57:09 -0400
Received: from nm5.access.bullet.mail.mud.yahoo.com ([66.94.237.206]:48867
	"EHLO nm5.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513Ab2J1U5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:07 -0400
X-Yahoo-Newman-Id: 591281.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uzccBLQVM1n9TNCXUc_JI0db0Cf9jSn9RruVIkyRo7CINSK
 neIVa1lmw_uCu76KiLmBLniNgYzzHq0nEls1FETzgkbd_iTwbyFKwMy79pkH
 rXw5j8IUJakU6qL.pGBatC8cvA8QVxJwbFx7IH57oMAx_aj3G9Qi38wNhQgc
 4M0TgxenYjZBmV6FAmIMycmZxCoqL8up8otXrbQlgAqYHIJhmWk03c8dzXaR
 TwxPURWn9KtzxiYujuJdPPGz16VE6ZgsYt6dBlXDiAX4JY61eAa.UOGfT3OZ
 K.L_D3PKCrjUJaHhtnjdavw0jM1lCMZePepq5ZLez6.xuZnr5ZZbH1rCRwHt
 myQ0s4pqf7Pecafj.VONZPoNyBI3wkor9ksLvV07Pxk_VBWNtMi1E1.Diu0l
 Vry2RyNiPbkdJhjLU_52K1UR.kAZg1kkGtHyLz24XjVhneZAVhC_rnrq9ioP
 zns3SN.25ztcVCD6W8Q1eI4qjR0aQlw--
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
Subject: [PATCH v4 1/9] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Sun, 28 Oct 2012 15:57:07 -0500
Message-Id: <1351457835-7553-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps to keep the file from getting confusing, removes one
duplicate version check and should encourage future editors to put new
macros where they belong.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
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

