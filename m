Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KZQ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:28:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50635 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0KZQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gx5prFlvD88L8z07xdR7VkL8kTMmuf4gjoVnmJH0eP8d7ZbD6dOakPYmNTiRgvT3QV
         dgz7gqi9yUwXdbltgX4LeuwZ1LH1AneeMvJqDDJaw03C4sqE3c0ZddM9Rhzfn+yKspOh
         xCXDYdMfqnM7KlRXOwroIUcmf9h2hObQHPCvA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] bitops: introduce CONFIG_GENERIC_FIND_LE_BIT
Date: Sat, 27 Nov 2010 01:28:39 +0900
Message-Id: <1290788919-5057-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290788919-5057-1-git-send-email-akinobu.mita@gmail.com>
References: <1290788919-5057-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The little-endian bitops patch series broke the build on m68knommu.

lib/find_next_bit.c:190: error: conflicting types for 'find_next_zero_le_bit'
/home/mita/scm/linux-2.6/arch/m68k/include/asm/bitops_no.h:286: error: previous
definition of 'find_next_zero_le_bit' was here

Because m68knommu selects CONFIG_GENERIC_FIND_NEXT_BIT, it redefines
find_next_zero_le_bit() in lib/find_next_bit.c.

This introduces CONFIG_GENERIC_FIND_NEXT_BIT to tell whether to use generic
implementation of find_*_le_bit() in lib/find_next_bit.c or not.  It will not
be selected by m68knommu to fix build failure.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/frv/Kconfig        |    4 ++++
 arch/h8300/Kconfig      |    4 ++++
 arch/m32r/Kconfig       |    4 ++++
 arch/microblaze/Kconfig |    3 +++
 arch/mips/Kconfig       |    4 ++++
 arch/parisc/Kconfig     |    4 ++++
 arch/powerpc/Kconfig    |    4 ++++
 arch/sh/Kconfig         |    3 +++
 arch/sparc/Kconfig      |    4 ++++
 arch/xtensa/Kconfig     |    3 +++
 lib/Kconfig             |    3 +++
 lib/Makefile            |    1 +
 lib/find_next_bit.c     |    3 +++
 13 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index f6bcb03..77deacd 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -21,6 +21,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 65f897d8..02de073 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -43,6 +43,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 5c291d6..df2e01a 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -265,6 +265,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 387d5ff..5f29d63 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -34,6 +34,9 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_LE_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 67a2fa2..0ca01a2 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -753,6 +753,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 0888675..ca59250 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -48,6 +48,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_BUG
 	bool
 	default y
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e625e9e..ac44ad9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -104,6 +104,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_GPIO
 	bool
 	help
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 7f217b3..0438776 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -72,6 +72,9 @@ config GENERIC_CSUM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_LE_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 45d9c87..af40adf 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -194,6 +194,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y if !ULTRA_HAS_POPULATION_COUNT
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d373d15..d20d434 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -21,6 +21,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_LE_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/lib/Kconfig b/lib/Kconfig
index fa9bf2c..2e5df8e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -22,6 +22,9 @@ config GENERIC_FIND_FIRST_BIT
 config GENERIC_FIND_NEXT_BIT
 	bool
 
+config GENERIC_FIND_LE_BIT
+	bool
+
 config GENERIC_FIND_LAST_BIT
 	bool
 	default y
diff --git a/lib/Makefile b/lib/Makefile
index e6a3763..a3265d6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -38,6 +38,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
+lib-$(CONFIG_GENERIC_FIND_LE_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index eb8934b..b7047d1 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -160,6 +160,7 @@ EXPORT_SYMBOL(find_first_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
+#ifdef CONFIG_GENERIC_FIND_LE_BIT
 
 /* include/linux/byteorder does not support "unsigned long" type */
 static inline unsigned long ext2_swabp(const unsigned long * x)
@@ -271,4 +272,6 @@ found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_le_bit);
+
+#endif /* CONFIG_GENERIC_FIND_LE_BIT */
 #endif /* __BIG_ENDIAN */
-- 
1.7.3.2

