Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab1EWWNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:19577 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab1EWWNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:13:18 -0400
X-ExtLoop1: 1
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 3/9] MCE: Always retrieve mce rip before calling no_way_out
Date: Mon, 23 May 2011 15:13:17 -0700
Message-Id: <4ddadbfd171625de3c@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Some of the rules in the decision engine need a valid rip,
so set it up before calling it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ed1542a..ee3b14e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -957,6 +957,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
+	mce_get_rip(&m, regs);
 	no_way_out = mce_no_way_out(&m, &msg);
 
 	barrier();
@@ -1037,7 +1038,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
-- 
1.7.3.1

