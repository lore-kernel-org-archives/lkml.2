Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2CEP5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:57:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2CEPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/7] perf annotate: Print asm code as blue when source code is displayed
Date: Mon,  5 Mar 2012 12:55:28 -0300
Message-Id: <1330962932-1796-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
 1 file changed, 6 insertions(+), 3 deletions(-)

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
 
-- 
1.7.9.2.358.g22243

