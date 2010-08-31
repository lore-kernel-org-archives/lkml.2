Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0HaLra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:47:30 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:64922 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab0HaLr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:47:29 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: lkml@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] wire up sys_time_change_notify() on ARM
Date: Tue, 31 Aug 2010 14:45:46 +0300
Message-Id: <1283255151-6364-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
References: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
X-Nokia-AV: Clean
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
index d02cfb6..ce38a6f 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -393,6 +393,7 @@
 #define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
 #define __NR_recvmmsg			(__NR_SYSCALL_BASE+365)
 #define __NR_accept4			(__NR_SYSCALL_BASE+366)
+#define __NR_time_change_notify		(__NR_SYSCALL_BASE+367)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index afeb71f..f1e64ba 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -376,6 +376,7 @@
 		CALL(sys_perf_event_open)
 /* 365 */	CALL(sys_recvmmsg)
 		CALL(sys_accept4)
+		CALL(sys_time_change_notify)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.7.1

