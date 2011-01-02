Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1ABHXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:35543 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1ABHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 078/260] x86, tsc: Fix a preemption leak in restore_sched_clock_state()
Date: Sun,  2 Jan 2011 02:16:14 -0500
Message-Id: <1293952756-15010-79-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:33.0711 (UTC) FILETIME=[AF19F9F0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 55496c896b8a695140045099d4e0175cf09d4eae upstream.

Doh, a real life genuine preemption leak..

This caused a suspend failure.

Reported-bisected-and-tested-by-the-invaluable: Jeff Chua <jeff.chua.linux@gmail.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Pritz <flo@xssn.at>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Len Brown <lenb@kernel.org>
sleep states
LKML-Reference: <1284150773.402.122.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c65f741..4094ae0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	get_cpu_var(cyc2ns_offset) = 0;
+	__get_cpu_var(cyc2ns_offset) = 0;
 	offset = cyc2ns_suspend - sched_clock();
 
 	for_each_possible_cpu(cpu)
-- 
1.7.3.3

