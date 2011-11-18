Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1KRXfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:35:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KRXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:35:34 -0500
Date: Fri, 18 Nov 2011 15:35:14 -0800
From: tip-bot for Rabin Vincent <rabin@rab.in>
Message-ID: <tip-78345d2edc25e001558f3b7c85906f645d38d23c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rabin@rab.in, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rabin@rab.in, mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
In-Reply-To: <1319702072-32676-1-git-send-email-rabin@rab.in>
References: <1319702072-32676-1-git-send-email-rabin@rab.in>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Call stop_machine_text_poke() on all CPUs
Git-Commit-ID: 78345d2edc25e001558f3b7c85906f645d38d23c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:35:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78345d2edc25e001558f3b7c85906f645d38d23c
Gitweb:     http://git.kernel.org/tip/78345d2edc25e001558f3b7c85906f645d38d23c
Author:     Rabin Vincent <rabin@rab.in>
AuthorDate: Thu, 27 Oct 2011 13:24:32 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:05:15 +0100

x86: Call stop_machine_text_poke() on all CPUs

It appears that stop_machine_text_poke() wants to be called on all CPUs,
like it's done from text_poke_smp().  Fix text_poke_smp_batch() to do
this.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Jason Baron <jbaron@redhat.com>
Link: http://lkml.kernel.org/r/1319702072-32676-1-git-send-email-rabin@rab.in
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
