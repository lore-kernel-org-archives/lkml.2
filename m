Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030430Ab2EQWQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:16:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:46382 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967770Ab2EQWOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320406"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 06/10] Use __kernel_ulong_t in x86 struct semid64_ds
Date: Thu, 17 May 2012 15:13:32 -0700
Message-Id: <1337292816-10839-7-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace unsigned long with __kernel_ulong_t in x86 struct semid64_ds
for user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 arch/x86/include/asm/sembuf.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/sembuf.h b/arch/x86/include/asm/sembuf.h
index ee50c80..cc2d6a3 100644
--- a/arch/x86/include/asm/sembuf.h
+++ b/arch/x86/include/asm/sembuf.h
@@ -13,12 +13,12 @@
 struct semid64_ds {
 	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
 	__kernel_time_t	sem_otime;	/* last semop time */
-	unsigned long	__unused1;
+	__kernel_ulong_t __unused1;
 	__kernel_time_t	sem_ctime;	/* last change time */
-	unsigned long	__unused2;
-	unsigned long	sem_nsems;	/* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+	__kernel_ulong_t __unused2;
+	__kernel_ulong_t sem_nsems;	/* no. of semaphores in array */
+	__kernel_ulong_t __unused3;
+	__kernel_ulong_t __unused4;
 };
 
 #endif /* _ASM_X86_SEMBUF_H */
-- 
1.7.6.5

