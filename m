Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0FXOkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:40:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0FXOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:38:53 -0400
Message-Id: <20100624143406.593090800@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 24 Jun 2010 16:28:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 02/11] perf: Fix argument of perf_arch_fetch_caller_regs
References: <20100624142804.431553874@chello.nl>
Content-Disposition: inline; filename=nobuhiro-fix-perf-arch-fetch-caller-regs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

"struct regs" was set to argument of perf_arch_fetch_caller_regs.
"struct pt_regs" is correct.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
---
 include/linux/perf_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -971,7 +971,7 @@ extern void __perf_sw_event(u32, u64, in
 
 #ifndef perf_arch_fetch_caller_regs
 static inline void
-perf_arch_fetch_caller_regs(struct regs *regs, unsigned long ip) { }
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
 #endif
 
 /*


