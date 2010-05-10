Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0EJQcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:32:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:59387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0EJQck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:32:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/4] perf newt: Use newtAddComponent()
Date: Mon, 10 May 2010 13:32:18 -0300
Message-Id: <1273509141-15696-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273509141-15696-1-git-send-email-acme@infradead.org>
References: <1273509141-15696-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of newtAddComponents(just-one-entry, NULL), that is not needed
if, like in this browser, we're adding just one component at a time.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 7a123a9..e283a6e 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -31,7 +31,7 @@ struct ui_progress *ui_progress__new(const char *title, u64 total)
 		self->scale = newtScale(0, 0, cols, total);
 		if (self->scale == NULL)
 			goto out_free_form;
-		newtFormAddComponents(self->form, self->scale, NULL);
+		newtFormAddComponent(self->form, self->scale);
 		newtRefresh();
 	}
 
@@ -107,7 +107,7 @@ static int popup_menu(int argc, char * const argv[])
 	if (listbox == NULL)
 		goto out_destroy_form;
 
-	newtFormAddComponents(form, listbox, NULL);
+	newtFormAddComponent(form, listbox);
 
 	for (i = 0; i < argc; ++i) {
 		int len = strlen(argv[i]);
@@ -365,7 +365,7 @@ static void map_symbol__annotate_browser(const struct map_symbol *self,
 
 	newtCenteredWindow(max_line_len + 2, rows - 5, self->sym->name);
 	form = newt_form__new();
-	newtFormAddComponents(form, tree, NULL);
+	newtFormAddComponent(form, tree);
 
 	newtFormRun(form, &es);
 	newtFormDestroy(form);
-- 
1.6.2.5

