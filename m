Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2IYXal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:30:41 -0400
Received: from nm4-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.190]:36719 "HELO
	nm4-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752578Ab2IYXai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:30:38 -0400
X-Yahoo-Newman-Id: 353819.44048.bm@omp1028.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iG9Bx.QVM1niF1dluVonxS2h6NVpriSWENuamOrKAoalQ.f
 FPnFPUSMdbbf_4vOwtQ7ihbSAlKNgPo.6woG7.VYdIWUB_hw.1hbGo4fN2lk
 VFaott45NOj2qu8zMxWDCsfmqlbcSSlditL3ZwNT_zm8He99qEh6mMqf4DA6
 UZUinPbkAhlpQeuy4VCgusYKZw0o4ySmY190RofpcFvv2UjV2iwAuOROAl29
 zZzPVvPQ6SybvzrCMKA5HLTHK.1_9HNfiNX.9ayML5tDXIHo6zj4yM8LcdGt
 Lb12C044.bfXBubyhYo9CYiowmN9zQGXh6DpF_yY_fYiXY7GWBapgnfsx2hN
 AxAdpLF2s9rzY2d3sc6lqQsQPl7KMD_VGAC80OFQRQQxKBHU8q1k_D2hp3e_
 hq6QKvSsQkwNnOTzpEuljgAAPRFT_rOCPx9njnCr7e0NZzFtkl0J6
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, linux-sparse@vger.kernel.org,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 5/25] compiler{,-gcc4}.h: Remove duplicate macros
Date: Tue, 25 Sep 2012 18:30:30 -0500
Message-Id: <1348615830-10127-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
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
index 7ad60cd..5755e23 100644
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
index 923d093..4d9f353 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -293,9 +293,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
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

