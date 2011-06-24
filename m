Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab1FXAiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:38:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64444 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897Ab1FXAiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Cu7SZjN9xg4Rg/Jwps+H+63wKMgC4G75GZcQiuk7inBazsIG6IBIzHqIYep7wbI7Se
         Y4VuZGoOIaATgHjBQtLPhXNhHI3l44AerItNlKyeh61tRZZVVxaqr9VOwrYaHGuxEEZk
         d5GzG5mFB0HvXIpfbl0s/Wg0U91t5dDsWsmhE=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH v9 09/13] mips: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Thu, 23 Jun 2011 19:36:48 -0500
Message-Id: <1308875813-20122-9-git-send-email-wad@chromium.org>
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
 arch/mips/Kconfig               |    1 +
 arch/mips/include/asm/seccomp.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..29b0848 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -10,6 +10,7 @@ config MIPS
 	select HAVE_ARCH_KGDB
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_SECCOMP_FILTER
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_C_RECORDMCOUNT
diff --git a/arch/mips/include/asm/seccomp.h b/arch/mips/include/asm/seccomp.h
index ae6306e..4014a3a 100644
--- a/arch/mips/include/asm/seccomp.h
+++ b/arch/mips/include/asm/seccomp.h
@@ -6,6 +6,7 @@
 #define __NR_seccomp_write __NR_write
 #define __NR_seccomp_exit __NR_exit
 #define __NR_seccomp_sigreturn __NR_rt_sigreturn
+#define __NR_seccomp_execve __NR_execve
 
 /*
  * Kludge alert:
@@ -19,6 +20,7 @@
 #define __NR_seccomp_write_32		4004
 #define __NR_seccomp_exit_32		4001
 #define __NR_seccomp_sigreturn_32	4193	/* rt_sigreturn */
+#define __NR_seccomp_execve_32		4011
 
 #elif defined(CONFIG_MIPS32_N32)
 
@@ -26,6 +28,7 @@
 #define __NR_seccomp_write_32		6001
 #define __NR_seccomp_exit_32		6058
 #define __NR_seccomp_sigreturn_32	6211	/* rt_sigreturn */
+#define __NR_seccomp_execve_32		6057
 
 #endif /* CONFIG_MIPS32_O32 */
 
-- 
1.7.0.4

