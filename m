Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0DIXBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:01:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33616
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab0DIXBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:01:36 -0400
Date: Fri, 09 Apr 2010 16:01:40 -0700 (PDT)
Message-Id: <20100409.160140.250344636.davem@davemloft.net>
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH 3/4] sched: Use local_irq_save_nmi() in cpu_clock()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since we can call cpu_clock() from NMI context fix up the IRQ
disabling to conform to the new rules.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 kernel/sched_clock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 5b49613..ef159ee 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -241,9 +241,9 @@ unsigned long long cpu_clock(int cpu)
 	unsigned long long clock;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	clock = sched_clock_cpu(cpu);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 
 	return clock;
 }
-- 
1.7.0.4

