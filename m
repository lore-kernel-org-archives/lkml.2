Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2DQLUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:20:51 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:41642 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2DQLUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:20:10 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] x86: Move x86_cpu_to_apicid to the __read_mostly section
Date: Tue, 17 Apr 2012 14:16:45 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-40-generic; KDE/4.4.5; i686; ; )
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>, ido@wizery.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171416.45799.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

x86_cpu_to_apicid is only written to during initialization. Benchmarks
show that moving it to the __read_mostly section helps avoid false
sharing on large multiprocessing systems.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
---
 arch/x86/include/asm/smp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0434c40..b9d6c1e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -53,7 +53,7 @@ static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 	return per_cpu(cpu_llc_shared_map, cpu);
 }
 
-DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
+DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
-- 
1.7.7.6

