Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0CZUok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:44:40 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12697 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0CZUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:44:38 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] Protect prefetch macro arguments.
Date: Fri, 26 Mar 2010 13:44:00 -0700
Message-Id: <1269636240-8895-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.6.1
X-OriginalArrivalTime: 26 Mar 2010 20:44:07.0384 (UTC) FILETIME=[146FDD80:01CACD25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GCC built-in __builtin_prefetch() is a vargs function.  If we
don't wrap the macro parameter in parentheses, a comma operator in the
actual argument list might cause unintended parameters to be passed to
__builtin_prefetch().

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 include/linux/prefetch.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index af7c36a..6179433 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -35,11 +35,11 @@
 */
 
 #ifndef ARCH_HAS_PREFETCH
-#define prefetch(x) __builtin_prefetch(x)
+#define prefetch(x) __builtin_prefetch((x))
 #endif
 
 #ifndef ARCH_HAS_PREFETCHW
-#define prefetchw(x) __builtin_prefetch(x,1)
+#define prefetchw(x) __builtin_prefetch((x), 1)
 #endif
 
 #ifndef ARCH_HAS_SPINLOCK_PREFETCH
-- 
1.6.6.1

