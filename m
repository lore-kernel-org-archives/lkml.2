Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2KGH1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:27:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50186 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2KGH11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:27:27 -0500
X-AuditID: 9c930179-b7c8bae000003559-77-509a0d5b8356
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 5/6] perf tools: Fix output of symbol_daddr offset
Date: Wed,  7 Nov 2012 16:27:13 +0900
Message-Id: <1352273234-28912-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index e2e466d24c16..166480ca2865 100644
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
1.7.11.7

