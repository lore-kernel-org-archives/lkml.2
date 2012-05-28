Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2E1Snl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:43:41 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40549 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2E1Snj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:43:39 -0400
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Vincent Sanders <vince@collabora.co.uk>,
        Vincent Sanders <vincent.sanders@collabora.co.uk>
Subject: [PATCH 2/2] Enable gcov support on the ARM architecture
Date: Mon, 28 May 2012 19:33:38 +0100
Message-Id: <1338230018-31052-3-git-send-email-vincent.sanders@collabora.co.uk>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Sanders <vince@collabora.co.uk>

Enable gcov support for ARM based on original patches by David
Singleton and George G. Davis

Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
---
 arch/arm/boot/bootp/Makefile      |    2 ++
 arch/arm/boot/compressed/Makefile |    2 ++
 arch/arm/include/asm/elf.h        |    1 +
 arch/arm/kernel/module.c          |    1 +
 kernel/gcov/Kconfig               |    2 +-
 5 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/bootp/Makefile b/arch/arm/boot/bootp/Makefile
index c394e30..5761f00 100644
--- a/arch/arm/boot/bootp/Makefile
+++ b/arch/arm/boot/bootp/Makefile
@@ -5,6 +5,8 @@
 # architecture-specific flags and dependencies.
 #
 
+GCOV_PROFILE	:= n
+
 LDFLAGS_bootp	:=-p --no-undefined -X \
 		 --defsym initrd_phys=$(INITRD_PHYS) \
 		 --defsym params_phys=$(PARAMS_PHYS) -T
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index bb26756..7482fcd 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -30,6 +30,8 @@ FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
 OBJS		+= string.o
 CFLAGS_string.o	:= -Os
 
+GCOV_PROFILE		:= n
+
 #
 # Architecture dependencies
 #
diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 38050b1..64afbd0 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -52,6 +52,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_ABS32		2
 #define R_ARM_CALL		28
 #define R_ARM_JUMP24		29
+#define R_ARM_TARGET1		38
 #define R_ARM_V4BX		40
 #define R_ARM_PREL31		42
 #define R_ARM_MOVW_ABS_NC	43
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 1e9be5d..b22fc22 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -89,6 +89,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			break;
 
 		case R_ARM_ABS32:
+		case R_ARM_TARGET1:
 			*(u32 *)loc += sym->st_value;
 			break;
 
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index a920281..2a02dae 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -35,7 +35,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || (PPC && EXPERIMENTAL) || MICROBLAZE
+	depends on SUPERH || S390 || X86 || (PPC && EXPERIMENTAL) || MICROBLAZE || ARM
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
-- 
1.7.10

