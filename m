Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab2FIDPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 23:15:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2FIDPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 23:15:44 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: arnd@arndb.de, akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] include: Fix compile warning in include/linux/bitops.h
Date: Fri,  8 Jun 2012 23:15:30 -0400
Message-Id: <1339211730-10398-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compile warning is caused by __const_hweight8 when using
hweight_long with -Wsign-compare option.
The reason is that the default return value of this macro is signed.
So need type casting to remove warning.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 include/asm-generic/bitops/const_hweight.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
index fa2a50b..3ad0dae 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -4,7 +4,7 @@
 /*
  * Compile time versions of __arch_hweightN()
  */
-#define __const_hweight8(w)		\
+#define __const_hweight8(w)	(unsigned long)	\
       (	(!!((w) & (1ULL << 0))) +	\
 	(!!((w) & (1ULL << 1))) +	\
 	(!!((w) & (1ULL << 2))) +	\
-- 
1.7.9.5

