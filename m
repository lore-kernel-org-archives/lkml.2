Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0HBBKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:10:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:51003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0HBBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/19] perf ui: Consider the refreshed dimensions in ui_browser__show
Date: Sun,  1 Aug 2010 22:08:40 -0300
Message-Id: <1280711334-30000-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When we call ui_browser__show we may have called
ui_browser__refresh_dimensions to check if the maximum lenght for the
contained entries changed, such as when zooming in and out DSOs or
threads in the hist browser.

For that to happen we must delete the old form, that will take care of
deleting the vertical scrollbar, etc, and then recreate them, with the
new dimensions.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 2f5f7a1..aed2149 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -342,8 +342,10 @@ static void ui_browser__reset_index(struct ui_browser *self)
 
 static int ui_browser__show(struct ui_browser *self, const char *title)
 {
-	if (self->form != NULL)
-		return 0;
+	if (self->form != NULL) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
 	ui_browser__refresh_dimensions(self);
 	newtCenteredWindow(self->width + 2, self->height, title);
 	self->form = newt_form__new();
-- 
1.6.2.5

