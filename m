Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0IJUdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:33:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0IJUdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:33:11 -0400
Subject: [PATCH] x86, tsc: Fix a preemption leak in
 restore_sched_clock_state()
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Nico Schottelius <nico-nospam@schottelius.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, Suresh Siddha <suresh.b.siddha@intel.com>,
        stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
        "Brown, Len" <lenb@kernel.org>
In-Reply-To: <AANLkTikKmsM2kunB_ocwRawLUiuP4-_nz-mPsiapw7TJ@mail.gmail.com>
References: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
	 <1284104920.402.21.camel@laptop>
	 <AANLkTinBwfLXi0Bv0_gzSWRsdDPzHFQFZFwEYjbwkNs4@mail.gmail.com>
	 <1284120353.402.39.camel@laptop>
	 <AANLkTikKmsM2kunB_ocwRawLUiuP4-_nz-mPsiapw7TJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 22:32:53 +0200
Message-ID: <1284150773.402.122.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


D'0h !! *facepalm*

Shame on me for not spotting that sooner.

---
Subject: x86, tsc: Fix a preemption leak in restore_sched_clock_state()

A real life genuine preemption leak..

Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 873a321..4496315 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	get_cpu_var(cyc2ns_offset) = 0;
+	__get_cpu_var(cyc2ns_offset) = 0;
 	offset = cyc2ns_suspend - sched_clock();
 
 	for_each_possible_cpu(cpu)

