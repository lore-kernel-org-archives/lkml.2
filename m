Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2JAXAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35110 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495Ab2JAXAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:16 -0400
Message-Id: <20121001225201.756144821@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 098/180] MIPS: Properly align the .data..init_task section.
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit 7b1c0d26a8e272787f0f9fcc5f3e8531df3b3409 upstream.

Improper alignment can lead to unbootable systems and/or random
crashes.

[ralf@linux-mips.org: This is a lond standing bug since
6eb10bc9e2deab06630261cd05c4cb1e9a60e980 (kernel.org) rsp.
c422a10917f75fd19fa7fe070aaaa23e384dae6f (lmo) [MIPS: Clean up linker script
using new linker script macros.] so dates back to 2.6.32.]

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/3881/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/mips/include/asm/thread_info.h |    4 ++--
 arch/mips/kernel/vmlinux.lds.S      |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 845da21..0e50757 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -60,6 +60,8 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("$28");
 #define current_thread_info()  __current_thread_info
 
+#endif /* !__ASSEMBLY__ */
+
 /* thread information allocation */
 #if defined(CONFIG_PAGE_SIZE_4KB) && defined(CONFIG_32BIT)
 #define THREAD_SIZE_ORDER (1)
@@ -93,8 +95,6 @@ register struct thread_info *__current_thread_info __asm__("$28");
 
 #define free_thread_info(info) kfree(info)
 
-#endif /* !__ASSEMBLY__ */
-
 #define PREEMPT_ACTIVE		0x10000000
 
 /*
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 162b299..d5c95d6 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -1,5 +1,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips
@@ -70,7 +71,7 @@ SECTIONS
 	.data : {	/* Data */
 		. = . + DATAOFFSET;		/* for CONFIG_MAPPED_KERNEL */
 
-		INIT_TASK_DATA(PAGE_SIZE)
+		INIT_TASK_DATA(THREAD_SIZE)
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		DATA_DATA
-- 
1.7.2.1.45.g54fbc



