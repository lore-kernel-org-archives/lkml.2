Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1LLPRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1LLPRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:19 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] perf symbols: Get rid of duplicated snprintf()
Date: Tue, 13 Dec 2011 00:16:51 +0900
Message-Id: <1323703017-6060-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'path' is set on a upper line, don't need to do it again.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/symbol.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 632b50c7bc26..e54b13d4c357 100644
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
1.7.6

