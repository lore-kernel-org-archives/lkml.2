Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0LDW1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 17:27:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44102 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0LDW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 17:27:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf events: Fix event inherit fallout of precalculated headers
Date: Sat,  4 Dec 2010 20:26:53 -0200
Message-Id: <1291501617-6966-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291501617-6966-1-git-send-email-acme@infradead.org>
References: <1291501617-6966-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

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
-- 
1.6.2.5

