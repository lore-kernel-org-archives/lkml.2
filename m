Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2ENNEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:04:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab2ENNEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:04:22 -0400
Date: Mon, 14 May 2012 06:03:59 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1txmtzf71eqie5xcukbfxors@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Add key bindings help window
Git-Commit-ID: 54e7a4e88eed9ac423e22a259ec51a973fd59bab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:04:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54e7a4e88eed9ac423e22a259ec51a973fd59bab
Gitweb:     http://git.kernel.org/tip/54e7a4e88eed9ac423e22a259ec51a973fd59bab
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 12 May 2012 16:36:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 12 May 2012 16:36:55 -0300

perf annotate browser: Add key bindings help window

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1txmtzf71eqie5xcukbfxors@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 547bd35..6e0ef79 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -581,10 +581,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	struct rb_node *nd = NULL;
 	struct map_symbol *ms = self->b.priv;
 	struct symbol *sym = ms->sym;
-	const char *help = "<-/ESC: Exit, TAB/shift+TAB: Cycle hot lines, "
-			   "H: Hottest line, ->/ENTER: Line action, "
-			   "O: Offset view, "
-			   "S: Source view";
+	const char *help = "Press 'h' for help on key bindings";
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name, help) < 0)
@@ -637,16 +634,30 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			else
 				nd = self->curr_hot;
 			break;
-		case 'H':
+		case K_F1:
 		case 'h':
+			ui_browser__help_window(&self->b,
+		"UP/DOWN/PGUP\n"
+		"PGDN/SPACE    Navigate\n"
+		"q/ESC/CTRL+C  Exit\n\n"
+		"->            Go to target\n"
+		"<-            Exit\n"
+		"h             Cycle thru hottest instructions\n"
+		"j             Toggle showing jump to target arrows\n"
+		"J             Toggle showing number of jump sources on targets\n"
+		"n             Search next string\n"
+		"o             Toggle disassembler output/simplified view\n"
+		"s             Toggle source code view\n"
+		"/             Search string\n"
+		"?             Search previous string\n");
+			continue;
+		case 'H':
 			nd = self->curr_hot;
 			break;
-		case 'S':
 		case 's':
 			if (annotate_browser__toggle_source(self))
 				ui_helpline__puts(help);
 			continue;
-		case 'O':
 		case 'o':
 			self->use_offset = !self->use_offset;
 			if (self->use_offset)
