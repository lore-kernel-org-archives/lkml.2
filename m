Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1BGHzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:55:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:36378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1BGHzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:55:09 -0500
Date: Mon, 7 Feb 2011 07:54:33 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Remove superfluous name_len field
Message-ID: <tip-764328d3209dd81b02a55722556b07b6f35e3ca0@git.kernel.org>
Git-Commit-ID: 764328d3209dd81b02a55722556b07b6f35e3ca0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Feb 2011 07:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  764328d3209dd81b02a55722556b07b6f35e3ca0
Gitweb:     http://git.kernel.org/tip/764328d3209dd81b02a55722556b07b6f35e3ca0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Feb 2011 07:33:24 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 5 Feb 2011 12:26:40 -0200

perf top: Remove superfluous name_len field

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
