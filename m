Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2AHPmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:42:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:59573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2AHPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/9] perf script: Add missing closedir() calls
Date: Sun,  8 Jan 2012 13:42:11 -0200
Message-Id: <1326037339-31125-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The get_script_path() calls opendir() but misses corresponding
closedir()'s. Add them.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fd1909a..bb68ddf 100644
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
1.7.8.GIT

