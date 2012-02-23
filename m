Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2BWI2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:28:13 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65009 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2BWI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:27:30 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-d9-4f45f86e1a28
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] perf annotate: Restore title when came back to original symbol
Date: Thu, 23 Feb 2012 17:46:22 +0900
Message-Id: <1329986784-4916-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tui annotation, the title was set to name of the target symbol if
user selects the target. However it remained after returning to original
symbol from the target. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/browsers/annotate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 374d3bc570b2..e73357770d5d 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -343,6 +343,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				pthread_mutex_unlock(&notes->lock);
 				symbol__tui_annotate(target, ms->map, evidx,
 						     timer, arg, delay_secs);
+				ui_browser__show_title(&self->b, sym->name);
 			}
 			continue;
 		case K_LEFT:
-- 
1.7.9

