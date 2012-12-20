Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2LTPms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:42:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65089 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LTPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:42:32 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v4 06/18] perf: add support for PERF_SAMPLE_ADDR in dump_sampple()
Date: Thu, 20 Dec 2012 16:41:36 +0100
Message-Id: <1356018108-6081-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356018108-6081-1-git-send-email-eranian@google.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
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
index 117983e..3982fc3 100644
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

