Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1HRTFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:05:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44314 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1HRTFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:05:00 -0400
Date: Thu, 18 Aug 2011 20:04:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 36/91] um: take userland definition of barrier()
 to user.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7tj-0007gP-Fy@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/process.h |    3 ---
 arch/um/include/shared/user.h    |    3 +++
 arch/um/os-Linux/signal.c        |    3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/um/include/shared/process.h b/arch/um/include/shared/process.h
index bb873a5..2821530 100644
--- a/arch/um/include/shared/process.h
+++ b/arch/um/include/shared/process.h
@@ -8,9 +8,6 @@
 
 #include <signal.h>
 
-/* Copied from linux/compiler-gcc.h since we can't include it directly */
-#define barrier() __asm__ __volatile__("": : :"memory")
-
 extern void sig_handler(int sig, struct sigcontext *sc);
 extern void alarm_handler(int sig, struct sigcontext *sc);
 
diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
index 58c0581..4fa82c0 100644
--- a/arch/um/include/shared/user.h
+++ b/arch/um/include/shared/user.h
@@ -40,4 +40,7 @@ extern int in_aton(char *str);
 extern size_t strlcpy(char *, const char *, size_t);
 extern size_t strlcat(char *, const char *, size_t);
 
+/* Copied from linux/compiler-gcc.h since we can't include it directly */
+#define barrier() __asm__ __volatile__("": : :"memory")
+
 #endif
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index c4a4e20..08d3061 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -16,9 +16,6 @@
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
 
-/* Copied from linux/compiler-gcc.h since we can't include it directly */
-#define barrier() __asm__ __volatile__("": : :"memory")
-
 void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
 	[SIGFPE]	= relay_signal,
-- 
1.7.2.5


