Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2I0EXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:23:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0EXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:23:43 -0400
Date: Wed, 26 Sep 2012 21:23:18 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-8f28f19a87cb48d13570ba774a3e85776eb36bb4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1346053107-11946-3-git-send-email-feng.tang@intel.com>
References: <1346053107-11946-3-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix a compiling error in util/map.c
Git-Commit-ID: 8f28f19a87cb48d13570ba774a3e85776eb36bb4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 21:23:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f28f19a87cb48d13570ba774a3e85776eb36bb4
Gitweb:     http://git.kernel.org/tip/8f28f19a87cb48d13570ba774a3e85776eb36bb4
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Mon, 27 Aug 2012 15:38:26 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 20 Sep 2012 08:36:34 -0300

perf tools: Fix a compiling error in util/map.c

This patch fix a compile warning taken as error:

	CC util/map.o
	cc1: warnings being treated as errors
	util/map.c: In function ‘map__fprintf_dsoname’:
	util/map.c:240: error: ‘dsoname’ may be used uninitialized in this function
	make: *** [util/map.o] Error 1

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346053107-11946-3-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b442ee4..ead5316 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -243,15 +243,14 @@ size_t map__fprintf(struct map *self, FILE *fp)
 
 size_t map__fprintf_dsoname(struct map *map, FILE *fp)
 {
-	const char *dsoname;
+	const char *dsoname = "[unknown]";
 
 	if (map && map->dso && (map->dso->name || map->dso->long_name)) {
 		if (symbol_conf.show_kernel_path && map->dso->long_name)
 			dsoname = map->dso->long_name;
 		else if (map->dso->name)
 			dsoname = map->dso->name;
-	} else
-		dsoname = "[unknown]";
+	}
 
 	return fprintf(fp, "%s", dsoname);
 }
