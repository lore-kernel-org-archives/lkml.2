Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0IRTtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:49:52 -0400
Received: from kroah.org ([198.145.64.141]:51463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0IRTBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:49 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185957.944265868@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Florian Pritz <flo@xssn.at>,
        Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [060/123] x86, tsc: Fix a preemption leak in restore_sched_clock_state()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=x86-tsc-fix-a-preemption-leak-in-restore_sched_clock_state.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	get_cpu_var(cyc2ns_offset) = 0;
+	__get_cpu_var(cyc2ns_offset) = 0;
 	offset = cyc2ns_suspend - sched_clock();
 
 	for_each_possible_cpu(cpu)


