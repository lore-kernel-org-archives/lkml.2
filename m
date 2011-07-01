Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1GAPSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:18:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1GAPSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:18:10 -0400
Date: Fri, 1 Jul 2011 15:17:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-eg0aqien8p1aqvzu9dft6dtv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, emunson@mgebm.net,
        ying.huang@intel.com, benh@kernel.crashing.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        emunson@mgebm.net, ying.huang@intel.com, benh@kernel.crashing.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] irq_work, ppc: Fix up arch hooks
Git-Commit-ID: 4f8b50bbbe63ae4ec6bea28a90a9a603c745ea71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:17:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f8b50bbbe63ae4ec6bea28a90a9a603c745ea71
Gitweb:     http://git.kernel.org/tip/4f8b50bbbe63ae4ec6bea28a90a9a603c745ea71
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 27 Jun 2011 17:22:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:02:22 +0200

irq_work, ppc: Fix up arch hooks

Commit e360adbe29 ("irq_work: Add generic hardirq context
callbacks") fouled up the ppc bit, not properly naming the
arch specific function that raises the 'self-IPI'.

Cc: Huang Ying <ying.huang@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: stable@kernel.org # 37+
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-eg0aqien8p1aqvzu9dft6dtv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f33acfd..03b29a6 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -544,7 +544,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 
 #endif /* 32 vs 64 bit */
 
-void set_irq_work_pending(void)
+void arch_irq_work_raise(void)
 {
 	preempt_disable();
 	set_irq_work_pending_flag();
