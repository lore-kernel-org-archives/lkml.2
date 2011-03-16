Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1CPN71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:59:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:35995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab1CPN7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:59:22 -0400
Date: Wed, 16 Mar 2011 13:58:52 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1299529629-18280-2-git-send-email-fweisbec@gmail.com>
References: <1299529629-18280-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Handle stopped state with tracepoints
Message-ID: <tip-a0f7d0f7fc02465bb9758501f611f63381792996@git.kernel.org>
Git-Commit-ID: a0f7d0f7fc02465bb9758501f611f63381792996
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:58:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0f7d0f7fc02465bb9758501f611f63381792996
Gitweb:     http://git.kernel.org/tip/a0f7d0f7fc02465bb9758501f611f63381792996
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 7 Mar 2011 21:27:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:14 +0100

perf: Handle stopped state with tracepoints

We toggle the state from start and stop callbacks but actually
don't check it when the event triggers. Do it so that
these callbacks actually work.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299529629-18280-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 974e2e6..533f715 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5478,6 +5478,8 @@ static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->hw.state & PERF_HES_STOPPED)
+		return 0;
 	/*
 	 * All tracepoints are from kernel-space.
 	 */
