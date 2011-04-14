Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1DNQ7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:59:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:38283 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab1DNQ7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,212,1301900400"; 
   d="scan'208";a="733384929"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH] futex: set FLAGS_HAS_TIMEOUT during demux for FUTEX_WAIT
Date: Thu, 14 Apr 2011 09:58:33 -0700
Message-Id: <39ac45dcef66930ae01cb5c632446a76447935b2.1302800313.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
restart futex_wait() without a timeout after a signal.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Tim Smith <tsmith201104@yahoo.com>
Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bda4157..6eac6b6 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2589,6 +2589,9 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 			return -ENOSYS;
 	}
 
+	if (timeout)
+		flags |= FLAGS_HAS_TIMEOUT;
+
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
-- 
1.7.1

