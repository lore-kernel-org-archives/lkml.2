Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab1FGTju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:39:50 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:36217 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394Ab1FGTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:39:48 -0400
Date: Tue, 7 Jun 2011 15:39:31 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [patch] perf_events: more wrong events for AMD fam10h
Message-ID: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm in the process of auditing perf_event's awesome "generalized events".

On AMD fam10h for some we have the following definitions:
  cache-references = INSTRUCTION_CACHE_FETCHES	0x530080
  cache-misses 	   = INSTRUCTION_CACHE_MISSES	0x530081

on Intel at least I'm pretty sure these events match to Last Level Cache 
accesses/misses, not icache.  Is there a reason for this?

Attached is a patch that removes these until better events can be found.
(LLC is tricky on AMD as it's a shared resource).

Note, l1-dcache-stores is broken too, I'm looking into it.

Thanks,

Vince
vweaver1@eecs.utk.edu

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index fe29c1d..a46b987 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -98,8 +98,6 @@ static const u64 amd_perfmon_event_map[] =
 {
   [PERF_COUNT_HW_CPU_CYCLES]			= 0x0076,
   [PERF_COUNT_HW_INSTRUCTIONS]			= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]		= 0x0080,
-  [PERF_COUNT_HW_CACHE_MISSES]			= 0x0081,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]		= 0x00c2,
   [PERF_COUNT_HW_BRANCH_MISSES]			= 0x00c3,
   [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x00d0, /* "Decoder empty" event */
