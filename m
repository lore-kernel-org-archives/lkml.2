Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab2I1XVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:21:09 -0400
Received: from nm22-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.60]:39002 "EHLO
	nm22-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758809Ab2I1XVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:21:00 -0400
X-Yahoo-Newman-Id: 766781.39372.bm@omp1020.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6FDnDW8VM1k6LrgkFRm.swHm.h3A_joyHDIZVq8xIB85o0K
 RZP6NEkd1SlsVD1JjTVcNRUvasLyAif_qq9lVrWY0B7ycyRKohqxgwZNMbhu
 4AjUDnEXiIMGcUH_EKfiuwjVg64p29zBjuBcg7w7zR1rU4J3iLuw6n1BkjSY
 _bPr6SbYsGjRW3Wil1TDwg5fNJD7mcJh_yBDXJCHja.c18kq0xlLD1AiZE1i
 XoR3eDl5kYz5Em7KDYqDRPMXhMMAQQLsMaH2u7Ukiw6scraqo3fRpRcrZs61
 Wy.5Ckr4WJiRTDrICRo1hoZlBp4sMm3XmcAd1ES5Vi7bPkV1Eb47FV5pIvY8
 TCDaIYOkRnrBZ2hQiRlCou2MHL9jNiIEYQ8s63eaOoeg_WdYrtsukKkwNHwl
 7r_9cMC.wkJizX7bWYxHquzvHI8viqW3eX3r2uDpglH3VA0hxhZnxjA--
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
Subject: [PATCH 5/10] compiler{,-gcc4}.h: Remove duplicate macros
Date: Fri, 28 Sep 2012 18:20:06 -0500
Message-Id: <1348874411-28288-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more
sense to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index b44307d..ad610f2 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #ifndef __CHECKER__
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f430e41..fd455aa 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -297,9 +297,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-#ifndef __linktime_error
-# define __linktime_error(message)
-#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

