Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2BWI1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:27:32 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65009 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2BWI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:27:29 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-d5-4f45f86ecf72
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] perf annotate: Handle lower case key code in annotate_browser__run()
Date: Thu, 23 Feb 2012 17:46:21 +0900
Message-Id: <1329986784-4916-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accepting upper case character only is unconvenient since it requires
SHIFT key too. Why not change to it accept a simple key stroke?

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/browsers/annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 76caae95df39..374d3bc570b2 100644
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
1.7.9

