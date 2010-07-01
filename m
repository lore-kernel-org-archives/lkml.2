Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0GATrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:47:36 -0400
Received: from puma.mail.utk.edu ([160.36.178.106]:33043 "EHLO
	puma.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab0GATrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:47:35 -0400
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 15:47:35 EDT
Date: Thu, 1 Jul 2010 15:30:16 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf wrong branches event on AMD
Message-ID: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

while doing some performance counter validation tests on some assembly 
language programs I noticed that the "branches:u" count was very wrong on 
AMD machines.

It looks like the wrong event was selected.

This is why event selection needs to be in user-space... it could be fixed 
instantly there, but the way things are done now it will take months to 
years for this fix to filter down to those trying to use perf counters...

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 611df11..c2897b7 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -102,8 +102,8 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
   [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 };
 
 static u64 amd_pmu_event_map(int hw_event)
