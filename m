Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0DFP6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:58:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:50221 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0DFP6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:58:45 -0400
Date: Tue, 6 Apr 2010 15:57:36 GMT
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
       vweaver1@eecs.utk.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, ming.m.lin@intel.com, tglx@linutronix.de,
       vweaver1@eecs.utk.edu, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1004060956580.1417@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1004060956580.1417@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Enable Nehalem-EX support
Message-ID: <tip-134fbadf028a5977a1b06b0253d3ee33e6f0c642@git.kernel.org>
Git-Commit-ID: 134fbadf028a5977a1b06b0253d3ee33e6f0c642
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 15:57:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  134fbadf028a5977a1b06b0253d3ee33e6f0c642
Gitweb:     http://git.kernel.org/tip/134fbadf028a5977a1b06b0253d3ee33e6f0c642
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Tue, 6 Apr 2010 10:01:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Apr 2010 17:52:59 +0200

perf, x86: Enable Nehalem-EX support

According to Intel Software Devel Manual Volume 3B, the
Nehalem-EX PMU is just like regular Nehalem (except for the
uncore support, which is completely different).

Signed-off-by:  Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <alpine.DEB.2.00.1004060956580.1417@cl320.eecs.utk.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
 
