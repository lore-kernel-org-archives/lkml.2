Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab2JAX1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:27:30 -0400
Received: from 1wt.eu ([62.212.114.60]:35262 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765Ab2JAXAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:55 -0400
Message-Id: <20121001225203.545037669@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?ISO-8859-15?q?=C3=89meric=20Maschino?= 
	<emeric.maschino@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 140/180] ia64: Add accept4() syscall
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: =?latin1?q?=C3=89meric=20Maschino?= <emeric.maschino@gmail.com>

commit 65cc21b4523e94d5640542a818748cd3be8cd6b4 upstream.

While debugging udev > 170 failure on Debian Wheezy
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648325), it appears
that the issue was in fact due to missing accept4() in ia64.

This patch simply adds accept4() to ia64.

Signed-off-by: Émeric Maschino <emeric.maschino@gmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Backported-by: Dennis Schridde <devurandom@gmx.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/ia64/include/asm/unistd.h |    3 ++-
 arch/ia64/kernel/entry.S       |   13 +++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 5a5347f..08a0e5c 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -311,11 +311,12 @@
 #define __NR_preadv			1319
 #define __NR_pwritev			1320
 #define __NR_rt_tgsigqueueinfo		1321
+#define __NR_accept4			1334
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			298 /* length of syscall table */
+#define NR_syscalls			311 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index d0e7d37..e3be543 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1806,6 +1806,19 @@ sys_call_table:
 	data8 sys_preadv
 	data8 sys_pwritev			// 1320
 	data8 sys_rt_tgsigqueueinfo
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall			// 1325
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall			// 1330
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_ni_syscall
+	data8 sys_accept4
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
-- 
1.7.2.1.45.g54fbc



