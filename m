Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0JSNzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:55:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:45087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0JSNzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:14 -0400
Message-Id: <20101019134808.354429461@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:43:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/7] perf, x86: Fixup the precise_ip computation
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we don't have PEBS, the LBR fixup doesn't make sense.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -497,12 +497,13 @@ static int x86_pmu_hw_config(struct perf
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs)
+		if (x86_pmu.pebs) {
 			precise++;
 
-		/* Support for IP fixup */
-		if (x86_pmu.lbr_nr)
-			precise++;
+			/* Support for IP fixup */
+			if (x86_pmu.lbr_nr)
+				precise++;
+		}
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;


