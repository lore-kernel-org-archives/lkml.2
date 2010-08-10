Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab0HJVyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:54:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219Ab0HJVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:54:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf ui: Make SPACE work as PGDN in all browsers
Date: Tue, 10 Aug 2010 18:53:43 -0300
Message-Id: <1281477226-11504-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281477226-11504-1-git-send-email-acme@infradead.org>
References: <1281477226-11504-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Not just on the annotate one.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c           |    1 +
 tools/perf/util/ui/browsers/annotate.c |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index edbb7dd..83d5748 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -169,6 +169,7 @@ int ui_browser__show(struct ui_browser *self, const char *title)
 	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
 	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddHotKey(self->form, ' ');
 	newtFormAddComponent(self->form, self->sb);
 	return 0;
 }
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 763592b..d2156ae 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -178,7 +178,6 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 
 	browser.b.width += 18; /* Percentage */
 	ui_browser__show(&browser.b, self->ms.sym->name);
-	newtFormAddHotKey(browser.b.form, ' ');
 	ret = ui_browser__run(&browser.b, &es);
 	newtFormDestroy(browser.b.form);
 	newtPopWindow();
-- 
1.6.2.5

