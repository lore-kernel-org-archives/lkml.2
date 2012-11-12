Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab2KLFOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 00:14:19 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53752 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2KLFOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 00:14:18 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-74-50a085a87628
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH] perf tools: Fix compile error on NO_NEWT=1 build
Date: Mon, 12 Nov 2012 14:14:00 +0900
Message-Id: <1352697240-422-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

    CC builtin-annotate.o
In file included from util/evsel.h:10:0,
                 from util/evlist.h:8,
                 from builtin-annotate.c:20:
util/hist.h: In function ‘script_browse’:
util/hist.h:198:45: error: unused parameter ‘script_opt’ [-Werror=unused-parameter]
cc1: all warnings being treated as errors
make: *** [builtin-annotate.o] Error 1
make: *** Waiting for unfinished jobs....

Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1278c2c72a96..8b091a51e4a2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -195,7 +195,7 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
 	return 0;
 }
 
-static inline int script_browse(const char *script_opt)
+static inline int script_browse(const char *script_opt __maybe_unused)
 {
 	return 0;
 }
-- 
1.7.11.7

