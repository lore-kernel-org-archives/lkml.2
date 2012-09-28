Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2I1B47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:56:59 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:51039 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab2I1Bz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	JPNTbdbXJH0Bt0607YgNNaj4mFylnwnWEnkB45Rg8a0fbWGlS0AvTGVkUmGsWLHM
	A1M7QZVY3gsrLpOpbYDxC01wPeTgUKyB479ltcu6CrKlLHGOBGMtHU9WovIfbfCK
	oAAaGM2H/72JY7P2G6yjk3QhxJEn/laWYPG5ALAvYGg=
From: Daniel Santos <daniel.santos@pobox.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-sparse@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v6 5/25] compiler{,-gcc4}.h: Remove duplicate macros
Date: Thu, 27 Sep 2012 20:54:21 -0500
Message-Id: <1348797281-25021-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
X-Pobox-Relay-ID: A5977AEC-090F-11E2-825B-18772E706CDE-06139138!b-pb-sasl-quonix.pobox.com
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

