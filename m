Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2AVM6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 07:58:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61553 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2AVM6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 07:58:16 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Chris Zankel <chris@zankel.net>
Subject: [PATCH] xtensa: fix memscan
Date: Sun, 22 Jan 2012 21:58:29 +0900
Message-Id: <1327237109-25284-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define memscan as memchr is wrong. Because the return value of memscan
and memchr are different when the character is not found.
So use generic memscan implementation to fix it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/include/asm/string.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/include/asm/string.h b/arch/xtensa/include/asm/string.h
index 5fb8c27..405a8c4 100644
--- a/arch/xtensa/include/asm/string.h
+++ b/arch/xtensa/include/asm/string.h
@@ -118,7 +118,4 @@ extern void *memmove(void *__dest, __const__ void *__src, size_t __n);
 /* Don't build bcopy at all ...  */
 #define __HAVE_ARCH_BCOPY
 
-#define __HAVE_ARCH_MEMSCAN
-#define memscan memchr
-
 #endif	/* _XTENSA_STRING_H */
-- 
1.7.4.4

