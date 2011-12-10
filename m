Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1LJX3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 18:29:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1LJX2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 18:28:47 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Subject: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event
Date: Sun, 11 Dec 2011 00:28:52 +0100
Message-Id: <1323559734-3488-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323559734-3488-1-git-send-email-eranian@google.com>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This event counts the number of reference core cpu cycles.
Reference means that the event increments at a constant rate which
is not subject to core CPU frequency adjustments. The event may
not count when the processor is in halted (low power) state.
As such, it may not be equivalent to wall clock time. However,
when the processor is not halted state, the event keeps
a constant correlation with wall clock time.

Signed-off-by: Stephane Eranian <eranian@google.com>
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
-- 
1.7.1

