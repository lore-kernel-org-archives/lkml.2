Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0ETQK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:10:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0ETQK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:10:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf TUI: Make 'space' be an alias to 'PgDn'
Date: Thu, 20 May 2010 13:10:44 -0300
Message-Id: <1274371845-27784-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274371845-27784-1-git-send-email-acme@infradead.org>
References: <1274371845-27784-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like if one is using the stdio based pager, or more/less, for that
matter.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 9338d06..051022e 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -383,6 +383,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
 	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
 	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
+	newtFormAddHotKey(self->form, ' ');
 	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
 
@@ -419,6 +420,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 			}
 			break;
 		case NEWT_KEY_PGDN:
+		case ' ':
 			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
 				break;
 
-- 
1.6.2.5

