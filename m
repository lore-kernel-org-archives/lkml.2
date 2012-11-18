Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2KROgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:36:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2KROaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/32] perf tools: Fix compile error on NO_NEWT=1 build
Date: Sun, 18 Nov 2012 11:29:40 -0300
Message-Id: <1353248997-30763-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352697240-422-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1278c2c..8b091a5 100644
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
1.7.9.2.358.g22243

