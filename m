Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2ELTyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:35562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2ELTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:53:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf annotate browser: Count the numbers of jump sources to a target
Date: Sat, 12 May 2012 16:53:05 -0300
Message-Id: <1336852387-16322-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336852387-16322-1-git-send-email-acme@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of simply marking an offset as a jump target. So that we can
implement a new feature: showing "jumpy" targets, I.e. addresses that
lots of places jump to.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vc7b0u5yxgrubig0q61ayhxf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 06367c1..4463626 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -16,7 +16,7 @@ struct browser_disasm_line {
 	double		percent;
 	u32		idx;
 	int		idx_asm;
-	bool		jump_target;
+	int		jump_sources;
 };
 
 struct annotate_browser {
@@ -98,7 +98,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		if (!ab->use_offset) {
 			printed = scnprintf(bf, sizeof(bf), "%" PRIx64 ": ", addr);
 		} else {
-			if (bdl->jump_target) {
+			if (bdl->jump_sources) {
 				printed = scnprintf(bf, sizeof(bf), "%*" PRIx64 ": ",
 						    ab->addr_width, addr);
 			} else {
@@ -707,7 +707,7 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 			continue;
 
 		bdlt = disasm_line__browser(dlt);
-		bdlt->jump_target = true;
+		++bdlt->jump_sources;
 	}
 		
 }
-- 
1.7.9.2.358.g22243

