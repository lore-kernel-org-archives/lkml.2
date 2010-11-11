Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0KKTac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:30:32 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:42175 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0KKTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:30:30 -0500
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
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv6 2/7] wire up sys_time_change_notify() on ARM
Date: Thu, 11 Nov 2010 21:29:57 +0200
Message-Id: <1289503802-22444-3-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_time_change_notify() is a new syscall with number and types of
parameters such that no ARM-specific processing is needed.

Tested with 2.6.36-rc3 using Documentation/time-change-notify-example.c.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
---
 arch/arm/include/asm/unistd.h |    1 +
 arch/arm/kernel/calls.S       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index c891eb7..45d5dc9 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -396,6 +396,7 @@
 #define __NR_fanotify_init		(__NR_SYSCALL_BASE+367)
 #define __NR_fanotify_mark		(__NR_SYSCALL_BASE+368)
 #define __NR_prlimit64			(__NR_SYSCALL_BASE+369)
+#define __NR_time_change_notify		(__NR_SYSCALL_BASE+370)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 5c26ecc..633e71a 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -379,6 +379,7 @@
 		CALL(sys_fanotify_init)
 		CALL(sys_fanotify_mark)
 		CALL(sys_prlimit64)
+		CALL(sys_time_change_notify)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.7.2.1.45.gb66c2

