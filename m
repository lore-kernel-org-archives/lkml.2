Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1E2CuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 22:50:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52116 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab1E2CuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 22:50:14 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] asm-generic/system.h: drop useless __KERNEL__
Date: Sat, 28 May 2011 22:55:08 -0400
Message-Id: <1306637708-11640-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1302738110-22344-1-git-send-email-vapier@gentoo.org>
References: <1302738110-22344-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header isn't exported to user-space, and even if it was, the
__KERNEL__ check covers the entire file, so we'd get a useless stub
in the first place.  So punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
andrew: could you pick this up ?  sent it out about 6 weeks ago with no love

 include/asm-generic/system.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index 4b0b9cb..215efa7 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -14,7 +14,6 @@
 #ifndef __ASM_GENERIC_SYSTEM_H
 #define __ASM_GENERIC_SYSTEM_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -139,5 +138,4 @@ unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_SYSTEM_H */
-- 
1.7.5.rc3

