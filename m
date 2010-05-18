Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0ERVYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:24:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50073 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0ERVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=WrFlV4LEYeSqYkRBWDYu4GVYy08rihoD85AeLIgCuOOLWWTjAqOlWiRA673c8wGwqT
         F+N4EdkoMNYnzmfy6zKIw3ZSkT9IoZRwaQX5O2IL4IvB4tD4D6hxW3bf/c4ul2/55lBw
         lO1rhevvI1Jn/E+RZiPVB429sx6sYA9M3PVD8=
Message-Id: <20100518212439.167259349@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 19 May 2010 01:19:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 2/4] x86,perf: p4_pmu_schedule_events -- use smp_processor_id instead of raw_
References: <20100518211916.407689068@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-use-smp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This snippet somehow escaped the commit

 | commit 137351e0feeb9f25d99488ee1afc1c79f5499a9a
 | Author: Cyrill Gorcunov <gorcunov@openvz.org>
 | Date:   Sat May 8 15:25:52 2010 +0400
 |
 |    x86, perf: P4 PMU -- protect sensible procedures from preemption

so bring it eventually back. It helps to catch preemption issue
(if there will be, rule of thumb -- don't use raw_ if you can).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
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

