Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab1BHWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:09:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38294 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1BHWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:09:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf annotate: Fix --stdio rendering
Date: Tue,  8 Feb 2011 20:09:18 -0200
Message-Id: <1297202960-15269-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297202960-15269-1-git-send-email-acme@infradead.org>
References: <1297202960-15269-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The checks for not using a max_lines parameter were b0rked, problem
introduced in 3653246.

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
 tools/perf/util/annotate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 1012841..6db4351 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -132,7 +132,7 @@ static int objdump_line__print(struct objdump_line *oline,
 		if (percent < min_pcnt)
 			return -1;
 
-		if (printed >= max_lines)
+		if (max_lines && printed >= max_lines)
 			return 1;
 
 		color = get_percent_color(percent);
@@ -154,7 +154,7 @@ static int objdump_line__print(struct objdump_line *oline,
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", oline->line);
-	} else if (printed >= max_lines)
+	} else if (max_lines && printed >= max_lines)
 		return 1;
 	else {
 		if (!*oline->line)
-- 
1.6.2.5

