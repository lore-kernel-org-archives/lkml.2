Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab2D0ImW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:42:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485Ab2D0ImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:42:20 -0400
Date: Fri, 27 Apr 2012 01:41:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-63yhb2htv9g3g1olmojzptkd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ui browser:
  Add method to write graphical characters
Git-Commit-ID: 59d038d591f7f00e6752cbfadbbc1c0ca318c5c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:41:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59d038d591f7f00e6752cbfadbbc1c0ca318c5c0
Gitweb:     http://git.kernel.org/tip/59d038d591f7f00e6752cbfadbbc1c0ca318c5c0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Apr 2012 16:26:14 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 16:26:14 -0300

ui browser: Add method to write graphical characters

To save typing on the switch char set slang stuff.

It also helps in removing more slang direct calls, wrapping them at the
ui_browser level, where at some point I'll try to implement those in
terms of GTK+.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-63yhb2htv9g3g1olmojzptkd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c           |    7 +++++++
 tools/perf/ui/browser.h           |    1 +
 tools/perf/ui/browsers/annotate.c |   14 ++++----------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index a1b140c..973ff74 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -593,6 +593,13 @@ unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
 	return row;
 }
 
+void ui_browser__write_graph(struct ui_browser *browser __used, int graph)
+{
+	SLsmg_set_char_set(1);
+	SLsmg_write_char(graph);
+	SLsmg_set_char_set(0);
+}
+
 void ui_browser__init(void)
 {
 	int i = 0;
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 2550277..ce20975 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -37,6 +37,7 @@ void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
+void ui_browser__write_graph(struct ui_browser *browser, int graph);
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int ui_browser__show(struct ui_browser *self, const char *title,
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 38f4c6f..c3fc6f3 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -71,9 +71,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(" ", 9);
 	}
 
-	SLsmg_set_char_set(1);
-	SLsmg_write_char(SLSMG_VLINE_CHAR);
-	SLsmg_set_char_set(0);
+	ui_browser__write_graph(self, SLSMG_VLINE_CHAR);
 	SLsmg_write_char(' ');
 
 	/* The scroll bar isn't being used */
@@ -116,10 +114,8 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			if (ins__is_jump(dl->ins)) {
 				bool fwd = dl->ops.target > (u64)dl->offset;
 
-				SLsmg_set_char_set(1);
-				SLsmg_write_char(fwd ? SLSMG_DARROW_CHAR :
-						       SLSMG_UARROW_CHAR);
-				SLsmg_set_char_set(0);
+				ui_browser__write_graph(self, fwd ? SLSMG_DARROW_CHAR :
+								    SLSMG_UARROW_CHAR);
 				SLsmg_write_char(' ');
 			} else {
 				slsmg_write_nstring(" ", 2);
@@ -131,9 +127,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			if (strcmp(dl->name, "retq")) {
 				slsmg_write_nstring(" ", 2);
 			} else {
-				SLsmg_set_char_set(1);
-				SLsmg_write_char(SLSMG_LARROW_CHAR);
-				SLsmg_set_char_set(0);
+				ui_browser__write_graph(self, SLSMG_LARROW_CHAR);
 				SLsmg_write_char(' ');
 			}
 
