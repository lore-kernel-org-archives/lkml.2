Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0K1Iek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 03:34:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:57063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab0K1Iei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 03:34:38 -0500
Date: Sun, 28 Nov 2010 08:34:15 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Default to using event__process_lost
Message-ID: <tip-37982ba0a0630066a6a0844a66aedaf91c66db84@git.kernel.org>
Git-Commit-ID: 37982ba0a0630066a6a0844a66aedaf91c66db84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Nov 2010 08:34:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37982ba0a0630066a6a0844a66aedaf91c66db84
Gitweb:     http://git.kernel.org/tip/37982ba0a0630066a6a0844a66aedaf91c66db84
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 26 Nov 2010 18:31:54 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Nov 2010 19:39:47 -0200

perf events: Default to using event__process_lost

Tool developers have to fill in a 'perf_event_ops' method table to
specify how to handle each event, so far the ones that were not
explicitely especified would get a stub that would just discard the
event.

Change that so that tool developers can get the lost event details and
the total number of such events at the end of 'perf report -D' output.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fa9d652..3d56047 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -262,7 +262,7 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->exit == NULL)
 		handler->exit = process_event_stub;
 	if (handler->lost == NULL)
-		handler->lost = process_event_stub;
+		handler->lost = event__process_lost;
 	if (handler->read == NULL)
 		handler->read = process_event_stub;
 	if (handler->throttle == NULL)
