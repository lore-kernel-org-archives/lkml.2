Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1APNM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:12:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1APNIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r6M54f+ZCJUmCS9NI2em6DERbcmzFWQZbNXRv0chDwEViC7c/9UooVYsubWMsd4Yft
         D93q+Mb6Lg+ssJXwBTG3MmHd5LuFk0XA3lfx78pcrXd0V/0QJypUBdVaeVy+ASAFywX9
         8yboUkqBCtCw85e5fvqOBnKFqRwpDNHO7p4H4=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 07/24] bitops: introduce CONFIG_GENERIC_FIND_BIT_LE
Date: Sun, 16 Jan 2011 22:08:36 +0900
Message-Id: <1295183333-13802-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces CONFIG_GENERIC_FIND_BIT_LE to tell whether to use generic
implementation of find_*_bit_le() in lib/find_next_bit.c or not.

For now we select CONFIG_GENERIC_FIND_BIT_LE for all architectures which
enable CONFIG_GENERIC_FIND_NEXT_BIT.

But m68knommu wants to define own faster find_next_zero_bit_le() and
continues using generic find_next_{,zero_}bit().
(CONFIG_GENERIC_FIND_NEXT_BIT and !CONFIG_GENERIC_FIND_BIT_LE)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation (s/GENERIC_FIND_LE_BIT/GENERIC_FIND_BIT_LE/)

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 arch/frv/Kconfig        |    4 ++++
 arch/h8300/Kconfig      |    4 ++++
 arch/m32r/Kconfig       |    4 ++++
 arch/m68knommu/Kconfig  |    4 ++++
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
 14 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index f6bcb03..e0764f0 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -21,6 +21,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 65f897d8..552219f 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -43,6 +43,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 5c291d6..b30cea3 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -265,6 +265,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index fa9f746..87b46f8 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -40,6 +40,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_GPIO
 	bool
 	default n
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 5f5018a..102d986 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -34,6 +34,9 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_BIT_LE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f489ec3..eb34034 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -755,6 +755,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 0888675..3aeaf16 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -48,6 +48,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_BUG
 	bool
 	default y
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 959f38c..b88d787 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -107,6 +107,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_GPIO
 	bool
 	help
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index fff2522..6ee6d4b 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -73,6 +73,9 @@ config GENERIC_CSUM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_BIT_LE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 45d9c87..085a9b7 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -194,6 +194,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y if !ULTRA_HAS_POPULATION_COUNT
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d373d15..7283919 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -21,6 +21,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_BIT_LE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 0ee67e0..99b8008 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -22,6 +22,9 @@ config GENERIC_FIND_FIRST_BIT
 config GENERIC_FIND_NEXT_BIT
 	bool
 
+config GENERIC_FIND_BIT_LE
+	bool
+
 config GENERIC_FIND_LAST_BIT
 	bool
 	default y
diff --git a/lib/Makefile b/lib/Makefile
index cbb774f..865dc16 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -38,6 +38,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
+lib-$(CONFIG_GENERIC_FIND_BIT_LE) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index c093ba9..19b5fa7 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -160,6 +160,7 @@ EXPORT_SYMBOL(find_first_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
+#ifdef CONFIG_GENERIC_FIND_BIT_LE
 
 /* include/linux/byteorder does not support "unsigned long" type */
 static inline unsigned long ext2_swabp(const unsigned long * x)
@@ -271,4 +272,6 @@ found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_bit_le);
+
+#endif /* CONFIG_GENERIC_FIND_BIT_LE */
 #endif /* __BIG_ENDIAN */
-- 
1.7.3.4

