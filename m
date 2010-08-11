Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0HKHoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:44:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab0HKHoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:44:14 -0400
Date: Wed, 11 Aug 2010 07:43:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui hist browser: Fixup key bindings
Message-ID: <tip-4694153c252a6ae19704b5bb66466050256395a4@git.kernel.org>
Git-Commit-ID: 4694153c252a6ae19704b5bb66466050256395a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:43:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4694153c252a6ae19704b5bb66466050256395a4
Gitweb:     http://git.kernel.org/tip/4694153c252a6ae19704b5bb66466050256395a4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Aug 2010 15:50:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 15:50:07 -0300

perf ui hist browser: Fixup key bindings

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
