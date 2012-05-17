Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582Ab2EQKLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:11:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509Ab2EQKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:11:30 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 5/8] MIPS: call ->smp_finish() a little late
Date: Thu, 17 May 2012 18:10:07 +0800
Message-Id: <1337249410-7162-6-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

We have move irq enable to ->smp_finish. Place ->smp_finish() a little
late to prepare for move set_cpu_online() into start_secondary.
And it's not necessary to call cpu_set(cpu, cpu_callin_map) and
synchronise_count_slave() with irq enabled.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
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
1.7.1

