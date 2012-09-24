Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2IXQJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:09:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58621 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab2IXP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:59:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/30] perf tools: Fix a compiling error in trace-event-perl.c for 32 bits machine
Date: Mon, 24 Sep 2012 12:59:15 -0300
Message-Id: <1348502384-14442-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

On my x86_32 mahcine, there is a compile error:

        CC util/scripting-engines/trace-event-perl.o
        cc1: warnings being treated as errors
        util/scripting-engines/trace-event-perl.c: In function
	perl_process_tracepoint:
        util/scripting-engines/trace-event-perl.c:285: error: format
	expects type 'int', but argument 2 has type '__u64'
        make: *** [util/scripting-engines/trace-event-perl.o] Error 1

Fix it by using the "%PRIu64" for __u64.

v2: use PRIu64 as suggested by Arnaldo.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120828101730.6b2fd97e@feng-i7
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index ffde3e4..f80605e 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %d", evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.7.1

