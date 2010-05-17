Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0EQAK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:10:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0EQAKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:10:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf tui: Make <- exit menus too
Date: Sun, 16 May 2010 21:10:33 -0300
Message-Id: <1274055034-25634-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274055034-25634-1-git-send-email-acme@infradead.org>
References: <1274055034-25634-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In fact it is now added to the hot key list when newt_form__new is used,
allowing us to remove the explicit assignment in all its users.

The visible change is that <- will exit the menu that pops up when -> is
pressed (and Enter when callchains are not being used).

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 6974431..59a63e4 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -118,6 +118,7 @@ int browser__show_help(const char *format, va_list ap)
 
 static void newt_form__set_exit_keys(newtComponent self)
 {
+	newtFormAddHotKey(self, NEWT_KEY_LEFT);
 	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
 	newtFormAddHotKey(self, 'Q');
 	newtFormAddHotKey(self, 'q');
@@ -323,7 +324,6 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
 	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
-	newtFormAddHotKey(self->form, NEWT_KEY_LEFT);
 
 	if (ui_browser__refresh_entries(self) < 0)
 		return -1;
@@ -757,7 +757,6 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	newtFormAddHotKey(self->form, 'T');
 	newtFormAddHotKey(self->form, 't');
 	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
-	newtFormAddHotKey(self->form, NEWT_KEY_LEFT);
 	newtFormAddComponents(self->form, self->tree, NULL);
 	self->selection = newt__symbol_tree_get_current(self->tree);
 
-- 
1.6.2.5

