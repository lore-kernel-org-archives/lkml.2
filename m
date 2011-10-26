Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab1JZRuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:50:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:54968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749Ab1JZRso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/11] perf ui browser: No need to switch char sets that often
Date: Wed, 26 Oct 2011 15:48:32 -0200
Message-Id: <1319651314-29404-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just before and after the loop.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0lh91cedngyg1pqarbky5vn7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 29c68ae..8607efa 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -231,13 +231,15 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 		       (browser->nr_entries - 1));
 	}
 
+	SLsmg_set_char_set(1);
+
 	while (h < height) {
 	        ui_browser__gotorc(browser, row++, col);
-		SLsmg_set_char_set(1);
-		SLsmg_write_char(h == pct ? SLSMG_DIAMOND_CHAR : SLSMG_BOARD_CHAR);
-		SLsmg_set_char_set(0);
+		SLsmg_write_char(h == pct ? SLSMG_DIAMOND_CHAR : SLSMG_CKBRD_CHAR);
 		++h;
 	}
+
+	SLsmg_set_char_set(0);
 }
 
 static int __ui_browser__refresh(struct ui_browser *browser)
-- 
1.6.2.5

