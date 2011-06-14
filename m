Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1FNXFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 19:05:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39464 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1FNXFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 19:05:22 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1 of 6] x86, UV: smp_processor_id in a preemptable region
Cc: mingo@elte.hu
Message-Id: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 14 Jun 2011 18:06:29 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Calling smp_processor_id() from within a preemptable region will issue
a warning if DEBUG_PREEMPT is set.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1334,7 +1334,9 @@ static ssize_t tunables_write(struct fil
 
 	instr[count] = '\0';
 
+	preempt_disable(); /* avoid DEBUG_PREEMPT warning */
 	bcp = &per_cpu(bau_control, smp_processor_id());
+	preempt_enable_no_resched();
 
 	ret = parse_tunables_write(bcp, instr, count);
 	if (ret)
