Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0CQSLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:11:08 -0400
Received: from gw1.transmode.se ([213.115.205.20]:59670 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab0CQSLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:11:07 -0400
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] [RFC] #define __BYTE_ORDER
Date: Wed, 17 Mar 2010 19:10:55 +0100
Message-Id: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-03-17 19:10:49,
	Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-03-17 19:10:49,
	Serialize complete at 2010-03-17 19:10:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux does not define __BYTE_ORDER in its endian header files
which makes some header files bend backwards to get at the
current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
to make it easier for header files that are used in user space too.

This patch has not been tested so watch out for breakage.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 arch/alpha/math-emu/sfp-util.h          |    5 -----
 arch/powerpc/include/asm/sfp-machine.h  |    6 ------
 arch/s390/include/asm/sfp-util.h        |    2 --
 arch/sh/math-emu/sfp-util.h             |    4 ----
 arch/sparc/math-emu/sfp-util_32.h       |    6 ------
 arch/sparc/math-emu/sfp-util_64.h       |    6 ------
 arch/x86/boot/compressed/relocs.c       |    4 ++--
 include/linux/byteorder/big_endian.h    |    3 +++
 include/linux/byteorder/little_endian.h |    3 +++
 9 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/alpha/math-emu/sfp-util.h b/arch/alpha/math-emu/sfp-util.h
index f53707f..d4c6ae7 100644
--- a/arch/alpha/math-emu/sfp-util.h
+++ b/arch/alpha/math-emu/sfp-util.h
@@ -28,8 +28,3 @@ extern unsigned long __udiv_qrnnd (unsigned long *, unsigned long,
 #define UDIV_NEEDS_NORMALIZATION 1  
 
 #define abort()			goto bad_insn
-
-#ifndef __LITTLE_ENDIAN
-#define __LITTLE_ENDIAN -1
-#endif
-#define __BYTE_ORDER __LITTLE_ENDIAN
diff --git a/arch/powerpc/include/asm/sfp-machine.h b/arch/powerpc/include/asm/sfp-machine.h
index 3a7a67a..8b8fab9 100644
--- a/arch/powerpc/include/asm/sfp-machine.h
+++ b/arch/powerpc/include/asm/sfp-machine.h
@@ -353,12 +353,6 @@
 #define abort()								\
 	return 0
 
-#ifdef __BIG_ENDIAN
-#define __BYTE_ORDER __BIG_ENDIAN
-#else
-#define __BYTE_ORDER __LITTLE_ENDIAN
-#endif
-
 /* Exception flags. */
 #define EFLAG_INVALID		(1 << (31 - 2))
 #define EFLAG_OVERFLOW		(1 << (31 - 3))
diff --git a/arch/s390/include/asm/sfp-util.h b/arch/s390/include/asm/sfp-util.h
index 0addc64..7d43fee 100644
--- a/arch/s390/include/asm/sfp-util.h
+++ b/arch/s390/include/asm/sfp-util.h
@@ -73,5 +73,3 @@ extern unsigned long __udiv_qrnnd (unsigned int *, unsigned int,
 #define UDIV_NEEDS_NORMALIZATION 0
 
 #define abort() return 0
-
-#define __BYTE_ORDER __BIG_ENDIAN
diff --git a/arch/sh/math-emu/sfp-util.h b/arch/sh/math-emu/sfp-util.h
index 8ae1bd3..e852602 100644
--- a/arch/sh/math-emu/sfp-util.h
+++ b/arch/sh/math-emu/sfp-util.h
@@ -66,7 +66,3 @@
   } while (0)
 
 #define abort()	return 0
-
-#define __BYTE_ORDER __LITTLE_ENDIAN
-
-
diff --git a/arch/sparc/math-emu/sfp-util_32.h b/arch/sparc/math-emu/sfp-util_32.h
index d1b2aff..0ea35af 100644
--- a/arch/sparc/math-emu/sfp-util_32.h
+++ b/arch/sparc/math-emu/sfp-util_32.h
@@ -107,9 +107,3 @@
 
 #define abort()								\
 	return 0
-
-#ifdef __BIG_ENDIAN
-#define __BYTE_ORDER __BIG_ENDIAN
-#else
-#define __BYTE_ORDER __LITTLE_ENDIAN
-#endif
diff --git a/arch/sparc/math-emu/sfp-util_64.h b/arch/sparc/math-emu/sfp-util_64.h
index 425d3cf..d17c9bc 100644
--- a/arch/sparc/math-emu/sfp-util_64.h
+++ b/arch/sparc/math-emu/sfp-util_64.h
@@ -112,9 +112,3 @@
 
 #define abort() \
 	return 0
-
-#ifdef __BIG_ENDIAN
-#define __BYTE_ORDER __BIG_ENDIAN
-#else
-#define __BYTE_ORDER __LITTLE_ENDIAN
-#endif
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index 89bbf4e..7b1aaa2 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -195,11 +195,11 @@ static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
 
 
 
-#if BYTE_ORDER == LITTLE_ENDIAN
+#if __BYTE_ORDER == __LITTLE_ENDIAN
 #define le16_to_cpu(val) (val)
 #define le32_to_cpu(val) (val)
 #endif
-#if BYTE_ORDER == BIG_ENDIAN
+#if __BYTE_ORDER == __BIG_ENDIAN
 #define le16_to_cpu(val) bswap_16(val)
 #define le32_to_cpu(val) bswap_32(val)
 #endif
diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index 3c80fd7..d53a67d 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -7,6 +7,9 @@
 #ifndef __BIG_ENDIAN_BITFIELD
 #define __BIG_ENDIAN_BITFIELD
 #endif
+#ifndef __BYTE_ORDER
+#define __BYTE_ORDER __BIG_ENDIAN
+#endif
 
 #include <linux/types.h>
 #include <linux/swab.h>
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index 83195fb..f7f8ad1 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -7,6 +7,9 @@
 #ifndef __LITTLE_ENDIAN_BITFIELD
 #define __LITTLE_ENDIAN_BITFIELD
 #endif
+#ifndef __BYTE_ORDER
+#define __BYTE_ORDER __LITTLE_ENDIAN
+#endif
 
 #include <linux/types.h>
 #include <linux/swab.h>
-- 
1.6.4.4

