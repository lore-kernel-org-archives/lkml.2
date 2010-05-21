Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0EUJLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:11:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:36402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0EUJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:24 -0400
Message-Id: <20100521090710.904944001@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/10] perf: Optimize perf_tp_event_match
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-opt-exl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we know tracepoints come from kernel context, avoid conditionals
that try and establish that very fact.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4477,7 +4477,10 @@ static int perf_tp_event_match(struct pe
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
-	if (perf_exclude_event(event, regs))
+	/*
+	 * All tracepoints are from kernel-space.
+	 */
+	if (event->attr.exclude_kernel)
 		return 0;
 
 	if (!perf_tp_filter_match(event, data))


