Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab1GCLmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 07:42:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38965 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1GCLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 07:42:38 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linkinjeon@gmail.com
Subject: [PATCH] include : compile warning by __const_hweight8
Date: Sun,  3 Jul 2011 20:42:25 +0900
Message-Id: <1309693345-2213-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compilation warning is caused by __const_hweight8 when using hweight_long with -Wsign-compare option.
The reason is that the default return value of this macro is signed. So, need tye casting to remove warning.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 include/asm-generic/bitops/const_hweight.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
index fa2a50b..d91b1aa 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -4,7 +4,7 @@
 /*
  * Compile time versions of __arch_hweightN()
  */
-#define __const_hweight8(w)		\
+#define __const_hweight8(w) (unsigned long)	\
       (	(!!((w) & (1ULL << 0))) +	\
 	(!!((w) & (1ULL << 1))) +	\
 	(!!((w) & (1ULL << 2))) +	\
-- 
1.7.4.4

