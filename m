Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1KNWaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:30:52 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:57349 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1KNWav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:30:51 -0500
Subject: [PATCH] powerpc/44x: Fix typos '47x' and 'CONFIG_47x'
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Suzuki Poulose <suzuki@in.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 23:30:27 +0100
Message-ID: <1321309827.20271.146.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 674bfa4855 ("powerpc/44x: Kexec support for PPC440X chipsets")
used the Kconfig symbol '47x', and the macro 'CONFIG_47x'. Neither
exist. These should have been 'PPC_47x' and 'CONFIG_PPC_47x'. Fix these
typos.

Also fix a related preprocessor check at the top of kexec.h.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The commit explanation sounds very confident, but this is all just
educated guesswork. Entirely untested too (I haven't got the hardware
nor the toolchain). So this needs careful review. 

 arch/powerpc/Kconfig             |    2 +-
 arch/powerpc/include/asm/kexec.h |    3 ++-
 arch/powerpc/kernel/misc_32.S    |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b177caa..951e18f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -345,7 +345,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP && !47x)) && EXPERIMENTAL
+	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP && !PPC_47x)) && EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index f921eb1..fadf513 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -2,7 +2,8 @@
 #define _ASM_POWERPC_KEXEC_H
 #ifdef __KERNEL__
 
-#if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_44x)
+#if defined(CONFIG_FSL_BOOKE) || \
+	(defined(CONFIG_44x) && !defined(CONFIG_PPC_47x))
 
 /*
  * On FSL-BookE we setup a 1:1 mapping which covers the first 2GiB of memory
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index f7d760a..7cd07b4 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -738,7 +738,7 @@ relocate_new_kernel:
 	mr      r5, r31
 
 	li	r0, 0
-#elif defined(CONFIG_44x)  && !defined(CONFIG_47x)
+#elif defined(CONFIG_44x)  && !defined(CONFIG_PPC_47x)
 
 /*
  * Code for setting up 1:1 mapping for PPC440x for KEXEC
-- 
1.7.4.4



