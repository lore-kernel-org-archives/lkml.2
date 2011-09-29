Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1I2Wsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:43974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1I2Ws1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/16] perf top browser: Fix up line width calculation
Date: Thu, 29 Sep 2011 19:47:59 -0300
Message-Id: <1317336490-19437-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing an artifact where the last 3 chars of a long DSO name would
remain on the screen sometimes.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-dkiakcl3z69dh1bt9uegaktv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/top.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 88403cf..9d93810 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -43,10 +43,10 @@ static void perf_top_browser__write(struct ui_browser *browser, void *entry, int
 
 	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
 		slsmg_printf("%20.2f ", syme->weight);
-		width -= 24;
+		width -= 21;
 	} else {
 		slsmg_printf("%9.1f %10ld ", syme->weight, syme->snap_count);
-		width -= 23;
+		width -= 20;
 	}
 
 	slsmg_printf("%4.1f%%", pcnt);
-- 
1.6.2.5

