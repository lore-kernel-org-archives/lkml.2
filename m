Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0HBHuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:50:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:60267 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0HBHut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:50:49 -0400
Date: Mon, 2 Aug 2010 07:50:08 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Consider the refreshed dimensions in ui_browser__show
Message-ID: <tip-63160f73e7baa6618f19d7681bcab5be5c557205@git.kernel.org>
Git-Commit-ID: 63160f73e7baa6618f19d7681bcab5be5c557205
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:50:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63160f73e7baa6618f19d7681bcab5be5c557205
Gitweb:     http://git.kernel.org/tip/63160f73e7baa6618f19d7681bcab5be5c557205
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Jul 2010 13:47:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Jul 2010 11:24:31 -0300

perf ui: Consider the refreshed dimensions in ui_browser__show

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
