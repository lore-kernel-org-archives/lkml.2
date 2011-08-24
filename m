Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1HXPYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:24:12 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57801 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1HXPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:24:10 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: linux-arch@vger.kernel.org, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] include: Fix compile warning in include/linux/bitops.h
Date: Thu, 25 Aug 2011 00:23:35 +0900
Message-Id: <1314199415-7924-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compile warning is caused by __const_hweight8 when using hweight_long with -Wsign-compare option.
The reason is that the default return value of this macro is signed. So need type casting to remove warning.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 include/asm-generic/bitops/const_hweight.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
index fa2a50b..31b7fce 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -4,15 +4,15 @@
 /*
  * Compile time versions of __arch_hweightN()
  */
-#define __const_hweight8(w)		\
-      (	(!!((w) & (1ULL << 0))) +	\
-	(!!((w) & (1ULL << 1))) +	\
-	(!!((w) & (1ULL << 2))) +	\
-	(!!((w) & (1ULL << 3))) +	\
-	(!!((w) & (1ULL << 4))) +	\
-	(!!((w) & (1ULL << 5))) +	\
-	(!!((w) & (1ULL << 6))) +	\
-	(!!((w) & (1ULL << 7)))	)
+#define __const_hweight8(w)	(unsigned long)	\
+      	(	(!!((w) & (1ULL << 0))) +	\
+		(!!((w) & (1ULL << 1))) +	\
+		(!!((w) & (1ULL << 2))) +	\
+		(!!((w) & (1ULL << 3))) +	\
+		(!!((w) & (1ULL << 4))) +	\
+		(!!((w) & (1ULL << 5))) +	\
+		(!!((w) & (1ULL << 6))) +	\
+		(!!((w) & (1ULL << 7)))	)
 
 #define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
 #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
-- 
1.7.4.4

