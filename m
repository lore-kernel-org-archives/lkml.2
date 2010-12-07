Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0LGGzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:55:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:43938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab0LGGzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:55:37 -0500
Date: Tue, 7 Dec 2010 06:54:51 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.1012031245220.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012031245220.2653@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Fix event inherit fallout of precalculated headers
Message-ID: <tip-614b6780eb0c393d2fb49ff62d61f29b877bd07e@git.kernel.org>
Git-Commit-ID: 614b6780eb0c393d2fb49ff62d61f29b877bd07e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 06:54:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  614b6780eb0c393d2fb49ff62d61f29b877bd07e
Gitweb:     http://git.kernel.org/tip/614b6780eb0c393d2fb49ff62d61f29b877bd07e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 3 Dec 2010 16:24:32 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 4 Dec 2010 22:56:11 -0200

perf events: Fix event inherit fallout of precalculated headers

The precalculated header size is not updated when an event is inherited. That
results in bogus sample entries for all child events. Bug introduced in c320c7b.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <alpine.LFD.2.00.1012031245220.2653@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/perf_event.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index aede712..7961b27 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6099,6 +6099,11 @@ inherit_event(struct perf_event *parent_event,
 	child_event->overflow_handler = parent_event->overflow_handler;
 
 	/*
+	 * Precalculate sample_data sizes
+	 */
+	perf_event__header_size(child_event);
+
+	/*
 	 * Link it up in the child's context:
 	 */
 	raw_spin_lock_irqsave(&child_ctx->lock, flags);
