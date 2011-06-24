Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab1FXAkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:40:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39699 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab1FXAiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nj6SN1E6Sz4fM/xmZGezPK5/0qta4Sqfk+nn5fe94mXe7I0ICumJRFYEdOsglfPYDy
         deESc6y3gMvL70tLXAkfo8XKdITYjmVySKh002EfxKfEgqxnERt/4+8wyQJSZ2khqdtK
         UsKo3Rd7vRhojz8NgLJJoTyqdOtSx0F9ZiKk0=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH v9 06/13] x86: add HAVE_SECCOMP_FILTER and seccomp_execve
Date: Thu, 23 Jun 2011 19:36:45 -0500
Message-Id: <1308875813-20122-6-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308875813-20122-1-git-send-email-wad@chromium.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to the x86 architecture by providing a compatibility
mode wrapper for sys_execve's number and selecting HAVE_SECCOMP_FILTER

v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/ia32_unistd.h |    1 +
 arch/x86/include/asm/seccomp_64.h  |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..c3b7d3b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -63,6 +63,7 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select HAVE_SECCOMP_FILTER
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
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

