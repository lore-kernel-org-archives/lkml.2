Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1J0Hzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:55:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49871 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1J0Hze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:55:34 -0400
From: Rabin Vincent <rabin@rab.in>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] x86: call stop_machine_text_poke() on all CPUs
Date: Thu, 27 Oct 2011 13:24:32 +0530
Message-Id: <1319702072-32676-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that stop_machine_text_poke() wants to be called on all CPUs,
like it's done from text_poke_smp().  Fix text_poke_smp_batch() to do
this.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c638228..1f84794 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -738,5 +738,5 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 }
-- 
1.7.7

