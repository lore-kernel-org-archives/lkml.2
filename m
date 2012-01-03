Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2ACURQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:17:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab2ACUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:16:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf session: Remove impossible condition check
Date: Tue,  3 Jan 2012 18:16:20 -0200
Message-Id: <1325621784-10683-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1325621784-10683-1-git-send-email-acme@infradead.org>
References: <1325621784-10683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The 'size' cannot be 0 because it was set to 8 on the above line in case
it was 0 and never changed.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325000151-4463-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cc5e6be..b5ca255 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1015,8 +1015,7 @@ more:
 		}
 	}
 
-	if (size == 0 ||
-	    (skip = perf_session__process_event(self, &event, tool, head)) < 0) {
+	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
 		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    head, event.header.size, event.header.type);
 		/*
-- 
1.7.8.rc0.35.gee6df

