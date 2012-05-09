Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2EIOfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:35:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab2EIOfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:35:06 -0400
Date: Wed, 9 May 2012 07:34:53 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-98112d2e957e0d348f06d8a40f2f720204a70b55@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-8-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-8-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs: Rename some variables
Git-Commit-ID: 98112d2e957e0d348f06d8a40f2f720204a70b55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:34:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98112d2e957e0d348f06d8a40f2f720204a70b55
Gitweb:     http://git.kernel.org/tip/98112d2e957e0d348f06d8a40f2f720204a70b55
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:14 +0200

perf/x86-ibs: Rename some variables

Simple patch that just renames some variables for better
understanding.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-8-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 34dfa85..29a1bff 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -62,7 +62,7 @@ struct perf_ibs_data {
 };
 
 static int
-perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *count)
+perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *hw_period)
 {
 	s64 left = local64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
@@ -91,7 +91,7 @@ perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *count)
 	if (left > max)
 		left = max;
 
-	*count = (u64)left;
+	*hw_period = (u64)left;
 
 	return overflow;
 }
@@ -262,13 +262,13 @@ static int perf_ibs_init(struct perf_event *event)
 static int perf_ibs_set_period(struct perf_ibs *perf_ibs,
 			       struct hw_perf_event *hwc, u64 *period)
 {
-	int ret;
+	int overflow;
 
 	/* ignore lower 4 bits in min count: */
-	ret = perf_event_set_period(hwc, 1<<4, perf_ibs->max_period, period);
+	overflow = perf_event_set_period(hwc, 1<<4, perf_ibs->max_period, period);
 	local64_set(&hwc->prev_count, 0);
 
-	return ret;
+	return overflow;
 }
 
 static u64 get_ibs_fetch_count(u64 config)
