Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1JNMaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:30:24 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58561 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab1JNMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:30:20 -0400
Subject: [PATCH 14/21] mips: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:29:51 +0200
Message-ID: <1318595391.6132.72.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/mips/Kconfig              |   14 --------------
 arch/mips/powertv/Kconfig      |    2 --
 arch/mips/powertv/asic/Kconfig |   28 ----------------------------
 3 files changed, 0 insertions(+), 44 deletions(-)
 delete mode 100644 arch/mips/powertv/asic/Kconfig

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b122adc..6b1e0dd 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -823,10 +823,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config ARCH_SUPPORTS_OPROFILE
-	bool
-	default y if !MIPS_MT_SMTC
-
 config GENERIC_HWEIGHT
 	bool
 	default y
@@ -2258,16 +2254,6 @@ config HZ
 
 source "kernel/Kconfig.preempt"
 
-config MIPS_INSANE_LARGE
-	bool "Support for large 64-bit configurations"
-	depends on CPU_R10000 && 64BIT
-	help
-	  MIPS R10000 does support a 44 bit / 16TB address space as opposed to
-	  previous 64-bit processors which only supported 40 bit / 1TB. If you
-	  need processes of more than 1TB virtual address space, say Y here.
-	  This will result in additional memory usage, so it is not
-	  recommended for normal users.
-
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/arch/mips/powertv/Kconfig b/arch/mips/powertv/Kconfig
index ff0e7e3..1a1b03e 100644
--- a/arch/mips/powertv/Kconfig
+++ b/arch/mips/powertv/Kconfig
@@ -1,5 +1,3 @@
-source "arch/mips/powertv/asic/Kconfig"
-
 config BOOTLOADER_DRIVER
 	bool "PowerTV Bootloader Driver Support"
 	default n
diff --git a/arch/mips/powertv/asic/Kconfig b/arch/mips/powertv/asic/Kconfig
deleted file mode 100644
index 2016bfe..0000000
--- a/arch/mips/powertv/asic/Kconfig
+++ /dev/null
@@ -1,28 +0,0 @@
-config MIN_RUNTIME_RESOURCES
-	bool "Support for minimum runtime resources"
-	default n
-	depends on POWERTV
-	help
-	  Enables support for minimizing the number of (SA asic) runtime
-	  resources that are preallocated by the kernel.
-
-config MIN_RUNTIME_DOCSIS
-	bool "Support for minimum DOCSIS resource"
-	default y
-	depends on MIN_RUNTIME_RESOURCES
-	help
-	  Enables support for the preallocated DOCSIS resource.
-
-config MIN_RUNTIME_PMEM
-	bool "Support for minimum PMEM resource"
-	default y
-	depends on MIN_RUNTIME_RESOURCES
-	help
-	  Enables support for the preallocated Memory resource.
-
-config MIN_RUNTIME_TFTP
-	bool "Support for minimum TFTP resource"
-	default y
-	depends on MIN_RUNTIME_RESOURCES
-	help
-	  Enables support for the preallocated TFTP resource.
-- 
1.7.4.4




