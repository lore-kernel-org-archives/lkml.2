Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557Ab2EQKLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:11:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37225 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506Ab2EQKLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:11:11 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 3/8] MIPS: SMTC: delay irq enable to ->smp_finish()
Date: Thu, 17 May 2012 18:10:05 +0800
Message-Id: <1337249410-7162-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prepare for smoothing set_cpu_[active|online]() mess up

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
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
1.7.1

