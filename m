Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab2C3RjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:39:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:29095 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab2C3RjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147943730"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf tools: Fix record sample overlap check for callchains
Date: Fri, 30 Mar 2012 10:38:34 -0700
Message-Id: <1333129114-22117-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
References: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf record checks for buffer overflow, but checked for the wrong
size for callchains.  callchains are 8 bytes each, not 1.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f421f7c..90c0756 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -550,7 +550,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 
 		data->callchain = (struct ip_callchain *)array;
 
-		if (sample_overlap(event, array, data->callchain->nr))
+		if (sample_overlap(event, array, (1 + data->callchain->nr) * 8))
 			return -EFAULT;
 
 		array += 1 + data->callchain->nr;
-- 
1.7.7.6

