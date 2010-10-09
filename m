Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab0JIT7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 15:59:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505Ab0JIT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 15:58:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
        Mathieu Lacage <mathieu.lacage@sophia.inria.fr>,
        Mathieu Lacage <mathieu.lacage@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] asm-generic: cmpxchg does not handle non-long arguments
Date: Sat,  9 Oct 2010 21:57:48 +0200
Message-Id: <1286654272-21483-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286654272-21483-1-git-send-email-arnd@arndb.de>
References: <1286654272-21483-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:62obePw552+fJQDBcr1ici2F0j4c2J0w/SkjRIXYvHA
 lL1Y2NDK0ZGjz6DY0vBEuw62+DpxYskOXe3CdG3yZjZc529ZU1
 ECpFMflgJJWo5Rq2gswwZlvHwaf8gWh50bk1nvRrpHmov+AEqx
 QZ87GmbEmIzjoIeCJkswOrtn9jxDcia+6vc0d7Lf186hZ/Ud+U
 7ema23cadltBZwGGP43Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>

The version of cmpxchg defined in asm-generic/system.h does not handle
correctly non-long arguments. Use the version defined in cmpxchg.h
instead.

Signed-off-by: Mathieu Lacage <mathieu.lacage@inria.fr>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/system.h |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index efa403b..4b0b9cb 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -21,6 +21,7 @@
 #include <linux/irqflags.h>
 
 #include <asm/cmpxchg-local.h>
+#include <asm/cmpxchg.h>
 
 struct task_struct;
 
@@ -136,25 +137,6 @@ unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
 #define xchg(ptr, x) \
 	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
 
-static inline unsigned long __cmpxchg(volatile unsigned long *m,
-				      unsigned long old, unsigned long new)
-{
-	unsigned long retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	if (retval == old)
-		*m = new;
-	local_irq_restore(flags);
-	return retval;
-}
-
-#define cmpxchg(ptr, o, n)					\
-	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
-					(unsigned long)(o),	\
-					(unsigned long)(n)))
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
-- 
1.7.1

