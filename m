Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab0HJVyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:54:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab0HJVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:53:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf ui hist browser: Fixup key bindings
Date: Tue, 10 Aug 2010 18:53:46 -0300
Message-Id: <1281477226-11504-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281477226-11504-1-git-send-email-acme@infradead.org>
References: <1281477226-11504-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To match what is shown when '?' or 'H' is pressed, i.e. the keybind help
window.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index dd512b7..dafdf67 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -215,12 +215,12 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
-	newtFormAddHotKey(self->b.form, 'A');
 	newtFormAddHotKey(self->b.form, 'a');
 	newtFormAddHotKey(self->b.form, '?');
 	newtFormAddHotKey(self->b.form, 'h');
-	newtFormAddHotKey(self->b.form, 'H');
 	newtFormAddHotKey(self->b.form, 'd');
+	newtFormAddHotKey(self->b.form, 'D');
+	newtFormAddHotKey(self->b.form, 't');
 
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
 	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
@@ -232,7 +232,7 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 		if (es->reason != NEWT_EXIT_HOTKEY)
 			break;
 		switch (es->u.key) {
-		case 'd': { /* Debug */
+		case 'D': { /* Debug */
 			static int seq;
 			struct hist_entry *h = rb_entry(self->b.top,
 							struct hist_entry, rb_node);
@@ -771,18 +771,17 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 			default:;
 			}
 
-			key = toupper(key);
 			switch (key) {
-			case 'A':
+			case 'a':
 				if (browser->selection->map == NULL &&
 				    browser->selection->map->dso->annotate_warned)
 					continue;
 				goto do_annotate;
-			case 'D':
+			case 'd':
 				goto zoom_dso;
-			case 'T':
+			case 't':
 				goto zoom_thread;
-			case 'H':
+			case 'h':
 			case '?':
 do_help:
 				ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
-- 
1.6.2.5

