Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1FCUcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:32:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47512 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1FCUcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ePFVNAf5eemLx/v2nv6TYvE9Z9okRyRuaLUhj2CZ35KmGkkbE4Yn4iCsHuW9/l9AmL
         oRK8xTxWnOAQ4y2KvRWpLWDDEqsorB/28o+ePVqhjeLCmwjpCxG5DO1uMuFYKqqZ/cFH
         g46Z5tpehJka8fAqz8rOI2Glr2wxCdP+xFa2w=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        paulmck@linux.vnet.ibm.com, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH v4 06/13] x86: add HAVE_SECCOMP_FILTER and seccomp_execve
Date: Fri,  3 Jun 2011 15:34:05 -0500
Message-Id: <1307133252-23259-6-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307133252-23259-1-git-send-email-wad@chromium.org>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to the x86 architecture by providing a compatibility
mode wrapper for sys_execve's number and selecting HAVE_SECCOMP_FILTER

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/ia32_unistd.h |    1 +
 arch/x86/include/asm/seccomp_64.h  |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..1843d17 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -64,6 +64,7 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select HAVE_SECCOMP_FILTER
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
diff --git a/arch/x86/include/asm/ia32_unistd.h b/arch/x86/include/asm/ia32_unistd.h
index 976f6ec..8ed2922 100644
--- a/arch/x86/include/asm/ia32_unistd.h
+++ b/arch/x86/include/asm/ia32_unistd.h
@@ -12,6 +12,7 @@
 #define __NR_ia32_exit		  1
 #define __NR_ia32_read		  3
 #define __NR_ia32_write		  4
+#define __NR_ia32_execve	 11
 #define __NR_ia32_sigreturn	119
 #define __NR_ia32_rt_sigreturn	173
 
diff --git a/arch/x86/include/asm/seccomp_64.h b/arch/x86/include/asm/seccomp_64.h
index 84ec1bd..85c4219 100644
--- a/arch/x86/include/asm/seccomp_64.h
+++ b/arch/x86/include/asm/seccomp_64.h
@@ -8,10 +8,12 @@
 #define __NR_seccomp_write __NR_write
 #define __NR_seccomp_exit __NR_exit
 #define __NR_seccomp_sigreturn __NR_rt_sigreturn
+#define __NR_seccomp_execve __NR_execve
 
 #define __NR_seccomp_read_32 __NR_ia32_read
 #define __NR_seccomp_write_32 __NR_ia32_write
 #define __NR_seccomp_exit_32 __NR_ia32_exit
 #define __NR_seccomp_sigreturn_32 __NR_ia32_sigreturn
+#define __NR_seccomp_execve_32 __NR_ia32_execve
 
 #endif /* _ASM_X86_SECCOMP_64_H */
-- 
1.7.0.4

