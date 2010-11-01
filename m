Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0KAOlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:41:23 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:55058 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab0KAOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:41:21 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 10:41:21 EDT
Subject: [PATCH] wrong PERF_COUNT_HW_CACHE_REFERENCES and
 PERF_COUNT_HW_CACHE_MISSES for AMD
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Stephane Eranian <eranian@google.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Cc: x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 15:11:03 +0100
Message-ID: <1288620663.2712.84.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current arch/x86/kernel/cpu/perf_event_amd.c file lists
L1-Instruction-Cache Misses and Accesses as PERF_COUNT_HW_CACHE_MISSES
resp. PERF_COUNT_HW_CACHE_REFERENCES.

This fix uses L2C-Misses and Accesses instead. (Real LLC-events would be
better, but there are some restrictions for Northbridge Events on AMD).

The event codes are copied from the list of cache events from the same
file.


Signed-off-by: Robert Schoene <robert.schoene@tu-dresden.de>


--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -100,8 +100,8 @@ static const u64 amd_perfmon_event_map[] =
 {
   [PERF_COUNT_HW_CPU_CYCLES]           = 0x0076,
   [PERF_COUNT_HW_INSTRUCTIONS]         = 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]     = 0x0080,
-  [PERF_COUNT_HW_CACHE_MISSES]         = 0x0081,
+  [PERF_COUNT_HW_CACHE_REFERENCES]     = 0x037D,
+  [PERF_COUNT_HW_CACHE_MISSES]         = 0x037E,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]  = 0x00c2,
   [PERF_COUNT_HW_BRANCH_MISSES]                = 0x00c3,
 };

