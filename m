Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2IXQA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab2IXQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/30] perf tools: Fix a compiling error in util/map.c
Date: Mon, 24 Sep 2012 12:59:16 -0300
Message-Id: <1348502384-14442-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

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
-- 
1.7.1

