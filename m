Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2EaFy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:54:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54050 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2EaFyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:54:24 -0400
X-AuditID: 9c93016f-b7c3cae000001954-08-4fc7078daa02
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf evlist: Pass third argument to ioctl explicitly
Date: Thu, 31 May 2012 14:51:46 +0900
Message-Id: <1338443506-25009-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
References: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl on perf event fd wants 3 arguments but we only
passed 2. As the only user of the functions is perf record
and it calls them for every events (regardless of group
setting), just pass 0 for now.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/evlist.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4ac5f5ae4ce9..244211070264 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -263,7 +263,8 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_DISABLE, 0);
 		}
 	}
 }
@@ -276,7 +277,8 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_ENABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_ENABLE, 0);
 		}
 	}
 }
-- 
1.7.10.2

