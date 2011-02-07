Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1BGAoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:44:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1BGAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:43:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/6] perf top: Remove superfluous name_len field
Date: Sun,  6 Feb 2011 22:42:12 -0200
Message-Id: <1297039337-6690-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297039337-6690-1-git-send-email-acme@infradead.org>
References: <1297039337-6690-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

>From the sym_entry struct, struct symbol already has this field.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    3 ---
 tools/perf/util/top.c    |    5 +++--
 tools/perf/util/top.h    |    1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 104de9a..154e088 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -787,9 +787,6 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 		}
 	}
 
-	if (!syme->skip)
-		syme->name_len = strlen(sym->name);
-
 	return 0;
 }
 
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 1d2e265..70a9c13 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -200,6 +200,7 @@ void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
 
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
+		struct symbol *sym = sym_entry__symbol(syme);
 
 		if (++printed > top->print_entries ||
 		    (int)syme->snap_count < top->count_filter)
@@ -211,7 +212,7 @@ void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
 		if (syme->map->dso->short_name_len > *dso_short_width)
 			*dso_short_width = syme->map->dso->short_name_len;
 
-		if (syme->name_len > *sym_width)
-			*sym_width = syme->name_len;
+		if (sym->namelen > *sym_width)
+			*sym_width = sym->namelen;
 	}
 }
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 611370f..5009508 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -31,7 +31,6 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
-	u16			name_len;
 	u8			origin;
 	struct map		*map;
 	struct sym_entry_source	*src;
-- 
1.6.2.5

