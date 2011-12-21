Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1LUKXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:23:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1LUKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:23:41 -0500
Date: Wed, 21 Dec 2011 02:23:26 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-c37e17497e01fc0f5d2d6feb5723b210b3ab8890@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323559734-3488-3-git-send-email-eranian@google.com>
References: <1323559734-3488-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events:
  Add PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event
Git-Commit-ID: c37e17497e01fc0f5d2d6feb5723b210b3ab8890
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 02:23:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c37e17497e01fc0f5d2d6feb5723b210b3ab8890
Gitweb:     http://git.kernel.org/tip/c37e17497e01fc0f5d2d6feb5723b210b3ab8890
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sun, 11 Dec 2011 00:28:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:26:37 +0100

perf events: Add PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event

This event counts the number of reference core cpu cycles.
Reference means that the event increments at a constant rate which
is not subject to core CPU frequency adjustments. The event may
not count when the processor is in halted (low power) state.
As such, it may not be equivalent to wall clock time. However,
when the processor is not halted state, the event keeps
a constant correlation with wall clock time.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323559734-3488-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 564769c..0885561 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -54,6 +54,7 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
 	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
 	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
+	PERF_COUNT_HW_REF_CPU_CYCLES		= 9,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
