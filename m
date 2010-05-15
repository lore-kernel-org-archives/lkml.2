Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0EOVqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:46:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0EOVqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=g5HfHX04kTvxdVVxQCmUBEDxTvPiRs7QoF69HfUXaFCfx1DgfYbqHnSX1qAzmLbnp6
         KHU56ug3hhl5oIRtq+75ZTX02kgKZ01r4ZF+aDIdfQJVHzPm10gSkJov7nZ5z3R4CCV9
         XDP5YG7NyvGbQ61VqVN6+//mXyuVR8eOgu7aw=
Date: Sun, 16 May 2010 01:45:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip/master] x86,perf: p4_pmu_schedule_events -- use
	smp_processor_id
Message-ID: <20100515214552.GA26557@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This snippet somehow escaped the commit

 | commit 137351e0feeb9f25d99488ee1afc1c79f5499a9a
 | Author: Cyrill Gorcunov <gorcunov@openvz.org>
 | Date:   Sat May 8 15:25:52 2010 +0400
 |
 |    x86, perf: P4 PMU -- protect sensible procedures from preemption

so make it eventually. In short -- it helps to catch preemption issue.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -762,7 +762,7 @@ static int p4_pmu_schedule_events(struct
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
