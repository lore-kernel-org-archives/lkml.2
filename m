Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0GIImg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:42:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0GIIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:39:51 -0400
Message-Id: <20100709083247.694385187@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/13] sparc64: Fix maybe_change_configuration() PCR setting.
References: <20100709082117.631541128@chello.nl>
Content-Disposition: inline; filename=davem-sparc-pmu-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

Need to mask out the existing event bits before OR'ing in
the new ones.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/sparc/kernel/perf_event.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -657,6 +657,7 @@ static u64 maybe_change_configuration(st
 		cpuc->current_idx[i] = idx;
 
 		enc = perf_event_get_enc(cpuc->events[i]);
+		pcr &= ~mask_for_index(idx);
 		pcr |= event_encoding(enc, idx);
 	}
 out:


