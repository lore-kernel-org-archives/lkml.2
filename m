Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1JSSX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:23:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56929 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1JSSXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:25 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf top: fix crash on annotate request
Date: Wed, 19 Oct 2011 12:23:18 -0600
Message-Id: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitting an annotate case where src is not set and
perf-top crashes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/annotate.c             |    3 +++
 tools/perf/util/ui/browsers/annotate.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bc8f477..26652b1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -205,6 +205,9 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	size_t line_len;
 	s64 line_ip, offset = -1;
 
+	if (!notes->src)
+		return -1;
+
 	if (getline(&line, &line_len, file) < 0)
 		return -1;
 
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index a2c351c..5a67ead 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -410,6 +410,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	ui_helpline__push("Press <- or ESC to exit");
 
 	notes = symbol__annotation(sym);
+	if (!notes->src)
+		return -1;
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct objdump_line_rb_node *rbpos;
-- 
1.7.6.4

