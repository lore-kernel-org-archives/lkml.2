Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1LUIoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:44:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1LUIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:44:14 -0500
Date: Wed, 21 Dec 2011 00:43:50 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-2b600f9578852d12af59420011e3dadfaa58b043@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1323703017-6060-3-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-3-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Get rid of duplicated snprintf()
Git-Commit-ID: 2b600f9578852d12af59420011e3dadfaa58b043
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:43:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b600f9578852d12af59420011e3dadfaa58b043
Gitweb:     http://git.kernel.org/tip/2b600f9578852d12af59420011e3dadfaa58b043
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 00:16:51 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:34:52 -0200

perf symbols: Get rid of duplicated snprintf()

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
