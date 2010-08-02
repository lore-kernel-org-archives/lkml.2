Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0HBBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:51004 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0HBBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/19] perf ui: Show the scroll bar over the left window frame
Date: Sun,  1 Aug 2010 22:08:41 -0300
Message-Id: <1280711334-30000-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we gain two columns and look more like classical (at least in
TUIs) scroll bars bars.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index aed2149..cdd958e 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -347,12 +347,12 @@ static int ui_browser__show(struct ui_browser *self, const char *title)
 		newtPopWindow();
 	}
 	ui_browser__refresh_dimensions(self);
-	newtCenteredWindow(self->width + 2, self->height, title);
+	newtCenteredWindow(self->width, self->height, title);
 	self->form = newt_form__new();
 	if (self->form == NULL)
 		return -1;
 
-	self->sb = newtVerticalScrollbar(self->width + 1, 0, self->height,
+	self->sb = newtVerticalScrollbar(self->width, 0, self->height,
 					 HE_COLORSET_NORMAL,
 					 HE_COLORSET_SELECTED);
 	if (self->sb == NULL)
-- 
1.6.2.5

