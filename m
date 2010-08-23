Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0HWIkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:40:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57204 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0HWIjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:39:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Blackfin: wire up new fanotify/prlimit64 syscalls
Date: Mon, 23 Aug 2010 04:40:05 -0400
Message-Id: <1282552805-18989-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
References: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/unistd.h |    5 ++++-
 arch/blackfin/mach-common/entry.S  |    3 +++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index 22886cb..14fcd25 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -389,8 +389,11 @@
 #define __NR_rt_tgsigqueueinfo	368
 #define __NR_perf_event_open	369
 #define __NR_recvmmsg		370
+#define __NR_fanotify_init	371
+#define __NR_fanotify_mark	372
+#define __NR_prlimit64		373
 
-#define __NR_syscall		371
+#define __NR_syscall		374
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index a5847f5..af1bffa 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1628,6 +1628,9 @@ ENTRY(_sys_call_table)
 	.long _sys_rt_tgsigqueueinfo
 	.long _sys_perf_event_open
 	.long _sys_recvmmsg		/* 370 */
+	.long _sys_fanotify_init
+	.long _sys_fanotify_mark
+	.long _sys_prlimit64
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
-- 
1.7.2

