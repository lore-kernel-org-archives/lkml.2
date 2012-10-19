Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161009Ab2JSV3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:29:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57768 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337Ab2JSV3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:29:13 -0400
Date: Fri, 19 Oct 2012 17:30:01 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com
Subject: [PATCH 1/3] perf_event: fix p6 FP_ASSIST event constraint
In-Reply-To: <alpine.DEB.2.02.1210191722430.14552@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1210191728570.14552@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210191722430.14552@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to Intel SDM Volume 3B, FP_ASSIST is limited to Counter 1 only,
not Counter 0.

Tested on a Pentium II.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff -ur linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_p6.c linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_p6.c
--- linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_p6.c	2012-10-14 17:41:04.000000000 -0400
+++ linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_p6.c	2012-10-19 14:50:41.212241569 -0400
@@ -34,7 +34,7 @@
 {
 	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
-	INTEL_EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x2),	/* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
 	INTEL_EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
 	INTEL_EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
