Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0EOXu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 19:50:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:44053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0EOXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 19:50:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf newt: Make <- exit the ui_browser
Date: Sat, 15 May 2010 20:50:43 -0300
Message-Id: <1273967444-18035-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273967444-18035-1-git-send-email-acme@infradead.org>
References: <1273967444-18035-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Right now that means that pressing the left arrow willl make the symbol
annotation window to exit back to the main symbol histogram browser.

This is another improvement on the UI fastpath, i.e. just the arrows and
enter are enough for most browsing.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index e74df12..5ded2f0 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -323,6 +323,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
 	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddHotKey(self->form, NEWT_KEY_LEFT);
 
 	if (ui_browser__refresh_entries(self) < 0)
 		return -1;
@@ -408,6 +409,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 		}
 			break;
 		case NEWT_KEY_ESCAPE:
+		case NEWT_KEY_LEFT:
 		case CTRL('c'):
 		case 'Q':
 		case 'q':
@@ -616,7 +618,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	if (hist_entry__annotate(self, &head) < 0)
 		return;
 
-	ui_helpline__push("Press ESC to exit");
+	ui_helpline__push("Press <- or ESC to exit");
 
 	memset(&browser, 0, sizeof(browser));
 	browser.entries = &head;
-- 
1.6.2.5

