Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2KENxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:53:21 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38014 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2KENxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:53:17 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v2 06/16] perf: add support for PERF_SAMPLE_ADDR in dump_sampple()
Date: Mon,  5 Nov 2012 14:50:53 +0100
Message-Id: <1352123463-7346-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352123463-7346-1-git-send-email-eranian@google.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
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

