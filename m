Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab2ITWrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:47:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53934 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab2ITWrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:47:20 -0400
Date: Thu, 20 Sep 2012 15:46:06 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net
Subject: [PATCH] audit: define AUDIT_ARCH_OPENRISC
Message-ID: <20120920224605.GA896@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using audit on OpenRISC, an audit arch is needed. This defines
it and fixes a compile-time bug uncovered in linux-next, likely from a
cut/paste from an arch with 64/32-bit modes that defined arch_arch():
arch/openrisc/kernel/ptrace.c:190:2: error: implicit declaration of function 'audit_arch'

This replaces it with the newly defined AUDIT_ARCH_OPENRISC, since it
is only 32-bit, and currently only operates in big-endian mode.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/openrisc/kernel/ptrace.c |    2 +-
 include/linux/audit.h         |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
index e71781d..71a2a0c 100644
--- a/arch/openrisc/kernel/ptrace.c
+++ b/arch/openrisc/kernel/ptrace.c
@@ -187,7 +187,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
-	audit_syscall_entry(audit_arch(), regs->gpr[11],
+	audit_syscall_entry(AUDIT_ARCH_OPENRISC, regs->gpr[11],
 			    regs->gpr[3], regs->gpr[4],
 			    regs->gpr[5], regs->gpr[6]);
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index d3fe97a..df19592 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -337,6 +337,7 @@ enum {
 #define AUDIT_ARCH_MIPSEL	(EM_MIPS|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_MIPS64	(EM_MIPS|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_MIPSEL64	(EM_MIPS|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
+#define AUDIT_ARCH_OPENRISC	(EM_OPENRISC)
 #define AUDIT_ARCH_PARISC	(EM_PARISC)
 #define AUDIT_ARCH_PARISC64	(EM_PARISC|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_PPC		(EM_PPC)
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
