Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0KKTcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:32:14 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:38974 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0KKTac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:30:32 -0500
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
        Mike Frysinger <vapier@gentoo.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Robin Getz <robin.getz@analog.com>, Philippe Gerum <rpm@xenomai.org>,
        "David S. Miller" <davem@davemloft.net>, Yi Li <yi.li@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCHv6 7/7] wire up sys_time_change_notify() on blackfin
Date: Thu, 11 Nov 2010 21:30:02 +0200
Message-Id: <1289503802-22444-8-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Mike Frysinger <vapier@gentoo.org>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Robin Getz <robin.getz@analog.com>
CC: Philippe Gerum <rpm@xenomai.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Yi Li <yi.li@analog.com>
CC: uclinux-dist-devel@blackfin.uclinux.org
CC: linux-kernel@vger.kernel.org
---
 arch/blackfin/include/asm/unistd.h |    3 ++-
 arch/blackfin/mach-common/entry.S  |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index 928ae97..e4a3f730 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -393,8 +393,9 @@
 #define __NR_fanotify_mark	372
 #define __NR_prlimit64		373
 #define __NR_cacheflush		374
+#define __NR_time_change_notify 375
 
-#define __NR_syscall		375
+#define __NR_syscall		376
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 2ca915e..8e85a9a 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1738,6 +1738,7 @@ ENTRY(_sys_call_table)
 	.long _sys_fanotify_mark
 	.long _sys_prlimit64
 	.long _sys_cacheflush
+	.long _sys_time_change_notify	/* 375 */
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
-- 
1.7.2.1.45.gb66c2

