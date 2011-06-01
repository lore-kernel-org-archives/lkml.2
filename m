Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161026Ab1FADLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:11:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab1FADK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mZNaOWw1EOk0erk512fk3a7xy8zOA9WKbI6FEahvylqiezLl4Ni9g2pEnAxEdf7UlH
         2CEVnJiz80S17N1+VMKJ8ijXmCuVpsr47kAZNKk3P/j5WVVZY//cl6vSg5RXTDD8WYTo
         qFUZc7Wjm1gN+s+SjP6KIYWqwz5wfb5ERgz/M=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v3 08/13] microblaze: select HAVE_SECCOMP_FILTER and provide seccomp_execve
Date: Tue, 31 May 2011 22:10:40 -0500
Message-Id: <1306897845-9393-8-git-send-email-wad@chromium.org>
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

