Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2JDQU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:20:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43826 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757132Ab2JDQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:20:27 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 3/4] Clean up the long arch list for the DEBUG_BUGVERBOSE config option
Date: Thu,  4 Oct 2012 17:15:56 +0100
Message-Id: <1349367357-13865-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
References: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces HAVE_DEBUG_BUGVERBOSE config option and selects it
in corresponding architecture Kconfig files. Architectures that already
select GENERIC_BUG don't need to select HAVE_DEBUG_BUGVERBOSE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
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
index cc5709d..9d26264 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -8,6 +8,7 @@ config FRV
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
 	select ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 49498bb..e875fc3 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ config M32R
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 3e2b2f6..dae1e7e 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -3,6 +3,7 @@ config M68K
 	default y
 	select HAVE_IDE
 	select HAVE_AOUT if MMU
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index cfbf3e3..3b3e27a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -13,6 +13,7 @@ config SUPERH
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 274d6cf..700a01a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -32,6 +32,7 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select HAVE_BPF_JIT
+	select HAVE_DEBUG_BUGVERBOSE
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 9a0d77d..df69d42 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -14,6 +14,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
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
