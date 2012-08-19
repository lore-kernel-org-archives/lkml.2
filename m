Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2HSC7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:1635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2HSC5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415443"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/74] Add __visible
Date: Sat, 18 Aug 2012 19:55:57 -0700
Message-Id: <1345345030-22211-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

gcc 4.6+ has support for a externally_visible attribute, that prevents
the optimizer from optimizing unused symbols away. Add a __visible macro
to use it with that compiler version or later.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/compiler-gcc4.h |    7 +++++++
 include/linux/compiler.h      |    4 ++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2f40791..934bc34 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -49,6 +49,13 @@
 #endif
 #endif
 
+#if __GNUC_MINOR__ >= 6
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible __attribute__((externally_visible))
+#endif
+
 #if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 923d093..f430e41 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -278,6 +278,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+#ifndef __visible
+#define __visible
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #ifndef __same_type
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
-- 
1.7.7.6

