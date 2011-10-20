Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1JTNGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:06:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:43251 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1JTNGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:06:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf hists: Don't consider filtered entries when calculating column widths
Date: Thu, 20 Oct 2011 11:05:47 -0200
Message-Id: <1319115948-12060-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319115948-12060-1-git-send-email-acme@infradead.org>
References: <1319115948-12060-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rf01wktu1e3f3az32nry86vu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1f269fd..f6a9939 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -725,7 +725,8 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 
 	while (next && row++ < max_rows) {
 		n = rb_entry(next, struct hist_entry, rb_node);
-		hists__calc_col_len(hists, n);
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
 		next = rb_next(&n->rb_node);
 	}
 }
-- 
1.6.2.5

