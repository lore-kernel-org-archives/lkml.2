Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2BTARc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:17:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2BTARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:17:30 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 19/30] x32: Generate <asm/unistd_64_x32.h>
Date: Sun, 19 Feb 2012 16:07:57 -0800
Message-Id: <1329696488-16970-20-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:17:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Generate macros for the *kernel* code to use to refer to x32 system
calls.  These have an __NR_x32_ prefix and do not include
__X32_SYSCALL_BIT.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/unistd.h |    1 +
 arch/x86/syscalls/Makefile    |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index dab5349..7a48a55 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -17,6 +17,7 @@
 # else
 
 #  include <asm/unistd_64.h>
+#  include <asm/unistd_64_x32.h>
 #  define __ARCH_WANT_COMPAT_SYS_TIME
 
 # endif
diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index 54bdbd7..414d402 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -34,6 +34,11 @@ syshdr_abi_unistd_64 := common,64
 $(out)/unistd_64.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)
 
+syshdr_abi_unistd_64_x32 := x32
+syshdr_pfx_unistd_64_x32 := x32_
+$(out)/unistd_64_x32.h: $(syscall64) $(syshdr)
+	$(call if_changed,syshdr)
+
 $(out)/syscalls_32.h: $(syscall32) $(systbl)
 	$(call if_changed,systbl)
 $(out)/syscalls_64.h: $(syscall64) $(systbl)
@@ -41,7 +46,7 @@ $(out)/syscalls_64.h: $(syscall64) $(systbl)
 
 syshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
 syshdr-y			+= syscalls_32.h
-syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h
+syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h unistd_64_x32.h
 syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
 
 targets	+= $(syshdr-y)
-- 
1.7.6.5

