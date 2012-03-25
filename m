Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2CYU2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:28:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51475 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab2CYU2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:28:19 -0400
Date: Sun, 25 Mar 2012 16:28:12 -0400 (EDT)
Message-Id: <20120325.162812.59519424882536855.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] perf: addr2line wants addresses in same format as
 objdump
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 13:28:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Therefore, in symbol__get_source_line(), use map__rip_2objdump
instead of calling map->unmap_ip() unconditionally.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/util/annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 734a503..26fa767 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -410,7 +410,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	if (!notes->src->lines)
 		return -1;
 
-	start = map->unmap_ip(map, sym->start);
+	start = map__rip_2objdump(map, sym->start);
 
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
-- 
1.7.9.1

