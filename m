Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0GCN7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 09:59:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:52713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0GCN7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 09:59:01 -0400
Date: Sat, 3 Jul 2010 13:58:23 GMT
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       robert.richter@amd.com, fweisbec@gmail.com, stable@kernel.org,
       tglx@linutronix.de, vweaver1@eecs.utk.edu, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       robert.richter@amd.com, fweisbec@gmail.com, stable@kernel.org,
       tglx@linutronix.de, vweaver1@eecs.utk.edu, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix incorrect branches event on AMD CPUs
Message-ID: <tip-f287d332ce835f77a4f5077d2c0ef1e3f9ea42d2@git.kernel.org>
Git-Commit-ID: f287d332ce835f77a4f5077d2c0ef1e3f9ea42d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Jul 2010 13:58:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f287d332ce835f77a4f5077d2c0ef1e3f9ea42d2
Gitweb:     http://git.kernel.org/tip/f287d332ce835f77a4f5077d2c0ef1e3f9ea42d2
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Thu, 1 Jul 2010 15:30:16 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 3 Jul 2010 15:19:34 +0200

perf, x86: Fix incorrect branches event on AMD CPUs

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
Cc: <stable@kernel.org>
LKML-Reference: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
