Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab2JCQtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:49:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51526 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964991Ab2JCQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:49:16 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] Clean up the long arch list for the DEBUG_BUGVERBOSE config option
Date: Wed,  3 Oct 2012 17:44:25 +0100
Message-Id: <1349282666-32100-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces HAVE_DEBUG_BUGVERBOSE config option and selects it
in corresponding architecture Kconfig files. Architectures that already
select GENERIC_BUG don't need to select HAVE_DEBUG_BUGVERBOSE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm64/Kconfig |    1 +
 arch/frv/Kconfig   |    1 +
 arch/m32r/Kconfig  |    1 +
 arch/m68k/Kconfig  |    1 +
 arch/sh/Kconfig    |    1 +
 arch/sparc/Kconfig |    1 +
 arch/tile/Kconfig  |    1 +
 lib/Kconfig.debug  |    8 ++++----
 8 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5dc9273..a308560 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -10,6 +10,7 @@ config ARM64
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index b885519..ac99638 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -11,6 +11,7 @@ config FRV
 	select GENERIC_CPU_DEVICES
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_UID16
+	select HAVE_DEBUG_BUGVERBOSE
 
 config ZONE_DMA
 	bool
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 49498bb..caabdb7 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -13,6 +13,7 @@ config M32R
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
+	select HAVE_DEBUG_BUGVERBOSE
 
 config SBUS
 	bool
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2517e4f..3b945a3 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -14,6 +14,7 @@ config M68K
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
 	select HAVE_UID16
+	select HAVE_DEBUG_BUGVERBOSE
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index cb5a22e..076a834 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -37,6 +37,7 @@ config SUPERH
 	select GENERIC_STRNLEN_USER
 	select HAVE_UID16
 	select HAVE_DEBUG_KMEMLEAK
+	select HAVE_DEBUG_BUGVERBOSE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a69bc77b..2006ddc 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -37,6 +37,7 @@ config SPARC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_DEBUG_BUGVERBOSE
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index afb3abd..e38ae98 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -18,6 +18,7 @@ config TILE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select HAVE_DEBUG_KMEMLEAK
+	select HAVE_DEBUG_BUGVERBOSE
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 63dfc4c..5636bfd 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -750,12 +750,12 @@ config DEBUG_HIGHMEM
 	  This options enables addition error checking for high memory systems.
 	  Disable for production systems.
 
+config HAVE_DEBUG_BUGVERBOSE
+	bool
+
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
-	depends on BUG
-	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
-		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || \
-		   TILE || ARM64
+	depends on BUG && (GENERIC_BUG || HAVE_DEBUG_BUGVERBOSE)
 	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
