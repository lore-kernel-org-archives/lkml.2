Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1ADRSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:18:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60196 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1ADRSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:18:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tools: Fix perf_event.h header usage
Date: Tue,  4 Jan 2011 15:18:05 -0200
Message-Id: <1294161485-28528-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294161485-28528-1-git-send-email-acme@infradead.org>
References: <1294161485-28528-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch fixes the usage of the perf_event.h header file
between command modules and the supporting code in util.

It is necessary to ensure that ALL files use the SAME
perf_event.h header from the kernel source tree.

There were a couple of #include <linux/perf_event.h> mixed
with #include "../../perf_event.h".

This caused issues on some distros because of mismatch
in the layout of struct perf_event_attr. That eventually
led perf stat to segfault.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@gmail.com>
LKML-Reference: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/parse-events.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 863d78d..a0ccd69 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
  
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1c9043c..b82cafb 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,7 +4,7 @@
  * Parse symbolic events/counts passed in as options:
  */
 
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 
 struct list_head;
 struct perf_evsel;
-- 
1.6.2.5

