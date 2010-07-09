Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0GIIlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:41:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:52232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0GIIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:40:09 -0400
Message-Id: <20100709083247.810209194@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:21 +0200
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
Subject: [PATCH 04/13] perf, powerpc: Use perf_sample_data_init() for the FSL code
References: <20100709082117.631541128@chello.nl>
Content-Disposition: inline; filename=perf-fsl-fix-sample_data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use perf_sample_data_init() to initialize struct perf_sample_data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_event_fsl_emb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -566,9 +566,9 @@ static void record_and_restart(struct pe
 	 * Finally record data if requested.
 	 */
 	if (record) {
-		struct perf_sample_data data = {
-			.period	= event->hw.last_period,
-		};
+		struct perf_sample_data data;
+
+		perf_sample_data_init(&data, 0);
 
 		if (perf_event_overflow(event, nmi, &data, regs)) {
 			/*


