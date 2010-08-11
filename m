Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0HKHnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:43:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:48499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674Ab0HKHnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:43:18 -0400
Date: Wed, 11 Aug 2010 07:42:58 GMT
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
Subject: [tip:perf/core] perf ui: Make SPACE work as PGDN in all browsers
Message-ID: <tip-9e22d6377ce6f31b1cc0bff16daeda2780495061@git.kernel.org>
Git-Commit-ID: 9e22d6377ce6f31b1cc0bff16daeda2780495061
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:42:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e22d6377ce6f31b1cc0bff16daeda2780495061
Gitweb:     http://git.kernel.org/tip/9e22d6377ce6f31b1cc0bff16daeda2780495061
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Aug 2010 15:09:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 15:09:02 -0300

perf ui: Make SPACE work as PGDN in all browsers

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
