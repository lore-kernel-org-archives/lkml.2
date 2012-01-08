Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2AHPnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:43:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:59590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2AHPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf annotate: Get rid of field_sep check
Date: Sun,  8 Jan 2012 13:42:17 -0200
Message-Id: <1326037339-31125-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The 'field_sep' variable is not set anywhere. Just remove the
conditional.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-7-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3ec2496..806e0a2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -313,10 +313,5 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		annotate.sym_hist_filter = argv[0];
 	}
 
-	if (field_sep && *field_sep == '.') {
-		pr_err("'.' is the only non valid --field-separator argument\n");
-		return -1;
-	}
-
 	return __cmd_annotate(&annotate);
 }
-- 
1.7.8.GIT

