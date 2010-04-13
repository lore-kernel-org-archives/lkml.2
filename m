Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0DMCqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 22:46:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38793 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0DMCqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 22:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CgRJvRni5KL+mVoJloxLqnMN2Rb7F+HiykuZlh3HB7nO+23MTXaSX7Hs/NGW8VHUG4
         j1q9aKj5woY9gaBBbhOaq8RhqnFE4y6Kp7Fkwks0cUJA38xir0D+d3CaMyGUzEITdkO4
         yNo4fUenLJTmuZ+q3uIQiLuINMlAbZEdmp//Y=
Date: Tue, 13 Apr 2010 10:52:28 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, zippel@linux-m68k.org
Subject: [PATCH] Kconfig: Make config Filter access to /dev/mem default y
Message-ID: <20100413025228.GC10860@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, most company start use >=2.6.31 kernels to replace redhat kernels.
But the config "Filter access to /dev/mem" is "default n", that allows kernel
rootkit using /dev/mem again. it could access all kernel memory default. Most 
administrator don't known the "Filter access to /dev/mem" is "defult N", when
he compiles the kernel, it's easily to be attacked by rootkit.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com> 

---
 arch/x86/Kconfig.debug            |    3 ++-
 arch/x86/configs/i386_defconfig   |    2 +-
 arch/x86/configs/x86_64_defconfig |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bc01e3e..733aea6 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -7,6 +7,7 @@ source "lib/Kconfig.debug"
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
+	default y
 	---help---
 	  If this option is disabled, you allow userspace (root) access to all
 	  of memory, including kernel and userspace memory. Accidental
@@ -20,7 +21,7 @@ config STRICT_DEVMEM
 	  This is sufficient for dosemu and X and all common users of
 	  /dev/mem.
 
-	  If in doubt, say Y.
+	  If in doubt, say N.
 
 config X86_VERBOSE_BOOTUP
 	bool "Enable verbose x86 bootup info messages"
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index d28fad1..95c85a8 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -2386,7 +2386,7 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
-# CONFIG_STRICT_DEVMEM is not set
+CONFIG_STRICT_DEVMEM=y
 CONFIG_X86_VERBOSE_BOOTUP=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_EARLY_PRINTK_DBGP=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 6c86acd..659bfe7 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -2360,7 +2360,7 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
-# CONFIG_STRICT_DEVMEM is not set
+CONFIG_STRICT_DEVMEM=y
 CONFIG_X86_VERBOSE_BOOTUP=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_EARLY_PRINTK_DBGP=y
-- 
1.6.5.3

