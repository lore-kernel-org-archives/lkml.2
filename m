Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1BPWzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:55:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:60604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1BPWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:54:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/6] perf annotate browser: Use the percent color for the whole line
Date: Wed, 16 Feb 2011 20:54:44 -0200
Message-Id: <1297896887-9983-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297896887-9983-1-git-send-email-acme@infradead.org>
References: <1297896887-9983-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Not just for the percentage number, to see the hot lines more easily.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 1aa3965..cfb5a27 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -44,8 +44,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		struct objdump_line_rb_node *olrb = objdump_line__rb(ol);
 		ui_browser__set_percent_color(self, olrb->percent, current_entry);
 		slsmg_printf(" %7.2f ", olrb->percent);
-		if (!current_entry)
-			ui_browser__set_color(self, HE_COLORSET_CODE);
 	} else {
 		ui_browser__set_percent_color(self, 0, current_entry);
 		slsmg_write_nstring(" ", 9);
@@ -57,6 +55,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(" ", width - 18);
 	else
 		slsmg_write_nstring(ol->line, width - 18);
+
+	if (!current_entry)
+		ui_browser__set_color(self, HE_COLORSET_CODE);
 }
 
 static double objdump_line__calc_percent(struct objdump_line *self,
-- 
1.6.2.5

