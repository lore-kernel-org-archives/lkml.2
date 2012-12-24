Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2LXFWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 00:22:17 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:60398 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2LXFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 00:22:15 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <viro@ZenIV.linux.org.uk>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <james.hogan@imgtec.com>,
        <arnd@arndb.de>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: [PATCH] CONFIG_GENERIC_SIGALTSTACK build breakage with asm-generic/syscalls.h
Date: Mon, 24 Dec 2012 10:51:36 +0530
Message-ID: <1356326496-11559-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20121221160713.GT4939@ZenIV.linux.org.uk>
References: <20121221160713.GT4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For arches which include asm-generic/syscalls.h as well as newly
introduced CONFIG_GENERIC_SIGALTSTACK, there's a build breakage due to
conflicting prototypes of sys_sigaltstack(), due to removal of struct
pt_regs from latter based code.

----------------------->8-------------------------
In file included from
/home/vineetg/arc/upstream-kernel/arch/arc/include/asm/syscalls.h:25,
                 from arch/arc/kernel/sys.c:6:
include/asm-generic/syscalls.h:26: error: conflicting types for
'sys_sigaltstack'
include/linux/syscalls.h:304: note: previous declaration of
'sys_sigaltstack' was here
make[2]: *** [arch/arc/kernel/sys.o] Error 1
----------------------->8-------------------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: james.hogan@imgtec.com
Cc: arnd@arndb.de
Cc: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---
 include/asm-generic/syscalls.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
index 58f466f..1db51b8 100644
--- a/include/asm-generic/syscalls.h
+++ b/include/asm-generic/syscalls.h
@@ -21,10 +21,12 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 			unsigned long fd, off_t pgoff);
 #endif
 
+#ifndef CONFIG_GENERIC_SIGALTSTACK
 #ifndef sys_sigaltstack
 asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 			struct pt_regs *);
 #endif
+#endif
 
 #ifndef sys_rt_sigreturn
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs);
-- 
1.7.4.1

