Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2H0Hoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:44:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:49807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2H0HoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:44:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="scan'208";a="138220467"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/3] Perf tools: Fix a compiling error in util/map.c
Date: Mon, 27 Aug 2012 15:38:26 +0800
Message-Id: <1346053107-11946-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a compile warning taken as error:

	CC util/map.o
	cc1: warnings being treated as errors
	util/map.c: In function ‘map__fprintf_dsoname’:
	util/map.c:240: error: ‘dsoname’ may be used uninitialized in this function
	make: *** [util/map.o] Error 1

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/util/map.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 7d37159..5f90dda 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -237,15 +237,14 @@ size_t map__fprintf(struct map *self, FILE *fp)
 
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

