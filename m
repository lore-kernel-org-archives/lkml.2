Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2K1NzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2K1NzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:55:18 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 03/14] perf tool: Fix period symbol_conf.field_sep display
Date: Wed, 28 Nov 2012 14:52:38 +0100
Message-Id: <1354110769-2998-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't properly display hist data with
symbol_conf.field_sep separator. We need to display
either space or separator.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 5452960..20a4392 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -523,17 +523,13 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 	struct perf_hpp_fmt *fmt;
 	char *start = hpp->buf;
 	int ret;
-	bool first = true;
 
 	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
-		if (!sep || !first) {
-			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
-			advance_hpp(hpp, ret);
-			first = false;
-		}
+		ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
+		advance_hpp(hpp, ret);
 
 		if (color && fmt->color)
 			ret = fmt->color(fmt, hpp, he);
-- 
1.7.11.7

