Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1LTTTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:19:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:33882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1LTTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/10] perf symbols: Get rid of duplicated snprintf()
Date: Tue, 20 Dec 2011 17:18:06 -0200
Message-Id: <1324408691-28296-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The 'path' variable is set on a upper line, don't need to do it again.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-3-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 632b50c..e54b13d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1757,7 +1757,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 		struct stat st;
 
 		/*sshfs might return bad dent->d_type, so we have to stat*/
-		sprintf(path, "%s/%s", dir_name, dent->d_name);
+		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
 		if (stat(path, &st))
 			continue;
 
@@ -1766,8 +1766,6 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 			    !strcmp(dent->d_name, ".."))
 				continue;
 
-			snprintf(path, sizeof(path), "%s/%s",
-				 dir_name, dent->d_name);
 			ret = map_groups__set_modules_path_dir(mg, path);
 			if (ret < 0)
 				goto out;
@@ -1788,9 +1786,6 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 			if (map == NULL)
 				continue;
 
-			snprintf(path, sizeof(path), "%s/%s",
-				 dir_name, dent->d_name);
-
 			long_name = strdup(path);
 			if (long_name == NULL) {
 				ret = -1;
-- 
1.7.8.rc0.35.gee6df

