Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab0KKTcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:32:32 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:42233 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab0KKTab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:30:31 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Christoph Hellwig <hch@lst.de>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCHv6 6/7] wire up sys_time_change_notify() on powerpc
Date: Thu, 11 Nov 2010 21:30:01 +0200
Message-Id: <1289503802-22444-7-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
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
index aa0f1eb..a57cc82 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -348,3 +348,4 @@ COMPAT_SYS_SPU(sendmsg)
 COMPAT_SYS_SPU(recvmsg)
 COMPAT_SYS_SPU(recvmmsg)
 SYSCALL_SPU(accept4)
+SYSCALL(time_change_notify)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 6151937..bea2c9e 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -367,10 +367,11 @@
 #define __NR_recvmsg		342
 #define __NR_recvmmsg		343
 #define __NR_accept4		344
+#define __NR_time_change_notify 345
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		345
+#define __NR_syscalls		346
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.7.2.1.45.gb66c2

