Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2BPFe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:34:26 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:37517 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2BPFeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:34:23 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk, nicolas.pitre@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: boot/compressed/decompress.c cleanup
Date: Thu, 16 Feb 2012 06:34:09 +0100
Message-Id: <1329370449-12033-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes against Linus' tree

- Remove unused declarations and includes
- Remove the ARCH_HAS_DECOMP_WDOG define
  because it is only used in lib/deflate.c, which
  only the alpha architecture uses. No other architecture
  uses this define
- Remove the Trace<xx> and Assert functions which aren't used
  in decompression routines.

Tested successfully on Linux 3.3.0-rc3

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/boot/compressed/decompress.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/arch/arm/boot/compressed/decompress.c b/arch/arm/boot/compressed/decompress.c
index 07be5a2..36f92ca 100644
--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -1,37 +1,14 @@
-#define _LINUX_STRING_H_
-
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
-#include <linux/linkage.h>
 #include <asm/string.h>
 
 extern unsigned long free_mem_ptr;
 extern unsigned long free_mem_end_ptr;
-extern void error(char *);
 
 #define STATIC static
 #define STATIC_RW_DATA	/* non-static please */
 
-#define ARCH_HAS_DECOMP_WDOG
-
-/* Diagnostic functions */
-#ifdef DEBUG
-#  define Assert(cond,msg) {if(!(cond)) error(msg);}
-#  define Trace(x) fprintf x
-#  define Tracev(x) {if (verbose) fprintf x ;}
-#  define Tracevv(x) {if (verbose>1) fprintf x ;}
-#  define Tracec(c,x) {if (verbose && (c)) fprintf x ;}
-#  define Tracecv(c,x) {if (verbose>1 && (c)) fprintf x ;}
-#else
-#  define Assert(cond,msg)
-#  define Trace(x)
-#  define Tracev(x)
-#  define Tracevv(x)
-#  define Tracec(c,x)
-#  define Tracecv(c,x)
-#endif
-
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
 #endif
-- 
1.7.4.1

