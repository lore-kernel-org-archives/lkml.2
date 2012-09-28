Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2I1Ei1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:38:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:42307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2I1Ebx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093226"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/31] perf, tools: Add intx/intx_checkpoint to perf script and header printing
Date: Thu, 27 Sep 2012 21:31:11 -0700
Message-Id: <1348806696-31170-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Just straight forward use of the new flags

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/header.c |    6 ++++--
 tools/perf/util/python.c |    8 +++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 74ea3c2..558b3b3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1217,9 +1217,11 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 				(u64)attr.config1,
 				(u64)attr.config2);
 
-		fprintf(fp, ", excl_usr = %d, excl_kern = %d",
+		fprintf(fp, ", excl_usr = %d, excl_kern = %d, intx = %d, intx_cp = %d",
 				attr.exclude_user,
-				attr.exclude_kernel);
+				attr.exclude_kernel,
+				attr.intx,
+				attr.intx_checkpointed);
 
 		fprintf(fp, ", excl_host = %d, excl_guest = %d",
 				attr.exclude_host,
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 0688bfb..70c234d 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -528,6 +528,8 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 		"bp_type",
 		"bp_addr",
 		"bp_len",
+		"intx",
+		"intx_checkpointed",
 		 NULL
 	};
 	u64 sample_period = 0;
@@ -548,6 +550,8 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 	    watermark = 0,
 	    precise_ip = 0,
 	    mmap_data = 0,
+	    intx = 0,
+	    intx_cp = 0,
 	    sample_id_all = 1;
 	int idx = 0;
 
@@ -562,7 +566,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 					 &enable_on_exec, &task, &watermark,
 					 &precise_ip, &mmap_data, &sample_id_all,
 					 &attr.wakeup_events, &attr.bp_type,
-					 &attr.bp_addr, &attr.bp_len, &idx))
+					 &attr.bp_addr, &attr.bp_len, &intx, &intx_cp, &idx))
 		return -1;
 
 	/* union... */
@@ -591,6 +595,8 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 	attr.precise_ip	    = precise_ip;
 	attr.mmap_data	    = mmap_data;
 	attr.sample_id_all  = sample_id_all;
+	attr.intx	    = intx;
+	attr.intx_checkpointed = intx_cp;
 
 	perf_evsel__init(&pevsel->evsel, &attr, idx);
 	return 0;
-- 
1.7.7.6

