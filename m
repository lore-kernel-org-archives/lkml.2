Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2EQKP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:15:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58823 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761445Ab2EQKPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:15:25 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com, tglx@linutronix.de
Subject: [PATCH -rt] MIPS: Octeon: convert smp_reserve_lock to raw spinlock
Date: Thu, 17 May 2012 18:15:09 +0800
Message-Id: <1337249709-7346-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Because __cpu_disable is called in atomic context and spinlock
is a mutex on -rt.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/mips/cavium-octeon/smp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index ef9c34a..473c72b 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -257,7 +257,7 @@ DEFINE_PER_CPU(int, cpu_state);
 
 extern void fixup_irqs(void);
 
-static DEFINE_SPINLOCK(smp_reserve_lock);
+static DEFINE_RAW_SPINLOCK(smp_reserve_lock);
 
 static int octeon_cpu_disable(void)
 {
@@ -266,7 +266,7 @@ static int octeon_cpu_disable(void)
 	if (cpu == 0)
 		return -EBUSY;
 
-	spin_lock(&smp_reserve_lock);
+	raw_spin_lock(&smp_reserve_lock);
 
 	set_cpu_online(cpu, false);
 	cpu_clear(cpu, cpu_callin_map);
@@ -277,7 +277,7 @@ static int octeon_cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	spin_unlock(&smp_reserve_lock);
+	raw_spin_unlock(&smp_reserve_lock);
 
 	return 0;
 }
-- 
1.7.1

