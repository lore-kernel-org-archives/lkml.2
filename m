Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1K1XSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:18:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48714 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab1K1XOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/25] perf ui progress: Fix divide by zero
Date: Mon, 28 Nov 2011 21:14:12 -0200
Message-Id: <1322522066-21879-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Happens in a perf.data file where one of the events had no samples.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j7st3oyiotvfxqde2nc41kxb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/progress.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/progress.c b/tools/perf/util/ui/progress.c
index 295e366..13aa64e 100644
--- a/tools/perf/util/ui/progress.c
+++ b/tools/perf/util/ui/progress.c
@@ -14,6 +14,9 @@ void ui_progress__update(u64 curr, u64 total, const char *title)
 	if (use_browser <= 0)
 		return;
 
+	if (total == 0)
+		return;
+
 	ui__refresh_dimensions(true);
 	pthread_mutex_lock(&ui__lock);
 	y = SLtt_Screen_Rows / 2 - 2;
-- 
1.7.8.rc0.35.gee6df

