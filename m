Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2EGFL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:11:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49169 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2EGFKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:10:30 -0400
X-AuditID: 9c930197-b7badae000000cfd-b6-4fa75942f6b0
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/7] perf top: Defaults to system_wide target
Date: Mon,  7 May 2012 14:08:58 +0900
Message-Id: <1336367344-28071-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default behaviour of perf to is monitoring events
system-wide, so make it explicit.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-top.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2a0ec09b9b77..3ffb2b697968 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1152,6 +1152,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_evsel *pos;
 	int status = -ENOMEM;
 	struct perf_top top = {
+		.target		     = {
+			.system_wide = true,
+		},
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
 		.freq		     = 1000, /* 1 KHz */
-- 
1.7.10.1

