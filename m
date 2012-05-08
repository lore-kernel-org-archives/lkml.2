Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2EHPIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:08:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2EHPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:08:03 -0400
Date: Tue, 8 May 2012 08:07:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-81pimnsnaa9y2j0a9plstu1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Don't display 0.
 00 percentages
Git-Commit-ID: 0822cc80d9aee026b1ebe43c02dc01e0a0227864
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:07:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0822cc80d9aee026b1ebe43c02dc01e0a0227864
Gitweb:     http://git.kernel.org/tip/0822cc80d9aee026b1ebe43c02dc01e0a0227864
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 27 Apr 2012 17:13:53 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 Apr 2012 17:13:53 -0300

perf annotate browser: Don't display 0.00 percentages

Cleaning up more the output.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-81pimnsnaa9y2j0a9plstu1c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index a90680b..44fb6a4 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -64,12 +64,12 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 					         !self->navkeypressed)));
 	int width = self->width;
 
-	if (dl->offset != -1) {
+	if (dl->offset != -1 && bdl->percent != 0.0) {
 		ui_browser__set_percent_color(self, bdl->percent, current_entry);
-		slsmg_printf(" %7.2f ", bdl->percent);
+		slsmg_printf("%6.2f ", bdl->percent);
 	} else {
 		ui_browser__set_percent_color(self, 0, current_entry);
-		slsmg_write_nstring(" ", 9);
+		slsmg_write_nstring(" ", 7);
 	}
 
 	SLsmg_write_char(' ');
@@ -82,9 +82,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		ui_browser__set_color(self, HE_COLORSET_CODE);
 
 	if (!*dl->line)
-		slsmg_write_nstring(" ", width - 9);
+		slsmg_write_nstring(" ", width - 7);
 	else if (dl->offset == -1)
-		slsmg_write_nstring(dl->line, width - 9);
+		slsmg_write_nstring(dl->line, width - 7);
 	else {
 		char bf[256];
 		u64 addr = dl->offset;
@@ -137,7 +137,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			scnprintf(bf, sizeof(bf), "%-6.6s %s", dl->name, dl->ops.raw);
 		}
 
-		slsmg_write_nstring(bf, width - 11 - printed);
+		slsmg_write_nstring(bf, width - 9 - printed);
 	}
 
 	if (current_entry)
@@ -175,7 +175,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	if (!bcursor->jump_target)
 		start_width += ab->offset_width + 1;
 
-	__ui_browser__line_arrow(browser, 9, from, to, start_width);
+	__ui_browser__line_arrow(browser, 7, from, to, start_width);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
