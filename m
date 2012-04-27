Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab2D0IqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:46:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab2D0IqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:46:12 -0400
Date: Fri, 27 Apr 2012 01:45:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ax2sss463eu88wgl9ee8a6b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Don'
 t draw jump connectors for out of function jumps
Git-Commit-ID: 38b31bd0cefbb0e69a182d9a94b09a7e648549dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:45:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38b31bd0cefbb0e69a182d9a94b09a7e648549dc
Gitweb:     http://git.kernel.org/tip/38b31bd0cefbb0e69a182d9a94b09a7e648549dc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Apr 2012 14:18:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Apr 2012 14:18:42 -0300

perf annotate browser: Don't draw jump connectors for out of function jumps

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
 1 files changed, 4 insertions(+), 2 deletions(-)

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
