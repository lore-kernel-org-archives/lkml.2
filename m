Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1CAREG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:04:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1CAREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:04:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/6] perf top browser: Fix up exit keys
Date: Tue,  1 Mar 2011 14:03:42 -0300
Message-Id: <1298999027-30673-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298999027-30673-1-git-send-email-acme@infradead.org>
References: <1298999027-30673-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The left key was exiting 'perf top --tui' when it really shouldn't, it
was too easy to leave the live annotation window and then press one too
many <- and get out of the tool altogether.

Do just like the report TUI does, ignore the left key for exit and also
ask the user when pressing ESC if that is really what is wanted.

Reported-by: Mike Galbraith <efault@gmx.de>
Suggested-by: Ingo Molnar <mingo@elte.hu>
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
 tools/perf/util/ui/browsers/top.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 2f47224..e9381ec 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -10,6 +10,7 @@
 #include "../../annotate.h"
 #include "../helpline.h"
 #include "../libslang.h"
+#include "../util.h"
 #include "../../evlist.h"
 #include "../../hist.h"
 #include "../../sort.h"
@@ -174,6 +175,12 @@ static int perf_top_browser__run(struct perf_top_browser *browser)
 			if (browser->selection)
 				perf_top_browser__annotate(browser);
 			break;
+		case NEWT_KEY_LEFT:
+			continue;
+		case NEWT_KEY_ESCAPE:
+			if (!ui__dialog_yesno("Do you really want to exit?"))
+				continue;
+			/* Fall thru */
 		default:
 			goto out;
 		}
-- 
1.6.2.5

