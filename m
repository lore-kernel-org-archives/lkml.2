Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab2IGIs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:48:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:28377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGIsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:48:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219252874"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 2/7] perf scripts: Add --symbols option to handle specific symbols
Date: Fri,  7 Sep 2012 16:42:24 +0800
Message-Id: <1347007349-3102-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
References: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since perf script no longer only handle the trace points, we can
add the symbol filter option so that scripts can handle specified
samples.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-script.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2d6e3b2..7ab86bb 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -14,6 +14,7 @@
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include "util/sort.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -1142,6 +1143,8 @@ static const struct option options[] = {
 		     parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		     "system-wide collection from all CPUs"),
+	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only display events for these comms"),
-- 
1.7.1

