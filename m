Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0ESH6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:58:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0ESH6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:58:20 -0400
Date: Wed, 19 May 2010 07:57:47 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gorcunov@openvz.org, a.p.zijlstra@chello.nl,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100518212439.354345151@openvz.org>
References: <20100518212439.354345151@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU -- add missing bit in CCCR mask
Message-ID: <tip-ce7f15452cc1dc1eca795542367871a07f37aa79@git.kernel.org>
Git-Commit-ID: ce7f15452cc1dc1eca795542367871a07f37aa79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 07:57:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce7f15452cc1dc1eca795542367871a07f37aa79
Gitweb:     http://git.kernel.org/tip/ce7f15452cc1dc1eca795542367871a07f37aa79
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 19 May 2010 01:19:19 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 May 2010 09:41:06 +0200

perf, x86: P4 PMU -- add missing bit in CCCR mask

Should be there for the sake of RAW events.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100518212439.354345151@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index b05400a..64a8ebf 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -89,7 +89,8 @@
 	P4_CCCR_ENABLE)
 
 /* HT mask */
-#define P4_CCCR_MASK_HT	(P4_CCCR_MASK | P4_CCCR_THREAD_ANY)
+#define P4_CCCR_MASK_HT				\
+	(P4_CCCR_MASK | P4_CCCR_OVF_PMI_T1 | P4_CCCR_THREAD_ANY)
 
 #define P4_GEN_ESCR_EMASK(class, name, bit)	\
 	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)
