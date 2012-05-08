Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2EHPHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:07:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2EHPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:07:15 -0400
Date: Tue, 8 May 2012 08:06:55 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-xeiyfsxptwtmlvowledg6wpy@git.kernel.org>
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
Subject: [tip:perf/core] perf annotate browser:
  Remove the vertical line after the percentages
Git-Commit-ID: 3e8b5ddf17d4639d41bc57ecfb51633815b70e49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:07:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e8b5ddf17d4639d41bc57ecfb51633815b70e49
Gitweb:     http://git.kernel.org/tip/3e8b5ddf17d4639d41bc57ecfb51633815b70e49
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 27 Apr 2012 16:44:56 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 Apr 2012 16:44:56 -0300

perf annotate browser: Remove the vertical line after the percentages

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
 1 files changed, 4 insertions(+), 5 deletions(-)

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
