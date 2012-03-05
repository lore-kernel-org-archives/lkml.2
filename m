Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2CEQVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:21:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60893 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2CEQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:21:20 -0500
Date: Mon, 5 Mar 2012 08:20:35 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-58e817d997d162682717dcaae39393dcadf5f296@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1329986784-4916-2-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Print asm code as blue when source code is displayed
Git-Commit-ID: 58e817d997d162682717dcaae39393dcadf5f296
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:21:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58e817d997d162682717dcaae39393dcadf5f296
Gitweb:     http://git.kernel.org/tip/58e817d997d162682717dcaae39393dcadf5f296
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 17:46:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:50 -0300

perf annotate: Print asm code as blue when source code is displayed

Print unselected asm code lines as blue. This is what we do now for
--stdio.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329986784-4916-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 295a9c9..76caae9 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -69,14 +69,17 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	if (!self->navkeypressed)
 		width += 1;
 
+	if (!ab->hide_src_code && ol->offset != -1)
+		if (!current_entry || (self->use_navkeypressed &&
+				       !self->navkeypressed))
+			ui_browser__set_color(self, HE_COLORSET_CODE);
+
 	if (!*ol->line)
 		slsmg_write_nstring(" ", width - 18);
 	else
 		slsmg_write_nstring(ol->line, width - 18);
 
-	if (!current_entry)
-		ui_browser__set_color(self, HE_COLORSET_CODE);
-	else
+	if (current_entry)
 		ab->selection = ol;
 }
 
