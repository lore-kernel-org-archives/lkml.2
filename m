Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab1FQVHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:07:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56837 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677Ab1FQVHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:07:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>
Subject: [PATCH] asm-generic/atomic.h: simplify inc/dec test helpers
Date: Fri, 17 Jun 2011 17:08:15 -0400
Message-Id: <1308344895-8011-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already declared inc/dec helpers, so we don't need to call the
atomic_{add,sub}_return funcs directly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Note: this shouldn't conflict with Arun's changes

 include/asm-generic/atomic.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e994197..5f62e28 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -117,8 +117,8 @@ static inline void atomic_dec(atomic_t *v)
 #define atomic_inc_return(v)		atomic_add_return(1, (v))
 
 #define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
-#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_dec_return(v) == 0)
+#define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
 #define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
-- 
1.7.5.3

