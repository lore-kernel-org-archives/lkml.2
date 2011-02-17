Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab1BQPEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:04:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:38138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab1BQPEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:04:11 -0500
Date: Thu, 17 Feb 2011 15:03:41 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Use the percent color for the whole line
Message-ID: <tip-b99976e2d277c963138e090ae17bf835f8a07680@git.kernel.org>
Git-Commit-ID: b99976e2d277c963138e090ae17bf835f8a07680
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:03:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b99976e2d277c963138e090ae17bf835f8a07680
Gitweb:     http://git.kernel.org/tip/b99976e2d277c963138e090ae17bf835f8a07680
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 9 Feb 2011 13:59:14 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Feb 2011 14:47:55 -0200

perf annotate browser: Use the percent color for the whole line

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
