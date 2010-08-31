Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0HaLqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:46:35 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:63420 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab0HaLqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:46:33 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: lkml@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] wire up sys_time_change_notify() on ia64
Date: Tue, 31 Aug 2010 14:45:50 +0300
Message-Id: <1283255151-6364-6-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
References: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: David Howells <dhowells@redhat.com>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: linux-ia64@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 arch/ia64/include/asm/unistd.h |    3 ++-
 arch/ia64/kernel/entry.S       |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 954d398..7445473 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -315,11 +315,12 @@
 #define __NR_fanotify_init		1323
 #define __NR_fanotify_mark		1324
 #define __NR_prlimit64			1325
+#define __NR_time_change_notify		1326
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			302 /* length of syscall table */
+#define NR_syscalls			303 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 244704a..48a5682 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1771,6 +1771,7 @@ sys_call_table:
 	data8 sys_fanotify_init
 	data8 sys_fanotify_mark
 	data8 sys_prlimit64			// 1325
+	data8 sys_time_change_notify
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
-- 
1.7.1

