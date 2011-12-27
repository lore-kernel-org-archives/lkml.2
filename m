Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1L0PgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 10:36:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57648 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1L0Pf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 10:35:59 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip:perf/core 1/4] perf session: Remove impossible condition check
Date: Wed, 28 Dec 2011 00:35:48 +0900
Message-Id: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'size' cannot be 0 because it was set to 8 on the
above line in case it was 0 and never changed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/session.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d9318d8a9ba1..1139f3c6dec5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1004,8 +1004,7 @@ more:
 		}
 	}
 
-	if (size == 0 ||
-	    (skip = perf_session__process_event(self, &event, tool, head)) < 0) {
+	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
 		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    head, event.header.size, event.header.type);
 		/*
-- 
1.7.6

