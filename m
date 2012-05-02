Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2EBTm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:42:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49669 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2EBTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:42:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf annotate browser: Remove the vertical line after the percentages
Date: Wed,  2 May 2012 16:42:37 -0300
Message-Id: <1335987758-11039-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335987758-11039-1-git-send-email-acme@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It is confusing when used with jump -> target lines.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xeiyfsxptwtmlvowledg6wpy@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index d203daf..a90680b 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -72,7 +72,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(" ", 9);
 	}
 
-	ui_browser__write_graph(self, SLSMG_VLINE_CHAR);
 	SLsmg_write_char(' ');
 
 	/* The scroll bar isn't being used */
@@ -83,9 +82,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		ui_browser__set_color(self, HE_COLORSET_CODE);
 
 	if (!*dl->line)
-		slsmg_write_nstring(" ", width - 10);
+		slsmg_write_nstring(" ", width - 9);
 	else if (dl->offset == -1)
-		slsmg_write_nstring(dl->line, width - 10);
+		slsmg_write_nstring(dl->line, width - 9);
 	else {
 		char bf[256];
 		u64 addr = dl->offset;
@@ -138,7 +137,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			scnprintf(bf, sizeof(bf), "%-6.6s %s", dl->name, dl->ops.raw);
 		}
 
-		slsmg_write_nstring(bf, width - 12 - printed);
+		slsmg_write_nstring(bf, width - 11 - printed);
 	}
 
 	if (current_entry)
@@ -176,7 +175,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	if (!bcursor->jump_target)
 		start_width += ab->offset_width + 1;
 
-	__ui_browser__line_arrow(browser, 10, from, to, start_width);
+	__ui_browser__line_arrow(browser, 9, from, to, start_width);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
-- 
1.7.9.2.358.g22243

