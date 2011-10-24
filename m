Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1JXK6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:58:19 -0400
Received: from dns1.mips.com ([12.201.5.69]:57960 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab1JXK6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:58:17 -0400
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <linux-kernel@vger.kernel.org>
CC: Deng-Cheng Zhu <dczhu@mips.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its place in __perf_evsel__open()
Date: Mon, 24 Oct 2011 18:57:00 +0800
Message-ID: <1319453820-12992-3-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319453820-12992-1-git-send-email-dczhu@mips.com>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: 73sl+2mUFWO8y1g6ItJp/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__perf_evsel__open() is called per event, it does not work for all the
grouped events at one time. So, currently group_fd will alway be -1 for
the events in a group. This patch fixes it.

Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/evsel.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e389815..7bd0d9d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -219,9 +219,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		int group_fd = -1;
-
 		for (thread = 0; thread < threads->nr; thread++) {
+			static int group_fd = -1;
 
 			if (!evsel->cgrp)
 				pid = threads->map[thread];
-- 
1.7.1

