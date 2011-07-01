Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1GAPSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:18:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:33205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab1GAPSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:18:37 -0400
Date: Fri, 1 Jul 2011 15:18:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-gukh0txmql2l4thgrekzzbfy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        mcree@orcon.net.nz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mcree@orcon.net.nz,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] irq_work, alpha: Fix up arch hooks
Git-Commit-ID: 0f933625e7b6c3d91878ae95e341bf1984db7eaf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:18:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f933625e7b6c3d91878ae95e341bf1984db7eaf
Gitweb:     http://git.kernel.org/tip/0f933625e7b6c3d91878ae95e341bf1984db7eaf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 28 Jun 2011 12:15:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:02:25 +0200

irq_work, alpha: Fix up arch hooks

Commit e360adbe29 ("irq_work: Add generic hardirq context
callbacks") fouled up the Alpha bit, not properly naming the
arch specific function that raises the 'self-IPI'.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Cree <mcree@orcon.net.nz>
Cc: stable@kernel.org # 37+
Link: http://lkml.kernel.org/n/tip-gukh0txmql2l4thgrekzzbfy@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 818e74e..f20d1b5 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -91,7 +91,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 #define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
 #define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
 
-void set_irq_work_pending(void)
+void arch_irq_work_raise(void)
 {
 	set_irq_work_pending_flag();
 }
