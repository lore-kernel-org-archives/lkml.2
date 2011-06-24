Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab1FXAju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:39:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64444 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326Ab1FXAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZXygYsUYDehh0fr7yjcXy2HBLa5oaR2y1wfO/NqvxoxbBA6jF2JnAupHWkhoN6m56+
         tmP5KbG7ewfsY0UOD644s6tvC5wRWy/fuywWoEwHNoF+Wlv26j5ElmQ1AfngGoazVaPk
         N8nn8MJ93XpYJG/Bhg7Xxd+25jiTcwE9tbJh4=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v9 08/13] microblaze: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Thu, 23 Jun 2011 19:36:47 -0500
Message-Id: <1308875813-20122-8-git-send-email-wad@chromium.org>
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
 arch/microblaze/Kconfig               |    1 +
 arch/microblaze/include/asm/seccomp.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index e446bab..dd570cc 100644
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

