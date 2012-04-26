Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2DZPGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:06:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:53716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab2DZPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:06:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf annotate browser: Don't draw jump connectors for out of function jumps
Date: Thu, 26 Apr 2012 12:06:17 -0300
Message-Id: <1335452777-27326-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335452777-27326-1-git-send-email-acme@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As described in the previous patch. Next step is to properly label those
jumps by using a -> arrow, i.e. not backwards/forwards, and allow the
user to navigate to this other function when enter or -> is pressed.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ax2sss463eu88wgl9ee8a6b6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 73e1ef0..077380b 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -153,7 +153,8 @@ static void annotate_browser__draw_current_loop(struct ui_browser *browser)
 	unsigned int from, to, start_width = 2;
 
 	list_for_each_entry_from(pos, &notes->src->source, node) {
-		if (!pos->ins || !ins__is_jump(pos->ins))
+		if (!pos->ins || !ins__is_jump(pos->ins) ||
+		    !disasm_line__has_offset(pos))
 			continue;
 
 		target = ab->offsets[pos->ops.target.offset];
@@ -689,7 +690,8 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 		struct disasm_line *dl = browser->offsets[offset], *dlt;
 		struct browser_disasm_line *bdlt;
 
-		if (!dl || !dl->ins || !ins__is_jump(dl->ins))
+		if (!dl || !dl->ins || !ins__is_jump(dl->ins) ||
+		    !disasm_line__has_offset(dl))
 			continue;
 
 		if (dl->ops.target.offset >= size) {
-- 
1.7.9.2.358.g22243

