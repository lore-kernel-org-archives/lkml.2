Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2KMVuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:50:16 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60768 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KMVuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:50:13 -0500
From: Vinson Lee <vlee@twitter.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vinson Lee <vlee@twitter.com>
Subject: [PATCH] perf tools: Fix build with older versions of bison.
Date: Tue, 13 Nov 2012 13:50:07 -0800
Message-Id: <1352843407-30618-1-git-send-email-vlee@twitter.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes this build error with older versions of bison.

    CC util/sysfs.o
    BISON util/pmu-bison.c
util/pmu.y:2.14-24: syntax error, unexpected string, expecting =
make: *** [util/pmu-bison.c] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
Cc: stable@vger.kernel.org # 3.4+
---
 tools/perf/Makefile            |    4 ++--
 tools/perf/util/parse-events.y |    1 -
 tools/perf/util/pmu.y          |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 00deed4..c2fb5bc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -241,13 +241,13 @@ $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-event
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
 
 $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
 $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index cd88209..85cdaed 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,5 +1,4 @@
 %pure-parser
-%name-prefix "parse_events_"
 %parse-param {void *_data}
 %parse-param {void *scanner}
 %lex-param {void* scanner}
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index ec89804..bfd7e85 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -1,5 +1,4 @@
 
-%name-prefix "perf_pmu_"
 %parse-param {struct list_head *format}
 %parse-param {char *name}
 
-- 
1.5.4.3

