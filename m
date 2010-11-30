Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0K3UMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:12:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:33373 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0K3ULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/11] perf session: Move ui_progress_update in __perf_session__process_events()
Date: Tue, 30 Nov 2010 18:10:50 -0200
Message-Id: <1291147856-17459-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The progress bar is changed when the file offset changes. This happens only
when the next mmap is done. No need to call ui_progress_update() for every
event.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.094836523@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2fdbccf..3c140da 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -773,10 +773,10 @@ remap:
 		err = -errno;
 		goto out_err;
 	}
+	ui_progress__update(progress, file_offset);
 
 more:
 	event = (event_t *)(buf + head);
-	ui_progress__update(progress, file_offset);
 
 	if (session->header.needs_swap)
 		perf_event_header__bswap(&event->header);
-- 
1.6.2.5

