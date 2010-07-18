Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab0GRBtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 21:49:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:39239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0GRBtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 21:49:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf ui: Make ui_browser__run exit on unhandled hot keys
Date: Sat, 17 Jul 2010 22:48:55 -0300
Message-Id: <1279417736-4396-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279417736-4396-1-git-send-email-acme@infradead.org>
References: <1279417736-4396-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Right now ENTER doesn't always exits the newt tree widget, as it is used
for expanding/collapsing branches, but with the new tree widget being
developed we need to regain control to handle it, expanding/collapsing
branches.

In fact its really up to the ui_browser user to state what extra keys
should stop ui_browser__run, and it should handle just the ones needed
for basic browsing.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 932f124..7979003 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -498,12 +498,8 @@ static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 			self->first_visible_entry_idx = self->index - offset;
 			self->seek(self, -offset, SEEK_END);
 			break;
-		case NEWT_KEY_RIGHT:
-		case NEWT_KEY_LEFT:
-		case NEWT_KEY_TAB:
-			return es->u.key;
 		default:
-			continue;
+			return es->u.key;
 		}
 		if (ui_browser__refresh_entries(self) < 0)
 			return -1;
-- 
1.6.2.5

