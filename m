Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2JDUXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:23:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41282 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2JDUXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:23:15 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 4/4] add finit_module syscall to asm-generic
Date: Thu,  4 Oct 2012 13:22:34 -0700
Message-Id: <1349382154-9804-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349382154-9804-1-git-send-email-keescook@chromium.org>
References: <1349382154-9804-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the finit_module syscall to the generic syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/unistd.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 991ef01..7ef8507 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -691,9 +691,13 @@ __SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
 #define __NR_process_vm_writev 271
 __SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
           compat_sys_process_vm_writev)
+#define __NR_kcmp 272
+__SYSCALL(__NR_kcmp, sys_kcmp)
+#define __NR_finit_module 273
+__SYSCALL(__NR_finit_module, sys_finit_module)
 
 #undef __NR_syscalls
-#define __NR_syscalls 272
+#define __NR_syscalls 274
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.9.5

