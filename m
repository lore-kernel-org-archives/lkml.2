Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2EUGBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:01:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37552 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2EUGBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:01:12 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: [PATCH 3/8] MIPS: SMTC: delay irq enable to ->smp_finish()
Date: Mon, 21 May 2012 14:00:03 +0800
Message-Id: <1337580008-7280-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prepare for smoothing set_cpu_[active|online]() mess up

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/smtc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index f5dd38f..af46fdd 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -615,7 +615,6 @@ void __cpuinit smtc_boot_secondary(int cpu, struct task_struct *idle)
 
 void smtc_init_secondary(void)
 {
-	local_irq_enable();
 }
 
 void smtc_smp_finish(void)
@@ -631,6 +630,8 @@ void smtc_smp_finish(void)
 	if (cpu > 0 && (cpu_data[cpu].vpe_id != cpu_data[cpu - 1].vpe_id))
 		write_c0_compare(read_c0_count() + mips_hpt_frequency/HZ);
 
+	local_irq_enable();
+
 	printk("TC %d going on-line as CPU %d\n",
 		cpu_data[smp_processor_id()].tc_id, smp_processor_id());
 }
-- 
1.7.5.4

