Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2FWKFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab2FWKFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:31 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 09/12] highmem: remove the deprecated form of kmap_atomic
Date: Sat, 23 Jun 2012 18:04:20 +0800
Message-Id: <1340445863-16111-10-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 include/linux/highmem.h |   41 +----------------------------------------
 1 files changed, 1 insertions(+), 40 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d3999b4..774fa47 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -110,54 +110,15 @@ static inline void kmap_atomic_idx_pop(void)
 #endif
 
 /*
- * NOTE:
- * kmap_atomic() and kunmap_atomic() with two arguments are deprecated.
- * We only keep them for backward compatibility, any usage of them
- * are now warned.
- */
-
-#define PASTE(a, b) a ## b
-#define PASTE2(a, b) PASTE(a, b)
-
-#define NARG_(_2, _1, n, ...) n
-#define NARG(...) NARG_(__VA_ARGS__, 2, 1, :)
-
-static inline void __deprecated *kmap_atomic_deprecated(struct page *page,
-							enum km_type km)
-{
-	return kmap_atomic(page);
-}
-
-#define kmap_atomic1(...) kmap_atomic(__VA_ARGS__)
-#define kmap_atomic2(...) kmap_atomic_deprecated(__VA_ARGS__)
-#define kmap_atomic(...) PASTE2(kmap_atomic, NARG(__VA_ARGS__)(__VA_ARGS__))
-
-static inline void __deprecated __kunmap_atomic_deprecated(void *addr,
-							enum km_type km)
-{
-	__kunmap_atomic(addr);
-}
-
-/*
  * Prevent people trying to call kunmap_atomic() as if it were kunmap()
  * kunmap_atomic() should get the return value of kmap_atomic, not the page.
  */
-#define kunmap_atomic_deprecated(addr, km)                      \
-do {                                                            \
-	BUILD_BUG_ON(__same_type((addr), struct page *));       \
-	__kunmap_atomic_deprecated(addr, km);                   \
-} while (0)
-
-#define kunmap_atomic_withcheck(addr)                           \
+#define kunmap_atomic(addr)                                     \
 do {                                                            \
 	BUILD_BUG_ON(__same_type((addr), struct page *));       \
 	__kunmap_atomic(addr);                                  \
 } while (0)
 
-#define kunmap_atomic1(...) kunmap_atomic_withcheck(__VA_ARGS__)
-#define kunmap_atomic2(...) kunmap_atomic_deprecated(__VA_ARGS__)
-#define kunmap_atomic(...) PASTE2(kunmap_atomic, NARG(__VA_ARGS__)(__VA_ARGS__))
-/**** End of C pre-processor tricks for deprecated macros ****/
 
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
-- 
1.7.7.6

