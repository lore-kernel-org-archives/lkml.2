Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0LAJMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:12:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:54147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0LAJME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:12:04 -0500
Date: Wed, 1 Dec 2010 09:11:34 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163820.094836523@linutronix.de>
References: <20101130163820.094836523@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Move ui_progress_update in __perf_session__process_events()
Message-ID: <tip-85b99952ccd3d84707661d8ae103c710daca1c8a@git.kernel.org>
Git-Commit-ID: 85b99952ccd3d84707661d8ae103c710daca1c8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:11:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85b99952ccd3d84707661d8ae103c710daca1c8a
Gitweb:     http://git.kernel.org/tip/85b99952ccd3d84707661d8ae103c710daca1c8a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:41 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 19:57:13 -0200

perf session: Move ui_progress_update in __perf_session__process_events()

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
