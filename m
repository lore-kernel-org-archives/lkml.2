Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2KUMzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:55:01 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55983 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2KUMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:41 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 06/19] perf: add support for PERF_SAMPLE_ADDR in dump_sampple()
Date: Wed, 21 Nov 2012 13:49:32 +0100
Message-Id: <1353502185-26521-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was missing from current code yet PERF_SAMPLE_ADDR has
been present for a long time. Needed for PEBS-LL mode.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 962c04f..b6d7cad 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1009,6 +1009,10 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		printf(" ... weight: %"PRIu64"\n", sample->weight);
+
+        if (sample_type & PERF_SAMPLE_ADDR)
+                printf(" ..... data: 0x%"PRIx64"\n", sample->addr);
+
 }
 
 static struct machine *
-- 
1.7.9.5

