Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2EBTmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:42:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:57005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2EBTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:42:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf annotate browser: Add a right arrow before call instructions
Date: Wed,  2 May 2012 16:42:34 -0300
Message-Id: <1335987758-11039-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335987758-11039-1-git-send-email-acme@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The counterpart of 'ret' instructions.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jlz2ldaquaow0rqi2vr4b91l@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 077380b..4778172 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -117,6 +117,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 				ui_browser__write_graph(self, fwd ? SLSMG_DARROW_CHAR :
 								    SLSMG_UARROW_CHAR);
 				SLsmg_write_char(' ');
+			} else if (ins__is_call(dl->ins)) {
+				ui_browser__write_graph(self, SLSMG_RARROW_CHAR);
+				SLsmg_write_char(' ');
 			} else {
 				slsmg_write_nstring(" ", 2);
 			}
-- 
1.7.9.2.358.g22243

