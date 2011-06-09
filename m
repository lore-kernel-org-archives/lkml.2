Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1FILVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:21:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:57219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab1FILVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:21:44 -0400
Date: Thu, 9 Jun 2011 11:21:18 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-ee65d52682535ea1343acb672898ed3c362e185c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, gerhard_pircher@gmx.net, benh@kernel.crashing.org,
        ralf@linux-mips.org, mattst88@gmail.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, gerhard_pircher@gmx.net,
        benh@kernel.crashing.org, ralf@linux-mips.org, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
In-Reply-To: <20110601180610.984881988@duck.linux-mips.net>
References: <20110601180610.984881988@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] pcspkr: Cleanup Kconfig dependencies
Git-Commit-ID: ee65d52682535ea1343acb672898ed3c362e185c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:21:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee65d52682535ea1343acb672898ed3c362e185c
Gitweb:     http://git.kernel.org/tip/ee65d52682535ea1343acb672898ed3c362e185c
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:09 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:52 +0200

pcspkr: Cleanup Kconfig dependencies

Lenghty lists of the kind "depends on ARCH1 || ARCH2 ... || ARCH123" are
usually either wrong or too coarse grained.  Or plain an ugly sin.

[ tglx: Fixed up amigaone ]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-alpha@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Gerhard Pircher <gerhard_pircher@gmx.net>
Link: http://lkml.kernel.org/r/20110601180610.984881988@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/alpha/Kconfig                      |    1 +
 arch/mips/Kconfig                       |    1 +
 arch/powerpc/platforms/amigaone/Kconfig |    2 +-
 arch/powerpc/platforms/chrp/Kconfig     |    1 +
 arch/powerpc/platforms/prep/Kconfig     |    1 +
 arch/powerpc/platforms/pseries/Kconfig  |    1 +
 arch/x86/Kconfig                        |    1 +
 init/Kconfig                            |    6 +++++-
 8 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 60219bf..ca2da8d 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -6,6 +6,7 @@ config ALPHA
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_IRQ_WORK
+	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..bf35bb6 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -5,6 +5,7 @@ config MIPS
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IRQ_WORK
+	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
diff --git a/arch/powerpc/platforms/amigaone/Kconfig b/arch/powerpc/platforms/amigaone/Kconfig
index 0224767..128de25 100644
--- a/arch/powerpc/platforms/amigaone/Kconfig
+++ b/arch/powerpc/platforms/amigaone/Kconfig
@@ -8,7 +8,7 @@ config AMIGAONE
 	select NOT_COHERENT_CACHE
 	select CHECK_CACHE_COHERENCY
 	select DEFAULT_UIMAGE
-	select PCSPKR_PLATFORM
+	select HAVE_PCSPKR_PLATFORM
 	help
 	Select AmigaOne for the following machines:
 	- AmigaOne SE/Teron CX (G3 only)
diff --git a/arch/powerpc/platforms/chrp/Kconfig b/arch/powerpc/platforms/chrp/Kconfig
index bc0b0ef..d3cdab5 100644
--- a/arch/powerpc/platforms/chrp/Kconfig
+++ b/arch/powerpc/platforms/chrp/Kconfig
@@ -1,6 +1,7 @@
 config PPC_CHRP
 	bool "Common Hardware Reference Platform (CHRP) based machines"
 	depends on 6xx
+	select HAVE_PCSPKR_PLATFORM
 	select MPIC
 	select PPC_I8259
 	select PPC_INDIRECT_PCI
diff --git a/arch/powerpc/platforms/prep/Kconfig b/arch/powerpc/platforms/prep/Kconfig
index bf8330e..f0536c7 100644
--- a/arch/powerpc/platforms/prep/Kconfig
+++ b/arch/powerpc/platforms/prep/Kconfig
@@ -1,6 +1,7 @@
 config PPC_PREP
 	bool "PowerPC Reference Platform (PReP) based machines"
 	depends on 6xx && BROKEN
+	select HAVE_PCSPKR_PLATFORM
 	select MPIC
 	select PPC_I8259
 	select PPC_INDIRECT_PCI
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 71af4c5..05cf476 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -1,6 +1,7 @@
 config PPC_PSERIES
 	depends on PPC64 && PPC_BOOK3S
 	bool "IBM pSeries & new (POWER5-based) iSeries"
+	select HAVE_PCSPKR_PLATFORM
 	select MPIC
 	select PCI_MSI
 	select PPC_XICS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..c2aa5ac 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..68c231c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -999,14 +999,18 @@ config ELF_CORE
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
+
 config PCSPKR_PLATFORM
 	bool "Enable PC-Speaker support" if EXPERT
-	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on HAVE_PCSPKR_PLATFORM
 	default y
 	help
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
+config HAVE_PCSPKR_PLATFORM
+	bool
+
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EXPERT
