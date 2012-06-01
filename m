Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823Ab2FAWTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:19:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54294 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965591Ab2FAWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/15] perf evlist: Pass third argument to ioctl explicitly
Date: Fri,  1 Jun 2012 19:16:32 -0300
Message-Id: <1338588999-32509-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ioctl on perf event fd wants 3 arguments but we only passed 2. As
the only user of the functions is perf record and it calls them for
every event (regardless of group setting), just pass 0 for now.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338443506-25009-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ed277e5..7400fb3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -274,7 +274,8 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_DISABLE, 0);
 		}
 	}
 }
@@ -287,7 +288,8 @@ void perf_evlist__enable(struct perf_evlist *evlist)
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
1.7.1

