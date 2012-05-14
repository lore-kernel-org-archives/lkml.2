Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab2ENNCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:02:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2ENNCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:02:46 -0400
Date: Mon, 14 May 2012 06:02:19 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-vc7b0u5yxgrubig0q61ayhxf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Count the numbers of jump sources to a target
Git-Commit-ID: 7d5b12f5a01d338d23874c7c242a74813a8848b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:02:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d5b12f5a01d338d23874c7c242a74813a8848b2
Gitweb:     http://git.kernel.org/tip/7d5b12f5a01d338d23874c7c242a74813a8848b2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 12 May 2012 13:40:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 12 May 2012 13:40:52 -0300

perf annotate browser: Count the numbers of jump sources to a target

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
 1 files changed, 3 insertions(+), 3 deletions(-)

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
