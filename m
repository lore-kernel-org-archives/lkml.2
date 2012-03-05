Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2CEPzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:55:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:53811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2CEPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/7] perf annotate: Handle lower case key code in annotate_browser__run()
Date: Mon,  5 Mar 2012 12:55:29 -0300
Message-Id: <1330962932-1796-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Accepting upper case character only is unconvenient since it requires
SHIFT key too. Why not change to it accept a simple key stroke?

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329986784-4916-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 76caae9..374d3bc5 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -287,9 +287,11 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				nd = self->curr_hot;
 			break;
 		case 'H':
+		case 'h':
 			nd = self->curr_hot;
 			break;
 		case 'S':
+		case 's':
 			if (annotate_browser__toggle_source(self))
 				ui_helpline__puts(help);
 			continue;
-- 
1.7.9.2.358.g22243

