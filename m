Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab1CXHIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:08:52 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:46219 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab1CXHIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:08:50 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 3/5] x86 idle: remove NOP halt_works()
Date: Thu, 24 Mar 2011 03:08:26 -0400
Message-id: <59c5d1540292b8c392d0a917e5f95da0297eef75.1300950095.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-reply-to: <1300950508-22746-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
In-reply-to: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

no functional change

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/processor.h |    5 -----
 arch/x86/kernel/process.c        |    3 +--
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b5c83f1..8776232 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -147,11 +147,6 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 
 extern const struct seq_operations cpuinfo_op;
 
-static inline int hlt_works(int cpu)
-{
-	return 1;
-}
-
 #define cache_line_size()	(boot_cpu_data.x86_cache_alignment)
 
 extern void cpu_detect(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4966c7e..cd461c3 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -414,8 +414,7 @@ void stop_this_cpu(void *dummy)
 	disable_local_APIC();
 
 	for (;;) {
-		if (hlt_works(smp_processor_id()))
-			halt();
+		halt();
 	}
 }
 
-- 
1.7.4.1.343.ga91df

