Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0HPRKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:10:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:48724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0HPRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:10:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/1] perf annotate tui: Fix exit and RIGHT keys handling
Date: Mon, 16 Aug 2010 14:10:31 -0300
Message-Id: <1281978631-15200-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281978631-15200-1-git-send-email-acme@infradead.org>
References: <1281978631-15200-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As part of ongoing effort to reduce the coupling with libnewt, browsers
are being changed to return the exit key.

The annotate browser is not returning it as expected by builtin-annotate
when annotating multiple symbols (when 'perf annotate' is called without
specifying a symbol name).

Fix it by returning the exit key and also adding the RIGHT key as a exit
key so that going to the next symbol in the TUI can work again.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 55ff792..a90273e 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -146,6 +146,7 @@ static int annotate_browser__run(struct annotate_browser *self,
 		return -1;
 
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
 
 	nd = self->curr_hot;
 	if (nd) {
@@ -178,7 +179,7 @@ static int annotate_browser__run(struct annotate_browser *self,
 	}
 out:
 	ui_browser__hide(&self->b);
-	return 0;
+	return es->u.key;
 }
 
 int hist_entry__tui_annotate(struct hist_entry *self)
-- 
1.6.2.5

