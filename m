Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1JSSXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:23:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42624 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1JSSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/7] perf annotate browser: Don't change selection line when returning from callq
Date: Wed, 19 Oct 2011 16:23:37 -0200
Message-Id: <1319048618-9790-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When the user navigates to another annotation browser pressing -> on a
'callq' line, on exit (<-) return to the originating 'callq' line.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-z5vgver0jgevbiicfndqni5g@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index a2c351c..1a12d8f 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -349,7 +349,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				symbol__tui_annotate(target, ms->map, evidx, nr_events,
 						     timer, arg, delay_secs);
 			}
-			break;
+			continue;
 		case NEWT_KEY_LEFT:
 		case NEWT_KEY_ESCAPE:
 		case 'q':
-- 
1.6.2.5

