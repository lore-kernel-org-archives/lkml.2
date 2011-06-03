Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1FCUd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:33:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65232 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1FCUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VdbGeOD/jTCtF9VAmHt1Tp6mUpzsq7h0dD6aagiVelzicPJMa0hn0TlWLexGSrIixI
         rIXmhpqS1aJWItojkMJelonkTgiGm6FAPj59bsNsVukwdpHGeS/RHdpeGxe8g8CnS4JJ
         Ftqc/nrSJMR6yPP03WGoDTs4v8YLNIqI0t1Zs=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        paulmck@linux.vnet.ibm.com, Will Drewry <wad@chromium.org>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v4 08/13] microblaze: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Fri,  3 Jun 2011 15:34:07 -0500
Message-Id: <1307133252-23259-8-git-send-email-wad@chromium.org>
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
 arch/microblaze/Kconfig               |    1 +
 arch/microblaze/include/asm/seccomp.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index eccdefe..30ef677 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -1,6 +1,7 @@
 config MICROBLAZE
 	def_bool y
 	select HAVE_MEMBLOCK
+	select HAVE_SECCOMP_FILTER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_GRAPH_TRACER
diff --git a/arch/microblaze/include/asm/seccomp.h b/arch/microblaze/include/asm/seccomp.h
index 0d91275..0e38eed 100644
--- a/arch/microblaze/include/asm/seccomp.h
+++ b/arch/microblaze/include/asm/seccomp.h
@@ -7,10 +7,12 @@
 #define __NR_seccomp_write		__NR_write
 #define __NR_seccomp_exit		__NR_exit
 #define __NR_seccomp_sigreturn		__NR_sigreturn
+#define __NR_seccomp_execve		__NR_execve
 
 #define __NR_seccomp_read_32		__NR_read
 #define __NR_seccomp_write_32		__NR_write
 #define __NR_seccomp_exit_32		__NR_exit
 #define __NR_seccomp_sigreturn_32	__NR_sigreturn
+#define __NR_seccomp_execve_32		__NR_execve
 
 #endif	/* _ASM_MICROBLAZE_SECCOMP_H */
-- 
1.7.0.4

