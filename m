Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2AGRZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:25:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2AGRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:38 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] perf script: Add missing closedir() calls
Date: Sun,  8 Jan 2012 02:25:25 +0900
Message-Id: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_script_path() calls opendir() but misses corresponding
closedir()'s. Add them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-script.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fd1909afcfd6..bb68ddf257b7 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1018,13 +1018,17 @@ static char *get_script_path(const char *script_root, const char *suffix)
 			__script_root = get_script_root(&script_dirent, suffix);
 			if (__script_root && !strcmp(script_root, __script_root)) {
 				free(__script_root);
+				closedir(lang_dir);
+				closedir(scripts_dir);
 				snprintf(script_path, MAXPATHLEN, "%s/%s",
 					 lang_path, script_dirent.d_name);
 				return strdup(script_path);
 			}
 			free(__script_root);
 		}
+		closedir(lang_dir);
 	}
+	closedir(scripts_dir);
 
 	return NULL;
 }
-- 
1.7.6

