Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161047Ab1FADLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:11:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161028Ab1FADLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N9/0sUVq7j142PpflCjGScE0QmUGuBlGn0Syo5zEP6XH6jjRKZAaX4v2mUZVoS9ouc
         luKC26o7AprujcHBnce3x3hPhWysFv0w4J59tAmOhzcsVZ/qXNmyVo5eX2c1d2JGpIVV
         cvroeNsHCjbK/NkqblKf5oVAFNHQDYJhiqxQ0=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 11/13] powerpc: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Tue, 31 May 2011 22:10:43 -0500
Message-Id: <1306897845-9393-11-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
system call numbering for execve and selecting HAVE_SECCOMP_FILTER.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/powerpc/Kconfig               |    1 +
 arch/powerpc/include/asm/seccomp.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8f4d50b..0bd4574 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select HAVE_SECCOMP_FILTER
 	select IRQ_PER_CPU
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
diff --git a/arch/powerpc/include/asm/seccomp.h b/arch/powerpc/include/asm/seccomp.h
index 00c1d91..3cb9cc1 100644
--- a/arch/powerpc/include/asm/seccomp.h
+++ b/arch/powerpc/include/asm/seccomp.h
@@ -7,10 +7,12 @@
 #define __NR_seccomp_write __NR_write
 #define __NR_seccomp_exit __NR_exit
 #define __NR_seccomp_sigreturn __NR_rt_sigreturn
+#define __NR_seccomp_execve __NR_execve
 
 #define __NR_seccomp_read_32 __NR_read
 #define __NR_seccomp_write_32 __NR_write
 #define __NR_seccomp_exit_32 __NR_exit
 #define __NR_seccomp_sigreturn_32 __NR_sigreturn
+#define __NR_seccomp_execve_32 __NR_execve
 
 #endif	/* _ASM_POWERPC_SECCOMP_H */
-- 
1.7.0.4

