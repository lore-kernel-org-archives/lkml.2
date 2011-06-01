Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006Ab1FADK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:10:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47719 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab1FADKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TuCyvVsdrPHbe2088eASneyhYsBzZPWgWsaSR1wrzsIRD0J8VIOwV5xDlEhEdG0DC9
         AEH0wHFweQ25feybpsrO1/cPI+ygbIdr4ObE03B/D/SoTJSTFBmXWdkI380/dwfVY/Jz
         WtSf11pvZG/OOWZ7lrhXnC0kIuQTNT0K9Fhyc=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v3 06/13] x86: add HAVE_SECCOMP_FILTER and seccomp_execve
Date: Tue, 31 May 2011 22:10:38 -0500
Message-Id: <1306897845-9393-6-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
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

