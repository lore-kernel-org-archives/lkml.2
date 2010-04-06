Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0DFOUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:20:14 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:32927 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0DFOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:20:09 -0400
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 10:20:09 EDT
Date: Tue, 6 Apr 2010 10:01:19 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf enable Nehalem-EX support
Message-ID: <alpine.DEB.2.00.1004060956580.1417@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to Intel Software Devel Manual Volume 3B, the Nehalem-EX PMU is 
just like regular Nehalem (except for the uncore support, which is 
completely different).

Signed-off-by:  Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 84bfde6..9c794ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -936,6 +936,7 @@ static __init int intel_pmu_init(void)
 
 	case 26: /* 45 nm nehalem, "Bloomfield" */
 	case 30: /* 45 nm nehalem, "Lynnfield" */
+	case 46: /* 45 nm nehalem-ex, "Beckton" */
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
