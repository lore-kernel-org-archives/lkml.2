Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab2H1CXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 22:23:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:38348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2H1CXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 22:23:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,324,1344236400"; 
   d="scan'208,223";a="192089581"
Date: Tue, 28 Aug 2012 10:17:30 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <namhyung@kernel.org>,
        <dsahern@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH  v2 1/3] perf tools: Fix a compiling error in
 trace-event-perl.c for 32 bits machine
Message-ID: <20120828101730.6b2fd97e@feng-i7>
In-Reply-To: <20120827153355.GA17634@infradead.org>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
	<1346053107-11946-2-git-send-email-feng.tang@intel.com>
	<20120827153355.GA17634@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8e2fe258906fc83869be10a1b4a40ef9acc4a2a6 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Mon, 27 Aug 2012 14:01:33 +0800
Subject: [PATCH 1/3] perf tools: Fix a compiling error in trace-event-perl.c for 32 bits machine

On my x86_32 mahcine, there is a compile error:

	CC util/scripting-engines/trace-event-perl.o
	cc1: warnings being treated as errors
	util/scripting-engines/trace-event-perl.c: In function ‘perl_process_tracepoint’:
	util/scripting-engines/trace-event-perl.c:285: error: format ‘%d’ expects type ‘int’, but argument 2 has type ‘__u64’
	make: *** [util/scripting-engines/trace-event-perl.o] Error 1

Fix it by using the "%PRIu64" for __u64.

v2: use PRIu64 as suggested by Arnaldo.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d280010..09db03f 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %d", evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.7.1
