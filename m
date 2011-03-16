Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1CPN67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:58:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab1CPN6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:58:53 -0400
Date: Wed, 16 Mar 2011 13:58:29 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
References: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix the software events state check
Message-ID: <tip-91b2f482e62ad0d444222253026a5cbca28c4ab9@git.kernel.org>
Git-Commit-ID: 91b2f482e62ad0d444222253026a5cbca28c4ab9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:58:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91b2f482e62ad0d444222253026a5cbca28c4ab9
Gitweb:     http://git.kernel.org/tip/91b2f482e62ad0d444222253026a5cbca28c4ab9
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 7 Mar 2011 21:27:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:13 +0100

perf: Fix the software events state check

Fix the mistakenly inverted check of events state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: <stable@kernel.org>
LKML-Reference: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ed253aa..974e2e6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5122,7 +5122,7 @@ static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
+		return 1;
 
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))
