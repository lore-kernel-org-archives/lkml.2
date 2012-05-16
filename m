Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2EPG7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759129Ab2EPG7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:59:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/7] perf, tool: Add union u64_swap type for swapping u64 data
Date: Wed, 16 May 2012 08:59:04 +0200
Message-Id: <1337151548-2396-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following union:
  union {
        u64 val64;
        u32 val32[2];
  } u;

is used on more than single places in perf code and will be used
more in upcomming patches.

Adding union u64_swap to have it defined globaly so we dont need
to redefine it all the time.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c |   10 ++--------
 tools/perf/util/types.h |    5 +++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21eaab2..4e1b44e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -462,10 +462,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
 	 */
-	union {
-		u64 val64;
-		u32 val32[2];
-	} u;
+	union u64_swap u;
 
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
@@ -608,10 +605,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
 	 */
-	union {
-		u64 val64;
-		u32 val32[2];
-	} u;
+	union u64_swap u;
 
 	array = event->sample.array;
 
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index 5f3689a..c51fa6b 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -16,4 +16,9 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 #endif /* __PERF_TYPES_H */
-- 
1.7.7.6

