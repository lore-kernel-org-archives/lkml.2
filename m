Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2EUGBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:01:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37552 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2EUGBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:01:48 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: [PATCH 5/8] MIPS: call ->smp_finish() a little late
Date: Mon, 21 May 2012 14:00:05 +0800
Message-Id: <1337580008-7280-6-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

We have move irq enable to ->smp_finish. Place ->smp_finish() a little
late to prepare for move set_cpu_online() into start_secondary.
And it's not necessary to call cpu_set(cpu, cpu_callin_map) and
synchronise_count_slave() with irq enabled.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index ba9376b..73a268a 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -122,13 +122,14 @@ asmlinkage __cpuinit void start_secondary(void)
 
 	notify_cpu_starting(cpu);
 
-	mp_ops->smp_finish();
 	set_cpu_sibling_map(cpu);
 
 	cpu_set(cpu, cpu_callin_map);
 
 	synchronise_count_slave();
 
+	mp_ops->smp_finish();
+
 	cpu_idle();
 }
 
-- 
1.7.5.4

