Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0IPWSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:18:00 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:57501 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab0IPWRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:17:19 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexander Shishkin <virtuoso@slind.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Christoph Hellwig <hch@lst.de>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 4/7] wire up sys_time_change_notify() on powerpc
Date: Fri, 17 Sep 2010 01:10:46 +0300
Message-Id: <1284675049-23479-5-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andreas Schwab <schwab@linux-m68k.org>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Christoph Hellwig <hch@lst.de>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: linuxppc-dev@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org
---
 arch/powerpc/include/asm/systbl.h |    1 +
 arch/powerpc/include/asm/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 3d21266..124b610 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -329,3 +329,4 @@ COMPAT_SYS(rt_tgsigqueueinfo)
 SYSCALL(fanotify_init)
 COMPAT_SYS(fanotify_mark)
 SYSCALL_SPU(prlimit64)
+SYSCALL(time_change_notify)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 597e6f9..6ab64da 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -348,10 +348,11 @@
 #define __NR_fanotify_init	323
 #define __NR_fanotify_mark	324
 #define __NR_prlimit64		325
+#define __NR_time_change_notify	326
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		326
+#define __NR_syscalls		327
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.7.2.1.45.gb66c2

