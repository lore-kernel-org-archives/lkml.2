Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab1FXAjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:39:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56680 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907Ab1FXAiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TEZsAqMjH1XG14MDTQLCKPfXfbC925K4J2TWbReqqEMcGF8QmQGb7tgFW2KXFWdrrc
         2dEwfA+R7Om2VqEPkw+486Eyotsygsa7ok7iFlzIb9I5mjq2R/nJRsf9QV+b4oAFg6oE
         gq/Vr8Sx+3te9vLTz2eQxxJus17RLKUM7ycLQ=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v9 10/13] s390: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Thu, 23 Jun 2011 19:36:49 -0500
Message-Id: <1308875813-20122-10-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308875813-20122-1-git-send-email-wad@chromium.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
system call numbering for execve and selecting HAVE_SECCOMP_FILTER.

v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/s390/Kconfig               |    1 +
 arch/s390/include/asm/seccomp.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 90d77bd..327d16a 100644
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

