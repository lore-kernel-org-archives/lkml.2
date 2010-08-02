Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0HBHvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:51:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:60293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0HBHvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:51:06 -0400
Date: Mon, 2 Aug 2010 07:50:26 GMT
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
Subject: [tip:perf/core] perf ui: Show the scroll bar over the left window frame
Message-ID: <tip-8d8c369f3d697e31e04133ca18b516952549ee33@git.kernel.org>
Git-Commit-ID: 8d8c369f3d697e31e04133ca18b516952549ee33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:50:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d8c369f3d697e31e04133ca18b516952549ee33
Gitweb:     http://git.kernel.org/tip/8d8c369f3d697e31e04133ca18b516952549ee33
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Jul 2010 14:08:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Jul 2010 11:24:31 -0300

perf ui: Show the scroll bar over the left window frame

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
