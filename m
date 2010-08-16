Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0HPRcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:32:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:40450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0HPRci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:32:38 -0400
Date: Mon, 16 Aug 2010 17:32:20 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate tui: Fix exit and RIGHT keys handling
Message-ID: <tip-e91846213241e3c46da8cbe992bceb1697de8d78@git.kernel.org>
Git-Commit-ID: e91846213241e3c46da8cbe992bceb1697de8d78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 17:32:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e91846213241e3c46da8cbe992bceb1697de8d78
Gitweb:     http://git.kernel.org/tip/e91846213241e3c46da8cbe992bceb1697de8d78
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Aug 2010 10:43:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Aug 2010 10:43:54 -0300

perf annotate tui: Fix exit and RIGHT keys handling

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
