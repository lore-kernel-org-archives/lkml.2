Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab0G3S0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:26:18 -0400
Received: from kroah.org ([198.145.64.141]:58451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759846Ab0G3Rze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:40 2010
Message-Id: <20100730175140.881401989@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [080/205] perf, x86: Fix incorrect branches event on AMD CPUs
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vince Weaver <vweaver1@eecs.utk.edu>

commit f287d332ce835f77a4f5077d2c0ef1e3f9ea42d2 upstream.

While doing some performance counter validation tests on some
assembly language programs I noticed that the "branches:u"
count was very wrong on AMD machines.

It looks like the wrong event was selected.

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -102,8 +102,8 @@ static const u64 amd_perfmon_event_map[]
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
   [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 };
 
 static u64 amd_pmu_event_map(int hw_event)


