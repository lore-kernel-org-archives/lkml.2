Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0CSIZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:25:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0CSIZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:25:32 -0400
Date: Fri, 19 Mar 2010 08:25:05 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268983738.13901.142.camel@minggr.sh.intel.com>
References: <1268983738.13901.142.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Fix key indexing in Pentium-4 PMU
Message-ID: <tip-40b7e05e17eef31ff30fe08dfc2424ef653a792c@git.kernel.org>
Git-Commit-ID: 40b7e05e17eef31ff30fe08dfc2424ef653a792c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Mar 2010 08:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40b7e05e17eef31ff30fe08dfc2424ef653a792c
Gitweb:     http://git.kernel.org/tip/40b7e05e17eef31ff30fe08dfc2424ef653a792c
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 19 Mar 2010 15:28:58 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Mar 2010 09:23:17 +0100

perf, x86: Fix key indexing in Pentium-4 PMU

Index 0-6 in p4_templates are reserved for common hardware
events. So p4_templates is arranged as below:

    0  -    6:  common hardware events
    7  -    N:  cache events
  N+1  -  ...:  other raw events

Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1268983738.13901.142.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 2a1a57f..facf961 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -709,7 +709,7 @@ enum P4_EVENTS_ATTR {
 };
 
 enum {
-	KEY_P4_L1D_OP_READ_RESULT_MISS,
+	KEY_P4_L1D_OP_READ_RESULT_MISS = PERF_COUNT_HW_MAX,
 	KEY_P4_LL_OP_READ_RESULT_MISS,
 	KEY_P4_DTLB_OP_READ_RESULT_MISS,
 	KEY_P4_DTLB_OP_WRITE_RESULT_MISS,
