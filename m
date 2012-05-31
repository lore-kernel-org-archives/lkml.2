Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab2EaUPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:15:46 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:37806 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab2EaUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:15:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] m68k: Use asm-generic version of <asm/types.h>
Date: Thu, 31 May 2012 22:15:38 +0200
Message-Id: <1338495338-1962-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1338495338-1962-1-git-send-email-geert@linux-m68k.org>
References: <1338495338-1962-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extra definition for BITS_PER_LONG we had is also indirectly provided
by <asm-generic/types.h>, via <asm-generic/int-ll64.h> and
<asm/bitsperlong.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/Kbuild  |    1 +
 arch/m68k/include/asm/types.h |   22 ----------------------
 2 files changed, 1 insertions(+), 22 deletions(-)
 delete mode 100644 arch/m68k/include/asm/types.h

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 4d1f8fa..064f867 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -23,5 +23,6 @@ generic-y += scatterlist.h
 generic-y += siginfo.h
 generic-y += statfs.h
 generic-y += topology.h
+generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
diff --git a/arch/m68k/include/asm/types.h b/arch/m68k/include/asm/types.h
deleted file mode 100644
index 89705ad..0000000
--- a/arch/m68k/include/asm/types.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _M68K_TYPES_H
-#define _M68K_TYPES_H
-
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-#include <asm-generic/int-ll64.h>
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-
-#define BITS_PER_LONG 32
-
-#endif /* __KERNEL__ */
-
-#endif /* _M68K_TYPES_H */
-- 
1.7.0.4

