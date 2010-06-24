Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0FXOiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:38:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab0FXOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:38:51 -0400
Message-Id: <20100624143406.648945135@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 24 Jun 2010 16:28:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/11] perf, sparc64: Fix maybe_change_configuration() PCR setting.
References: <20100624142804.431553874@chello.nl>
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


