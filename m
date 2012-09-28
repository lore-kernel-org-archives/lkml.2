Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2I1Bzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:55:55 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:50926 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab2I1Bzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	eudYVMdIJKa8GpEcKUlfqgcR2qnkNOLD+EzDSIyqU/BoTrycYykz6yD3XYImmJyM
	TYGTC/6RNPXNQUjRTAimsLsKP1X/swIP7q0uNKwJUv/jMs7WMyKSaDhrZQV9Nv8n
	6TTwfnQNngKKWyuD6iBnT5fQyPlUcHxFT4CCnudxHOc=
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
Subject: [PATCH v6 2/25] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Thu, 27 Sep 2012 20:54:18 -0500
Message-Id: <1348797281-25021-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
X-Pobox-Relay-ID: A0E5D9EE-090F-11E2-A4B4-18772E706CDE-06139138!b-pb-sasl-quonix.pobox.com
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
index 8721704..4506d65 100644
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

