Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2H0HoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:44:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:49807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2H0HoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:44:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="scan'208";a="138220456"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/3] perf tools: Fix a compiling error in trace-event-perl.c for 32 bits machine
Date: Mon, 27 Aug 2012 15:38:25 +0800
Message-Id: <1346053107-11946-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my x86_32 mahcine, there is a compile error:

	CC util/scripting-engines/trace-event-perl.o
	cc1: warnings being treated as errors
	util/scripting-engines/trace-event-perl.c: In function ‘perl_process_tracepoint’:
	util/scripting-engines/trace-event-perl.c:285: error: format ‘%d’ expects type ‘int’, but argument 2 has type ‘__u64’
	make: *** [util/scripting-engines/trace-event-perl.o] Error 1

Fix it by using the "%lld" for __u64.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d280010..1cde6aa 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %d", evsel->attr.config);
+		die("ug! no event found for type %lld", evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.7.1

