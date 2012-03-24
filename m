Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2CXOUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:20:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2CXOUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:20:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Fix the array pointer to follow event data properly
Date: Sat, 24 Mar 2012 15:19:56 +0100
Message-Id: <1332598796-3586-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we dont update the 'array' pointer properly after
processing the RAW data. This way perf might report wrong data
for branch stack if it is used along with tracepoint sample.

I'm not sure tracepoint could be connected with branch stack,
but I think the array pointer should have correct value after
each sample processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d9da62a..56a96896 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -580,6 +580,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_data = (void *) pdata;
+		array = (u64 *)(((char *)array) + data->raw_size + sizeof(u32));
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
-- 
1.7.7.6

