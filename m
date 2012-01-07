Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2AGR0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:26:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2AGRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:55 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] perf annotate: Get rid of field_sep check
Date: Sun,  8 Jan 2012 02:25:31 +0900
Message-Id: <1325957132-10600-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'field_sep' variable is not set anywhere. Just remove
the conditional.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-annotate.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3ec2496f1e35..806e0a286634 100644
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
1.7.6

