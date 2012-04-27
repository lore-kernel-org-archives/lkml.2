Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab2D0Ief (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:34:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2D0Ieb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:34:31 -0400
Date: Fri, 27 Apr 2012 01:34:06 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-igoynvtg2wc6mdfinc69prp6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Make lines more compact
Git-Commit-ID: 8bf39cb81bdad01ad0d830e8c3639b9e8f552d57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:34:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bf39cb81bdad01ad0d830e8c3639b9e8f552d57
Gitweb:     http://git.kernel.org/tip/8bf39cb81bdad01ad0d830e8c3639b9e8f552d57
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Apr 2012 15:07:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Apr 2012 17:08:24 -0300

perf annotate browser: Make lines more compact

But now we have a lot of space on the right...

Perhaps we should add a "Trending on G+" gizmo... ;-)

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-igoynvtg2wc6mdfinc69prp6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index c5ab21c..34b86ea 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -82,11 +82,11 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		ui_browser__set_color(self, HE_COLORSET_CODE);
 
 	if (!*dl->line)
-		slsmg_write_nstring(" ", width - 18);
+		slsmg_write_nstring(" ", width - 10);
 	else if (dl->offset == -1)
-		slsmg_write_nstring(dl->line, width - 18);
+		slsmg_write_nstring(dl->line, width - 10);
 	else {
-		char bf[256], *line = dl->line;
+		char bf[256];
 		u64 addr = dl->offset;
 		int printed, color = -1;
 
@@ -114,12 +114,12 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf),
 						!ab->use_offset ? dl->operands : NULL,
 						dl->target);
-			line = bf;
-			slsmg_write_nstring(" ", 7);
-			printed += 7;
-		}
+			slsmg_write_nstring(" ", 2);
+			printed += 2;
+		} else
+			scnprintf(bf, sizeof(bf), "  %-6.6s %s", dl->name, dl->operands);
 
-		slsmg_write_nstring(line, width - 18 - printed);
+		slsmg_write_nstring(bf, width - 10 - printed);
 	}
 
 	if (current_entry)
@@ -653,6 +653,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.priv	 = &ms,
 			.use_navkeypressed = true,
 		},
+		.use_offset = true,
 	};
 	int ret = -1;
 
