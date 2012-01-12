Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2ALUkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:40:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51198 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2ALUkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:40:01 -0500
From: Sorin Dumitru <dumitru.sorin87@gmail.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net
Cc: Sorin Dumitru <dumitru.sorin87@gmail.com>
Subject: [PATCH] perf: check if address is in range
Date: Thu, 12 Jan 2012 22:39:38 +0200
Message-Id: <1326400778-24131-1-git-send-email-dumitru.sorin87@gmail.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When addr isn't in the [sym->start,sym->end] range offset
will be a very big value, giving us a segfault when we do:
	h->addr[offset]++
Fix this by checking that addr is in the correct range.

Signed-off-by: Sorin Dumitru <dumitru.sorin87@gmail.com>
---
 tools/perf/util/annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 011ed26..4ddc55f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr >= sym->end)
+	if (addr <= sym->start || addr >= sym->end)
 		return 0;
 
 	offset = addr - sym->start;
-- 
1.7.8.3

