Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1FCUc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:32:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65232 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1FCUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UzI4AlUAt6QlyiCNps2AgV1cRn6DV9DWjj/TVFOwHeUJ7I1c4lPYBFN7jVa/V4VB45
         e8sI6jsa8suSeCxliC92ixUtETf61XNv1C/1knxSmsa0+ypo35IG9GTAmDaR44yLxALk
         xAMAw5+5e51U/dvNdHUDUU+HNg7Z8R3+FSB44=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        paulmck@linux.vnet.ibm.com, Will Drewry <wad@chromium.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v4 12/13] sparc: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Fri,  3 Jun 2011 15:34:11 -0500
Message-Id: <1307133252-23259-12-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307133252-23259-1-git-send-email-wad@chromium.org>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
system call numbering for execve and selecting HAVE_SECCOMP_FILTER.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/sparc/Kconfig               |    2 ++
 arch/sparc/include/asm/seccomp.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e560d10..5249760 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -25,6 +25,7 @@ config SPARC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_SECCOMP_FILTER
 
 config SPARC32
 	def_bool !64BIT
@@ -39,6 +40,7 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
+	select HAVE_SECCOMP_FILTER
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/sparc/include/asm/seccomp.h b/arch/sparc/include/asm/seccomp.h
index adca1bc..a1dac08 100644
--- a/arch/sparc/include/asm/seccomp.h
+++ b/arch/sparc/include/asm/seccomp.h
@@ -6,10 +6,12 @@
 #define __NR_seccomp_write __NR_write
 #define __NR_seccomp_exit __NR_exit
 #define __NR_seccomp_sigreturn __NR_rt_sigreturn
+#define __NR_seccomp_execve __NR_execve
 
 #define __NR_seccomp_read_32 __NR_read
 #define __NR_seccomp_write_32 __NR_write
 #define __NR_seccomp_exit_32 __NR_exit
 #define __NR_seccomp_sigreturn_32 __NR_sigreturn
+#define __NR_seccomp_execve_32 __NR_execve
 
 #endif /* _ASM_SECCOMP_H */
-- 
1.7.0.4

