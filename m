Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1IVWOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:14:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1IVWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:28 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=b3Xt8IKdiIYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=QmLstDrSBIOjJvd1QVsA:9 a=rM4hZF0_oNvuPrtRx5QA:7 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221025.454175252@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Winchester <kjwinchester@gmail.com>, jbaron@redhat.com,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 03/21] x86: jump_label: arch_jump_label_text_poke_early: add missing __init
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0003-x86-jump_label-arch_jump_label_text_poke_early-add-m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Winchester <kjwinchester@gmail.com>

arch_jump_label_text_poke_early calls text_poke_early, which is
an __init function.  Thus arch_jump_label_text_poke_early should
be the same.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: jbaron@redhat.com
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/1313539478-30303-1-git-send-email-kjwinchester@gmail.com

[ Use __init_or_module instead of __init ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..cacdd46 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -42,7 +42,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init_or_module arch_jump_label_text_poke_early(jump_label_t addr)
 {
 	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
 			JUMP_LABEL_NOP_SIZE);
-- 
1.7.5.4


