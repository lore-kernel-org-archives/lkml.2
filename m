Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab2C3QKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:10:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807Ab2C3QJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf annotate: addr2line wants addresses in same format as objdump
Date: Fri, 30 Mar 2012 13:09:21 -0300
Message-Id: <1333123764-15662-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

Therefore, in symbol__get_source_line(), use map__rip_2objdump
instead of calling map->unmap_ip() unconditionally.

Link: http://lkml.kernel.org/r/20120325.162812.59519424882536855.davem@davemloft.net
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e5a462f..31ba2a2 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -408,7 +408,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	if (!notes->src->lines)
 		return -1;
 
-	start = map->unmap_ip(map, sym->start);
+	start = map__rip_2objdump(map, sym->start);
 
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
-- 
1.7.9.2.358.g22243

