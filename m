Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1FCUdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:33:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65232 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1FCUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aeXlXquXvp2Q0QnWrtY3PtHykHFoeRqETyl3wmwXaeeDQDKHuNwuh3zwqv7XSjRHIN
         FYcfx96xt2lJuxKGioDGNZxlfvvbQZ08wFsdcnzDJP/8zv9uJvhfA5hMk5LHwtHBPmD3
         t1XYdgeY0GLC+YCmhLN8+3uk3JCWtWauP4VcA=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        paulmck@linux.vnet.ibm.com, Will Drewry <wad@chromium.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v4 10/13] s390: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Fri,  3 Jun 2011 15:34:09 -0500
Message-Id: <1307133252-23259-10-git-send-email-wad@chromium.org>
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
 arch/s390/Kconfig               |    1 +
 arch/s390/include/asm/seccomp.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2508a6f..9382198 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -64,6 +64,7 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 config S390
 	def_bool y
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select HAVE_SECCOMP_FILTER
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
diff --git a/arch/s390/include/asm/seccomp.h b/arch/s390/include/asm/seccomp.h
index 781a9cf..e5792f5 100644
--- a/arch/s390/include/asm/seccomp.h
+++ b/arch/s390/include/asm/seccomp.h
@@ -7,10 +7,11 @@
 #define __NR_seccomp_write	__NR_write
 #define __NR_seccomp_exit	__NR_exit
 #define __NR_seccomp_sigreturn	__NR_sigreturn
+#define __NR_seccomp_execve	__NR_execve
 
 #define __NR_seccomp_read_32	__NR_read
 #define __NR_seccomp_write_32	__NR_write
 #define __NR_seccomp_exit_32	__NR_exit
-#define __NR_seccomp_sigreturn_32 __NR_sigreturn
+#define __NR_seccomp_execve_32	__NR_execve
 
 #endif	/* _ASM_S390_SECCOMP_H */
-- 
1.7.0.4

