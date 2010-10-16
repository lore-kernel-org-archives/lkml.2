Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0JPR1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:27:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60734 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0JPR1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:27:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Date: Sat, 16 Oct 2010 13:27:15 -0400
Message-Id: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the arch doesn't provide atomic64 functionality (there are quite a
few), then don't bother trying to build this test.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/atomic64_test.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 250ed11..0ac1a66 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -12,6 +12,8 @@
 #include <linux/kernel.h>
 #include <asm/atomic.h>
 
+#ifdef ATOMIC64_INIT
+
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
 static __init int test_atomic64(void)
 {
@@ -164,3 +166,5 @@ static __init int test_atomic64(void)
 }
 
 core_initcall(test_atomic64);
+
+#endif
-- 
1.7.3.1

