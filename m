Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2HFJ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:28:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:60004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612Ab2HFJ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193675612"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] timer: do not define __mod_timer as inline function
Date: Mon,  6 Aug 2012 17:29:21 +0800
Message-Id: <1344245361-24710-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__mod_timer() is a bit 'huge' to be defined as inline.

$ size kernel/timer*.o
   text    data     bss     dec     hex filename
  18908    4034    8257   31199    79df kernel/timer-before.o
  17961    4034    8257   30252    762c kernel/timer-after.o

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a61c093..0be4216 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -736,7 +736,7 @@ static struct tvec_base *lock_timer_base(struct timer_list *timer,
 	}
 }
 
-static inline int
+static int
 __mod_timer(struct timer_list *timer, unsigned long expires,
 						bool pending_only, int pinned)
 {
-- 
1.7.7.6

