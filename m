Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2JEG5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:57:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51578 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab2JEG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:57:20 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-d5-506e6c105505
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/5] perf trace: Explicitly enable system-wide mode if no option is given
Date: Fri,  5 Oct 2012 14:02:14 +0900
Message-Id: <1349413336-26936-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
References: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When no target cpu/user/task option is given, perf trace will do its
job system wide for all online cpus.  Make it explicit to reduce
possible confusion when reading code.

No functional changes intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7bb7e757c745..231b60690ce9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -344,6 +344,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		return err;
 	}
 
+	if (perf_target__none(&trace.opts.target))
+		trace.opts.target.system_wide = true;
+
 	setup_pager();
 
 	return trace__run(&trace);
-- 
1.7.11.4

