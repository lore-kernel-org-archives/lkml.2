Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab2JaAnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:43:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:15557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758972Ab2JaAec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208";a="211509848"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/32] perf, tools: Add abort_tx,no_tx,in_tx branch filter options to perf record -j v3
Date: Tue, 30 Oct 2012 17:34:01 -0700
Message-Id: <1351643663-23828-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make perf record -j aware of the new in_tx,no_tx,abort_tx branch qualifiers.

v2: ABORT -> ABORTTX
v3: Add more _
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    3 +++
 tools/perf/builtin-record.c              |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index b38a1f9..159680e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -172,6 +172,9 @@ following filters are defined:
         - u:  only when the branch target is at the user level
         - k: only when the branch target is in the kernel
         - hv: only when the target is at the hypervisor level
+	- in_tx: only when the target is in a hardware transaction
+	- no_tx: only when the target is not in a hardware transaction
+	- abort_tx: only when the target is a hardware transaction abort
 
 +
 The option requires at least one branch type among any, any_call, any_ret, ind_call.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5783c32..067d8ee 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -763,6 +763,9 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORTTX),
+	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_INTX),
+	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NOTX),
 	BRANCH_END
 };
 
-- 
1.7.7.6

