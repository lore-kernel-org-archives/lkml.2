Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0CSHqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:46:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:45685 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0CSHqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:46:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,273,1267430400"; 
   d="scan'208";a="605840039"
Subject: [PATCH] perf, x86: Fix key index in Pentium-4 PMU
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Mar 2010 15:28:58 +0800
Message-Id: <1268983738.13901.142.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index 0-6 in p4_templates are reserved for common hardware events.
So p4_templates is arranged as below,
0 - 6: common hardware events
7 - N: cache events
N+1 - ...: other raw events

Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
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


