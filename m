Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2KUMwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:52:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49713 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2KUMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:52:18 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v3 19/19] perf tools: Fix output of symbol_daddr offset
Date: Wed, 21 Nov 2012 13:49:45 +0100
Message-Id: <1353502185-26521-20-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The symbol addresses in a dso have relative offsets from the start of
a mapping.  So in order to ouput correct offset value from @ip, one of
them should be converted.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index e2e466d..166480c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -186,7 +186,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 		if (map->type == MAP__VARIABLE) {
 			ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
 			ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
-					ip - sym->start);
+					ip - map->unmap_ip(map, sym->start));
 			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
 				       width - ret, "");
 		} else {
-- 
1.7.9.5

